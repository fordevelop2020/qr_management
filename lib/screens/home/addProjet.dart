import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: implementation_imports
import 'package:flutter/src/material/stepper.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_management/screens/home/Home.dart';
import 'dart:io';
import 'package:qr_management/screens/home/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:qr_management/widgets/button_widget.dart';

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
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String title;


@override
_MyAddPageState createState() =>  _MyAddPageState();

}

class _MyAddPageState extends State<MyAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>()];
  TextEditingController _searchController = new TextEditingController();
  final _controller = TextEditingController();
  final db = Firestore.instance;
  static var _focusNode= FocusNode();

  //déclaration des variables

  String value = 'public';
  int _currentStep = 0;

  StepperType _stepperType = StepperType.vertical;
  DateTime _datePrj = DateTime.now();
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

  String details ='';
  String comments ='';
  var _typesProjet=['Select project type','Public','Private','Deco','Other'];
  var _phases = ['Select phase','Esquisse','Aps','Apd','Pac','Pe','dce','exe','Reception'];
  var _selectedPhase = 'Select phase';
  var _selectedTypeProjet ='Select project type';

  List<Asset> imagePlans = List<Asset>();
  List<Asset> image3d = List<Asset>();
  List<String> imageUrls = <String>[];
  List<String> fileUrls = <String>[];
  List<String> imageUrls3d = <String>[];
  String _error = 'No Error Dectected';
  bool isUploading = false;
  VoidCallback listener;


  String fileName;
  Map<String, String> _paths;
  Map<String,String> documents;
  String _extension;
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  StorageUploadTask _uploadTask2;

  bool _isPressed = false;

//
  void _openFileExplorer() async {
    try {
        _paths = await FilePicker.getMultiFilePath(
          // ignore: missing_return
          type: FileType.custom, allowedExtensions: [_extension]);
        setState(() {
          documents = _paths;
        });

      uploadToFirebase();
    } on PlatformException catch(e){
      print("Unsupported operation" +e.toString());
    }
      if (!mounted){ return;}
  }
    uploadToFirebase(){
//      if (_multiPick) {
        _paths.forEach((fileName, filePath) => {
          upload(fileName, filePath)});
//      } else {
//        String fileName = _path.split('/').last;
//        String filePath = _path;
//        upload(fileName, filePath);
//      }
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

String _bytesTransferred(StorageTaskSnapshot snapshot) {
  return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
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

  Future<dynamic> postFile(fileName) async {
    _extension = fileName.toString().split('.').last;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask2 = reference.putFile(File(fileName),StorageMetadata(contentType: '$FileType.custom/$_extension'));
    StorageTaskSnapshot downloadUrl = await uploadTask2.onComplete;
    final String url =(await downloadUrl.ref.getDownloadURL());
    return url;

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
      void initState() {
        // TODO: implement initState
        super.initState();
        _dateText = "${_datePrj.day}/${_datePrj.month}/${_datePrj.year}";
      }

      @override
      void dispose() {
        _controller.dispose();
        super.dispose();
      }
      switchStepType() {
        setState(() =>
        _stepperType == StepperType.vertical
            ? _stepperType = StepperType.horizontal
            : _stepperType = StepperType.vertical);
      }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop();},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("This project is added successfully !"),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
          for(String dwnlfile in documents.values){
            postFile(dwnlfile).then((downloadUrl){
              fileUrls.add(downloadUrl.toString());
          for (var imageFile in imagePlans) {
            postImage(imageFile).then((downloadUrl) {
              imageUrls.add(downloadUrl.toString());
              for(var imageFile2 in image3d) {
                postImage(imageFile2).then((downloadUrl2){
                  imageUrls3d.add(downloadUrl2.toString());

              if (imageUrls.length == imagePlans.length) {
                if (imageUrls3d.length == image3d.length) {
                  if (fileUrls.length == documents.length) {

                String documentID = DateTime
                    .now()
                    .millisecondsSinceEpoch
                    .toString();
                Firestore.instance.collection('Projet')
                    .document(documentID)
                    .setData({

                  "email": widget.email,
                  "typeP": _selectedTypeProjet,
                  "name": _name,
                  "reference": reference,
                  "customer": customer,
                  "location": location,
                  "mo": mo,
                  "moDelegate": moDelegate,
                  "bet": bet,
                  "topo": topo,
                  "date": _datePrj,
                  "phase": _selectedPhase,
                  "clues": clues,
                  "responsible": responsible,
                  "imagePlans": imageUrls,
                  "details": details,
                  "image3d" : imageUrls3d,
                  "comments": comments,
                  "documents" : fileUrls,
                })
                    .then((_) {
                  setState(() {
                    imagePlans = [];
                    imageUrls = [];
                    image3d = [];
                    imageUrls3d = [];
                    fileUrls = [];

                  });
                  //uploadImages();
                });
              }}}
            }).catchError((err) {
              print(err);
            });
          } }).catchError((err) {
              print(err);
              });
          } }).catchError((err) {
              print(err);
            });
          }}

        return Scaffold(
//          key: _scaffoldKey,
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
//                    key: _formKey,
                  key: _scaffoldKey,
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
                                showAlertDialog(context);
//                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>
//                                new Home()),
//                                );

                              }
                            }
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
              ]),

          floatingActionButton: FloatingActionButton(onPressed: switchStepType,
            backgroundColor: Color(0xff0f4c75),
            child: Icon(Icons.swap_horizontal_circle, color: Colors.white,),),

        );
      }

      List<Step> _stepper() {

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
        List<Step> _steps = [
          Step(title: const Text('Phase A'),
              content: Form(
                key: formKeys[0],
//              key: _scaffoldKey,
                child: Column(

                  children: <Widget>[

                    Row(
                      children: <Widget>[
                     Icon(Icons.blur_on,color:Colors.grey[600]),
                        SizedBox(width: 20,),
                        DropdownButton<String>(


                         items: _typesProjet.map((String dropDownStringItem){

                           return DropdownMenuItem<String>(

                             value: dropDownStringItem,
                             child: (Text(dropDownStringItem,style:TextStyle(color:Colors.grey[600],fontSize: 16))),
                           );
                          }).toList(),

                          onChanged:(String newValueSelected){
                            setState(() {
                              this._selectedTypeProjet = newValueSelected;
                              print(_selectedTypeProjet);
                            });

                          },
                          value: _selectedTypeProjet,
                          icon: Icon(Icons.arrow_drop_down),
                        ),
                      ],
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
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty || value.length < 1) {
                          return 'Please enter valid localisation';
                        }
                      },
                      onChanged: (String nv) {
                        setState(() {
                          location = nv;
                        });
                      },
                    ),


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
                        Icon(Icons.blur_on,color:Colors.grey[600]),
                        SizedBox(width: 20,),
                        new Expanded(
                         child: Text(_dateText, style: TextStyle(color: Colors.grey[600],fontSize: 16)),

                        ),

                        new IconButton(
                          icon: Icon(Icons.date_range,color: Color(0xff3282b8)),
                          onPressed: () => _selectDatePrj(context),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.blur_on,color:Colors.grey[600]),
                        SizedBox(width: 20,),
                        DropdownButton<String>(


                          items: _phases.map((String dropDownStringItem2){

                            return DropdownMenuItem<String>(

                              value: dropDownStringItem2,
                              child: (Text(dropDownStringItem2,style:TextStyle(color:Colors.grey[600],fontSize: 16))),
                            );
                          }).toList(),

                          onChanged:(String newValueSelected2){
                            setState(() {
                              this._selectedPhase = newValueSelected2;
                              print(_selectedPhase);
                            });

                          },
                          value: _selectedPhase,
                          icon: Icon(Icons.arrow_drop_down),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Indices',
                          icon: Icon(Icons.blur_on)),
                      onChanged: (String nv) {
                        setState(() {
                          clues = nv;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Manager',
                          icon: Icon(Icons.blur_on)),
                      onChanged: (String nv) {
                        setState(() {
                          responsible = nv;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.blur_on,color:Colors.grey[600]),
                      SizedBox(width: 20),
                      ButtonWidget(
                        title: ('Add documents'),
                        hasBorder: true,

                        // ignore: missing_return
                        onPressed: (){
                          setState(() {
                            _isPressed = !_isPressed;
                          });
                            _openFileExplorer();

                        },
                        // ignore: missing_return
                        validator: ( bool _pressed){

                          if(_pressed = !_isPressed){
                            return Text(" add doc plz");
                          }
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
                   )
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
//              key: _scaffoldKey,
                child: Stack(
                    children: <Widget>[
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
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isEmpty || value.length < 1) {
                                        return 'Please enter valid details';
                                      }
                                    },

                                    onChanged: (String nv) {
                                      setState(() {
                                        details = nv;
                                      });
                                    },
                                  ),

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
                                     height: 15,
                                   ),


                                   SizedBox(
                                       height: 180.0,
                                  child: Column(
                                    children: <Widget>[
//                                    Expanded(
//                                      child: SizedBox(
//                                        height: 25.0,
                                        Wrap(
                                         crossAxisAlignment: WrapCrossAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(Icons.blur_on,color: Colors.grey[600],),
                                                      SizedBox(width: 20),
                                                      Text('Images Plans:', style: new TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 16.0,
//                                                        letterSpacing: 2.0,
//
                                                      ),),
                                                    ],
                                                  ),

                                                ],
                                        ),
//                                      )
//                                    ),
                                    Row(
                                        children: <Widget>[
                                          new IconButton(icon: new Icon(Icons.add_photo_alternate), onPressed: loadAssets),
                                        ],
                                      ),
                                      Card(
                                        elevation: 2.5,
                                        child: SizedBox(
                                          height: 90,
                                          child: Expanded(

                                            child: buildGridView(),
                                          ),
                                        ),
                                      ),
                                      ],),
                                     ),
                                  SizedBox(
                                    height: 170.0,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.blur_on,color: Colors.grey[600],),
                                            SizedBox(width: 20),
                                            Text('Images 3D:', style: new TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16.0,
                                            ),),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[

                                            new IconButton(icon: new Icon(Icons.add_photo_alternate), onPressed: loadAssets3D),
                                          ],
                                        ),
                                        Card(
                                          elevation: 2.5,
                                          child: SizedBox(
                                            height: 90,
                                            child: Expanded(
                                              child: buildGridView3D(),
                                            ),
                                          ),
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


class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;

  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status: ${_bytesTransferred(snapshot)} bytes sent');
        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task #${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}