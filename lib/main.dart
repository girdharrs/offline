import 'package:flutter/material.dart';
import 'package:offline/viewpage.dart';
void main() {
  runApp(MaterialApp(home: viewpage(),));}
class demo extends StatefulWidget {
  const demo({Key? key}) : super(key: key);
  @override
  _demoState createState() => _demoState();
}
class _demoState extends State<demo> {
  @override
  Widget build(BuildContext context) {

    double theight = MediaQuery.of(context).size.height;
    double twidth = MediaQuery.of(context).size.width;
    double appbarheight = kToolbarHeight;  // 56
    double statusbarheight = MediaQuery.of(context).padding.top;
    double navbarheight = MediaQuery.of(context).padding.bottom;
   // double bodyheight = theight - statusbarheight - appbarheight - navbarheight;  // with appbar
   double bodyheight = theight - statusbarheight  - navbarheight;   // without appbar

    print("$theight\n$twidth\n$appbarheight\n$statusbarheight\n$navbarheight\n$bodyheight");

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: bodyheight * 0.44 - 20,
            color: Colors.blue,
            width: double.infinity,
            child: Text("Hello", style: TextStyle(fontSize: bodyheight * 0.10),),
            margin: EdgeInsets.all(10),
          ),Container(
            height: bodyheight * 0.22,
            color: Colors.red,
            width: double.infinity,
          ),Container(
            height: bodyheight * 0.34,
            color: Colors.yellow,
            width: double.infinity,
          )
        ],
      ),
    );
  }
}

