// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qr_management/screens/home/Home.dart';
import 'package:qr_management/screens/home/ScanQrCode.dart';
import 'package:qr_management/screens/home/addProjet.dart';
import 'package:qr_management/screens/home/myFiles.dart';
import 'package:qr_management/screens/home/proj_tile_clt.dart';

class ScanQrClt extends StatefulWidget {

  const ScanQrClt({Key key}) : super(key: key);
  @override
  _ScanQrCltState createState() => _ScanQrCltState();

}

class _ScanQrCltState extends State<ScanQrClt> {
  String qrResultScan = "Not Yet Scanned!";
  int _currentIndex =0;

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Scan Project Client",style: TextStyle(color: Color(0xff0f4c75)),),
        backgroundColor: Colors.grey[300],
        toolbarOpacity: 0.5,
        iconTheme: IconThemeData(
            color: Color(0xff0f4c75)
        ),
        centerTitle: true,
      ),
//      bottomNavigationBar: CurvedNavigationBar(
//        color: Color(0xff0f4c75) ,
//        backgroundColor: Colors.white,
//        buttonBackgroundColor: Color(0xff0f4c75),
//        height: 50,
//
////              currentIndex: _currentIndex,
//        items: <Widget>[
//          Icon(Icons.home,size: 20,color: Colors.white,),
//          Icon(FontAwesomeIcons.qrcode,size: 20,color: Colors.white,),
//          Icon(FontAwesomeIcons.fileDownload,size: 20,color: Colors.white,),
//          Icon(Icons.add_circle,size: 20,color: Colors.white,),
//
//        ] ,
//        index: _currentIndex,
//        animationDuration: Duration(milliseconds: 200),
//        animationCurve: Curves.bounceInOut,
//        onTap: (index){
//          setState(() {
//            _currentIndex = index;
//          });
//          _onTap();
//        },
//      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "RESULT",
              style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
            Row(
              children: <Widget>[
                Container(
                  width: 300,
                  child: Text(
                    "Project name: "+qrResultScan,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18.0),

                  ),),


                IconButton(
                  icon: Icon(Icons.remove_red_eye,color: Color(0xff3282b8),), onPressed: () {
                  Navigator.of(context).push( MaterialPageRoute(
                    builder: (context) => ProjTileClt(qrResult : qrResultScan),
                  ));
                },
                ),
              ],
            ),



            SizedBox(
              height: 20.0,
            ),
            FlatButton(
              padding: EdgeInsets.all(15.0),
              child: Text("SCAN QR CODE"),
              onPressed: () async{
                try {
                  String scanning = await BarcodeScanner.scan();
                  setState(() {
                    qrResultScan = scanning;
                    print(qrResultScan);
                  });
                } on PlatformException catch(ex){
                  if(ex.code == BarcodeScanner.CameraAccessDenied){
                    setState(() {
                      qrResultScan = "Camera permission was denied";
                    });
                  }else {
                    setState(() {
                      qrResultScan = "Unknown Error $ex";
                    });
                  }
                }on FormatException{
                  setState(() {
                    qrResultScan = "You pressed the back button before scanning anything";
                  });
                }catch(ex){

                }

              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Color(0xff3282b8), width: 3.0)),
            ),
          ],
        ),

      ),
    );
  }
}
