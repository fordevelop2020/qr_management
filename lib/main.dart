import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:qr_management/screens/home/Home.dart';
import 'package:qr_management/shared/globals.dart';
import 'package:qr_management/widgets/button_widget.dart';
import 'package:qr_management/widgets/textfield_widget.dart';
import 'package:qr_management/widgets/wave_widget.dart';
import 'ForgotScreen.dart';
import 'models/home_model.dart';
import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => HomeModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
//      return new MaterialApp(
//        title: 'Qr Management',
//        theme: new ThemeData(
//          primarySwatch: Colors.purple,
//        ),
//
//        home: new MyHomePage(),
//      );
//    return StreamProvider<User>.value(
//      value: AuthService().user,
//      child: MaterialApp(
//       home: Wrapper(),
//      ),
//    );

  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final emailTextController =  TextEditingController();
  final passwordTextController =   TextEditingController();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser userData;
  bool loading = false;
  String error = '';
  final formKey = new GlobalKey<FormState>();

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }



  final GoogleSignIn googleSignIn = GoogleSignIn();
  String successMessage = '';
  String errorMessage = '';
  String _email;

  String _password;


  bool validateAndSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
      print('Form is valid. Email:$_email, password:$_password');
    }
      return false;
  }

//  void validateAndSubmit(){
//    if(validateAndSave()){
//
//    }
//  }



  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
        .authentication;

    final AuthCredential firebaseUser = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
    );
    final FirebaseUser user = (await firebaseAuth.signInWithCredential(
        firebaseUser)).user;

    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) =>
            new Home(user: user, googleSignIn: googleSignIn,)
        )
    );
  }

  Future<FirebaseUser> signUpWithMail(String emailT , String passwordT) async
  {
    if(validateAndSave()){

      final bool isValid = EmailValidator.validate(emailT);

      print('Email is valid? ' + (isValid ? 'yes' : 'no'));
      FirebaseUser userData;
      try{
      userData = (await firebaseAuth.createUserWithEmailAndPassword(email: emailT, password: passwordT)).user;
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) =>
              new Home(user: userData, googleSignIn: googleSignIn,)
          )
      );
      print(emailT);
      print(passwordT);

    }catch (e){
      print(e.toString());
    }

    if(userData != null){
      print(userData);
      return userData;
    }
    return null;
  // ignore: unnecessary_statements
  } else (e){
      // ignore: unnecessary_statements
      e.toString();
    };
  }


//  Future<void> resetPassword(String email) async {
//    await firebaseAuth.sendPasswordResetEmail(email: email);
//  }

  Future<FirebaseUser> signInWithMail(String emailT , String passwordT) async
  {

    final bool isValid = EmailValidator.validate(emailT);

    print('Email is valid? ' + (isValid ? 'yes' : 'no'));

    try{
      userData = (await firebaseAuth.signInWithEmailAndPassword(email: emailT, password: passwordT)).user;
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) =>
              new Home(user: userData, googleSignIn: googleSignIn,)
          )
      );
      print(emailT);
      print(passwordT);

    }catch (e){
      print(e.toString());
    }

    if(userData != null){
      print(userData);
      return userData;
    }
    return null;
  }

  @override
    void dispose(){
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final model = Provider.of<HomeModel>(context);

    return new Scaffold(
      backgroundColor: Global.white,
      body: Stack(
        children: <Widget>[

          Container(

            height: size.height - 200,
            //color: Global.mediumBlue,
            color: Color(0xff3282b8),

          ),
          AnimatedPositioned(

            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuad,
            top: keyboardOpen ? -size.height / 3.7 : 0.0,
            child: WaveWidget(
              size: size,
              yOffset: size.height / 3.0,
              color: Global.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),


//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
                child : new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                   Text(
                  'OYA & Think+',
                  style: TextStyle(
                    color: Global.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
           // ]),

            ]),
    ),

          Padding(
            padding: const EdgeInsets.all(30.0),
                child: new Form(
                key: formKey,
            child:new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
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
                new TextForm2Field(
                  hintText: 'Password',
                  validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                //  controller: passwordTextController,
                  obscureText: model.isVisible ? false : true,
                  prefixIconData: Icons.lock_outline,
                  suffixIconData: model.isVisible
                      ? Icons.visibility
                      : Icons.visibility_off,

                  onSaved: (value) => _password = value,
                ),

//                SizedBox(
//                  height: 10.0,
//                ),
//                Column(
//                 // crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//
//                    SizedBox(
//                      height: 10.0,
//                    ),
                    Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=> ForgotScreen()));
                            },
                          child :Text('Forgot password?', style: TextStyle(color: Color(0xff3282b8)),
                            ),
                          )),
                      ],
                    ),
                //  ],
               // ),
                (errorMessage != ''
                    ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )

                    : Container()),

                SizedBox(
                  height: 10.0,
                ),
              ButtonWidget(
                  title: 'Sign in with Google',
                    hasBorder: false,
                onPressed: ()  {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    _signIn();
//                    if(userData != null){
//                      loading = true;
//                      Navigator.of(context).push(
//                          new MaterialPageRoute(
//                              builder: (BuildContext context) =>
//                              new Home(user: userData, googleSignIn: googleSignIn,)
//                          )
//                      );
//                    } else {}
//                  }
                  }},
              ),
                SizedBox(
                  height: 10.0,
                ),
                ButtonWidget(
                  title: 'Login',
                  hasBorder: true,
                    // ignore: missing_return
                    onPressed: ()  {
                    if (formKey.currentState.validate()) {
                       formKey.currentState.save();
                      signInWithMail(_email,_password);
//                        if(userData != null){
//                          loading = true;
//                          Navigator.of(context).push(
//                              new MaterialPageRoute(
//                                  builder: (BuildContext context) =>
//                                  new Home(user: userData, googleSignIn: googleSignIn,)
//                              )
//                          );
////                          Route route = MaterialPageRoute(builder: (context) => MyAddPage());
////                             Navigator.push(context, route);
//                        //  return AddProjet();
//                        } else {}
                    }},
    ),
                SizedBox(
                  height: 10.0,
                ),
                ButtonWidget(
                  title :('Sign Up'),
                  hasBorder: true,
                  onPressed: (){
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      signUpWithMail(_email,_password);
                      setState((){
                        error = 'Could not sign in with those credentials';
                      });
                  }},

                  )],
    )),
    )],
    ));
  }
}
//  },
//
//
//}

//          ),
//          ),
//
//    ]));

//          ),
//          (successMessage != ''
//              ? Text(
//            successMessage,
//            textAlign: TextAlign.center,
//            style: TextStyle(fontSize: 24, color: Colors.green),
//          )
//              : Container()),
//        ],
//      ),
//    );
//  }
//}

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//
//        appBar: AppBar(
//        backgroundColor: Colors.purple,
//     title: Text('Sign In'),),
//     //   width: double.infinity,
////        decoration: BoxDecoration(
////          image: DecorationImage(
////            image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover
////          )
////        ),
//    body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            FlatButton(
//            color: Colors.purple,
//              child: Text('Sign in with Google', style: TextStyle(color: Colors.white),), onPressed: _signIn,
//            ),
//            new Image.asset('assets/logo.png'),
//          new Padding(padding: const EdgeInsets.only(bottom: 30.0),),
//            new InkWell(
//              onTap: (){
//                _signIn();
//              },
//            ),
//            new Image.asset('assets/googleLogo.png', width: 200.0),
//          ],
//        ),
//      ),
//    );
//  }
//}




