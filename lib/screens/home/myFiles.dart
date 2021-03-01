import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Home.dart';
import 'ScanQrCode.dart';
import 'addProjet.dart';
class MyFiles extends StatefulWidget {
  final FirebaseUser user;
  final String email;
  final GoogleSignIn googleSignIn;

  const MyFiles({Key key, this.user, this.googleSignIn,this.email,}) : super(key: key);

  @override
  _MyFilesState createState() => _MyFilesState();
}
  class _MyFilesState extends State<MyFiles> with TickerProviderStateMixin {
    AnimationController animationController;
    Animation<double> animation;
    double opacity1 = 0.0;
    double opacity2 = 0.0;
    double opacity3 = 0.0;
    int _currentIndex =2;

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
     _onOpen(String link) async {
      if (await canLaunch(link)) {
        await launch(link);
      } else {
        throw 'Could not launch $link';
      }}

      final double tempHeight = MediaQuery.of(context).size.height -
         (MediaQuery.of(context).size.width / 1.2) +
         24.0;

     final List<Widget> _children = [
       Home(user: widget.user, googleSignIn: widget.googleSignIn,email: widget.user.email),
       ScanQrCode(user: widget.user, googleSignIn: widget.googleSignIn,email: widget.user.email),
       MyFiles(user: widget.user, googleSignIn: widget.googleSignIn,email: widget.user.email),
       MyAddPage(user: widget.user, googleSignIn: widget.googleSignIn,email: widget.user.email),
     ];
     _onTap() { // this has changed
       Navigator.of(context)
           .push(MaterialPageRoute(builder: (BuildContext context) => _children[_currentIndex])); // this has changed
     }

    return Scaffold(
      appBar: AppBar(
        title: Text("my Files"),
        backgroundColor: Color(0xff0f4c75),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xff0f4c75) ,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Color(0xff0f4c75),
        height: 50,

//              currentIndex: _currentIndex,
        items: <Widget>[
          Icon(Icons.home,size: 20,color: Colors.white,),
          Icon(FontAwesomeIcons.qrcode,size: 20,color: Colors.white,),
          Icon(FontAwesomeIcons.fileDownload,size: 20,color: Colors.white,),
          Icon(Icons.add_circle,size: 20,color: Colors.white,),

        ] ,
        index: _currentIndex,
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.bounceInOut,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
          _onTap();
        },
      ),

      body: Stack(
        children : <Widget>[
//        height: MediaQuery.of(context).size.height,
//        padding: const EdgeInsets.all(10.0),
         Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.4,
              child: Image.asset('assets/imgFiles.jpg'),
            )
            ],),

          Positioned(
            top: (MediaQuery.of(context).size.width / 1.2) -64.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
//                padding: EdgeInsets.all(10),
//                width: double.infinity,
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
//                      Padding(
//                    padding: const EdgeInsets.only(top: 32.0,left: 18.0,right: 16.0),

//                    ),
//                  Card(
//                    elevation: 20.0,
                   Expanded(
                     child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: opacity2,
                      child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16,top: 8,bottom: 8),

                        child: new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection("Projet").snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) return new Text("There is no expense");
                          return ListView.builder(
                            shrinkWrap: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot dataQr = snapshot.data.documents[index];
                                List docSingle = dataQr['documents'];
                                                  return new ListView(
                                                    shrinkWrap: true,
                                                    children: docSingle?.map((fifi) {
                                                      return new Builder(
                                                        // ignore: missing_return
                                                          builder: (BuildContext context) {
                                                            String uri = '${Uri.decodeComponent(fifi)}';
                                                            String fileName = uri.substring(uri.lastIndexOf('/') + 1, uri.length);
                                                            String nameWithoutEx = fileName.substring(0, fileName.lastIndexOf('?'));
                                                            print(nameWithoutEx);


                                                            return InkWell(
                                                              child: Row(
                                                                children: <Widget>[
                                                                  Padding(
                                                                    padding: EdgeInsets.all(8.0),
                                                                    child: Icon(Icons.attach_file, color: Color(0xff0f4c75),),),
                                                                  Divider(),
                                                                  Flexible(
                                                                    child: ListTile(title: new Text(nameWithoutEx,
//                                                                      textAlign: TextAlign.justify,
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w300,
                                                                        fontSize: 16,
                                                                        letterSpacing: 0.27,
                                                                        color: Color(0xff0f4c75),
                                                                      ),
                                                                      maxLines: 3,
                                                                      overflow: TextOverflow.ellipsis,),
                                                                      subtitle: new Text(dataQr['name']),

                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                              onTap: () =>
                                                                  _onOpen(
                                                                      fifi),

                                                            );
                                                          }
                                                      );
                                                    })?.toList() ?? [],
                                                      );
                              });
                        })),
                  ),


                        )
                ]),
              ),
            ),
    )))],
        ),
      );
    }
}
