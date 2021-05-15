// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  //Instantiate Interstitial Ads admob
  final InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: 'ca-app-pub-7514857792356108/6439031018',
    request: AdRequest(),
    listener: AdListener(),
  );

  //Interstitial Ad events
  final AdListener listener1 = AdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) {
      ad.dispose();
      print('Ad closed.');
    },
    // Called when an ad is in the process of leaving the application.
    onApplicationExit: (Ad ad) => print('Left application.'),
  );
  @override
  void initState() {
    MobileAds.instance.initialize();
    myInterstitial.load();

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-7514857792356108/2297523297',
      request: AdRequest(),
      size: AdSize.banner,
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bannerAd.dispose();
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
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
                  myInterstitial.show();
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
            SizedBox(height: 20,),

            if (_isBannerAdReady)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
          ],
        ),

      ),
    );
  }
}
