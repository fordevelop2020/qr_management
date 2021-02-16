import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class MyFiles extends StatefulWidget {
  final String email;
  const MyFiles({Key key, this.email}) : super(key: key);

  @override
  _MyFilesState createState() => _MyFilesState();
}
  class _MyFilesState extends State<MyFiles> {

  @override
  Widget build(BuildContext context) {
     _onOpen(String link) async {
      if (await canLaunch(link)) {
        await launch(link);
      } else {
        throw 'Could not launch $link';
      }}

    return Scaffold(
      appBar: AppBar(
        title: Text("my Files"),
        backgroundColor: Color(0xff0f4c75),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
          Image.asset('assets/building.png', height: 180, width: 380,),
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

                child: new StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection("Projet").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) return new Text("There is no expense");

                      return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot dataQr = snapshot.data.documents[index];
                            List docSingle = dataQr['documents'];
                                              return SizedBox(
                                                height: 250.0,
                                                child: new ListView(
                                                  children: docSingle?.asMap()?.map((i,
                                                      fifi) =>
                                                      MapEntry(
                                                          i,
                                                          Builder(
                                                            // ignore: missing_return
                                                              builder: (
                                                                  BuildContext context) {

                                                                String uri = '${Uri.decodeComponent(fifi)}';
                                                                String fileName = uri.substring(uri.lastIndexOf('/') + 1, uri.length);
                                                                String nameWithoutEx = fileName.substring(0, fileName.lastIndexOf('?'));
                                                                print(nameWithoutEx);
                                                                print(i);

                                                                return InkWell(
                                                                  child: Row(
                                                                    children: <Widget>[

                                                                      Padding(
                                                                        padding: EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child: Icon(
                                                                          Icons.attach_file,
                                                                          color: Color(
                                                                              0xff0f4c75),),
                                                                      ),
                                                                      Divider(),
                                                                      Flexible(
                                                                        child: ListTile(
                                                                          title: new Text(
                                                                              nameWithoutEx),
//                                                              subtitle: new Text(fifi['name']),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  onTap: () =>
                                                                      _onOpen(fifi),

                                                                );
                                                              }
                                                          )
                                                      ))?.values?.toList() ?? [],
                                                    ),
                                              );
                          });
                    }),
              ),
            ),
          ],
        ),
      )
    );
    }
}
