
import 'dart:io';
import 'package:flutter_linkify/flutter_linkify.dart';
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
    Future<void> _onOpen(LinkableElement link) async {
      if (await canLaunch(link.url)) {
        await launch(link.url);
      } else {
        throw 'Could not launch $link';
      }
    }


      return Scaffold(
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
                      height: 700.0,
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text("Project :  ${widget.qrResult}",
                                style: TextStyle(fontSize: 18.0,
                                    fontWeight: FontWeight.bold),),
                              Padding(padding: EdgeInsets.all(8.0),),
                              Divider(),
                              new Text("Reference : ${dataQr['reference']}",
                                style: TextStyle(fontSize: 18.0),),
                              Padding(padding: EdgeInsets.only(top: 8.0),),
                              Divider(),
                              new Text("Details : ${dataQr['details']}",
                                style: TextStyle(fontSize: 18.0),),
                              Padding(padding: EdgeInsets.only(top: 8.0),),
                              Divider(),
                              new Text("Date : ${dataQr['date']}",
                                style: TextStyle(fontSize: 18.0),),
                              Padding(padding: EdgeInsets.only(top: 8.0),),
                              Divider(),
                              new Text("Customer : ${dataQr['customer']}",
                                style: TextStyle(fontSize: 18.0),),
                              Padding(padding: EdgeInsets.only(top: 8.0),),
                              Divider(),
                              SizedBox(
                                height: 150,
//                                child: new Text(docFile.toString()),
                                child: ListView(

                                  children: docFile.map((fifi) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Linkify(
                                          onOpen: _onOpen,
                                            text: fifi,
                                           );
                                        }
                                        );

                                  }).toList(),
                                ),
                              ),


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




  

