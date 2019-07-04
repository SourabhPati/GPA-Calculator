import 'package:flutter/material.dart';
import './gpa_calc.dart';
import 'dart:async';

class GPA extends StatefulWidget{
  @override
  GPAState createState() => new GPAState(); 
}
class GPAState extends State<GPA>{
  TextEditingController controller = new TextEditingController();
  int n;
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: new AppBar(title: new Text("GPA calculator"), backgroundColor: Colors.deepOrangeAccent),
      body: new Container(
        decoration: new BoxDecoration(border: new Border.all(color: Colors.transparent,width: 100.0),color: Colors.transparent),
        child: new ListView(
           children: <Widget>[
              new TextField(
                textAlign: TextAlign.center,
                autofocus: true,

                decoration: new InputDecoration(
                  fillColor: Colors.deepOrangeAccent,
                  hintText: "   Number of Subjects",
                  hintStyle: new TextStyle(color: Colors.deepPurple[300])
                ),
                keyboardType: TextInputType.number,
                controller: controller,
                onChanged: (String str){
                  setState((){
                  if(controller.text=="")
                      n=0;
                    n=int.parse(controller.text);
                  });
                },
              ),
              new IconButton(
                icon:new Icon(Icons.arrow_forward),
                onPressed: (){
                  if(n is int && n>0 && n<15){
                    int pass=n;
                    n=0;
                    controller.text="";
                  Navigator.of(context).push(new MaterialPageRoute(builder:(BuildContext context)=>new GPAcalc(pass)));
                }
                else{
                    controller.text="";
                    alert();
                  }
                },
              )
            ],
          ),
        ),
    );
  }
  Future<Null> alert() async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('Invalid number !'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('Please enter a valid number of subjects'),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Got it'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}