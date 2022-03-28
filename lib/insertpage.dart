import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offline/DbHelper.dart';
import 'package:offline/viewpage.dart';
import 'package:sqflite/sqflite.dart';

class insertpage extends StatefulWidget {
  const insertpage({Key? key}) : super(key: key);

  @override
  _insertpageState createState() => _insertpageState();
}

class _insertpageState extends State<insertpage> {
  TextEditingController a1 = TextEditingController();
  TextEditingController a2 = TextEditingController();
  TextEditingController a3 = TextEditingController();
  TextEditingController a4 = TextEditingController();

  Database? db;
  final ImagePicker _picker = ImagePicker();
  File? file;

  bool ready = false;
  DateTime t = DateTime.now();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DbHelper dbHelper = DbHelper();

    // String str = t.toString();
     String str = t.toString();      // 2020/02/15 08:50:12
     List<String> list=str.split(" ");// 2020/02/15  08:50:12
     String date=list[0];

    dbHelper.createDataBase().then((value) {
      db = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("insert contact book"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: Text("Select picture"),
                          children: [
                            ListTile(
                              title: Text("Camera"),
                              leading: Icon(Icons.camera),
                              onTap: () async {
                                Navigator.pop(context);
                                final XFile? photo = await _picker.pickImage(
                                    source: ImageSource.camera);
                                file = File(photo!.path);
                                ready = true;
                                setState(() {});
                              },
                            ),
                            ListTile(
                              title: Text("Gallery"),
                              leading: Icon(Icons.photo),
                              onTap: () async {
                                Navigator.pop(context);
                                final XFile? image = await _picker.pickImage(
                                    source: ImageSource.gallery);

                                file = File(image!.path);
                                ready = true;
                                setState(() {});
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Badge(
                      badgeContent: Icon(Icons.edit),
                      child: ready
                          ? CircleAvatar(
                              radius: 75,
                              child: CircleAvatar(
                                radius: 73,
                                backgroundImage: Image.file(
                                  file!,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ).image,
                              ),
                            )
                          : Image.asset("images/profile.png",
                              height: 100, width: 100)),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: a1,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "enter name",
                  labelText: "name"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: a2,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "enter contact",
                  labelText: "contact"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: a3,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "enter email id",
                  labelText: "email id"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: a4,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "birthdate",
                  labelText: "birthdate"),
              onTap: () {
                showDatePicker(
                    context: context,initialEntryMode: DatePickerEntryMode.calendar,

                    initialDate: DateTime.now(),
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2025)).then((value){
                  print(value);
                  // a4.text=t.toString();
                  String str=value.toString();
                  List<String> list=str.split(" ");// 2020/02/15  08:50:12
                  String date=list[0];
                  a4.text=date;


                  setState(() {

                  });
                });

              },
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                String name = a1.text;
                String contact = a2.text;
                String email = a3.text;
                String birth = a4.text;

                String qry = "insert into contactbook(name,contact,email,birth) values('$name','$contact','$email','$birth')";
                int i = await db!.rawInsert(qry);


                print(i);

                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return viewpage();
                  },
                ));
              },
              child: Text("save"))
        ],
      ),
    );
  }
}
