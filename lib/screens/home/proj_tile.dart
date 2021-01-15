
import 'dart:io';
import 'package:flutter_linkify/flutter_linkify.dart';
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
    Future<void> _onOpen(LinkableElement link) async {
      if (await canLaunch(link.url)) {
        await launch(link.url);
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

                    return Container(
                      height: 900,
                      padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/building.png',height: 200,width: 400,),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(20),
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
                                          padding: const EdgeInsets.only(right: 0.0),
                                          child: IconButton(icon: Icon(Icons.edit),color: Color(0xff0f4c75),onPressed: (){
                                            Navigator.of(context).push(new MaterialPageRoute(
                                                builder: (BuildContext context) => new SettingsForm(
                                                  name: dataQr['name'],
                                                  reference: dataQr['reference'],
                                                  date: dataQr['date'].toDate(),
                                                  index: dataQr.reference,
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
                                              child: Icon(Icons.comment, color: Color(0xff0f4c75),),
                                              ),
                                          Divider(),
                                          new Text("Reference : ${dataQr['reference']}",
                                            style: TextStyle(fontSize: 18.0),),],
                                       ),
                                          Row(
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.details, color: Color(0xff0f4c75),),
                                              ),
                                          Divider(),
                                          new Text("Details : ${dataQr['details']}",
                                            style: TextStyle(fontSize: 16.0),),],
                                       ),
                                          Row(
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.date_range, color: Color(0xff0f4c75),),
                                              ),

                                          Divider(),
                                          new Text("Date project : ${dataQr['date'].toDate()}",
                                            style: TextStyle(fontSize: 16.0),),],
                                       ),
                                          Row(
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.person, color: Color(0xff0f4c75),),
                                              ),
                                          Divider(),
                                          new Text("Customer : ${dataQr['customer']}",
                                            style: TextStyle(fontSize: 16.0),),],
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
                                                  Icon(Icons.attach_file, color: Color(0xff0f4c75),);
                                                  return Builder(

                                                    builder: (BuildContext context) {
//                                                    Icon(Icons.attach_file, color: Color(0xff0f4c75),);
                                                      return Linkify(

                                                        onOpen: _onOpen,
                                                          text: "Documents: "+fifi,style:TextStyle(fontSize: 16.0),
                                                        textAlign: TextAlign.justify,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,

                                                         );
                                                      }
                                                      );

                                                })?.toList() ?? [Text("no document found")],
                                              ),
                                            ),
//                                  ],
//                                     ),


                                            carouselSlider = CarouselSlider(
                                              height: 200.0,
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




  

