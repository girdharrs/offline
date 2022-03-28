import 'package:flutter/material.dart';
import 'package:offline/DbHelper.dart';
import 'package:offline/editpage.dart';
import 'package:offline/insertpage.dart';
import 'package:sqflite/sqflite.dart';

class viewpage extends StatefulWidget {
  const viewpage({Key? key}) : super(key: key);

  @override
  _viewpageState createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {
  Database? db;
  List<Map> list = [];
  List<Map> searchlist = [];
  bool ready = false;
  bool search = false;
  // Widget? g;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // g = Center(child: CircularProgressIndicator());

    get();
  }

  get() {
    DbHelper dbHelper = DbHelper();

    dbHelper.createDataBase().then((value) async {
      db = value;
      String qry = "Select * from contactbook";
      list = await db!.rawQuery(qry);
      print(list);
      ready = true;
      // g = ListView.builder(
      //   itemCount: list.length,
      //   itemBuilder: (context, index) {
      //     Map m = list[index];
      //
      //     return ListTile(
      //       onLongPress: () {
      //         showDialog(
      //           context: context,
      //           builder: (context) {
      //             return AlertDialog(
      //               title: Text("Update or Delete"),
      //               content: Text("Please select your choice..."),
      //               actions: [
      //                 TextButton.icon(
      //                     onPressed: () async {
      //                       Navigator.pop(context);
      //                       Navigator.pushReplacement(context,
      //                           MaterialPageRoute(
      //                         builder: (context) {
      //                           return edit(m);
      //                         },
      //                       ));
      //                     },
      //                     icon: Icon(Icons.edit),
      //                     label: Text("Update")),
      //                 TextButton.icon(
      //                     onPressed: () async {
      //                       int id = m["id"];
      //                       String qry =
      //                           "delete from contactbook where id='$id'";
      //                       await db!.rawDelete(qry);
      //                       // Navigator.pop(context);
      //
      //                       Navigator.pushReplacement(context,
      //                           MaterialPageRoute(
      //                         builder: (context) {
      //                           return viewpage();
      //                         },
      //                       ));
      //                     },
      //                     icon: Icon(Icons.delete),
      //                     label: Text("Delete"))
      //               ],
      //             );
      //           },
      //         );
      //       },
      //       leading: Text("${m['id']}"),
      //       title: Text("${m['name']}"),
      //       subtitle: Text("${m['contact']}"),
      //       trailing: IconButton(
      //           onPressed: () {
      //             showDialog(
      //               context: context,
      //               builder: (context) {
      //                 return AlertDialog(
      //                   title: Text("Update or Delete"),
      //                   content: Text("Please select your choice..."),
      //                   actions: [
      //                     TextButton.icon(
      //                         onPressed: () async {
      //                           Navigator.pop(context);
      //                           Navigator.pushReplacement(context,
      //                               MaterialPageRoute(
      //                             builder: (context) {
      //                               return edit(m);
      //                             },
      //                           ));
      //                         },
      //                         icon: Icon(Icons.edit),
      //                         label: Text("Update")),
      //                     TextButton.icon(
      //                         onPressed: () async {
      //                           int id = m["id"];
      //                           String qry =
      //                               "delete from contactbook where id='$id'";
      //                           await db!.rawDelete(qry);
      //                           // Navigator.pop(context);
      //
      //                           Navigator.pushReplacement(context,
      //                               MaterialPageRoute(
      //                             builder: (context) {
      //                               return viewpage();
      //                             },
      //                           ));
      //                         },
      //                         icon: Icon(Icons.delete),
      //                         label: Text("Delete"))
      //                   ],
      //                 );
      //               },
      //             );
      //           },
      //           icon: Icon(Icons.more_vert)),
      //     );
      //   },
      // );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: search
          ? AppBar(
              title: TextField(
                autofocus: true,
                onChanged: (value) {
                  if(value.isEmpty)
                    {
                      searchlist = list;
                    }
                  else
                    {
                      searchlist=[];

                      for(int i=0;i<list.length;i++)
                        {
                          Map m=list[i];
                          if(m['name'].toString().toLowerCase().contains(value.trim().toLowerCase())||
                             m['contact'].toString().toLowerCase().contains(value.trim().toLowerCase())
                          )
                            {
                              searchlist.add(m);
                            }
                        }
                    }
                  setState(() {

                  });
                },
                decoration: InputDecoration(
                    suffix: IconButton(
                        onPressed: () {
                          search = false;
                          setState(() {});
                        },
                        icon: Icon(Icons.close))),
              ),
            )
          : AppBar(
              title: Text("Contact Book"),
              actions: [
                IconButton(
                    onPressed: () {

                      setState(() {
                        searchlist = list;
                      search = true;
                      });
                    },
                    icon: Icon(Icons.search))
              ],
            ),
      body: ready
          ? ListView.builder(
              itemCount: search?searchlist.length:list.length,
              itemBuilder: (context, index) {
                Map m =search? searchlist[index]:list[index];

                return ListTile(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Update or Delete"),
                          content: Text("Please select your choice..."),
                          actions: [
                            TextButton.icon(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return edit(m);
                                    },
                                  ));
                                },
                                icon: Icon(Icons.edit),
                                label: Text("Update")),
                            TextButton.icon(
                                onPressed: () async {
                                  int id = m["id"];
                                  String qry =
                                      "delete from contactbook where id='$id'";
                                  await db!.rawDelete(qry);
                                  // Navigator.pop(context);

                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return viewpage();
                                    },
                                  ));
                                },
                                icon: Icon(Icons.delete),
                                label: Text("Delete"))
                          ],
                        );
                      },
                    );
                  },

                  leading: Text("${m['id']}"),
                  title: Text("${m['name']}"),
                  subtitle: Text("${m['contact']}"),
                  trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Update or Delete"),
                              content: Text("Please select your choice..."),
                              actions: [
                                TextButton.icon(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                        builder: (context) {
                                          return edit(m);
                                        },
                                      ));
                                    },
                                    icon: Icon(Icons.edit),
                                    label: Text("Update")),
                                TextButton.icon(
                                    onPressed: () async {
                                      int id = m["id"];
                                      String qry =
                                          "delete from contactbook where id='$id'";
                                      await db!.rawDelete(qry);
                                      // Navigator.pop(context);

                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                        builder: (context) {
                                          return viewpage();
                                        },
                                      ));
                                    },
                                    icon: Icon(Icons.delete),
                                    label: Text("Delete"))
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.more_vert)),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return insertpage();
            },
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
