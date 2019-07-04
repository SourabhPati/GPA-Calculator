import 'package:flutter/material.dart';
import './score_page.dart';
import 'dart:async';
import 'package:validator/validator.dart';
class GPAcalc extends StatefulWidget {
  final int n;

  GPAcalc(this.n);

  @override
  GPAcalcstate createState() => new GPAcalcstate();
}

class GPAcalcstate extends State<GPAcalc> {
  List<String> _items = ['O', 'A+', 'A', 'B+', 'B', 'C', 'P', 'F/Ab/I'].toList();
  var _selection;
  var list;
  var _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = new List.generate(widget.n, (i) => new TextEditingController());
    _selection= new List<String>()..length=widget.n;
    list = new List<int>.generate(widget.n, (i) =>i);
  }

  @override
  Widget build(BuildContext context) {
    int sogxc = 0, soc = 0;
    var textFields = <Widget>[];
    bool safeToNavigate = true ;
    textFields.add(new Row(
      children: [
        new Padding(
      padding:new EdgeInsets.only(left: 96.0),
    ),
        new Column(
          children:[
          new Text(
            "Credits",
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 17.0),
            ),
          ]
        ),
        new Padding(
      padding:new EdgeInsets.only(left: 72.0),
    ),
        new Column(
          children:[
           new Text(
            "Grade",
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 17.0),
            ),
          ],
        ),
        new Padding(
          padding:new EdgeInsets.only(bottom:25.0),
        ),
    ]
    ),
    );
      list.forEach((i) {
          textFields.add( new Column(
                children: [
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    new Text("Subject ${i+1}:",style: new TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),),
                    new Padding(
                      padding:new EdgeInsets.only(left: 35.0),
                    ),
                    new Container(
                      width: 56.0,
                    child: new TextField(
                      autocorrect: false,
                    controller: _controllers[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                        hintText: "Credit ${i + 1}", hintStyle: new TextStyle(color: Colors.deepPurple[400])),
                    ),
                    ),
                    new Padding(
                      padding:new EdgeInsets.all(30.0),
                    ),
                    new DropdownButton<String>(
                      hint: new Text("select",style: new TextStyle(color: Colors.deepPurple[400])),
                      value: _selection[i],
                      items: _items.map((String item) {
                        return new DropdownMenuItem<String>(
                          value: item,
                          child: new Text(item),
                        );
                      }).toList(),
                      onChanged: (s) {
                        setState(() {
                          _selection[i] = s;
                        });
                      },
                    )
                  ]
                  ),
                ],
              ),
          );
      });
        
    double res = 0.0;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("GPA calculator"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      backgroundColor: Colors.orange[100],
      body: new Container(
        decoration: new BoxDecoration(border: new Border.all(color: Colors.transparent, width: 30.0)),
        child: new ListView(
          children: textFields,
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Calculate',
        backgroundColor: Colors.deepOrangeAccent,
        child: new Icon(Icons.assessment),
        onPressed: () {
          for (int i = 0; i < widget.n; i++) {
            String chk = _controllers[i].text;
            if(chk == "" || !isInt(chk) || int.parse(chk) < 1 || int.parse(chk) > 6){
              safeToNavigate = false;
              continue;
            }
            if(_selection[i]==null){
              safeToNavigate = false;
              continue;
            }
            int cp = int.parse(chk);
            int gp = calculate(_selection[i]);
            int gxc = gp * cp;
            sogxc += gxc;
            soc += cp;
          }
          res = sogxc / soc;
          if(safeToNavigate)
          Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (BuildContext context) => new ScorePage(res),
                ),
              );
              else{
            alert();
          }
        },
      ),
    );
  }

  int calculate(var a) {
    if (a == "O") return 10;
    if (a == "A+") return 9;
    if (a == "A") return 8;
    if (a == "B+") return 7;
    if (a == "B") return 6;
    if (a == "C") return 5;
    if (a == "P") return 4;
    if (a == "F/Ab/I") return 0;
    return 0;
  }
 Future<Null> alert() async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('Credits/Grade empty or invalid !'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('Please fill in Credits and select respective grades correctly for all subjects to see your GPA.'),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Okay'),
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