import 'package:flutter/material.dart';
import 'package:notes/notes/dbclass.dart';
import 'package:notes/notes/viewpage.dart';
import 'package:sqflite/sqflite.dart';

class add_notes extends StatefulWidget {
  String? method;
  String? title;
  String? notes;
  int? id;
  int? theme;
  add_notes({this.title,this.notes,this.id,this.theme,this.method});
  @override
  State<add_notes> createState() => _add_notesState();
}

class _add_notesState extends State<add_notes> {
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  int fontval=10;
  int currenttheme=0;
  List imglist=["blue.png","green.png","orange.png","red.png","skyblue.png"];
  List colorappbarlist=[Colors.blue,Colors.green,Colors.orange,Colors.red,Colors.lightBlueAccent];
  List colorbglist=[Colors.blue.withOpacity(0.5),Colors.green.withOpacity(0.5),Colors.orange.withOpacity(0.5),Colors.red.withOpacity(0.5),Colors.lightBlueAccent.withOpacity(0.5)];
  Color currentappbarcolor=Colors.blue;
  Color currentbodycolor=Colors.blue.withOpacity(0.5);
  Color currenttextbgcolor=Colors.transparent;
  Color currenticoncolor=Colors.black;
  @override
  void initState() {
    if(widget.method=="update")
      {
        t1.text=widget.title!;
        t2.text=widget.notes!;
        currentappbarcolor=colorappbarlist[widget.theme!];
        currentbodycolor=colorbglist[widget.theme!];
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: currentappbarcolor,
        title: TextField(

          controller: t1,
          keyboardType: TextInputType.multiline,
          maxLines: null,),
        actions: [
          IconButton(onPressed: () async {
            String title=t1.text;
            String notes=t2.text;
            if(widget.method=="update")
              {
                String q="update notes set title='$title',notes='$notes',theme='$currenttheme' where id=${widget.id}";
                dbclass().createdb().then((value) async {
                  int id=await value.rawUpdate(q);
                  if(id==1)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return viewpage();
                    },));
                  }
                });
              }
            else
              {
                String q="insert into notes values (null,'$title','$notes','$currenttheme')";
                dbclass().createdb().then((value) async {
                  int id=await value.rawInsert(q);
                  if(id>=1)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return viewpage();
                    },));
                  }
                });
              }
          }, icon: Icon(Icons.save)),
        ],
      ),
      body: Container(
        color: currentbodycolor,
        child: Column(children: [
          TextField(controller: t2,style: TextStyle(fontSize: fontval.toDouble(),
            color: currenticoncolor,
            backgroundColor: currenttextbgcolor
          )),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: (){
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.white, context: context,
                  builder: (BuildContext context) {
                      return Container(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imglist.length,
                          itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                currenttheme=index;
                                currentappbarcolor=colorappbarlist[index];
                                currentbodycolor=colorbglist[index];
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: 60,
                              child: Image.asset("images/${imglist[index]}"),
                            ),
                          );
                        },),
                      );
                },
                );
              }, icon: Icon(Icons.color_lens_outlined)),
              IconButton(onPressed: (){
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.white, context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imglist.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                currenticoncolor=colorappbarlist[index];
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: colorappbarlist[index],
                                shape: BoxShape.circle
                              ),
                            ),
                          );
                        },),
                    );
                  },
                );
              }, icon: Icon(Icons.circle,color: currenticoncolor,)),
              IconButton(onPressed: (){
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.white, context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imglist.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                currenttextbgcolor=colorappbarlist[index];
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: colorappbarlist[index],
                                  shape: BoxShape.circle
                              ),
                            ),
                          );
                        },),
                    );
                  },
                );
              }, icon: Icon(Icons.format_color_text_outlined)),
              DropdownButton(onChanged: (value) {
                setState(() {
                  fontval=value as int;
                });
              },items: [
                DropdownMenuItem(child: Text("10",style: TextStyle(fontSize: 10),),value: 10,),
                DropdownMenuItem(child: Text("12",style: TextStyle(fontSize: 12)),value: 12,),
                DropdownMenuItem(child: Text("14",style: TextStyle(fontSize: 14)),value: 14,),
                DropdownMenuItem(child: Text("16",style: TextStyle(fontSize: 16)),value: 16,),
                DropdownMenuItem(child: Text("18",style: TextStyle(fontSize: 18)),value: 18,),
                DropdownMenuItem(child: Text("24",style: TextStyle(fontSize: 24)),value: 24,),
              ],),
            ],
          )
        ]),
      ),
    );
  }
}
