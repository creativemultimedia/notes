import 'package:flutter/material.dart';
import 'package:notes/notes/dbclass.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'add_notes.dart';

class viewpage extends StatefulWidget {
  const viewpage({Key? key}) : super(key: key);
  @override
  State<viewpage> createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {

  List<Map> list=[];
  Database? database;
  Future<List> getNotes() async {
    database=await dbclass().createdb();
    String q="select * from notes";
    list=await database!.rawQuery(q);
    return list;
  }
  Color tile_color=Colors.white;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Notes"),),
      body: FutureBuilder(
        future: getNotes(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.done)
          {
            print("=>${snapshot.data}");
            List<Map> mylist=snapshot.data as List<Map>;
            return ListView.builder(itemBuilder: (context, index) {
              Map m=mylist[index];
              if(m['theme']=='blue')
                {
                  tile_color=Colors.blue;
                }
              return ListTile(
                tileColor: tile_color,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return add_notes(m: m,method: "update",);
                  },));
                },
                title: Text("${m['title']}"),
                subtitle: Text("${m['notes']}"),
                leading: Text("${m['id']}"),
              );
            },itemCount: mylist.length,);
          }
          else
          {
            return Center(child: CircularProgressIndicator(),);
          }
        },),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return add_notes(method: "insert",);
        },));
      },
      child: Icon(Icons.add)),
    );
  }
}
