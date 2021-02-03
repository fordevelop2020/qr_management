import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_management/screens/home/settings_form.dart';
import 'package:url_encoder/url_encoder.dart';
import 'package:url_launcher/url_launcher.dart';


class MyFiles extends StatefulWidget {
  final String email;

  const MyFiles({Key key, this.email}) : super(key: key);

  @override
  _MyFilesState createState() => _MyFilesState();
}

  class _MyFilesState extends State<MyFiles> {

    List docFile = [];

  @override
  Widget build(BuildContext context) {

     _onOpen(String link) async {
      if (await canLaunch(link)) {
        await launch(link);
      } else {
        throw 'Could not launch $link';
      }
      }



    return Scaffold(
      appBar: AppBar(
        title: Text("my Files"),
        backgroundColor: Color(0xff0f4c75),
      ),

      body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection('Projet').getDocuments(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return CircularProgressIndicator();
            final List<DocumentSnapshot> documents = snapshot.data.documents;
            docFile = ['documents'];
//            return ListView(
//                children: documents.map((doc) =>
            return Container(
                    height: 1300,
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Image.asset('assets/building.png',height: 180,width: 380,),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                )
                            ),
//     ],
                   child: Card(
                         child: ListView(
//
                                        children: documents?.map((fifi) {
                                          return Builder(

                                              // ignore: missing_return
                                              builder: (BuildContext context) {
                                                for(int index = 0; index < fifi['documents'].toString().length ; index++){
                                                  String uri = '${Uri.decodeComponent(fifi['documents'][index].toString())}';
                                                String fileName = uri.substring(uri.lastIndexOf('/')+1,uri.length);
                                                String nameWithoutEx = fileName.substring(0, fileName.lastIndexOf('?'));
                                                print("Document hh:"+fifi['documents'][index].toString());
                                                return InkWell(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Padding(padding: EdgeInsets.all(8.0),
                                                        child: Icon(Icons.attach_file, color: Color(0xff0f4c75),),
                                                      ),
//                                                                SizedBox(width: 20.0,),
                                                      Divider(),
                                                      Text(
                                                        "Document:" +nameWithoutEx,
                                                        style: TextStyle(
                                                          color: Colors.blueAccent,
                                                          decoration: TextDecoration.underline,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  onTap: () => _onOpen(fifi['documents'][index].toString()),

                                                );
                                              }}
                                          );

                                        })?.toList() ?? [Text("no document found")],
                                      ),
//                    )).toList()


//                  docFile = dataQr['documents'];
//
//                  DateTime dateProject = dataQr['date'].toDate();

//                  return Container(
//                    height: 1300,
//                    padding: const EdgeInsets.all(10.0),
//                    child: Column(
//                      children: <Widget>[
//                        Image.asset('assets/building.png',height: 180,width: 380,),
//                        Expanded(
//                          child: Container(
//                            padding: EdgeInsets.all(10),
//                            width: double.infinity,
//                            decoration: BoxDecoration(
//                                color: Colors.white,
//                                borderRadius: BorderRadius.only(
//                                  topLeft: Radius.circular(30),
//                                  topRight: Radius.circular(30),
//                                )
//                            ),
////     ],
//
////                                    child: Card(
//                            child: Container(
//                              child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    SizedBox(
//                                      height: 100,
//                                      //                                child: new Text(docFile.toString()),
//                                      child: ListView(
//
//                                        children: docFile?.map((fifi) {
//                                          return Builder(
//
//                                              builder: (BuildContext context) {
//                                                String fileName = fifi.toString().substring(fifi.lastIndexOf('/')+1, fifi.length);
//                                                String nameWithoutEx = fileName.substring(0, fileName.lastIndexOf('?'));
//                                                return InkWell(
//                                                  child: Row(
//                                                    children: <Widget>[
//                                                      Padding(padding: EdgeInsets.all(8.0),
//                                                        child: Icon(Icons.attach_file, color: Color(0xff0f4c75),),
//                                                      ),
////                                                                SizedBox(width: 20.0,),
//                                                      Divider(),
//                                                      Text(
//                                                        "Document: "+ nameWithoutEx,
//                                                        style: TextStyle(
//                                                          color: Colors.blueAccent,
//                                                          decoration: TextDecoration.underline,
//                                                          fontSize: 14.0,
//                                                        ),
//                                                      ),
//                                                    ],
//                                                  ),
//                                                  onTap: () => _onOpen(fifi),
//                                                );
//                                              }
//                                          );
//
//                                        })?.toList() ?? [Text("no document found")],
//                                      ),
//                                    ),


//
//                          ]),
//                        )
//                          ))],
//                    ),

//                  );

//            );
//          }
//      ),

            )
            )
            )
            ],
                    ));
          })

    );}
}
