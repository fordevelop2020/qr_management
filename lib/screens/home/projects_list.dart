//import 'dart:async';
//
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:qr_management/models/project.dart';
//import 'package:qr_management/screens/home/Home.dart';
//import 'package:qr_management/screens/home/proj_tile.dart';
//import 'package:firebase_database/firebase_database.dart';
//
//
//class ProjList extends StatefulWidget {
//  @override
//  _ProjListState createState() => _ProjListState();
//}
//
//final projectReference = FirebaseDatabase.instance.reference().child('project');
//
//class _ProjListState extends State<ProjList> {
//  List<Project> items;
//  StreamSubscription<Event> _onProjectAddedSubscription;
//  StreamSubscription<Event> _onProjectChangedSubscription;
//
//  @override
//  void initState() {
//    super.initState();
//    items = new List();
//    _onProjectAddedSubscription =
//        projectReference.onChildAdded.listen(_onProjectAdded);
//    _onProjectChangedSubscription =
//        projectReference.onChildChanged.listen(_onProjectUpdate);
//  }
//
//  @override
//  void dispose() {
//    // TODO: implement dispose
//    super.dispose();
//    _onProjectAddedSubscription.cancel();
//    _onProjectChangedSubscription.cancel();
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Project DB',
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text('Project Information'),
//          centerTitle: true,
//          backgroundColor: Colors.deepPurpleAccent,
//        ),
//        body: Center(
//          child: ListView.builder(
//              itemCount: items.length,
//              padding: EdgeInsets.only(top: 12.0),
//              itemBuilder: (context, position) {
//                return Column(
//                  children: <Widget>[
//                    Divider(height: 7.0,),
//                    Row(
//                      children: <Widget>[
//                        Expanded(child: ListTile(title: Text(
//                          '${items[position].name}', style: TextStyle(
//                          color: Colors.blueAccent,
//                          fontSize: 21.0,
//
//                        ),),
//                            subtitle:
//                            Text('${items[position].details}', style: TextStyle(
//                              color: Colors.blueGrey,
//                              fontSize: 21.0,
//
//                            ),),
//                            leading: Column(
//                              children: <Widget>[
//                                CircleAvatar(
//                                  backgroundColor: Colors.amberAccent,
//                                  radius: 17.0,
//                                  child: Text('${position + 1}',
//                                    style: TextStyle(
//                                      color: Colors.blueGrey,
//                                      fontSize: 21.0,
//
//                                    ),),
//
//                                ),
//
//                              ],
//                            ),
//                            onTap: () =>
//                                _navigateToProjectInformation(
//                                    context, items[position])),),
//                        IconButton(
//                            icon: Icon(Icons.delete, color: Colors.red),
//                            onPressed: () =>
//                                _deleteProject(
//                                    context, items[position], position)),
//                        IconButton(
//                            icon: Icon(Icons.edit, color: Colors.blueAccent),
//                            onPressed: () =>
//                                _navigateToProject(context, items[position])),
//
//                      ],
//                    ),
//                  ],
//                );
//              }
//          ),
//        ),
//
//        floatingActionButton: FloatingActionButton(
//          child: Icon(Icons.add, color: Colors.white),
//          backgroundColor: Colors.deepOrangeAccent,
//          onPressed: () => _createNewProject(context),
//        ),
//
//      ),
//    );
//  }
//
//
//  void _onProjectAdded(Event event) {
//    setState(() {
//      items.add(new Project.fromSnapShot(event.snapshot));
//    });
//  }
//
//  void _onProjectUpdate(Event event) {
//    var oldProjectValue = items.singleWhere((project) =>
//    project.projId == event.snapshot.key);
//    setState(() {
//      items[items.indexOf(oldProjectValue)] =
//      new Project.fromSnapShot(event.snapshot);
//    });
//  }
//
//  void _deleteProject(BuildContext context, Project project,
//      int position) async {
//    await projectReference.child(project.projId).remove().then((_) {
//      setState(() {
//        items.removeAt(position);
//      });
//    });
//  }
//
//  void _navigateToProjectInformation(BuildContext context,
//      Project project) async {
//    await Navigator.push(
//      context, MaterialPageRoute(builder: (context) => Home(project)),
//    );
//  }
//
//
//  void _navigateToProject(BuildContext context, Project project) async {
//    await Navigator.push(context,
//      MaterialPageRoute(builder: (context) => ProjTile(project)),
//    );
//  }
//
//
//  void _createNewProject(BuildContext context) async {
//    await Navigator.push(context,
//      MaterialPageRoute(builder: (context) => Home(Project(
//          null,
//          '',
//          '',
//          '',
//          '',
//          '',
//          '',
//          '',
//          '',
//          '',
//          '',
//          '',
//          '',
//          '',
//          '',
//          '',
//          '',
//          ''))),
//    );
//  }
//}
//
//
////    final proj = Provider.of<List<Project>>(context) ?? [];
////   // print(proj.documents);
//////    for (var doc in proj.documents){
//////      print(doc.data);
//////    }
////    proj.forEach((project) {
////     print (project.name);
////     print(project.reference);
////     print(project.image);
////     print(project.projId);
////    });
////
////    return ListView.builder(
////      itemCount: proj.length,
////        itemBuilder: (context, index){
////        return ProjTile(projet: proj[index]);
////        },
////    );
////  }
////}
