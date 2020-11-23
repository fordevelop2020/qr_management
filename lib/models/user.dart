import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {

 final String uid;

  User({ this.uid});

}


class UserData{
 final String uid;
 final String name;
 final String reference;
 final String image;
 final int projId;

 UserData({this.uid, this.name, this.reference, this.image, this.projId});
}
