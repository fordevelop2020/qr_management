 import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qr_management/models/project.dart';


class ProjTile extends StatefulWidget {
  final Project project;
  ProjTile(this.project);


  @override
  _ProjTileState createState() => _ProjTileState();
}

final projectReference = FirebaseDatabase.instance.reference().child('project');

class _ProjTileState extends State<ProjTile> {
  List<Project> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Tile'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        height: 400.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                new Text("Name : ${widget.project.name}", style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                new Text("Reference : ${widget.project.reference}", style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                new Text("Details : ${widget.project.details}", style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                new Text("Date : ${widget.project.date}", style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                new Text("Customer : ${widget.project.customer}", style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: EdgeInsets.only(top: 8.0),
//      child: Card(
//        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
//        elevation: 6,
//        child: ListTile (
//          leading: CircleAvatar(
//            radius: 25.0,
//            backgroundColor: Colors.cyan[projet.projId],
//            backgroundImage: AssetImage('assets/User_Avatar_2.png'),
//          ),
//          title: Text(projet.name),
//          subtitle: Text('Created by :${projet.reference}'),
//
//
//        ),
//      ),
//    );
//  }

  
