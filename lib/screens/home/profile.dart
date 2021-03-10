

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


class MyProfile extends StatefulWidget {
  final FirebaseUser user;
  final String email;
  final GoogleSignIn googleSignIn;
  final String imageUrl;

  MyProfile({this.user, this.googleSignIn, this.email, this.imageUrl,});


  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile>{

  String name;
  String imageUrl;
  String email;
  File _image;
  String imgUrl = "";
  File _signature;
  String webSite = "";


  @override
  Widget build(BuildContext context) {
    imageUrl = widget.user?.photoUrl;
    name = widget.user?.displayName;
    email = widget.user?.email;

      getImage() async {
       File _file = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        this._image = _file;
      });
    }
     getSignature() async {
       File _sign = await ImagePicker.pickImage(source: ImageSource.gallery);
       setState(() {
         this._signature = _sign;
       });
      }

    Future<String> postImage(imageFile) async {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(imageFile);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

      String dwnlYrl = await storageTaskSnapshot.ref.getDownloadURL();
      return dwnlYrl;

    }

    void _addData() async {
        String logo = await postImage(_image);
        String sign = await postImage(_signature);
      String documentID = widget.user.email;
      Firestore.instance.collection('Profile').document(documentID).setData({
                          "email": widget.email,
                          "website": webSite,
                          "signature": sign,
                          "logo": logo,

                        })
                            .then((_) {
                        }).catchError((err) {
                  print(err);
                });

    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4c75),
        centerTitle: true,
        title: Text("My Profile", style: TextStyle(color: Colors.white),),

      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          shadowColor: Colors.lightBlue,
          child: Column(
            children: <Widget>[
                Center(
                  child: CircleAvatar(
                    backgroundImage: imageUrl != null? NetworkImage(imageUrl): null,
                    child: imageUrl == null? Icon(Icons.account_circle,size: 40): Container(),

//                                              child: Image.network(widget.user.photoUrl,width: sidebarSize/2,),
                    radius: 40.0,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(height: 20.0,),
                Text(name ?? email,style: TextStyle(color: Color(0xff0f4c75)),),
              SizedBox(height: 20.0,),

//            Container(
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
                   Row(
                     children: <Widget>[
                       Text("Logo:",style:TextStyle(fontSize: 14, color: Color(0xff0f4c75)),),
                       SizedBox(width: 53.0,),
                       Container(
                         child: Card(
                           elevation: 3.5,
                           child: ClipRRect(
                             borderRadius: BorderRadius.all(Radius.circular(10)),

                             child: _image!= null ? Image.file(
                               _image,
                               fit: BoxFit.fill,
                               width: 50,
                               height: 50,
                             ): Text("no image selected!")

                           ),
                         ),
                       ),
              SizedBox(width: 25.0,),
              IconButton(icon: Icon(Icons.add_photo_alternate), onPressed: getImage,tooltip: 'Pick Image',),
                     ],
                   ),

              SizedBox(height: 15.0,),
              Row(
                children: <Widget>[
                  Text("Signature:",style:TextStyle(fontSize: 14, color: Color(0xff0f4c75)),),
                  SizedBox(width: 25.0,),
                  Container(
                    child: Card(
                      elevation: 3.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),

                        child: _signature != null ? Image.file(
                          _signature,
                          fit: BoxFit.fill,
                          width: 50,
                          height: 50,
                        ): Text("no signature selected!")

                      ),
                    ),
                  ),
                  SizedBox(width: 25.0,),
                  IconButton(icon: Icon(Icons.add_photo_alternate), onPressed: getSignature,tooltip: 'Pick Signature',),
                ],
              ),
              SizedBox(height: 15.0,),
              Container(

                child:  TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    labelText: 'Web Site', labelStyle:TextStyle(fontSize: 14, color: Color(0xff0f4c75)),
                  ),
                  onChanged: (String val) =>
                      setState(() => webSite = val),style:TextStyle(fontSize: 14, color: Color(0xff0f4c75)) ,
                ),
              ),
              SizedBox(height: 15.0,),
              Container(
                child: RaisedButton(
                  child: Text("Submit", style: TextStyle(color: Colors.white)),color: Color(0xff0f4c75),
                  onPressed:

                      _addData,





                ),
              ),
              SizedBox(height: 15.0,),
            ],
          ),
        ),
      ),
    );
  }


}
