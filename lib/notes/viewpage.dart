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
  List notes=[];
  List titles=[];
  List themes=[];
  List ids=[];
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
            mylist.forEach((element) {
              notes.add(element['notes']);
              titles.add(element['title']);
              themes.add(element['theme']);
              ids.add(element['id']);
            });
            return ListView.builder(itemBuilder: (context, index) {
              if(themes[index]=='blue')
                {
                  tile_color=Colors.blue;
                }
              if(themes[index]=='green')
              {
                tile_color=Colors.green;
              }
              if(themes[index]=='orange')
              {
                tile_color=Colors.orange;
              }
              if(themes[index]=='red')
              {
                tile_color=Colors.red;
              }
              if(themes[index]=='lightBlueAccent')
              {
                tile_color=Colors.lightBlueAccent;
              }
              return ListTile(
                tileColor: tile_color,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return add_notes(title: titles[index],notes: notes[index],id: ids[index],theme:themes[index],method: "update",);
                  },));
                },
                title: Text("${titles[index]}"),
                subtitle: Text("${notes[index]}"),
                leading: Text("${ids[index]}"),
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
