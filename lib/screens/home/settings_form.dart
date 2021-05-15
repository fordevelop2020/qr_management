import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:qr_management/screens/home/Home.dart';
import 'package:qr_management/screens/home/ScanQrCode.dart';
import 'package:qr_management/screens/home/myFiles.dart';
import 'package:qr_management/screens/home/utils.dart';
import 'package:qr_management/widgets/button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:qr_management/api.dart';
import 'addProjet.dart';

class SettingsForm extends StatefulWidget {
  final FirebaseUser user;
  final String email;
  final GoogleSignIn googleSignIn;
  SettingsForm({this.user, this.googleSignIn,this.email, this.name,this.reference,this.date,this.index,this.localisation,
  this.mo, this.moDelegate, this.bet, this.topograph, this.customer, this.phase1, this.clues, this.comments, this.manager, this.details,this.imagesNotif,
    this.image3Ds,this.docId,this.documents});
  final String name;
  final String reference;
  final index;
  final DateTime date;
  final String localisation;
  final String mo;
  final String moDelegate;
  final String bet;
  final String topograph;
  final String customer;
  final String phase1;
  final String clues;
  final String comments;
  final String manager;
  final String details;
  final List imagesNotif ;
  final List image3Ds;
  final String docId;
  final List documents;


  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final  _listKey = GlobalKey();
  DateTime _datePrj;
  String _dateText;
  String name;
  String reference;
  String localisation;
   String mo;
   String moDelegate;
   String bet;
   String topograph;
   String customer;
   String phase;
   String clues;
   String comments;
   String manager;
   String details;
   String docId;
   File imgFile;
  CloudApi api;
  var _phases = ['Esquisse','Aps','Apd','Pac','Pe','dce','exe','Reception'];
  var _selectedPhase = 'Esquisse';

  List<Asset> imagePlans2 = List<Asset>();
  List<Asset> image3d = List<Asset>();
   List<String> imageUrls=[];
  List<String> imageUrls3d=[];
  List<String> fileUrls = [];
   int index= 0;
   bool isSelected = false;
  String _error = 'No Error Dectected';
  List imagePlans =[];
  List image3Dss =[];
  List imagesTotal = [];
  List docs = [];
  String fileName;

  Map<String, String> _paths;
  Map<String,String> documents2= Map<String,String>();
  String _extension;
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  StorageUploadTask _uploadTask2;


  TextEditingController ctrName;
  TextEditingController ctrRef;
  TextEditingController ctrLocal;
  TextEditingController ctrMo;
  TextEditingController ctrMoD;
  TextEditingController ctrBet;
  TextEditingController ctrTopo;
  TextEditingController ctrCust;
//  TextEditingController ctrPhase;
  TextEditingController ctrClu;
  TextEditingController ctrComm;
  TextEditingController ctrManager;
  TextEditingController ctrDetails;
  int _currentIndex =0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctrName = new TextEditingController(text: widget.name);
    ctrRef = new TextEditingController(text: widget.reference);
    ctrLocal = new TextEditingController(text: widget.localisation);
    ctrBet = new TextEditingController(text: widget.bet);
    ctrClu = new TextEditingController(text: widget.clues);
    ctrComm = new TextEditingController(text: widget.comments);
    ctrCust = new TextEditingController(text: widget.customer);
    ctrManager= new TextEditingController(text: widget.manager);
    ctrMo = new TextEditingController(text: widget.mo);
    ctrMoD = new TextEditingController(text: widget.moDelegate);
//    ctrPhase = new TextEditingController(text: widget.phase);
    ctrTopo = new TextEditingController(text: widget.topograph);
    ctrDetails = new TextEditingController(text: widget.details);


    _datePrj = widget.date;
    _dateText = "${_datePrj.day}/${_datePrj.month}/${_datePrj.year}";
    name = widget.name;
    reference = widget.reference;
    localisation = widget.localisation;
    bet = widget.bet;
    clues = widget.clues;
    comments = widget.comments;
    customer = widget.customer;
    manager = widget.manager;
    mo = widget.mo;
    moDelegate = widget.moDelegate;
    phase = widget.phase1;
    topograph = widget.topograph;
    details = widget.details;
    imagePlans = widget.imagesNotif;
    image3Dss = widget.image3Ds;
    imagesTotal = imagePlans + image3Dss;
    docId = widget.docId;
    docs = widget.documents;

    rootBundle.loadString('assets/credentials.json').then((json){
      api = CloudApi(json);
    });

  }

  Future<Null> _selectDatePrj(BuildContext context) async {
    final picked = await showDatePicker(context: context,
        initialDate: _datePrj,
        firstDate: DateTime(2012),
        lastDate: DateTime(2080));

    if (picked != null) {
      setState(() {
        _datePrj = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }



  Future<void> loadAssets() async {
    setState(() {
      imagePlans2 = List<Asset>();
    });
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: false,
        selectedAssets: imagePlans2,
        cupertinoOptions  : CupertinoOptions(takePhotoIcon: "chat"),
//
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on PlatformException catch (e) {
      error = e.message;
    }

    if (!mounted) return;

    setState(() {
      imagePlans2 = resultList;
      _error = error;
    });
  }

  Future<void> loadAssets2() async {
    setState(() {
      image3d = List<Asset>();
    });
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: false,
        selectedAssets: image3d,
        cupertinoOptions  : CupertinoOptions(takePhotoIcon: "chat"),
//
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on PlatformException catch (e) {
      error = e.message;
    }

    if (!mounted) return;

    setState(() {
      image3d = resultList;
      _error = error;
    });
  }

  Widget buildGridView() {
    return GridView.count(
        crossAxisCount: 6,
        // ignore: missing_return
        children: List.generate(imagePlans2.length, (index)
        {
          Asset asset = imagePlans2[index];
          return Padding(
            padding: EdgeInsets.all(2.0),
            child: ThreeDContainer(
              backgroundColor: MultiPickerApp.darker,
              backgroundDarkerColor: MultiPickerApp.darker,
              height: 50,
              width: 50,
              borderDarkerColor: MultiPickerApp.pauseButton,
              borderColor: MultiPickerApp.pauseButtonDarker,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: AssetThumb(
                  asset: asset,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          );
        }));
  }

  Widget buildGridView2() {
    return GridView.count(
        crossAxisCount: 6,
        // ignore: missing_return
        children: List.generate(image3d.length, (index)
        {
          Asset asset = image3d[index];
          return Padding(
            padding: EdgeInsets.all(2.0),
            child: ThreeDContainer(
              backgroundColor: MultiPickerApp.darker,
              backgroundDarkerColor: MultiPickerApp.darker,
              height: 50,
              width: 50,
              borderDarkerColor: MultiPickerApp.pauseButton,
              borderColor: MultiPickerApp.pauseButtonDarker,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: AssetThumb(
                  asset: asset,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          );
        }));
  }



  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    final response = await api.save(
        fileName, (await imageFile.getByteData()).buffer.asUint8List());
    print(response.downloadLink);
    return response.downloadLink;
  }

    Future<dynamic> postFile(fileName) async {
    _extension = fileName.toString().split('.').last;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask2 = reference.putFile(File(fileName),StorageMetadata(contentType: '$FileType.custom/$_extension'));
    StorageTaskSnapshot downloadUrl = await uploadTask2.onComplete;
    final String url =(await downloadUrl.ref.getDownloadURL());
    return url;

  }



  Future<void> _editDocs() async{
    for(String dwnlfile in documents2.values) {
      postFile(dwnlfile).then((downloadUrl) {
        fileUrls.add(downloadUrl.toString());
        if (fileUrls.length == documents2.length) {
          Firestore.instance.runTransaction((
              Transaction transaction) async {
            DocumentSnapshot snapshot = await transaction.get(
                widget.index);
            await transaction.update(snapshot.reference, {

              "documents": docs + fileUrls
            });
          });
//                }
        }
      }).catchError((err) {
        print(err);
      });
    }

  }


  void _openFileExplorer() async {
    try {
      _paths = await FilePicker.getMultiFilePath(
        // ignore: missing_return
          type: FileType.custom, allowedExtensions: [_extension]);
      setState(() {
        documents2 = _paths;
      });
      uploadToFirebase();
      _editDocs();

    } on PlatformException catch(e){
      print("Unsupported operation" +e.toString());
    }if (!mounted){ return;}
  }

  uploadToFirebase(){
    _paths.forEach((fileName, filePath) => {
      upload(fileName, filePath)});
  }

  upload(fileName, filePath) {
    _extension = fileName.toString().split('.').last;
    StorageReference storageRef =
    FirebaseStorage.instance.ref().child(fileName);
    _uploadTask2 = storageRef.putFile(
      File(filePath),
      StorageMetadata(
        contentType: '$FileType.custom/$_extension',
      ),
    );
    setState(() {
      _tasks.add(_uploadTask2);

    });
  }



  Future<void> downloadFile(StorageReference ref) async {
    final String url = await ref.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/tmp.jpg');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task.future).totalByteCount;
    var bodyBytes = downloadData.bodyBytes;
    final String name = await ref.getName();
    final String path = await ref.getPath();
    print(
      'Success!\nDownloaded $name \nUrl: $url'
          '\npath: $path \nBytes Count :: $byteCount',
    );
  }


  @override
        Widget build(BuildContext context) {
          ThemeData theme = Theme.of(context);

          Future<void> _onOpen(String link) async {
            if (await canLaunch(link)) {
              await launch(link);
            } else {
              throw 'Could not launch $link';
            }
          }



          _editingDT(){
            Firestore.instance.runTransaction((
                Transaction transaction) async {
              DocumentSnapshot snapshot = await transaction.get(
                  widget.index);
              await transaction.update(snapshot.reference, {
//                "imagePlans":imagePlans + imageUrls,
//                "image3d":  image3Dss + imageUrls3d,
                "reference": reference,
                "date": _datePrj,
                "location": localisation,
                "bet": bet,
                "clues": clues,
                "comments": comments,
                "customer": customer,
                "responsible": manager,
                "mo": mo,
                "moDelegate": moDelegate,
                "phase": _selectedPhase,
                "topo": topograph,
                "details": details,
              });
            });

          }

          _addImgP(){
            for (var imageFile in imagePlans2) {
              postImage(imageFile).then((downloadUrl) {
                imageUrls.add(downloadUrl.toString());
                if (imageUrls.length == imagePlans2.length) {
                  Firestore.instance.runTransaction((
                      Transaction transaction) async {
                    DocumentSnapshot snapshot = await transaction.get(
                        widget.index);
                    await transaction.update(snapshot.reference, {

                      "imagePlans":imagePlans + imageUrls,
                    });
                  });
//                  _editingDT();
                }
              }).catchError((err) {
                print(err);
              });
            }
          }

          _adImg3D(){
            for (var imageFile3d in image3d) {
              postImage(imageFile3d).then((downloadUrl2) {
                imageUrls3d.add(downloadUrl2.toString());
                if (imageUrls3d.length == image3d.length) {
                  Firestore.instance.runTransaction((
                      Transaction transaction) async {
                    DocumentSnapshot snapshot = await transaction.get(
                        widget.index);
                    await transaction.update(snapshot.reference, {
                      "image3d":  image3Dss + imageUrls3d,
                    });
                  });
//                  _editingDT();
                }

              }).catchError((err) {
                print(err);
              });
            }
          }

          Future<void> _editProject() async{
            _editingDT();
            _addImgP();
                 _adImg3D();


            Navigator.pop(context);
          }


          final List<Widget> children = <Widget>[];
          _tasks.forEach((StorageUploadTask task) {
            final Widget tile = UploadTaskListTile(task: task,
              onDismissed: (){
                setState(() {
                  _tasks.remove(task);
                });
              },
              onDownload: (){
                downloadFile(task.lastSnapshot.ref);
              },
            );  children.add(tile);
          });

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


          return new Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text("Update your project data",style: TextStyle(color: Color(0xff0f4c75)),),
              backgroundColor: Colors.grey[300],
              toolbarOpacity: 0.5,
              iconTheme: IconThemeData(
                  color: Color(0xff0f4c75)
              ),
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

            body: Form(
              key: _formKey,
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Project images", style: TextStyle(color: Color(0xff0f4c75),fontSize: 18.0,fontWeight: FontWeight.w600),),
                          ),
                        ],
                      ),
                         Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
                            child: Column(children: <Widget>[
                              Stack(
                                  children: <Widget>[
                                    Text("Images Plans & images 3D",style: TextStyle(
                                color: Colors.grey[600],
                          fontSize: 14.0,
                        ),),

                                    SizedBox(
                                      height: 80.0,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: imagePlans.asMap().map((i, item) =>
                                            MapEntry(
                                              i,
                                              Builder(
                                                  builder: (BuildContext context) {
                                                    return Container(
                                                        child: Stack(
                                                            alignment: AlignmentDirectional.bottomCenter,
                                                            children: <Widget>[
                                                              Container(
//                                                                margin: EdgeInsets.all(8.0),
                                                                child: Card(
                                                                  elevation: 3.5,
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                    child: Image.network(
                                                                      item,
                                                                      fit: BoxFit.fill,
//                                                              BorderRadius.all(Radius.circular(10)),
                                                                      width: 50,
                                                                      height: 50,
                                                                      errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                                                                        return Text('error widget...');
                                                                      },
                                                                    ),

                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                  right: -16,
                                                                  top: 2,
                                                                  child: IconButton(
                                                                      icon: Icon(
                                                                        Icons.cancel,
                                                                        color: Colors.red.withOpacity(0.7),
                                                                        size: 18,
                                                                      ),
                                                                      onPressed: () => setState(() {
                                                                        imagePlans.removeAt(i);


                                                                      })))
                                                            ] ));

                                                  }),
                                            )).values.toList(),

                                      ),
                                    ),


                                  ]),
                            ])),
                      SizedBox(
                        height: 80.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: image3Dss.asMap().map((i, item) =>
                              MapEntry(
                                i,
                                Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                          child: Stack(
                                              alignment: AlignmentDirectional.bottomCenter,
                                              children: <Widget>[
                                                Container(
//                                                                margin: EdgeInsets.all(8.0),
                                                  child: Card(
                                                    elevation: 3.5,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      child: Image.network(
                                                        item,
                                                        fit: BoxFit.fill,
//                                                              BorderRadius.all(Radius.circular(10)),
                                                        width: 50,
                                                        height: 50,
                                                        errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                                                          return Text('error widget...');
                                                        },
                                                      ),

                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    right: -16,
                                                    top: 2,
                                                    child: IconButton(
                                                        icon: Icon(
                                                          Icons.cancel,
                                                          color: Colors.red.withOpacity(0.7),
                                                          size: 18,
                                                        ),
                                                        onPressed: () => setState(() {
                                                          image3Dss.removeAt(i);


                                                        })))
                                              ] ));

                                    }),
                              )).values.toList(),

                        ),
                      ),
//                      ),
                      Card(
                        elevation: 4.0,
//                        color: Color(0xffBBE1FA),
                        shadowColor: Color(0xffBBE1FA),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),

                        ),
                        child: SizedBox(
                          height: 170.0,
                          child: Row(
                            mainAxisAlignment : MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                           Card(
                            elevation: 3.0,
                            shadowColor:Color(0xffBBE1FA) ,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: SizedBox(
                                height: 178.0,
                                width: 174,

                                  child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text("Add images Plans",style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14.0,
                                      ),),
                                      new IconButton(icon: new Icon(Icons.add_photo_alternate), onPressed: loadAssets,),
                                      SizedBox(
                                        height: 60.0,

                                        child: Expanded(

                                          child: buildGridView(),
                                        ),
                                      ),
                                    ],
                                  ),

                              ),   ),
                              SizedBox(width: 3.0,),
                              Card(
                                elevation: 3.0,
                                shadowColor:Color(0xffBBE1FA) ,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: SizedBox(
                                  height: 178.0,
                                  width: 174,
                                  child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text("Add images 3D",style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14.0,
                                      ),),
                                      new IconButton(icon: new Icon(Icons.add_photo_alternate), onPressed: loadAssets2,),
                                      SizedBox(
                                        height: 60.0,

                                        child: Expanded(

                                          child: buildGridView2(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Project identifiers", style: TextStyle(color: Color(0xff0f4c75),fontSize: 18.0,fontWeight: FontWeight.w600),),
                          ),
                        ],
                      ),


                      Card(
                        elevation: 3.5,
                        shadowColor: Color(0xffBBE1FA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              TextFormField(
                                enableInteractiveSelection: false,
                                enabled: false,
                                controller: ctrName,
                                style: theme.textTheme.subhead.copyWith(color: theme.disabledColor),
                                decoration: new InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Name project',
                                ),
                              ),

                              SizedBox(height: 15.0),
                              TextFormField(
                                controller: ctrRef,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Reference',
                                ),
                                onChanged: (String val2) =>
                                    setState(() => reference = val2),
                              ),
                              SizedBox(height: 15.0),

                              TextFormField(
                                controller: ctrDetails,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Details',
                                ),
                                onChanged: (String val2) =>
                                    setState(() => details = val2),
                              ),
                              SizedBox(height: 15.0),
                              Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: TextFormField(
                                      initialValue: _dateText,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30)),
                                        labelText: 'Date project',
                                        suffixIcon: new IconButton(
                                          icon: Icon(Icons.date_range,
                                              color: Color(0xff0f4c75)),
                                          onPressed: () => _selectDatePrj(context),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 15.0),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Project information", style: TextStyle(color: Color(0xff0f4c75),fontSize: 18.0,fontWeight: FontWeight.w600),),
                          ),
                        ],
                      ),
                      Card(
                        elevation: 3.5,
                        shadowColor: Color(0xffBBE1FA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: ctrCust,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Customer',
                                ),
                                onChanged: (String val2) =>
                                    setState(() => customer = val2),
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                controller: ctrLocal,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Localisation',
                                ),
                                onChanged: (String val) =>
                                    setState(() => localisation = val),
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                controller: ctrMo,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Mo',
                                ),
                                onChanged: (String val2) => setState(() => mo = val2),
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                controller: ctrMoD,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  labelText: 'MoDelegate',
                                ),
                                onChanged: (String val2) =>
                                    setState(() => moDelegate = val2),
                              ),
                              SizedBox(height: 15.0),
                          DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                labelText: 'Phase',
                              ),

                              items: _phases.map((phasee){
                                return DropdownMenuItem(
                                  value: phasee,
                                  child: Text(phasee),
                                );
                              }).toList(),

                              onChanged: (String val) => setState(() => _selectedPhase = val),
                              value: phase ??  _selectedPhase   ,

                          ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                controller: ctrClu,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Indices',
                                ),
                                onChanged: (String val2) =>
                                    setState(() => clues = val2),
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                controller: ctrComm,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Comments',
                                ),
                                onChanged: (String val2) =>
                                    setState(() => comments = val2),
                              ),
                              SizedBox(height: 15.0),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Project members", style: TextStyle(color: Color(0xff0f4c75),fontSize: 18.0,fontWeight: FontWeight.w600),),
                          ),
                        ],
                      ),

                      Card(
                        elevation: 3.5,
                        shadowColor: Color(0xffBBE1FA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 15.0),
                              TextFormField(
                                controller: ctrManager,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Manager',
                                ),
                                onChanged: (String val2) =>
                                    setState(() => manager = val2),
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                controller: ctrBet,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  labelText: 'BET',
                                ),
                                onChanged: (String val2) => setState(() => bet = val2),
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                controller: ctrTopo,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Topographer',
                                ),
                                onChanged: (String val2) =>
                                    setState(() => topograph = val2),
                              ),
                              SizedBox(height: 15.0),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("My files", style: TextStyle(color: Color(0xff0f4c75),fontSize: 18.0,fontWeight: FontWeight.w600),),
                          ),
                        ],
                      ),
                      docs.isEmpty || docs == null ? Text("no document found") :

                      Card(
                        elevation: 4.0,
                        shadowColor: Color(0xffBBE1FA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),

                        ),
                        child: SizedBox(
                          height: 135,
                          child: ListView(

                            children: docs.map((fifi) {
                              return Builder(
                                  builder: (BuildContext context) {
                                    String uri = '${Uri.decodeComponent(fifi.toString())}';
                                    String fileName = uri.substring(uri.lastIndexOf('/')+1,uri.length);
                                    String nameWithoutEx = fileName.substring(0, fileName.lastIndexOf('?'));
                                    return InkWell(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.attach_file, color: Color(0xff0f4c75),),
                                          ),
                                          Flexible(
                                            child: Text(
                                              "Document: "+ nameWithoutEx,
                                              textAlign: TextAlign.justify,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Color(0xff0f4c75),
                                                decoration: TextDecoration.underline,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete,color: Color(0xff0f4c75),),
                                              onPressed: () => setState(() {
                                              docs.removeAt(index);
                                              }
                                          )),
                                        ],
                                      ),
                                      onTap: () => _onOpen(fifi),
                                    );
                                  }
                              );

                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.lightBlue
                                        .withOpacity(0.5),
                                    offset: const Offset(1.1, 1.1),
                                    blurRadius: 10.0),
                              ],
                            ),
                            child: RaisedButton(
                              color: Color(0xff0f4c75),
                              child: Text('Add documents', style: TextStyle(fontWeight: FontWeight.w600,
                                fontSize: 14,
                                letterSpacing: 0.0,
                                color: Colors.white,),),
                              onPressed: (){
                                _openFileExplorer();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 90,
                        child: Expanded(
                          child: ListView(
                            children: children,
                          ),
                        ),
                      ),

                      // dropDown
//

                      RaisedButton(
                          color: Color(0xff0f4c75),
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _editProject();

                            }
                          }
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }
