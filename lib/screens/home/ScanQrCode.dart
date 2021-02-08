// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_management/screens/home/Home.dart';
import 'package:qr_management/screens/home/proj_tile.dart';

class ScanQrCode extends StatefulWidget {


  @override
  _ScanQrCodeState createState() => _ScanQrCodeState();

}

class _ScanQrCodeState extends State<ScanQrCode> {
 String qrResultScan = "Not Yet Scanned!";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4c75),
        title: Text("Scan"),
        centerTitle: true,
      ),
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
                    builder: (context) => ProjTile(qrResult : qrResultScan),
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
