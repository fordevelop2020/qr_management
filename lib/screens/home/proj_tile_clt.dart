
import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qr_management/screens/home/Home.dart';
import 'package:qr_management/screens/home/ScanQrClt.dart';
import 'package:qr_management/screens/home/addProjet.dart';
import 'package:qr_management/screens/home/myFiles.dart';
import 'package:qr_management/screens/home/settings_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'ScanQrCode.dart';
// ignore: must_be_immutable
class ProjTileClt extends StatefulWidget {
//  final FirebaseUser user;
//  final String email;
//  final GoogleSignIn googleSignIn;

  ProjTileClt({this.qrResult});
  final String qrResult;


  @override
  _ProjTileCltState createState() => _ProjTileCltState();
}
class _ProjTileCltState extends State<ProjTileClt> with TickerProviderStateMixin  {
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
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  int _currentIndex =0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
  }

  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
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
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    DocumentSnapshot dataQr ;
//    final List<Widget> _children = [
//      Home(user: widget.user, googleSignIn: widget.googleSignIn,email: widget.user.email),
//      ScanQrCode(user: widget.user, googleSignIn: widget.googleSignIn,email: widget.user.email),
//      MyFiles(user: widget.user, googleSignIn: widget.googleSignIn,email: widget.user.email),
//      MyAddPage(user: widget.user, googleSignIn: widget.googleSignIn,email: widget.user.email),
//    ];
//    _onTap() { // this has changed
//      Navigator.of(context)
//          .push(MaterialPageRoute(builder: (BuildContext context) => _children[_currentIndex])); // this has changed
//    }

    return Scaffold(
//        backgroundColor: Color(0xff0f4c75),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Project Tile Client',style: TextStyle(color: Color(0xff0f4c75)),),
        backgroundColor: Colors.grey[300],
        toolbarOpacity: 0.5,
        iconTheme: IconThemeData(
            color: Color(0xff0f4c75)
        ),
      ),

      body: Stack(
          children : <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.asset('assets/updatePrj.jpg'),
                )
              ],),

            Positioned(
                top: (MediaQuery.of(context).size.width / 1.2) -94.0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.0),
                        topRight: Radius.circular(32.0),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0
                        )
                      ],
                    ),

                    child: Padding(
                        padding: const EdgeInsets.only(left:8.0, right:8.0),
                        child: SingleChildScrollView(
                            child: Container(
                                constraints: BoxConstraints(
                                    minHeight: 364.0,
                                    maxHeight: tempHeight > 364.0 ? tempHeight : 364.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[

                                      Expanded(
                                          child: AnimatedOpacity(
                                              duration: const Duration(milliseconds: 500),
                                              opacity: opacity2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 16, right: 16,top: 8,bottom: 8),



                                                child: StreamBuilder<QuerySnapshot>(
                                                    stream: Firestore.instance.collection('Projet').where(
                                                        "name", isEqualTo: widget.qrResult).snapshots(),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.data == null) return Text("no data created for this Qr Code");

                                                      return ListView.builder(
                                                          itemCount: snapshot.data.documents.length,
                                                          itemBuilder: (context, index1) {
                                                            dataQr = snapshot.data.documents[index1];
                                                            // ignore: unnecessary_statements
                                                            imgList = dataQr['imagePlans'];
                                                            docFile = dataQr['documents'] ;
                                                            // ignore: unnecessary_statements
                                                            DateTime dateProject = dataQr['date'].toDate();


                                                            return Expanded(
                                                              child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: <Widget>[
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 16, bottom: 16, right: 16),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Positioned(
                                                                                  top:(MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
                                                                                  right: 35,
                                                                                  child:ScaleTransition(
                                                                                    alignment: Alignment.center,
                                                                                    scale:CurvedAnimation(
                                                                                        parent: animationController, curve: Curves.fastOutSlowIn),

                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),),]),
                                                                    Card(
                                                                      elevation: 2.5,
                                                                      child: Column(
                                                                        children: <Widget>[
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
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Card(
                                                                      elevation: 2.5,
                                                                      child: Column(
                                                                        children: <Widget>[
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
                                                                                child: Icon(Icons.account_circle, color: Color(0xff0f4c75),),
                                                                              ),
                                                                              Divider(),
                                                                              new Text("Customer : ${dataQr['customer']}",
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
                                                                              new Text("Indices : ${dataQr['clues']}",
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
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Card(
                                                                      elevation: 2.5,
                                                                      child: Column(
                                                                        children: <Widget>[
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
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Divider(),
                                                                    Card(
                                                                      elevation: 2.5,
                                                                      child: Column(
                                                                        children: <Widget>[
                                                                          docFile.isEmpty || docFile == null ? Text("no document found") :
                                                                          SizedBox(height: 10.0,),
                                                                          SizedBox(
                                                                            height: 130,


                                                                            child: ListView(
                                                                              children: docFile.map((fifi) {


                                                                                return new Builder(

                                                                                    builder: (BuildContext context) {
                                                                                      String uri = '${Uri.decodeComponent(fifi.toString())}';
                                                                                      String fileName = uri.substring(uri.lastIndexOf('/')+1,uri.length);
                                                                                      String nameWithoutEx = fileName.substring(0, fileName.lastIndexOf('?'));
                                                                                      return InkWell(
                                                                                        child: Row(
                                                                                          children: <Widget>[
                                                                                            Padding(padding: EdgeInsets.all(8.0),
                                                                                              child: Icon(Icons.attach_file, color: Color(0xff0f4c75),),
                                                                                            ),
                                                                                            Divider(),
                                                                                            Flexible(
                                                                                              child: Text(
                                                                                                "Document: "+ nameWithoutEx,
                                                                                                textAlign: TextAlign.justify,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                maxLines: 2,
                                                                                                style: TextStyle(
                                                                                                  color: Colors.blueAccent,
                                                                                                  decoration: TextDecoration.underline,
                                                                                                  fontSize: 14.0,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        onTap: () => _onOpen(fifi),
                                                                                      );
                                                                                    }
                                                                                );
                                                                              }).toList(),
                                                                            ),

                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 10.0,),
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

                                                                      items: imgList?.map((item) {
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
                                                                      })?.toList()?? [Text("no images added!")],
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
                                                                  ]
                                                              ),
                                                            );


//                                  ),
//                              ),
//                            )
//                          ],
//                        ),


//                      decoration: new BoxDecoration(
//                        boxShadow: [
//                          BoxShadow(
//                            color: Colors.grey.withOpacity(.5),
//                            blurRadius: 20.0, // soften the shadow
//                            spreadRadius: 0.0, //extend the shadow
//                            offset: Offset(
//                              5.0, // Move to right 10  horizontally
//                              5.0, // Move to bottom 10 Vertically
//                            ),
//                          )
//                        ],
//                      ),

//                    );
                                                          }
                                                      );

                                                    }
                                                ),

                                              )))]
                                ))))))]
      ),
//

    );
  }
}






