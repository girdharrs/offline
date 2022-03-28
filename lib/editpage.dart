import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offline/viewpage.dart';
import 'package:sqflite/sqflite.dart';

import 'DbHelper.dart';

class edit extends StatefulWidget {
  Map<dynamic, dynamic> m;

  edit(this.m);

  @override
  _editState createState() => _editState();
}

class _editState extends State<edit> {
  TextEditingController a1 = TextEditingController();
  TextEditingController a2 = TextEditingController();
  TextEditingController a3 = TextEditingController();
  TextEditingController a4 = TextEditingController();
  Database? db;
  final ImagePicker _picker = ImagePicker();
  File? file;

  bool ready = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    a1.text = widget.m['name'];
    a2.text = widget.m['contact'];
    a3.text = widget.m['email'];
    a4.text = widget.m['birth'];

    DbHelper dbHelper = DbHelper();

    dbHelper.createDataBase().then((value) {
      db = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit contact "),
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
                              radius: 70,
                              child: CircleAvatar(
                                radius: 68,
                                backgroundImage: Image.file(
                                  file!,
                                  height: 100,
                                  width: 100,
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
            ),),
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
                        context: context,
                        initialEntryMode: DatePickerEntryMode.calendar,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2025))
                    .then((value) {
                  print(value);
                  a4.text = value.toString();
                  setState(() {});
                });
              },
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                String newname = a1.text;
                String newcontact = a2.text;
                String newemail = a3.text;
                String newbirth = a4.text;

                int id = widget.m['id'];

                String qry =
                    "update contactbook set name = '$newname', contact = '$newcontact',email ='$newemail',birth = '$newbirth' where id='$id'";
                await db!.rawUpdate(qry);
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return viewpage();
                  },
                ));
              },
              child: Text("Update"))
        ],
      ),
    );
  }
}
