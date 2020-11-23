import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: implementation_imports
import 'package:flutter/src/material/stepper.dart';

import 'package:multi_image_picker/multi_image_picker.dart';

import 'dart:io';
import 'package:qr_management/screens/home/utils.dart';

class AddProjet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Add Project',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new MyAddPage(),
    );
  }

}
class CommonThings {
  static Size size;
}


class MyAddPage extends StatefulWidget {

//  final GlobalKey<ScaffoldState> globalKey;
//  const UploadImages({Key key, this.globalKey}) : super(key: key);
  MyAddPage({Key key, this.title, this.email}) : super(key: key);
  final String email;

  final String title;


@override
_MyAddPageState createState() =>  _MyAddPageState();

}

class _MyAddPageState extends State<MyAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>()];
  TextEditingController _searchController = new TextEditingController();
  final _controller = TextEditingController();
  final db = Firestore.instance;
  static var _focusNode= FocusNode();

  String value = 'public';
  int _currentStep = 0;

  StepperType _stepperType = StepperType.vertical;
  DateTime _datePrj = new DateTime.now();
  String _dateText ='';
  String projId ='';
  String _typeP ='';
  String _name ='';
  String reference ='';
  String customer ='';
  String location ='';
  String mo ='';
  String moDelegate ='';
  String bet ='';
  String topo ='';

  String date ='';
  String phase ='';
  String clues ='';
  String responsible ='';


//  File imagePlans;
  String details ='';
//  String image3d;
  String comments ='';

  List<Asset> imagePlans = List<Asset>();
  List<Asset> image3d = List<Asset>();
  List<String> imageUrls = <String>[];
  List<String> imageUrls3d = <String>[];
  String _error = 'No Error Dectected';
  bool isUploading = false;
  VoidCallback listener;


  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 6,
      // ignore: missing_return
      children: List.generate(imagePlans.length, (index)
    {
      Asset asset = imagePlans[index];
//        return AssetThumb(
//          asset: asset,
//          width: 100,
//          height: 100,
//        );
      // print(asset.getByteData(quality: 100));
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
//      }),
  //  );
  }
  Widget buildGridView3D() {
    return GridView.count(
        crossAxisCount: 6,
        // ignore: missing_return
        children: List.generate(image3d.length, (index)
        {
          Asset asset = image3d[index];
//        return AssetThumb(
//          asset: asset,
//          width: 100,
//          height: 100,
//        );
          // print(asset.getByteData(quality: 100));
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
//      }),
    //  );
  }

//  onImageGalleryPressed() async {
//    imagePlans= (await ImagePicker.pickImage(source: ImageSource.gallery)) as List<File>;
//    if(imagePlans != null){
//      image = imagePlans as File;
//      setState(() {
//        imagePlans = image as List<File>;
//      });
//    }
//
//  }

//  onImageCameraPressed2() async {
//    image3d = await ImagePicker.pickImage(source: ImageSource.camera);
//    if(image3d != null){
//      image = image3d;
//      setState(() {
//        image3d = image;
//      });
//    }
//  }
//
//  onImageGalleryPressed2() async {
//    image3d= await ImagePicker.pickImage(source: ImageSource.gallery);
//    if(image3d != null){
//      image = image3d;
//      setState(() {
//        image3d = image;
//      });
//    }
//
//  }
//  void _onImageButtonPressed(ImageSource source) {
//    setState(() {
//      imagePlans = ImagePicker.pickImage(source: source, maxHeight: 50.0 , maxWidth: 50.0);
//    });
//  }


//   void createData() async {
//     DateTime now = DateTime.now();
//     String nf = DateFormat('kk:mm:ss:MMMMd').format(now);
//     var imageP = 'nomfoto-$nf' + '.jpg';
//     var image3 = 'nomfoto-$nf' + '.jpg';
//     final StorageReference ref = FirebaseStorage.instance.ref().child(imageP);
//     final StorageUploadTask task = ref.putFile(imagePlans);
//     var part1 = 'https://firebasestorage.googleapis.com/v0/b/qrmanage-bd34f.appspot.com/o/';
//     var fullPathImg = part1 + image3;
//     print(fullPathImg);
//   }

//    void _onImageButtonPressed2(ImageSource source) {
//      setState(() {
//        image3d = ImagePicker.pickImage(source: source, maxHeight: 50.0 , maxWidth: 50.0);
//
//      });
//  }

//  Future getImage() async {
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//    setState(() {
//      imagePlans = image;
//    });
//  }


//   uploadFile() async {
//     final _storage = FirebaseStorage.instance;
//     final _picker = ImagePicker();
//     PickedFile image;
//
//     imagePlans = (await _picker.getImage(source: ImageSource.gallery)) as File;
//     var file= File(imagePlans.path);
//     if(imagePlans != null){
//       var snapshot = await _storage.ref()
//           .child('folderName/imageName')
//           .putFile(file)
//           .onComplete;
////       var downloadUrl = await snapshot.ref.getDownloadURL();
////       setState(() {
////         imagePlans = downloadUrl;
////       });
//
//     }else {
//       print('no path received');
//     }}
//    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
//    StorageReference storageReference = FirebaseStorage.instance
//        .ref()
//        .child(imageFileName);
//    StorageUploadTask uploadTask = storageReference.putFile(imagePlans);
//    await uploadTask.onComplete;
//    print('File Uploaded');
//    storageReference.getDownloadURL().then((fileURL) {
//      setState(() {
//        imagePlans = fileURL;
//      });
//    });
      // }

//  void _showaddphoto(){
//    AlertDialog dialog = new AlertDialog(
//      actions: <Widget>[
//        new IconButton(icon: new Icon(Icons.camera_alt), onPressed: () => _onImageButtonPressed(ImageSource.camera),
//            tooltip: 'Take a Photo'),
//        new IconButton(icon: new Icon(Icons.sd_storage), onPressed:  () => _onImageButtonPressed(ImageSource.gallery),
//            tooltip: 'Pick Image from gallery')
//      ],
//    );
//    showDialog(context: context,child: dialog);
//  }
//
//    void _showaddphoto2(){
//      AlertDialog dialog = new AlertDialog(
//        actions: <Widget>[
//          new IconButton(icon: new Icon(Icons.camera_alt), onPressed: () => _onImageButtonPressed2(ImageSource.camera),
//              tooltip: 'Take a Photo'),
//          new IconButton(icon: new Icon(Icons.sd_storage), onPressed:  () => _onImageButtonPressed2(ImageSource.gallery),
//              tooltip: 'Pick Image from gallery')
//        ],
//      );
//      showDialog(context: context,child: dialog);
//    }


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

//  void uploadImages(){
//    for ( var imageFile in imagePlans) {
//      postImage(imageFile).then((downloadUrl) {
//        imageUrls.add(downloadUrl.toString());
//        if(imageUrls.length==imagePlans.length){
//          String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
//          Firestore.instance.collection('images').document(documnetID).setData({
//            'urls':imageUrls
//          }).then((_){
//            SnackBar snackbar = SnackBar(content: Text('Uploaded Successfully'));
//            widget.globalKey.currentState.showSnackBar(snackbar);
//            setState(() {
//              imagePlans = [];
//              imageUrls = [];
//            });
//          });
//        }
//      }).catchError((err) {
//        print(err);
//      });
//    }

      // }
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

  Future<void> loadAssets3D() async {
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
  Future<dynamic> postImage(Asset imageFile) async {
//    await imageFile.requestOriginal();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putData(( await imageFile.getByteData()).buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
//    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();

  }



      @override
      void initState() {
        // TODO: implement initState
        super.initState();
//    _focusNode.addListener(() {
//      setState(() {});
//      print('Has focus $_focusNode.hasFocus');
//    });
        _dateText = "${_datePrj.day}/${_datePrj.month}/${_datePrj.year}";
      }

      @override
      void dispose() {
        _controller.dispose();
        // _focusNode.dispose();
        super.dispose();
      }
      switchStepType() {
        setState(() =>
        _stepperType == StepperType.vertical
            ? _stepperType = StepperType.horizontal
            : _stepperType = StepperType.vertical);
      }

      @override
      Widget build(BuildContext context) {
        void showSnackBarMessage(String message,
            [MaterialColor color = Colors.red]) {
          Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }


        Future<void> _addData() async {
          for (var imageFile in imagePlans) {
            postImage(imageFile).then((downloadUrl) {
              imageUrls.add(downloadUrl.toString());
//         if(imageUrls.length==imagePlans.length){
//           String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
//           Firestore.instance.collection('Projet').document(documnetID).setData({
//             'urls':imageUrls
//           }).then((_){
//             SnackBar snackbar = SnackBar(content: Text('Uploaded Successfully'));
//             widget.globalKey.currentState.showSnackBar(snackbar);
//             setState(() {
//               imagePlans = [];
//               imageUrls = [];
//             });
//           });
//         }
//       }).catchError((err) {
//         print(err);
//       });
//     }
//      int randomNumber = Random().nextInt(100000);
//     // int uploadCount = 0;
//      String imageLocation = 'images/image${randomNumber}.jpg';
//      String imageLocation2 = 'images/image${randomNumber}.jpg';
//
////      DateTime now = DateTime.now();
//////      String nf = DateFormat('kk:mm:ss:MMMMd').format(now);
////      var imageP = 'nomfoto-$nf' + '.jpg';
////      var image3 = 'nomfoto-$nf' + '.jpg';
//      final StorageReference ref = FirebaseStorage.instance.ref().child(imageLocation);
//    // final StorageReference ref2 = FirebaseStorage.instance.ref().child(imageLocation2);
////     final StorageUploadTask task = ref.putFile(imagee);
////     final StorageUploadTask task2 = ref2.putFile(imagee);
//     final StorageMetadata metaData = StorageMetadata(contentType: 'image/png');
//    // final StorageUploadTask task2 = ref2.putFile(imagee);
////     images.forEach((image) {
////       ref.putFile(image, metaData).onComplete.then((snapshot){
////
////       }
////      await  task.onComplete;
////      await task2.onComplete;
////   })
////      var part1 = 'https://firebasestorage.googleapis.com/v0/b/qrmanage-bd34f.appspot.com/o/';
////      var fullPathImg = part1 + image3;
////      var fullPathImg2 = part1 + image3;
//      //imagePlans = fullPathImg as File;
//
//      print(imageLocation);
//     print(imageLocation2);
//      final FormState formState = _formKey.currentState;
//      if(!formState.validate()){
//        showSnackBarMessage('Please enter correct data');
//      } else{
//        formState.save();
//        final ref = FirebaseStorage().ref().child(imageLocation);
//        var imageString = await ref.getDownloadURL();
//        final ref2 = FirebaseStorage().ref().child(imageLocation2);
//        var imageString2 = await ref2.getDownloadURL();

//        Firestore.instance.runTransaction((Transaction transaction) async{
              for(var imageFile2 in image3d) {
                postImage(imageFile2).then((downloadUrl2){
                  imageUrls3d.add(downloadUrl2.toString());

              if (imageUrls.length == imagePlans.length) {
                if (imageUrls3d.length == image3d.length) {

                String documnetID = DateTime
                    .now()
                    .millisecondsSinceEpoch
                    .toString();
                Firestore.instance.collection('Projet')
                    .document(documnetID)
                    .setData({
//          CollectionReference reference1 = Firestore.instance.collection('Projet');
//          await reference1.add({
                  "email": widget.email,
                  // "projId" = snapshot.key;
                  "typeP": _typeP,
                  "name": _name,
                  "reference": reference,
                  "customer": customer,
                  "location": location,
                  "mo": mo,
                  "moDelegate": moDelegate,
                  "bet": bet,
                  "topo": topo,
                  "date": _dateText,
                  "phase": phase,
                  "clues": clues,
                  "responsible": responsible,
                  "imagePlans": imageUrls,
                  "details": details,
                  "image3d" : imageUrls3d,
                  "comments": comments,
                })
                    .then((_) {
                  setState(() {
                    imagePlans = [];
                    imageUrls = [];
                    image3d = [];
                    imageUrls3d = [];
                  });
                  //uploadImages();
                });
              }}
            }).catchError((err) {
              print(err);
            });
          } }).catchError((err) {
              print(err);
              });
          }}

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text('New project', style: new TextStyle(
              color: Colors.white,
              fontSize: 20.0,
//            letterSpacing: 2.0,
              //  fontFamily: "Pacifico"
            ),),

            backgroundColor: Color(0xff0f4c75),
          ),
          body: Column(

              children: <Widget>[
                Theme(
                  data: ThemeData(
                      primaryColor: Color(0xff3282b8)
                  ),
                  child: Form(

                    key: _formKey,
                    child: Expanded(
                      child: Stepper(
                        steps: _stepper(),
                        physics: ClampingScrollPhysics(),
                        type: _stepperType,
                        currentStep: this._currentStep,

                        onStepTapped: (step) {
                          setState(() {
                            this._currentStep = step;
                          });
                        },
                        onStepContinue: () {
                          setState(() {
                            if (formKeys[_currentStep].currentState
                                .validate()) {
                              if (_currentStep < _stepper().length - 1) {
                                _currentStep = _currentStep + 1;
                                //  _addData();
                              } else {
                                _addData();
                                _currentStep = 0;
                              }
                            }

//                    if (this._currentStep < this
//                        ._stepper()
//                        .length - 1) {
//                      _addData();
//                      this._currentStep = this._currentStep + 1;
//
//                    } else {
//                      _addData();
//                      print('complete!');
//                      //retour a home
//                    }
//                      }
                          });
                        },


                        onStepCancel: () {
                          setState(() {
                            if (this._currentStep > 0) {
                              this._currentStep = this._currentStep - 1;
                            } else {
                              this._currentStep = 0;
                            }
                          });
                        },


                      ),


                    ),

                  ),
                ),
//            RaisedButton(
//              child:  Text(
//                'Save details',
//                style:  TextStyle(color: Colors.white),
//              ),
//              onPressed: _addData,
//              color: Colors.blue,
//            ),
              ]),

          floatingActionButton: FloatingActionButton(onPressed: switchStepType,
            backgroundColor: Color(0xff0f4c75),
            child: Icon(Icons.swap_horizontal_circle, color: Colors.white,),),

        );
      }

      List<Step> _stepper() {
        List<Step> _steps = [
          Step(title: const Text('Phase A'),
              content: Form(
                key: formKeys[0],
                child: Column(

                  children: <Widget>[
                    DropdownButton(
                      // value: value,
                      items: [
                        DropdownMenuItem(
                          child: Text('Public'),

                          value: 'public',
                        ),
                        DropdownMenuItem(
                          child: Text('Private'),
                          value: 'private',
                        ),
                        DropdownMenuItem(
                          child: Text('Deco'),
                          value: 'deco',
                        )
                      ],
                      onChanged: (newValue) {
                        print(newValue);

                        setState(() {
                          _typeP = newValue;
                        });
                        DropdownMenuItem(child: Text(_typeP));
                      },

                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      hint: Text("Select type project",
                        style: TextStyle(color: Colors.black),),

                    ),

                    TextFormField(
                      //focusNode: _focusNode,
                      decoration: InputDecoration(labelText: 'Name',
                        icon: Icon(Icons.blur_on),
                        labelStyle: TextStyle(
                            decorationStyle: TextDecorationStyle.solid),
                      ),
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty || value.length < 1) {
                          return 'Please enter valid name';
                        }
                      },
                      onChanged: (String nv) {
                        setState(() {
                          _name = nv;
                        });
                      },
                      maxLines: 1,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Reference',
                          icon: Icon(Icons.blur_on)),
                      onChanged: (String nv) {
                        setState(() {
                          reference = nv;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Customer',
                          icon: Icon(Icons.blur_on)),
                      onChanged: (String nv) {
                        setState(() {
                          customer = nv;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Localisation',
                          icon: Icon(Icons.blur_on)),
                      onChanged: (String nv) {
                        setState(() {
                          location = nv;
                        });
                      },
                    ),


//              onTap: () async {
//                Prediction p = await PlacesAutocomplete.show(
//                    context: context,
//                    apiKey: "AIzaSyDLnjy6ICK27e1ifFQ1UTJvlgpNVGFjlPo",
//                    mode : Mode.fullscreen,
//                    language: "fr" ,
//                    components: [
//                     new Component(Component.country, "fr")
//                    ]);
//              },
////              cursorColor: Colors.blue,
////              textInputAction: TextInputAction.go,
////              controller: ,
//                 onChanged : (value){
//                setState(() {
//
//                });

//             },
//
//              decoration: InputDecoration(labelText: 'Location', prefixIcon: Icon(Icons.location_on)),
                    // ),


                    TextFormField(
                      decoration: InputDecoration(labelText: 'MO',
                          icon: Icon(Icons.blur_on)),
                      onChanged: (String nv) {
                        setState(() {
                          mo = nv;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'MO delegate',
                          icon: Icon(Icons.blur_on)),
                      onChanged: (String nv) {
                        setState(() {
                          moDelegate = nv;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'BET',
                          icon: Icon(Icons.blur_on)),
                      onChanged: (String nv) {
                        setState(() {
                          bet = nv;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Topographer',
                          icon: Icon(Icons.blur_on)),
                      onChanged: (String nv) {
                        setState(() {
                          topo = nv;
                        });
                      },
                    ),

                  ],
                ),
              ),
              isActive: _currentStep >= 0,
              state: StepState.complete

          ),
          Step(
            // isActive: false,

              title: const Text('Phase B'),
              content: Form(
                key: formKeys[1],
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        //TextFormField(
                        new Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Date',
                                hintText: _dateText,
                                icon: Icon(Icons.blur_on)),
                            onChanged: (String nv) {
                              setState(() {
                                date = nv;
                              });
                            },
                          ),

                        ),


//                    decoration: InputDecoration(labelText: 'Date',
//                        icon:Icon(Icons.blur_on)),),
                        new IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () => _selectDatePrj(context),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Phase',
                          icon: Icon(Icons.blur_on)),
                      onChanged: (String nv) {
                        setState(() {
                          phase = nv;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Clues',
                          icon: Icon(Icons.blur_on)),
                      onChanged: (String nv) {
                        setState(() {
                          clues = nv;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Responsible',
                          icon: Icon(Icons.blur_on)),
                      onChanged: (String nv) {
                        setState(() {
                          responsible = nv;
                        });
                      },
                    ),
                  ],
                ),
              ),
              isActive: _currentStep >= 1,
              state: StepState.complete
          ),

          Step(
              title: const Text('Phase C'),
              content: Form(
                key: formKeys[2],
                child: Stack(
                    children: <Widget>[

                      //

                      Container(

                        child: Stack(
                            children: <Widget>[
                              SizedBox(height: 10.0,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: <Widget>[
                                  TextFormField(

                                    decoration: InputDecoration(
                                        labelText: 'Details',
                                        icon: Icon(Icons.blur_on)),

                                    onChanged: (String nv) {
                                      setState(() {
                                        details = nv;
                                      });
                                    },
                                  ),

                                  // SizedBox(height: 20.0,),

                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Comments',
                                        icon: Icon(Icons.blur_on)),
                                    onChanged: (String nv) {
                                      setState(() {
                                        comments = nv;
                                      });
                                    },
                                  ),


                                   SizedBox(
                                       height: 200.0,
                                  child: Column(
//
//
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[

                                      // Divider(height: 10.0),
                                    Expanded(
//
                                      child: SizedBox(
                                        height: 25.0,
                                        child: Text(
                                          'Image Plans:  ',

                                        ),
                                      ),
                                    ),
                                    Row(
//                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[

                                          new IconButton(icon: new Icon(Icons.add_photo_alternate), onPressed: loadAssets),
                                        ],
                                      ),
                                      Expanded(

                                        child: buildGridView(),
                                      ),
                                      ],),
                                     ),
                                  SizedBox(
                                    height: 200.0,
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            height: 25.0,
                                            child: Text(
                                              'Image 3D:  ',
                                            ),
                                          ),
                                        ),
                                        Row(
//                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[

                                            new IconButton(icon: new Icon(Icons.add_photo_alternate), onPressed: loadAssets3D),
                                          ],
                                        ),
                                        Expanded(
                                          child: buildGridView3D(),
                                        ),
                                      ],),
                                  ),


                 ],),]),
                      ),
                    ]),),

              isActive: _currentStep >= 2,
              state: StepState.complete

          ),
        ];
        return _steps;
      }
    }