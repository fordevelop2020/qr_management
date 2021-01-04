import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_management/widgets/button_widget.dart';
import 'package:qr_management/widgets/textfield_widget.dart';

import 'models/home_model.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  String _email ="";
  var _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4c75),
        title: Text("Forgot password"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(padding: EdgeInsets.only(top: 30,left: 20,right: 20),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Text("We will mail you a link ... Please click on that link to reset your password", style: TextStyle(color: Colors.blueAccent, fontSize: 15),),
              SizedBox(
                height: 30.0,
              ),
               new TextForm2Field(
                hintText: 'Email',
                validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
                //controller: emailTextController,
                obscureText: false,
                prefixIconData: Icons.mail_outline,
                suffixIconData: model.isValid ? Icons.check : null,
                onSaved: (value) => _email = value,
              ),
              SizedBox(
                height: 10.0,
              ),
              ButtonWidget(
                title: 'Send Email',
                hasBorder: true,
                // ignore: missing_return
                onPressed: ()  {
                  if (_formkey.currentState.validate()) {
                    _formkey.currentState.save();
                FirebaseAuth.instance.sendPasswordResetEmail(email: _email).then((value) => print("Check your mail"));
                  }},
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
