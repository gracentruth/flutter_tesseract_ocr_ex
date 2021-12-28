

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData,rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tesseract Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _ocrText='';
  String _ocrHocr='';

  Map<String, String> tessimgs = {
    "kor":
    "https://raw.githubusercontent.com/khjde1207/tesseract_ocr/master/example/assets/test1.png",
    "en": "https://tesseract.projectnaptha.com/img/eng_bw.png",
    "ch_sim": "https://tesseract.projectnaptha.com/img/chi_sim.png",
    "ru": "https://tesseract.projectnaptha.com/img/rus.png",
  };

  var LangList = ["kor", "eng"];
  var selectList = [];
  String path = "https://raw.githubusercontent.com/khjde1207/tesseract_ocr/master/example/assets/test1.png";
  bool bload = false;

  var urlEditController = TextEditingController();



  void runFilePiker() async { // 사진을 갤러리에서 가지고 오고 싶을 때 실행하는 함수android && ios only
    final pickedFile =
    await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _ocr(urlEditController.text);
    }
  }

  Future<void> writeToFile(ByteData data, String path) {
    print('-----');
    print(data);
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void _ocr(url) async {
    if (selectList.length <= 0) {
      print("Please select language");
      return;
    }

    Directory tempDir = await getTemporaryDirectory();
    print('tempDir:'+tempDir.toString());
    HttpClient httpClient = new HttpClient();
    print('httpClient:'+httpClient.toString());
    // HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    // print('request:'+request.toString());
    // HttpClientResponse response = await request.close();
    // print('resoinse:'+response.toString());
    // Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    // print('bytes:'+bytes.toString());
    String dir = tempDir.path;
    print('dir:'+dir.toString());


    path = url;
    if (kIsWeb == false &&
        (url.indexOf("http://") == 0 || url.indexOf("https://") == 0)) {

      Directory tempDir = await getTemporaryDirectory(); //현재의 디렉토리를 받아온다.

      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      String dir = tempDir.path; //현재 디렉토리의 경로
      print('$dir/test.jpg');
      File file = new File('$dir/test.jpg');
      await file.writeAsBytes(bytes);
      url = file.path;

    }
    var langs = selectList.join("+");

    bload = true;
    setState(() {});

    _ocrText =
    await FlutterTesseractOcr.extractText(url, language: langs, args: {
      "preserve_interword_spaces": "1",
    });


    bload = false;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Padding(
            padding:EdgeInsets.all(10),
            child:Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      child:Text('urls'),
                      onPressed:(){
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return SimpleDialog(
                                title: const Text('Select Url'),

                              );
                            });

                      },
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'input image url',
                        ),
                        controller: urlEditController,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _ocr(urlEditController.text);
                        },
                        child: Text("Run")),
                  ],
                ),
                Row(
                  children: [
                    ...LangList.map((e){
                      return Row(
                        children: [
                          Checkbox(
                            value: selectList.indexOf(e) >= 0,
                            onChanged: (v) async{
                              if (selectList.indexOf(e) < 0) {
                                selectList.add(e);
                              } else {
                                selectList.remove(e);
                              }
                              setState(() {});
                            },),
                          Text(e)
                        ],
                      );
                    }).toList(),
                  ],
                ),
                Expanded( //사진 보여주는 부분
                    child: ListView(
                      children: [
                        path.length <= 0
                            ? Container()
                            : path.indexOf("http") >= 0
                            ? Image.network(path)
                            : Image.file(File(path)),
                        bload
                            ? Column(children: [CircularProgressIndicator()])
                            : Text(
                          '$_ocrText', // 찾아낸 문자열 내용들
                        ),
                      ],
                    ))

              ],

            ),
          ),


        ],
      ),
    //  floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //   runFilePiker();
    //   _ocr();
    // },
    // tooltip: 'OCR',
    // child: Icon(Icons.add),
    // ), // Th,

    );
  }
}
