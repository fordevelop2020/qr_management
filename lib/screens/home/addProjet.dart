import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: implementation_imports
import 'package:flutter/src/material/stepper.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:io';
import 'package:qr_management/screens/home/utils.dart';
import 'package:file_picker/file_picker.dart';

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
  List<Asset> documents = List<Asset>();
  List<Asset> image3d = List<Asset>();
  List<String> imageUrls = <String>[];
  List<String> imageUrls3d = <String>[];
  String _error = 'No Error Dectected';
  bool isUploading = false;
  VoidCallback listener;


  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType ;
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
//
  void _openFileExplorer() async {
    try {
      _path = null;
//      if(_multiPick){
        _paths = await FilePicker.getMultiFilePath(
          type: FileType.custom, allowedExtensions: [_extension]);
//      }else {
//        _path = await FilePicker.getFilePath(
//          type: FileType.custom, allowedExtensions: [_extension]);
//      }
//      uploadToFirebase();
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
    final StorageUploadTask uploadTask = storageRef.putFile(
      File(filePath),
      StorageMetadata(
        contentType: '$FileType.custom/$_extension',
      ),
    );
    setState(() {
      _tasks.add(uploadTask);
    });
  }
//
//dropDown() {
//  return DropdownButton(
//    hint: new Text('Select'),
//    value: _pickingType,
//    items: <DropdownMenuItem>[
//      new DropdownMenuItem(
//        child: new Text('Audio'),
//        value: FileType.audio,
//      ),
//      new DropdownMenuItem(
//        child: new Text('Image'),
//        value: FileType.image,
//      ),
//      new DropdownMenuItem(
//        child: new Text('Video'),
//        value: FileType.video,
//      ),
//      new DropdownMenuItem(
//        child: new Text('Any'),
//        value: FileType.custom,
//      ),
//    ],
//    onChanged: (value) => setState(() {
//      _pickingType = value;
//    }),
//  );
//}

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
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Image.memory(
          bodyBytes,
          fit: BoxFit.fill,
        ),
      ),
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

      @override
      Widget build(BuildContext context) {

        //////////////////////////////////////////////////////
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


        //////////////////////////////////////////////////////
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
              for(var imageFile2 in image3d) {
                postImage(imageFile2).then((downloadUrl2){
                  imageUrls3d.add(downloadUrl2.toString());

              if (imageUrls.length == imagePlans.length) {
                if (imageUrls3d.length == image3d.length) {

                String documentID = DateTime
                    .now()
                    .millisecondsSinceEpoch
                    .toString();
                Firestore.instance.collection('Projet')
                    .document(documentID)
                    .setData({

                  "email": widget.email,
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
                  "documents" : uploadToFirebase(),
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
        final List<Widget> childr = <Widget>[];
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
        return Scaffold(
          key: _scaffoldKey,
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
        List<Step> _steps = [
          Step(title: const Text('Phase A'),
              content: Form(
                key: formKeys[0],
                child: Column(

                  children: <Widget>[
                    DropdownButton(
//                      value: _typeP,
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
//                    dropDown(),
//                 SwitchListTile.adaptive(
//                     title: Text('Pick Multiple Files', textAlign: TextAlign.left,),
//                     onChanged: (bool value){
//                       setState(() {
//                         _multiPick = value;
//                       });
//                     },
//                   value: _multiPick,
//                 ),
                  OutlineButton(
                    child: Text('Open File Explorer'),
                    onPressed: (){
                      _openFileExplorer();
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
//                  Flexible(
//                    child: ListView(
////                      children: childr,
//                    ),
//                  ),
//
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
                                    children: <Widget>[
                                    Expanded(
                                      child: SizedBox(
                                        height: 25.0,
                                        child: Wrap(
                                         crossAxisAlignment: WrapCrossAlignment.start,
                                                children: <Widget>[
                                                  Icon(Icons.blur_on),
                                                  Text('Image Plans:', style: new TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14.0,
                                                    letterSpacing: 2.0,
//
                                                  ),),

                                                ],
                                        ))),
                                    Row(
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
                                            height: 10.0,
                                            child: Text(
                                              'Image 3D:  ',
                                            ),
                                          ),
                                        ),
                                        Row(
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
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