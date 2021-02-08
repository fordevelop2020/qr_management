import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:qr_management/screens/home/utils.dart';
import 'package:qr_management/widgets/button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'addProjet.dart';

class SettingsForm extends StatefulWidget {
  SettingsForm({this.email, this.name,this.reference,this.date,this.index,this.localisation,
  this.mo, this.moDelegate, this.bet, this.topograph, this.customer, this.phase, this.clues, this.comments, this.manager, this.details,this.imagesNotif,this.docId,this.documents});
  final String email;
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
  final String phase;
  final String clues;
  final String comments;
  final String manager;
  final String details;
  final List imagesNotif ;
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

  List<Asset> imagePlans2 = List<Asset>();
   List<String> imageUrls=[];
  List<String> fileUrls = [];
   int index= 0;
   bool isSelected = false;
  String _error = 'No Error Dectected';
  List imagePlans =[];
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
  TextEditingController ctrPhase;
  TextEditingController ctrClu;
  TextEditingController ctrComm;
  TextEditingController ctrManager;
  TextEditingController ctrDetails;


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
    ctrPhase = new TextEditingController(text: widget.phase);
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
    phase = widget.phase;
    topograph = widget.topograph;
    details = widget.details;
    imagePlans = widget.imagesNotif;
    docId = widget.docId;
    docs = widget.documents;
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



  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putData(( await imageFile.getByteData()).buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    return storageTaskSnapshot.ref.getDownloadURL();
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



          Future<void> _editProject() async{
      for (var imageFile in imagePlans2) {
        postImage(imageFile).then((downloadUrl) {
          imageUrls.add(downloadUrl.toString());
      if (imageUrls.length == imagePlans2.length) {
//                if (fileUrls.length == documents2.length) {

                  Firestore.instance.runTransaction((
                      Transaction transaction) async {
                    DocumentSnapshot snapshot = await transaction.get(
                        widget.index);
                    await transaction.update(snapshot.reference, {
                      "imagePlans": imagePlans + imageUrls,
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
                      "phase": phase,
                      "topo": topograph,
                      "details": details,
                    });
                  });

              }
            }).catchError((err) {
              print(err);
            });
          }
//        }).catchError((err) {
//          print(err);
//        });
//      }
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


          return new Scaffold(
            appBar: AppBar(
              title: Text("Update your project data"),
              backgroundColor: Color(0xff0f4c75),
            ),
            body: Form(
              key: _formKey,
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      new IconButton(icon: new Icon(Icons.add_photo_alternate), onPressed: loadAssets),
                      SizedBox(
                        height: 100.0,

                        child: Expanded(

                          child: buildGridView(),
                        ),
                      ),

                   Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
                      child: Column(children: <Widget>[


                           Stack(
                             children: <Widget>[
                                SizedBox(
                                  height: 150.0,

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

//                                                  ConstrainedBox(
//                                                      constraints: BoxConstraints.expand(),
                                                       Image.network(
                                                         item,
                                                         fit: BoxFit.fill,
                                                            height: 200,
                                                             width: 180,
                                                             errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                                                             return Text('Your error widget...');
                                                           },
                                                         ),
                                                  Positioned(
                                                      right: -2,
                                                      top: -9,
                                                      child: IconButton(
                                                          icon: Icon(
                                                            Icons.cancel,
                                                            color: Colors.red.withOpacity(0.5),
                                                            size: 18,
                                                          ),
                                                          onPressed: () => setState(() {
                                                            imagePlans.removeAt(i);
                                                          })))
                                                ] ));

                                          }),
                                      )).values.toList(),

      ),

                    ),]),

                      ])),


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
                      TextFormField(
                        controller: ctrPhase,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          labelText: 'Phase',
                        ),
                        onChanged: (String val2) =>
                            setState(() => phase = val2),
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        controller: ctrClu,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          labelText: 'Clues',
                        ),
                        onChanged: (String val2) =>
                            setState(() => clues = val2),
                      ),
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
                      docs.isEmpty || docs == null ? Text("no document found") :

                      SizedBox(
                        height: 100,
                        child: ListView(

                          children: docs.map((fifi) {
                            return Builder(
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
//                                        IconButton(
//                                            icon: Icon(Icons.create,color: Color(0xff0f4c75),),
//                                            onPressed: _editDocs ,
//                                            ),
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
                      Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          RaisedButton(
                            child: Text('Add documents', style: TextStyle(color:Colors.grey[600]),),
                            onPressed: (){
                              _openFileExplorer();
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 180,
                        child: Expanded(
                          child: ListView(
                            children: children,
                          ),
                        ),
                      ),

                      // dropDown
//                DropdownButtonFormField(
//                    decoration: textInputDecoration,
//                    value: _currentReference ?? dataQr.reference,
//                    items: references.map((reference){
//                      return DropdownMenuItem(
//                        value: reference,
//                        child: Text('$reference'),
//                      );
//                    }).toList(),
//                    onChanged: (val) => setState(() => _currentReference = val)
//                ),

                      RaisedButton(
                          color: Color(0xff0f4c75),
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
//                              _addData();
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
