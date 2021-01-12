import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class Project {
  String projId;
   String typeP;
   String name;
   String reference;
   String customer;
   String location;
   String mo;
   String moDelegate;
   String bet;
   String topo;

   String date;
   String phase;
   String clues;
   String responsible;


   String imagePlans;
   String details;
   String image3d;
   String comments;


  Project(this.projId,this.typeP, this.name, this.reference, this.customer, this.location,
      this.mo, this.moDelegate, this.bet, this.topo, this.date, this.phase,
      this.clues, this.responsible, this.imagePlans, this.details, this.image3d,
      this.comments);


  Map<String, dynamic> toJson() =>{
//    this.projId = obj['projId'];
//    this.typeP = obj['typeP'];
//    this.name = obj['name'];
//    this.reference = obj['reference'];
//    this.customer = obj['customer'];
//    this.location = obj['location'];
//    this.mo = obj['mo'];
//    this.moDelegate = obj['moDelegate'];
//    this.bet = obj['bet'];
//    this.topo = obj['topo'];
//    this.date = obj['date'];
//    this.phase = obj['phase'];
//    this.clues = obj['clues'];
//    this.responsible = obj['responsible'];
//    this.imagePlans = obj['imagePlans'];
//    this.details = obj['details'];
//    this.image3d = obj['image3d'];
//    this.comments = obj['comments'];
  'name' :  name,

  };

//  Project.fromMap(Map<String, dynamic> data){
//    this.name = data['name'];
//  }

//   String get _projId => projId;
//   String get _typeP => typeP;
//   String get _name => name;
//   String get _reference => reference;
//   String get _customer => customer;
//   String get _location => location;
//   String get _mo => mo;
//   String get _moDelegate => moDelegate;
//   String get _bet => bet;
//   String get _topo => topo;
//   String get _date => date;
//   String get _phase => phase;
//   String get _clues => clues;
//   String get _responsible => responsible;
//   String get _imagePlans => imagePlans;
//   String get _details => details;
//   String get _image3d => image3d;
//   String get _comments => comments;



   Project.fromSnapShot(DocumentSnapshot snapshot){
//     projId = snapshot.key;
     name = snapshot['name'];
//     reference = snapshot['reference'];
//     customer = snapshot['customer'];
//     location = snapshot['location'];
//     mo = snapshot['mo'];
//     moDelegate = snapshot['moDelegate'];
//     bet = snapshot['bet'];
//     topo = snapshot['topo'];
//     date = snapshot['date'];
//     phase = snapshot['phase'];
//     clues = snapshot['clues'];
//     responsible = snapshot['responsible'];
//     imagePlans = snapshot['imagePlans'];
//     details = snapshot['details'];
//     image3d = snapshot['image3d'];
//     comments = snapshot['comments'];




   }

}