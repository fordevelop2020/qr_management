
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:qr_management/screens/home/settings_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
// ignore: must_be_immutable
class ProjTile extends StatefulWidget {

  String qrResult;
  ProjTile({this.qrResult});

  @override
  _ProjTileState createState() => _ProjTileState();
}
class _ProjTileState extends State<ProjTile> {
  int _current = 0;
  CarouselSlider carouselSlider;
  List imgList = [];

  List docFile = [];
  var pathFile;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
  }


  @override
  Widget build(BuildContext context) {
   Size size = MediaQuery.of(context).size;
    Future<void> _onOpen(String link) async {
      if (await canLaunch(link)) {
        await launch(link);
      } else {
        throw 'Could not launch $link';
      }
    }

      return Scaffold(
//        backgroundColor: Color(0xff0f4c75),
        appBar: AppBar(
          title: Text('Project Tile'),
          backgroundColor: Color(0xff0f4c75),
        ),

        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('Projet').where(
                "name", isEqualTo: widget.qrResult).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data == null) return CircularProgressIndicator();

              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index1) {
                    DocumentSnapshot dataQr = snapshot.data.documents[index1];
                    // ignore: unnecessary_statements
                    imgList = dataQr['imagePlans'];
                    docFile = dataQr['documents'];

                    DateTime dateProject = dataQr['date'].toDate();


                    return Container(
                      height: 1500,
                      padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/building.png',height: 200,width: 400,),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  )
                                ),
//     ],

//                                    child: Card(
                                     child: Container(
                                       child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: IconButton(icon: Icon(Icons.edit),color: Color(0xff0f4c75),onPressed: (){
                                            Navigator.of(context).push(new MaterialPageRoute(
                                                builder: (BuildContext context) => new SettingsForm(
                                                  name: dataQr['name'],
                                                  reference: dataQr['reference'],
                                                  date: dataQr['date'].toDate(),
                                                  index: dataQr.reference,
                                                  localisation: dataQr['location'],
                                                  mo: dataQr['mo'],
                                                  moDelegate: dataQr['moDelegate'],
                                                  bet: dataQr['bet'],
                                                  topograph: dataQr['topo'],
                                                  customer: dataQr['customer'],
                                                  phase: dataQr['phase'],
                                                  clues: dataQr['clues'],
                                                  comments: dataQr['comments'],
                                                  manager: dataQr['responsible'],
                                                  details: dataQr['details'],


                                                )
                                            ));
                                          },),
                                        ),
                                      ],
                                    ),
                                          Row(
                                          children: <Widget>[
                                               Padding(padding: EdgeInsets.all(8.0),
                                                 child: Icon(Icons.work, color: Color(0xff0f4c75),),
                                        ),
                                            Divider(),
                                            new Text("Project :  ${widget.qrResult}",
                                            style: TextStyle(fontSize: 18.0,
                                                fontWeight: FontWeight.bold),),],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.title, color: Color(0xff0f4c75),),
                                              ),
                                              Divider(),
                                              new Text("Type : ${dataQr['typeP']}",
                                                style: TextStyle(fontSize: 14.0),),],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.comment, color: Color(0xff0f4c75),),
                                              ),
                                          Divider(),
                                          new Text("Reference : ${dataQr['reference']}",
                                            style: TextStyle(fontSize: 14.0),),],
                                       ),
                                          Row(
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.location_on, color: Color(0xff0f4c75),),
                                              ),
                                              Divider(),
                                              new Text("Localisation : ${dataQr['location']}",
                                                style: TextStyle(fontSize: 14.0),),],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.person, color: Color(0xff0f4c75),),
                                              ),
                                          Divider(),
                                          new Text("Mo : ${dataQr['mo']}",
                                            style: TextStyle(fontSize: 14.0),),],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.person_pin, color: Color(0xff0f4c75),),
                                              ),
                                              Divider(),
                                              new Text("Mo Delegate : ${dataQr['moDelegate']}",
                                                style: TextStyle(fontSize: 14.0),),],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.group, color: Color(0xff0f4c75),),
                                              ),
                                              Divider(),
                                              new Text("BET : ${dataQr['bet']}",
                                                style: TextStyle(fontSize: 14.0),),],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.gps_fixed, color: Color(0xff0f4c75),),
                                              ),
                                              Divider(),
                                              new Text("Topographer : ${dataQr['topo']}",
                                                style: TextStyle(fontSize: 14.0),),],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.date_range, color: Color(0xff0f4c75),),
                                              ),

                                          Divider(),
                                          new Text("Date project : ${dateProject.day}/${dateProject.month}/${dateProject.year}",
                                            style: TextStyle(fontSize: 14.0),),],
                                           ),
                                          Row(
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.account_circle, color: Color(0xff0f4c75),),
                                              ),
                                          Divider(),
                                          new Text("Customer : ${dataQr['customer']}",
                                            style: TextStyle(fontSize: 14.0),),],
                                       ),
                                        Row(
                                          children: <Widget>[
                                            Padding(padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.show_chart, color: Color(0xff0f4c75),),
                                            ),
                                            Divider(),
                                            new Text("Phase : ${dataQr['phase']}",
                                              style: TextStyle(fontSize: 14.0),),],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.assignment, color: Color(0xff0f4c75),),
                                            ),
                                            Divider(),
                                            new Text("Clues : ${dataQr['clues']}",
                                              style: TextStyle(fontSize: 14.0),),],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.supervisor_account, color: Color(0xff0f4c75),),
                                            ),
                                            Divider(),
                                            new Text("Manager : ${dataQr['responsible']}",
                                              style: TextStyle(fontSize: 14.0),),],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.comment, color: Color(0xff0f4c75),),
                                            ),
                                            Divider(),
                                            new Text("Comments : ${dataQr['comments']}",
                                              style: TextStyle(fontSize: 14.0),),],
                                        ),
//                                        Row(
//                                          children: <Widget>[
//                                            Padding(padding: EdgeInsets.all(8.0),
//                                              child: Icon(Icons.attach_file, color: Color(0xff0f4c75),),
//                                            ),
                                          Divider(),
                                          SizedBox(
                                              height: 100,
            //                                child: new Text(docFile.toString()),
                                              child: ListView(

                                                children: docFile?.map((fifi) {
                                                  return Builder(

                                                    builder: (BuildContext context) {
                                                      String fileName = fifi.toString().substring(fifi.lastIndexOf('/')+1, fifi.length);
                                                      String nameWithoutEx = fileName.substring(0, fileName.lastIndexOf('?'));
                                                    return InkWell(
                                                            child: Row(
                                                              children: <Widget>[
                                                                Padding(padding: EdgeInsets.all(8.0),
                                                                  child: Icon(Icons.attach_file, color: Color(0xff0f4c75),),
                                                                ),
//                                                                SizedBox(width: 20.0,),
                                                                Divider(),
                                                                Text(
                                                                 "Document: "+ nameWithoutEx,
                                                                  style: TextStyle(
                                                                    color: Colors.blueAccent,
                                                                    decoration: TextDecoration.underline,
                                                                    fontSize: 14.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            onTap: () => _onOpen(fifi),
                                                          );

//                                                      return Linkify(
//                                                        onOpen: _onOpen,
//                                                        text: "Documents: "+nameWithoutEx+","+fifi,style:TextStyle(fontSize: 16.0),
//                                                        textAlign: TextAlign.justify,
//                                                        overflow: TextOverflow.ellipsis,
//                                                        maxLines: 2,
//
//                                                         );
                                                      }
                                                      );

                                                })?.toList() ?? [Text("no document found")],
                                              ),
                                            ),
//                                  ],
//                                     ),


                                            carouselSlider = CarouselSlider(
                                              height: 200,
                                              initialPage: 0,
                                              enlargeCenterPage: true,
                                              autoPlay: true,
                                              reverse: false,
                                              autoPlayInterval: Duration(seconds: 2),
                                              autoPlayAnimationDuration: Duration(
                                                  milliseconds: 2000),
                                              pauseAutoPlayOnTouch: Duration(seconds: 10),
                                              scrollDirection: Axis.horizontal,
                                              onPageChanged: (index) {
                                                setState(() {
                                                  _current = index;
                                                });
                                              },

                                              items: imgList.map((item) {
                                                return Builder(
                                                  builder: (BuildContext context) {
                                                    return Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width,
                                                      margin: EdgeInsets.symmetric(
                                                          horizontal: 10.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                      ),
                                                      child: Image.network(
                                                        item,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                            Divider(),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: imgList.map((url) {
                                                int index = imgList.indexOf(url);
                                                return Container(
                                                  width: 8.0,
                                                  height: 8.0,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10.0, horizontal: 2.0),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: _current == index ? Colors
                                                          .blueAccent : Colors.grey),
                                                );
                                              }).toList(),
                                            ),
                                          ]),
                                     ),


//                                  ),
                              ),
                            )
                          ],
                        ),


                      decoration: new BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.5),
                            blurRadius: 20.0, // soften the shadow
                            spreadRadius: 0.0, //extend the shadow
                            offset: Offset(
                              5.0, // Move to right 10  horizontally
                              5.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                      ),

                    );
                  }
              );
            }
        ),

      );
    }
  }




  

