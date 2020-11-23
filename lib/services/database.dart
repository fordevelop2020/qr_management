import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_management/models/project.dart';
import 'package:qr_management/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference projCollection = Firestore.instance.collection('projects');
  Future updateUserData(String name, String reference, String image, int projId) async{
    return await projCollection.document(uid).setData({
      'name' : name,
      'reference' : reference ,
      'image' : image ,
      'projId' : projId ,
    });
  }

  //proj list from snapshot
//  List<Project> _projListFromSnapshot(QuerySnapshot snapshot){
//    return snapshot.documents.map((doc){
//      return Project(
//        name: doc.data['name'] ?? '' ,
//        reference: doc.data['reference'] ?? '' ,
//        image: doc.data['image'] ?? '',
//        projId: doc.data['projId'] ?? 0,
//      );
//    }).toList();
//  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      reference: snapshot.data['reference'],
      image: snapshot.data['image'],
      projId: snapshot.data['projId']
    );
  }

  // get projects stream
//  Stream<List<Project>> get projects {
//    return projCollection.snapshots()
//        .map(_projListFromSnapshot) ;
//}

// get user doc stream

Stream<UserData> get userData{
    return projCollection.document(uid).snapshots()
        .map(_userDataFromSnapshot);
}

}