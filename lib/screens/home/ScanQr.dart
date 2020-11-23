// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ScanQr extends StatefulWidget {
  @override
  _ScanQrState createState() => _ScanQrState();

}

class _ScanQrState extends State<ScanQr> {
  String qrResult = "Not Yet Scanned!";
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
            Text(
              qrResult,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),

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
                    qrResult = scanning;
                  });
                } on PlatformException catch(ex){
                  if(ex.code == BarcodeScanner.CameraAccessDenied){
                    setState(() {
                      qrResult = "Camera permission was denied";
                    });
                  }else {
                    setState(() {
                      qrResult = "Unknown Error $ex";
                    });
                  }
                }on FormatException{
                  setState(() {
                    qrResult = "You pressed the back button before scanning anything";
                  });
                }catch(ex){

                }

              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Colors.blue, width: 3.0)),
              ),
          ],
        ),

      ),
    );
  }
}