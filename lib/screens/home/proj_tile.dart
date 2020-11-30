
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProjTile extends StatefulWidget {

  String qrResult;
  ProjTile({this.qrResult});

  @override
  _ProjTileState createState() => _ProjTileState();
}

class _ProjTileState extends State<ProjTile> {
  int _current = 0;
  int _index = 0;
  CarouselSlider carouselSlider;
  List imgList=[] ;
  List<T> map<T>(List list, Function handler){
    List<T> result = [];
    for(var i = 0; i < list.length; i++){
      result.add(handler(i, list[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Tile'),
        backgroundColor: Color(0xff0f4c75),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Projet').where("name", isEqualTo: widget.qrResult).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data == null) return CircularProgressIndicator();

          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index1){
              DocumentSnapshot dataQr = snapshot.data.documents[index1];
              // ignore: unnecessary_statements
              imgList = dataQr['imagePlans'];
              print('coucou : $imgList');
             return Container(
              height: 600.0,
              padding: const EdgeInsets.all(20.0),
              child: Card(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      new Text(widget.qrResult, style: TextStyle(fontSize: 18.0),),
                      Padding(padding: EdgeInsets.only(top: 8.0),),
                      Divider(),
                      new Text("Reference : ${dataQr['reference']}", style: TextStyle(fontSize: 18.0),),
                      Padding(padding: EdgeInsets.only(top: 8.0),),
                      Divider(),
                      new Text("Details : ${dataQr['details']}", style: TextStyle(fontSize: 18.0),),
                      Padding(padding: EdgeInsets.only(top: 8.0),),
                      Divider(),
                      new Text("Date : ${dataQr['date']}", style: TextStyle(fontSize: 18.0),),
                      Padding(padding: EdgeInsets.only(top: 8.0),),
                      Divider(),
                      new Text("Customer : ${dataQr['customer']}", style: TextStyle(fontSize: 18.0),),
                      Padding(padding: EdgeInsets.only(top: 8.0),),
                      Divider(),

                      carouselSlider = CarouselSlider(
                        height: 250.0,
                        initialPage: 0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        reverse: false,
                        autoPlayInterval: Duration(seconds: 2),
                        autoPlayAnimationDuration: Duration(milliseconds: 2000),
                        pauseAutoPlayOnTouch: Duration(seconds: 10),
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index){
                          setState(() {
                            _current = index;
                          });
                        },

                        items: imgList.map((item){
                           return Builder(
                            builder: (BuildContext context){
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                ),
                                child: Image.network(
                                  item,
                                  fit: BoxFit.fill,
                                ),
                              );

                            },
                          );
                        }).toList(),
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: map<Widget>(
//                          imgList, (index, url){
//                            return Container(
//                              width: 10.0,
//                              height: 10.0,
//                              margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 2.0),
//                              decoration: BoxDecoration(shape: BoxShape.circle,
//                              color: _current == index ? Colors.redAccent: Colors.blue),
//                            );
//                        }),
//                      ),
//                      SizedBox(height: 20.0,),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          OutlineButton(onPressed: goToPrevious,
//                          child: Text("<"),),
//                          OutlineButton(onPressed: goToNext,
//                            child: Text(">"),),
//                        ],
//                      ),
                    ],
                  ),
                ),
              ),
            );
    }
          );
//          } else if(snapshot.connectionState == ConnectionState.none){
//            return Text("No Data!");
//          }
//          return CircularProgressIndicator();
        }
      ),
    );

  }
//  goToPrevious(){
//    carouselSlider.previousPage(
//      duration: Duration(milliseconds: 300), curve: Curves.ease
//    );
//  }
//  goToNext(){
//    carouselSlider.nextPage(
//        duration: Duration(milliseconds: 300), curve: Curves.decelerate
//    );
//
//  }
}


  

