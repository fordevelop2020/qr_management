import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

import 'content.dart';

void main() => runApp(Reviews());

class Reviews extends StatefulWidget {
  @override
  ReviewsState createState() => ReviewsState();
}

class ReviewsState extends State<Reviews> {

  WidgetBuilder builder = buildProgressIndicator;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Rate my app !',style: TextStyle(color: Color(0xff0f4c75)),),
        backgroundColor: Colors.grey[300],
        toolbarOpacity: 0.5,
      ),
      body: RateMyAppBuilder(
        builder: builder,
        onInitialized: (context, rateMyApp) {
          setState(() =>
          builder = (context) => ContentWidget(rateMyApp: rateMyApp));
          rateMyApp.conditions.forEach((condition) {
            if (condition is DebuggableCondition) {
              print(condition
                  .valuesAsString); // We iterate through our list of conditions and we print all debuggable ones.
            }
          });

          print('Are all conditions met ? ' +
              (rateMyApp.shouldOpenDialog ? 'Yes' : 'No'));

          if (rateMyApp.shouldOpenDialog) {
            rateMyApp.showRateDialog(context);
          }
        },
      ),
    ),
  );

  /// Builds the progress indicator, allowing to wait for Rate my app to initialize.
  static Widget buildProgressIndicator(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}




//  int selectedValue1;
//  int selectedValue2;
//
//  void onChange1(int value) {
//    setState(() {
//      selectedValue1 = value;
//    });
//  }
//
//  void onChange2(int value) {
//    setState(() {
//      selectedValue2 = value;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Rate my App',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: Scaffold(
//        body: SafeArea(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Text(
//                'How was the help you received?',
//                style: TextStyle(color: Color(0xFF6f7478), fontSize: 18),
//              ),
//              SizedBox(height: 20),
//              ReviewSlider(
//                onChange: onChange1,
//              ),
//              Text(selectedValue1.toString()),
//              SizedBox(height: 20),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
