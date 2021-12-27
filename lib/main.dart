import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

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
  String path = "";
  bool bload = false;

  var urlEditController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Padding(
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
                     //_ocr(urlEditController.text);
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
                        onChanged: (v) {
                        print('check');
                        },),
                      Text(e)
                    ],
                  );
                }).toList(),
              ],
            ),

          ],

        ),
      ),

    );
  }
}
