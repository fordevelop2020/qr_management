
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_picture_uploader/firebase_picture_uploader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:qr_management/screens/home/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class SettingsForm extends StatefulWidget {
  SettingsForm({this.email, this.name,this.reference,this.date,this.index,this.localisation,
  this.mo, this.moDelegate, this.bet, this.topograph, this.customer, this.phase, this.clues, this.comments, this.manager, this.details,this.imagesNotif,this.docId});
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


  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
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
   List  _imagesTile;
   File imgFile;
  List<UploadJob> _profilePictures = [];
   List<String> imageUrls;
   int index= 0;
   bool isSelected = false;
  String _error = 'No Error Dectected';
  List<Asset> imagePlans = List<Asset>();
  Future <File> _imageFile;

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
//    index = widget.index;
    docId = widget.docId;

//  setState(() {
//    imagePlans.add("Add Image");
//  });

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
      imagePlans = List<Asset>();
    });
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: false,
        selectedAssets: imagePlans,
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
      imagePlans = resultList;
      _error = error;
    });
  }

  Widget buildGridView() {
    return GridView.count(
        crossAxisCount: 6,
        // ignore: missing_return
        children: List.generate(imagePlans.length, (index)
        {
          Asset asset = imagePlans[index];
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
  
//  Future _onAddImageClick(int index) async{
//    setState(() {
//      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
//      getFileImage(index);
//    });
//  }
//
//  void getFileImage(int index){
//    _imageFile.then((file) async {
//      setState(() {
//        ImageUploadModel imageUpload = new ImageUploadModel();
//        imageUpload.isUploaded = false;
//        imageUpload.uploading = false;
//        imageUpload.imageFile = file;
//        imageUpload.imageUrl = '';
//        imagePlans.replaceRange(index, index+1, [imageUpload]);
//      });
//    });
//  }
//  void _showPicker(context) {
//    showModalBottomSheet(
//        context: context,
//        builder: (BuildContext bc) {
//          return SafeArea(
//            child: Container(
//              child: new Wrap(
//                children: <Widget>[
//                  new ListTile(
//                      leading: new Icon(Icons.photo_library),
//                      title: new Text('Photo Library'),
//                      onTap: () {
//                        loadAssets();
//                        Navigator.of(context).pop();
//                      }),
//                ],
//              ),
//            ),
//          );
//        }
//    );
//  }

// _showImage(){
//    if(imgFile == null && imagesTile == null){
//      return Text("image placeholder");
//    }else if (imgFile != null){
//      print("showing images from local file");
//
//
//      return SizedBox(
//        height: 150.0,
//        child: ListView.builder(
//          itemCount: imagesTile.length,
//          itemBuilder: (context, index) {
//            final item = imagesTile[index];
//            return  Container(
//                     child: Stack(
//                                    alignment: AlignmentDirectional
//                                        .bottomCenter,
//                                    children: <Widget>[
//                                       GestureDetector(
//                                         child: Image.network(item,
//                                          fit: BoxFit.fill,
//                                          height: 200,
//                                          width: 180,
//                                      ),
//                                       onTap:() { //
//                                         setState(() {
//
//                                         });
//                                       },
//                                       )
//
//                                    ],
//            ));}
//
//            ),
//      );
//
//
//
//
//
//
//
//
//
//      return Stack(
//          children: <Widget>[
//            SizedBox(
//              height: 150.0,
//              child: ListView(
//                scrollDirection: Axis.horizontal,
//                children: imagesTile.asMap().entries.map((item) {
//                  Builder(
//                    // ignore: missing_return
//                      builder: (BuildContext context) {
//                        isSelected = true;
//                        int idx = item.key;
//                        String val = item.value;
//                          return Container(
//                              child: Stack(
//                                  alignment: AlignmentDirectional
//                                      .bottomCenter,
//                                  children: <Widget>[
//                                    imgFile != null
//                                        ? Image.file(
//                                      imgFile,
//                                      fit: BoxFit.fill,
//                                      height: 200,
//                                      width: 180,
//                                    )
//                                        : Image.network(item.value),
//
//                                    FlatButton(
//                                      padding: EdgeInsets.all(10),
//                                      color: Colors.black54,
//                                      child: Text('Change Image',
//                                        style: TextStyle(
//                                            color: Colors.white,
//                                            fontSize: 16,
//                                            fontWeight: FontWeight.w400),),
//                                      onPressed: () => _getLocalImage(),
//                                    ),
//                                  ]));
//                      });
//                }).toList(),
//              ),
//            ),]);

//    }else if (imagesTile != null){
//      print("showing images from url");
//
//      return Stack(
////        alignment: AlignmentDirectional.bottomCenter,
//        children: <Widget>[
//                    SizedBox(
//                      height: 150.0,
//                      child: ListView(
//                              scrollDirection: Axis.horizontal,
//                              children: imagesTile.asMap().map((i, item) =>
//                                  MapEntry(
//                                      i,
//                                      Builder(
//                                        builder: (BuildContext context) {
//                                            return Container(
//                                              child: Stack(
//                                                alignment: AlignmentDirectional.bottomCenter,
//                                                children: <Widget>[
////                                                  ConstrainedBox(
////                                                      constraints: BoxConstraints.expand(),
//                                                       Image.network(
//                                                         item,
//                                                         fit: BoxFit.fill,
//                                                            height: 200,
//                                                             width: 180,
//                                                             errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
//                                                             return Text('Your error widget...');
//                                                           },
//                                                         ),
//                                                        FlatButton(
//                                                          padding: EdgeInsets.all(10),
//                                                          color: Colors.black54,
//                                                    child: Text('Change Image', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),),
//                                                    onPressed: () => _getLocalImage(),
//                                                  )
////                                                      ),
////                                                ],
//                                                ] ));
//
//                                          }),
//                                      )).values.toList(),
//      ),
//                    ),]);
//    }}

//  _getLocalImage() async{
//    String error = 'No Error Dectected';
//    File imageFileReslt= await ImagePicker.pickImage(
//        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400
//    );
//    if(imageFileReslt != null) {
//      setState(() {
//        imgFile = imageFileReslt;
//        _error = error;
//        isSelected = true;
//        index ++;
//      });
//    }
//  }

  Future<dynamic> postImage(Asset imageFile) async {
//    await imageFile.requestOriginal();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putData(( await imageFile.getByteData()).buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
//    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();

  }



  void onErrorCallback(error, stackTrace) {
    print(error);
    print(stackTrace);
  }

  void profilePictureCallback(
      {List<UploadJob> uploadJobs, bool pictureUploadProcessing}) {
    _profilePictures = uploadJobs;
//    _imagesTile = uploadJobs;
  }

  Future<void> _addData() async {
        for (var imageFile in imagePlans) {
          postImage(imageFile).then((downloadUrl) {
            imageUrls.add(downloadUrl.toString());
                if (imageUrls.length == imagePlans.length) {
//                  String doci = docId.toString();
                  Firestore.instance.runTransaction((Transaction transaction) async {
                    DocumentSnapshot snapshot = await transaction.get(widget.index);
                    await transaction.update(snapshot.reference,{
                        "imagePlans": imageUrls,
                      });
//                        setState(() {
//                          imagePlans = [];
//                          imageUrls = [];
//                        });
                      });
              }}).catchError((err) {
                print(err);
              });
            }
    }


  void _editProject(){
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot snapshot = await transaction.get(widget.index);
        await transaction.update(snapshot.reference, {
          "name": name,
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
//          "imagePlans": imageUrls
        });
      });

    Navigator.pop(context);
  }

        @override
        Widget build(BuildContext context) {
//    final profilePictureTile = new Material(
//          color: Colors.transparent,
//          child: new Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              const Text('Project Images',
//                  style: TextStyle(
//                    color: Colors.blueAccent,
//                    fontSize: 15.0,
//                  )),
//              const Padding(
//                padding: EdgeInsets.only(bottom: 5.0),
//              ),
//              new PictureUploadWidget(
//                onPicturesChange: profilePictureCallback,
//                localization: PictureUploadLocalization(),
//                initialImages: _profilePictures,
//                settings: PictureUploadSettings(onErrorFunction: onErrorCallback,
////                customUploadFunction: uploadProfilePicture,
//                imageSource: ImageSourceExtended.askUser,
//                minImageCount: 0, maxImageCount: 5, imageManipulationSettings:
//                const ImageManipulationSettings(compressQuality: 75,
//                )),
//                buttonStyle: const PictureUploadButtonStyle(),
//                buttonText: 'Upload Picture',
//                enabled: true,
//              ),
//            ],
//          ),
//        );
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
                   Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
                      child: Column(children: <Widget>[

//                        profilePictureTile]
                        Row(
                          children: <Widget>[
                            new IconButton(icon: new Icon(Icons.add_photo_alternate), onPressed: loadAssets),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            new IconButton(icon: new Icon(Icons.save), onPressed: _addData),
                          ],
                        ),
                        SizedBox(
                          height: 100,
                          child: Expanded(

                            child: buildGridView(),
                          ),
                        ),


                      ])),


                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: ctrName,
                        decoration: new InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          labelText: 'Name project',
                        ),
//                         validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                        onChanged: (String val2) => setState(() => name = val2),
                      ),

                      SizedBox(height: 15.0),
//                                       new Padding(
//                                         padding: const EdgeInsets.all(16.0),
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
                                      color: Color(0xff3282b8)),
                                  onPressed: () => _selectDatePrj(context),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 15.0),

//                      SizedBox(height: 150.0,
//                                    Expanded(

//                          child: ListView(
//                            scrollDirection: Axis.horizontal,
//                            children: imagesTile.asMap().map((i, item) =>
//                                MapEntry(
//                                    i,
//
//                                    Builder(
//                                      builder: (BuildContext context) {
//                                        int ind = 0;
//                                        bool selected = i == ind;
//                                        for (
//                                        ind = 0; ind < item.length; ind ++) {
//                                          return Container(
//                                            width: 140.0,
//                                            height: 100.0,
//                                            margin: EdgeInsets.symmetric(
//                                                vertical: 10.0,
//                                                horizontal: 2.0),
//                                            child: ConstrainedBox(
//                                                constraints: BoxConstraints
//                                                    .expand(),
//
//                                                child: GestureDetector(
//                                                  onTap: () {
//                                                    _showPicker(context);
//                                                  },
//                                                  child: item = selected && imgFile != null ?
//                                                  Image.file(
//                                                    imgFile,
//                                                    fit: BoxFit.fill,
//                                                  ) : Image.network(item),
////                                                       errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
////                                                       return Text('Your error widget...');
////                                                     },
//
//                                                )),
//
//                                          );
//                                        }
//                                        return Container(
//                                            width: 140,
//                                            height: 100,
//                                            margin: EdgeInsets.symmetric(
//                                                vertical: 10.0,
//                                                horizontal: 2.0),
//                                            child: ConstrainedBox(
//                                                constraints: BoxConstraints
//                                                    .expand(),
//                                                child: Image.network(
//                                                    item[ind])));
//                                      },
//
//                                    ))).values.toList(),
//                          )),
                      SizedBox(height: 15.0),

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
                      // slider
//                SizedBox(height: 20.0),
//                Slider(
//                  value: (_currentProjId ?? userData.projId).toDouble(),
//                  activeColor: Colors.cyan[_currentProjId ?? userData.projId],
//                  inactiveColor: Colors.cyan[_currentProjId ?? userData.projId],
//                  min : 100.0,
//                  max : 900.0,
//                  divisions: 8,
//                  onChanged: (val) => setState(() => _currentProjId = val.round()),
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

//      class ImageUploadModel{
//  bool isUploaded;
//  bool uploading;
//  File imageFile;
//  String imageUrl;
//
//  ImageUploadModel({
//    this.isUploaded,
//    this.uploading,
//    this.imageFile,
//    this.imageUrl,
//      });
//}