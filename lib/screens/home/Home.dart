// ignore: avoid_web_libraries_in_flutter
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
// ignore: unused_import
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:qr_management/models/project.dart';
import 'package:qr_management/screens/home/Reviews.dart';
import 'package:qr_management/screens/home/ScanQrCode.dart';
import 'package:qr_management/screens/home/myFiles.dart';
import 'package:qr_management/screens/home/profile.dart';
import 'package:qr_management/screens/home/proj_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import 'Help.dart';
import 'addProjet.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_management/api.dart';

class Home extends StatefulWidget {

final FirebaseUser user;
Future _data;
final GoogleSignIn googleSignIn;
final String qrResult;
final String email;
final String title;
final String photoUrl;

Home({this.user, this.googleSignIn, this.qrResult, this.email, this.title,this.photoUrl});
 @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<NetworkImage> _listOfImages = <NetworkImage>[];
  String qrData = "projectTest";
  String name;
  String email;
  String imageUrl;
  String projectDet = "";
  TextEditingController _searchController = TextEditingController();
  List _allResults = [];
  List _allResults2 = [];
  List _resultsList = [];
  Future resultsLoaded;
 int _currentIndex =0;
  static final _kAdIndex = 2;
  NativeAd _ad;
  bool _isLoaded = false;
//  CloudApi api;
  WidgetBuilder builder = buildProgressIndicator;

 static const adUnitIdNat = "ca-app-pub-7514857792356108/8873622662";
// static const adUnitIdNat = 'ca-app-pub-3940256099942544/1044960115';


 //Instantiate Interstitial Ads admob
  final InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: 'ca-app-pub-7514857792356108/6439031018',
    request: AdRequest(),
    listener: AdListener(),
  );

  //Interstitial Ad events
  final AdListener listener = AdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: $error');
    },
//    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
//    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) {
      ad.dispose();
      print('Ad closed.');
    },
//    // Called when an ad is in the process of leaving the application.
    onApplicationExit: (Ad ad) => print('Left application.'),
  );

  int _getDestinitionItemIndex(int rawIndex){
    if(rawIndex >= _kAdIndex && _isLoaded){
      return rawIndex -1;
    }
    return rawIndex;
  }

//  RateMyApp _rateMyApp = RateMyApp(
//    preferencesPrefix: 'rateMyApp_',
//    minDays: 3,
//    minLaunches: 7,
//    remindDays: 2,
//    remindLaunches: 5,
//    googlePlayIdentifier: 'com.fordevelop.qr_management',
//  );


  @override
  void initState() {
    limits= [0, 0, 0, 0, 0, 0,0,0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    super.initState();
//    rootBundle.loadString('assets/credentials.json').then((json){
//      api = CloudApi(json);
//    });
    _searchController.addListener(_onSearchChanged);
    MobileAds.instance.initialize();
    myInterstitial.load();
    _ad = NativeAd(
      adUnitId: adUnitIdNat,
      factoryId: 'listTile',
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');       },
      ),
    );

    _ad.load();
    print("my ad");print(adUnitIdNat);
//   _rateMyApp.init().then((_){
//     if(_rateMyApp.shouldOpenDialog){
//       _rateMyApp.showStarRateDialog(
//           context,
//           title: 'Enjoying Archi Viewer App?',
//           message: 'Please leave a rating!',
//
//           dialogStyle: DialogStyle(
//             titleAlign: TextAlign.center,
//             messageAlign: TextAlign.center,
//             messagePadding: EdgeInsets.only(bottom: 20.0),
//           ),
//         starRatingOptions: StarRatingOptions(),
//       );
//     }
//   });



  }

  @override
  void dispose(){
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _ad?.dispose();
    super.dispose();

  }

//
//  Future<dynamic> deleteImage(Asset imageFile) async{
//    final response = await api.delete(imageFile);
//    print(response.downloadLink);
//    return response.downloadLink;
//
//  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    resultsLoaded = getDataProjectsStreamsSnapshots();
  }

  _onSearchChanged(){
    searchResultsList();
    print(_searchController.text);
  }

  searchResultsList(){
    var showResults = [];
    if(_searchController.text != ""){
      for(var projSnapshot in _allResults){
        var name = Project.fromSnapShot(projSnapshot).name.toLowerCase();
        print("name proj"+name);
        if(name.contains(_searchController.text.toLowerCase())){
          showResults.add(projSnapshot);
        }
      }

    }else {
      showResults = List.from(_allResults);
    }

    setState(() {
      _resultsList = showResults;
    });
  }

  getDataProjectsStreamsSnapshots() async{
//    final uid = await Provider.of(context).auth.getCurrentUID();
    var data = await Firestore.instance
    .collection('Projet')
//    .document(uid)
//    .collection('name')
//    .where("date", isLessThanOrEqualTo: DateTime.now())
    .where("email", isEqualTo: widget.user?.email)
//    .orderBy('date')
    .getDocuments();

    setState(() {
      _allResults = data.documents;

    });
    searchResultsList();

    return "complete";
  }

  getPosition(duration){
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    double start = position.dy - 20;
    double contLimit = position.dy + renderBox.size.height - 20;
    double step = (contLimit-start)/6;
    limits = [];
    for (double x = start; x <= contLimit; x = x + step) {
      limits.add(x);
    }
    setState(() {
      limits = limits;
    });

  }

  Offset _offset = Offset(0,0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];

  bool isMenuOpen = false;

  double getSize(int x){
    double size  = (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 20 : 14;
    return size;
  }

  
  void _signOut() {
    AlertDialog alertDialog = new AlertDialog(
      content: Container(
        height: 215.0,

        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: widget.user.photoUrl != null? NetworkImage(widget.user.photoUrl): null,
              child: widget.user.photoUrl  == null? Icon(Icons.account_circle,size: 40): Container(),
              radius: 40.0,
              backgroundColor: Colors.transparent,
            ),
//            ClipOval(
//              child: new Image.network(widget.user.photoUrl),
//            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Sign out?", style: new TextStyle(fontSize: 16.0),),
            ),
            //new Divider(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    widget.googleSignIn.signOut();
                    Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context) => new MyHomePage())
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.check),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                      ),
                      Text("Yes")
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.close),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                      ),
                      Text("Cancel")
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("My Projects",style: TextStyle(color: Color(0xff0f4c75)),);

  static Widget buildProgressIndicator(BuildContext context) =>
      const Center(child: CircularProgressIndicator());



  @override
  Widget build(BuildContext context){


    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 0.65;
    double menuContainerHeight = mediaQuery.height/1.4;

    imageUrl = widget.user?.photoUrl;
    name = widget.user?.displayName;
    email = widget.user?.email;


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



    _launchURL() async {
      const url = 'https://thinkoya.com';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    _myFiles() async{
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => new MyFiles(email: widget.user.email,user: widget.user,googleSignIn: widget.googleSignIn,))
      );

    }

    _reviews() async{
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => new Reviews())
      );

    }
    _myProfile() async{
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => new MyProfile(email: widget.user.email,user: widget.user,googleSignIn: widget.googleSignIn,
                  imageUrl:widget.user.photoUrl))
      );

    }

    _myHelp() async{
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => new Help())
      );

    }
    Future<bool> confirm(DismissDirection direction, BuildContext context) async {
      return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm delete"),
              content: const Text("Are you sure you wish to delete this project?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Delete")),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                )
              ],
            );
          });
    }

    Future<void> _getData() async {
      setState(() {
        getDataProjectsStreamsSnapshots();

      });
    }

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(
              color: Color(0xff0f4c75)
            ),
            centerTitle: true,

             title: cusSearchBar,
             toolbarOpacity: 0.5,
             actions: <Widget>[
               IconButton(icon: cusIcon,color: Color(0xff0f4c75), onPressed: (){
                 setState(() {
                   if(this.cusIcon.icon == Icons.search){
                     this.cusIcon = Icon(Icons.cancel,color: Color(0xff0f4c75),);
                     this.cusSearchBar = TextField(
                       controller: _searchController,
                       textInputAction: TextInputAction.go,
                       decoration: InputDecoration(
                         border: InputBorder.none,
                         hintText: "Search Project",
                         hintStyle: TextStyle(color: Color(0xff0f4c75)),
                         suffixIcon: _searchController.text.isNotEmpty
                             ? GestureDetector(
                           onTap: () {
                             WidgetsBinding.instance.addPostFrameCallback(
                                     (_) => _searchController.clear());
                           },
                         )
                             : null,
                       ),
//                       ),
                       style: TextStyle(
                         color: Color(0xff0f4c75),
                         fontSize: 16.0,
                       ),
                     );
                   } else{
                     this.cusIcon = Icon(Icons.search,color: Color(0xff0f4c75),);
                   this.cusSearchBar = Text("My projects",style: TextStyle(color: Color(0xff0f4c75)),);
                   }
                 });

               },)
             ],
             elevation: 20.0,
//             textTheme: TextTheme(
//               title: TextStyle(color: Colors.redAccent)
//             ),

             backgroundColor: Colors.grey[300],
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
                if(_currentIndex == 3){
                  myInterstitial.show();
                }
                if(_currentIndex == 2){
                  myInterstitial.show();
                }
              },
            ),
            body: Container(
                width: mediaQuery.width,

                  child: Stack(
                      children: <Widget>[
                        _resultsList.length!= 0
                    ?
                        RefreshIndicator(
                          child:Column(
                            children : [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0,8.0,2.0,0.0),
                              child: Row(
                                mainAxisAlignment : MainAxisAlignment.center,
                              children: <Widget>[

                                Container(
                                  padding: EdgeInsets.all(10.0),
                                    alignment: Alignment(0, 0),
                                    height: 50.0,
                                    color: Colors.orange.withOpacity(0.5),
                                    child: Text("To remove a project, swipe the tile to the left",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.justify)),
                              ],
                          ),
                            ),

                          Expanded(child: ListView.builder(
                           itemCount: _resultsList.length
                           + (_isLoaded ? 1 : 0),
                            itemBuilder: (context, index) {
                              if ( _isLoaded && index == _kAdIndex){
                                return
                                 Container(
                            margin: EdgeInsets.fromLTRB(25.0,8.0,8.0,8.0),
                            height: 150.0,
                            alignment: Alignment.center,
                           child: AdWidget(ad: _ad),);
                              } else {
                                final item = _resultsList[_getDestinitionItemIndex(index)];

                                                    _listOfImages = [];
                                                    for (int i = 0;
                                                    i <
                                                        item.data['imagePlans']
                                                        .length;
                                                    i++) {
                                                    _listOfImages.add(NetworkImage(item.data['imagePlans'][i]));}

                                                  return
                                                    Dismissible(
//                                                  key: Key(_resultsList[index].toString()),
                                                    key: UniqueKey(),
                                                    confirmDismiss: (direction) async => await confirm(direction,context),
                                                    background: Container(
                                                      alignment: AlignmentDirectional.centerEnd,
                                                      color: Colors.redAccent,
                                                      child: Icon(Icons.delete, color: Colors.white,),
                                                    ),
                                                       onDismissed: (direction){
                                                      DocumentSnapshot document = item;
                                                      _resultsList.remove(_resultsList.removeAt(index));
                                                      Firestore.instance.collection("Projet")
                                                      .document(document.documentID)
                                                      .delete().catchError((e){
                                                        print(e);
                                                      });
                                                      final snackBar = SnackBar(content: Text('Project: ${item.data['name']} is deleted!'));
                                                          Scaffold.of(context).showSnackBar(snackBar);
                                                      print(document.documentID);
                                                    },
                                                    child: SimpleFoldingCell.create(

                                                      frontWidget: _buildFrontWidget(context,item),
                                                      innerWidget: _buildInnerWidget(context,item),


                                                      cellSize: Size(MediaQuery
                                                          .of(context)
                                                          .size.width, 220),
                                                      padding: EdgeInsets.all(0),
                                                      animationDuration: Duration(
                                                          milliseconds: 300),
                                                      borderRadius: 10,
                                                      onOpen: () =>
                                                          print('$index cell opened'),
                                                      onClose: () =>
                                                          print('$index cell closed'),
                                                    )
//
                                                  );
                                                 }} ,
                            // ignore: missing_return


                                              ),)]),
                onRefresh: _getData,
                        ): Center(child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text("No data saved yet!, please add a project with the + icon", style: TextStyle(color:Color(0xff0f4c75).withOpacity(0.3),fontSize: 15, fontWeight: FontWeight.bold),maxLines: 3,textAlign: TextAlign.justify
                            ,overflow: TextOverflow.ellipsis,),
                        ),

                        ),

//                                          }),



                    AnimatedPositioned(
                      duration: Duration(milliseconds: 1500),
                      left: isMenuOpen?0: -sidebarSize+20,
                      top: 0,
                      curve: Curves.elasticOut,
                      child: SizedBox(
                        width: sidebarSize,
                        child: GestureDetector(
                          onPanUpdate: (details){
                            if(details.localPosition.dx <=sidebarSize){
                              setState(() {
                                _offset = details.localPosition;
                              });
                            }

                            if(details.localPosition.dx>sidebarSize-20 && details.delta.distanceSquared>2){
                              setState(() {
                                isMenuOpen = true;
                              });
                            }

                          },
                          onPanEnd: (details){
                            setState(() {
                              _offset = Offset(0,0);
                            });
                          },
                          child: Stack(
                            children: <Widget>[
                              CustomPaint(
                                size: Size(sidebarSize, mediaQuery.height),
                                painter: DrawerPainter(offset: _offset),
                              ),
                              Container(
                                height: mediaQuery.height,
                                width: sidebarSize,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      height: mediaQuery.height*0.25,
                                      child: Center(
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: Row(
                                              mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                               children: <Widget>[
                                                 new IconButton(

                                                   icon: Icon(Icons.directions_run, color: Colors.white,size: 20.0,),
                                                   onPressed: (){
                                                     _signOut();
                                                   },
                                                 ),

                                               Divider(),
//                                               SizedBox(width: 150.0),
                                                 new IconButton(
                                                   enableFeedback: true,
                                                   icon: Icon(Icons.keyboard_backspace,color: Colors.white,size: 20,),
                                                   onPressed: (){
                                                     this.setState(() {
                                                       isMenuOpen = false;
                                                     });
                                                   },),

                                               ],),
                                            ),
                                            CircleAvatar(
                                              backgroundImage: imageUrl != null? NetworkImage(imageUrl): null,
                                                child: imageUrl == null? Icon(Icons.account_circle,size: 40): Container(),

//                                              child: Image.network(widget.user.photoUrl,width: sidebarSize/2,),
                                              radius: 40.0,
                                              backgroundColor: Colors.transparent,
                                            ),
                                            SizedBox(height: 20.0,),
                                            Text(name ?? email,style: TextStyle(color: Colors.white),),
                                            ],
                                        ),

                                      ),
                                    ),
                                    Divider(thickness: 1,),
                                    Container(
                                      key: globalKey,
                                      width: double.infinity,
                                      height: menuContainerHeight,
                                      child: Column(
                                        children: <Widget>[
                                          MyButton(
                                            text: "My profile",
                                            iconData: FontAwesomeIcons.personBooth,
                                            textSize: getSize(0),
                                            height: (menuContainerHeight)/8,
                                            onPressed: _myProfile,

                                          ),
                                          MyButton(
                                            text: "About us?",
                                            iconData: Icons.work,
                                            textSize: getSize(0),
                                            height: (menuContainerHeight)/8,
                                            onPressed: _launchURL,
                                          ),
                                          MyButton(
                                            text: "My Files",
                                            iconData: Icons.attach_file,
                                            textSize: getSize(1),
                                            height: (menuContainerHeight)/8,
                                            onPressed: _myFiles,
                                          ),

                                          MyButton(
                                            text: "Help",
                                            iconData: Icons.help_outline,
                                            textSize: getSize(3),
                                            height: (menuContainerHeight)/8,
                                            onPressed: _myHelp,),
                                          MyButton(
                                            text: "Rate the app",
                                            iconData: Icons.star_half,
                                            textSize: getSize(4),
                                            height: (menuContainerHeight)/8,
                                            onPressed: _reviews,
                                          ),
//                                        MyButton(
//                                          text: "Settings",
//                                          iconData: Icons.settings,
//                                          textSize: getSize(5),
//                                          height: (menuContainerHeight)/8,),

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
//        ));

  }


final pdf = pw.Document();
 MemoryImage image;



Future savePdf() async{
  Directory documentDirectory = await getApplicationDocumentsDirectory();
  String documentPath = documentDirectory.path;
  File file = File("$documentPath/example.pdf");
  file.writeAsBytesSync(pdf.save());

  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save());
}

Widget _buildFrontWidget(BuildContext context,DocumentSnapshot document) {

String dataProj = document['name'].toString();
DateTime _datePrj = document['date'].toDate();
String dueDate = "${_datePrj.day}/${_datePrj.month}/${_datePrj.year}";
String email = document['email'].toString();
String logo;
String sign;


  return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Profile').where(
          "email", isEqualTo: widget.user.email).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();

        final docData = snapshot.data.documents;
        for (var ind in docData) {
           logo = ind.data['logo'];
           sign = ind.data['signature'];

        }
//        String logo = docData['logo'];

        return SizedBox(
          height: MediaQuery.of(context).size.height,
//          child: Expanded(
            child: Builder(
              // ignore: missing_return
                builder: (BuildContext context) {
                  return Container(

                      color: Color(0xffffffff),
                      alignment: Alignment.center,
                      child: Row(

                          children: <Widget>[

                            Expanded(
                              flex: 1,

                              child: Container(

                                width: 150.0,
                                height: 200.0,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.all(Radius.circular(
                                        40)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[500],
                                          offset: Offset(4.0, 4.0),
                                          blurRadius: 15.0,
                                          spreadRadius: 1.0),

                                      BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-4.0, -4.0),
                                          blurRadius: 15.0,
                                          spreadRadius: 1.0),
                                    ]),
//
                                child: Container(

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Container(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      21.0, 8.0, 8.0, 8.0),
                                                  child: Text(
                                                    dataProj,
//                                      document['name'].toString(),
                                                    overflow: TextOverflow.ellipsis,

                                                    maxLines: 5,
                                                    style: TextStyle(
                                                      color: Color(0xFF1b262c),
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.bold,
                                                      // fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                            ),
                                            Container(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      21.0, 8.0, 8.0, 8.0),
                                                  child: Text(
//                                        document['date'].toString(),
                                                    dueDate,
                                                    style: TextStyle(
                                                      color: Color(0xFF1b262c),
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.bold,
                                                      // fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                      )
                                    ],),
                                ),

                              ),
                            ),

                            Expanded(
                                flex: 2,
                                child: Container(
                                    height: 200.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.all(Radius
                                            .circular(40)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[500],
                                              offset: Offset(4.0, 4.0),
                                              blurRadius: 15.0,
                                              spreadRadius: 1.0),

                                          BoxShadow(
                                              color: Colors.white,
                                              offset: Offset(-4.0, -4.0),
                                              blurRadius: 15.0,
                                              spreadRadius: 1.0),
                                        ]),

                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                  document['reference'].toString(),
                                                  style: TextStyle(
                                                    color: Color(0xff0f4c75),
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  )
                                              ),
                                            )
                                        ),
                                        Container(
                                            child: Row(children: <Widget>[
                                              Container(child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  FontAwesomeIcons.mapMarkerAlt,
                                                  color: new Color(0xffF7B928),
                                                  size: 20.0,),
                                              ),),
                                              Container(child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                    document['location'].toString(),
                                                    style: TextStyle(
                                                      color: Color(0xff0f4c75),
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.bold,
                                                    )),
                                              ),),
                                            ],)
                                        ),

                                        Container(
                                          child: Row(children: <Widget>[
                                            Container(child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                radius: 30.0,
                                                backgroundImage:
                                                  document['imagePlans'][0]!= null ? NetworkImage(document['imagePlans'][0]): Icon(Icons.account_circle,size: 40) ,
//                                                          child: document['imagePlans']== null ?Icon(Icons.account_circle,size: 40): Container(),
                                            ),),
                                            )],),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[

                                            Positioned(
                                              right: 50,
                                              bottom: 0,
                                              child: IconButton(
                                                icon: Icon(Icons.list),
                                                color: Color(0xff0f4c75),
                                                onPressed: () {
                                                  final foldingCellState = context
                                                      .findAncestorStateOfType<
                                                      SimpleFoldingCellState>();
                                                  foldingCellState?.toggleFold();
                                                },
//
                                              ),
                                            ),
                                            Positioned(
                                              right: 50,
                                              bottom: 0,
                                              child: IconButton(
                                                icon: Icon(Icons.remove_red_eye),
                                                color: Color(0xff0f4c75),

                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProjTile(
                                                              qrResultHome: dataProj,
                                                              user: widget.user,
                                                              googleSignIn: widget
                                                                  .googleSignIn,
                                                              email: widget.user
                                                                  .email,),
                                                      ));
                                                },
                                              ),
                                            ),
                                            Positioned(
                                              right: 70,
                                              bottom: 0,
                                              child: IconButton(
                                                icon: Icon(Icons.print),
                                                color: Color(0xff0f4c75),
                                                onPressed: () async {

                                                  final PdfImage image = await pdfImageFromImageProvider(
                                                      pdf: pdf.document, image: Image.network(logo).image);
                                                  final PdfImage signat = await pdfImageFromImageProvider(
                                                      pdf: pdf.document, image: Image.network(sign).image);
                                                  print(signat);
//                                              final PdfImage image = await pdfImageFromImageProvider(
////                                            'assets/oyalogo.png'
//                                                  pdf: pdf.document
//                                                  , image: ""
//                                              );

                                                  pdf.addPage(


                                                      pw.MultiPage(
                                                          pageFormat: PdfPageFormat
                                                              .a4,

                                                          margin: pw.EdgeInsets.all(
                                                              32),
                                                          build: (
                                                              pw.Context context) {
                                                            return <pw.Widget>[
                                                              pw.Row(
                                                                  mainAxisAlignment: pw
                                                                      .MainAxisAlignment
                                                                      .center,
                                                                  children: [

                                                                    pw.Image(
                                                                      image,height: 100,width: 300
                                                                    ),
                                                                  ]
                                                              ),

                                                              pw.SizedBox(
                                                                  height: 30.0
                                                              ),
                                                              pw.Header(
                                                                level: 0,
                                                                child: pw.Text(
                                                                    "project identifiers"),
                                                              ),

                                                              pw.Text(
                                                                  "Name of the project: " +
                                                                      document['name']),
                                                              pw.Text(
                                                                  "Reference: " +
                                                                      document['reference']),
                                                              pw.Text("Details: " +
                                                                  document['details']),
                                                              pw.Text(
                                                                  "Date of creation: " +
                                                                      _datePrj
                                                                          .toString()),
                                                              pw.SizedBox(
                                                                  height: 30.0
                                                              ),

                                                              pw.Header(
                                                                level: 0,
                                                                child: pw.Text(
                                                                    "Project information"),
                                                              ),
                                                              pw.Text("Type: " +
                                                                  document['typeP']),
                                                              pw.Text("Customer: " +
                                                                  document['customer']),
                                                              pw.Text("Location: " +
                                                                  document['location']),
                                                              pw.Text("Phase: " +
                                                                  document['phase']),
                                                              pw.Text(
                                                                  "Project owner: " +
                                                                      document['mo']),
                                                              pw.Text(
                                                                  "Project owner delegate: " +
                                                                      document['moDelegate']),
                                                              pw.Text("Clues: " +
                                                                  document['clues']),
                                                              pw.Text("Comments: " +
                                                                  document['comments']),

                                                              pw.SizedBox(
                                                                  height: 30.0
                                                              ),

                                                              pw.Header(
                                                                level: 0,
                                                                child: pw.Text(
                                                                    "Project members"),
                                                              ),
                                                              pw.Text("Manager: " +
                                                                  document['responsible']),
                                                              pw.Text(
                                                                  "Bureau d'études technique: " +
                                                                      document['bet']),
                                                              pw.Text(
                                                                  "Topographer: " +
                                                                      document['topo']),

                                                              pw.SizedBox(
                                                                  height: 60.0
                                                              ),
                                                              pw.Row(
                                                                  mainAxisAlignment: pw
                                                                      .MainAxisAlignment
                                                                      .center,
                                                                  children: [


                                                                    pw.BarcodeWidget(
                                                                      barcode: pw.Barcode
                                                                          .qrCode(
                                                                        errorCorrectLevel: pw
                                                                            .BarcodeQRCorrectionLevel
                                                                            .high,
                                                                      ),
                                                                      data: document['name']
                                                                          .toString(),

                                                                      height: 100.0,
                                                                      width: 100.0,
                                                                    ),
                                                                    pw.SizedBox(width: 200.0),
                                                                    pw.Image(
                                                                        signat,height: 100,width: 300
                                                                    ),
                                                                  ]
                                                              ),

//                                                          pw.SizedBox(height: 60.0),

                                                            ];
                                                          }
                                                      ));
                                                  print(pw.Barcode.qrCode());
//                                      writeOnPdf();

                                                  await savePdf();
//                                        Directory documentDirectory = await getApplicationDocumentsDirectory();
//                                        String documentPath = documentDirectory.path;
//                                        String fullPath = "$documentPath/example.pdf";
//                                        String name = document['name'];
//                                        Navigator.push(context, MaterialPageRoute(
//                                          builder: (context) => pdfPreviewScreen(path: fullPath, name: name)
//                                        ));

                                                },
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )

                                )),
                          ]));
//      );

                }),
//          ),
        );

      });
}


Widget _buildInnerWidget(BuildContext context,DocumentSnapshot document) {
  return Builder(

      builder: (context)

  {
    return Container(
        color: Color(0xffffffff),
        alignment: Alignment.center,

          child: Container(
              height: 320.0,
              width: 340.0,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500],
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0 ),

                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0),
                  ]),
              child: Column(children: <Widget>[
                Container(child: Padding(

                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    "Details",
                    style: TextStyle(
                      color: Color(0xff0f4c75),
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),),
                Container(

                  child: Row(children: <Widget>[
                    Container(child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.person_pin,
                        color: new Color(0xff0f4c75),
                        size: 20.0,),
                    ),),
                    Container(child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                          document['customer'].toString(),
                          style: TextStyle(
                            color: Color(0xff0f4c75),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          )),

                    ),
                    )
                  ]),
                ),

                Container(
                  child: Row(children: <Widget>[
                    Container(child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.group,
                        color: new Color(0xff0f4c75),
                        size: 20.0,),
                    ),),
                    Container(child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                          document['mo'].toString(),
                          style: TextStyle(
                            color: Color(0xff0f4c75),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          )),

                    ),
                    )
                  ]),
                ),
                Container(
                  child: Row(children: <Widget>[
                    Container(child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.comment,
                        color: new Color(0xff0f4c75),
                        size: 20.0,),
                    ),),
                    Expanded(
                      child: Container(child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                            document['comments'].toString(),
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Color(0xff0f4c75),
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            )),

                      ),
                      ),
                    )
                  ]),
                ),
                Container(
                //  color: Color(0xffffffff),
                  child: Row(children: <Widget>[
                    Container(child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.build,
                        color: new Color(0xff0f4c75),
                        size: 20.0,),
                    ),),
                    Container(child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                          document['phase'].toString(),
                          style: TextStyle(
                            color: Color(0xff0f4c75),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          )),

                    ),
                    )
                  ]),
                ),
                Container(
//                  color: Color(0xffffffff),
                  child: Row(children: <Widget>[
                    Container(child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.details,
                        color: new Color(0xff0f4c75),
                        size: 20.0,),
                    ),),
                    Expanded(
                      child: Container(child: Padding(
                        padding: const EdgeInsets.all(6.0),
                          child: Text(
                              document['details'].toString(),
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                color: Color(0xff0f4c75),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              )),
                        ),

                      ),
                    ),
                  ]),
                ),
                Container(
//                  color: Color(0xffffffff),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[

                      Positioned(

                        right: 0,
                        bottom: 0,
                        child: IconButton(
                          icon: Icon(Icons.list),
                          color: Color(0xff0f4c75),
                          onPressed: () {
                            final foldingCellState = context
                                .findAncestorStateOfType<SimpleFoldingCellState>();
                            foldingCellState?.toggleFold();
                          },

                        ),
                      ),

                    ],
                  ),
                ),


              ],

              )


        ),

    );
//        )
  }
  );
}}

class MyButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final double textSize;
  final double height;
  final Function onPressed;

  MyButton({this.text, this.iconData, this.textSize,this.height, this.onPressed});



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialButton(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            iconData,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: textSize),
          ),
        ],
      ),

      onPressed:  onPressed ,
    );
  }
}
class DrawerPainter extends CustomPainter{

  final Offset offset;
  DrawerPainter({this.offset});
  
  double getControlPointX(double width){
    if(offset.dx == 0){
      return width;
    } else {
      return offset.dx>width?offset.dx:width+75;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()..color = Color(0xff0f4c75)..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(-size.width, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(getControlPointX(size.width),offset.dy,size.width, size.height);
    path.lineTo(-size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}