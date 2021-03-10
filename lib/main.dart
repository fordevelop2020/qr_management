import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:qr_management/screens/home/Home.dart';

import 'package:qr_management/screens/home/ScanQrClt.dart';
import 'package:qr_management/screens/home/ScanQrCode.dart';
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

  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  final emailTextController =  TextEditingController();
  final passwordTextController =   TextEditingController();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser userData;
  bool loading = false;
  String error = '';
  GlobalKey<FormState> _formKey =  GlobalKey<FormState>();

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }



  final GoogleSignIn googleSignIn = GoogleSignIn();
  String successMessage = '';
  String errorMessage = '';
  String _email='';
  String _password='';


  bool validateAndSave(){
    final form = _formKey.currentState;

    if(form.validate()){
      form.save();
      print('Form is valid. Email:$_email, password:$_password');
//      final snackbar = new SnackBar(content: new Text("Email:$_email, password:$_password"));
//      Scaffold.of(context).showSnackBar(snackbar);
      return true;

    }
      return false;
  }

  showdialog(context){
    return showDialog(context : context, builder:(context){
      var height = MediaQuery.of(context).size.height;
      var width = MediaQuery.of(context).size.width;
      return AlertDialog(backgroundColor: Colors.transparent,elevation:0.1,shape: CircleBorder(),content:
             Container(
               height: 50,
               width:  20,
               color: Colors.transparent,
               child: SpinKitFadingGrid(
            color: Colors.blueAccent,
//              size: 50.0,
                controller: AnimationController(vsync: this,
                duration: const Duration(milliseconds: 1200)),
          ),
             ),
      );
    });
  }

  void toastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        fontSize: 16.0
    );
  }


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
//    if(validateAndSave()){

//      final bool isValid = EmailValidator.validate(emailT);
//
//      print('Email is valid? ' + (isValid ? 'yes' : 'no'));
//      FirebaseUser userData;

      userData = (await firebaseAuth.createUserWithEmailAndPassword(email: emailT, password: passwordT)).user;
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) =>
              new Home(user: userData, googleSignIn: googleSignIn,)
          )
      );
      print(emailT);
      print(passwordT);

//    }catch (e){
//      print(e.toString());
//    }
//
//    if(userData != null){
//      print(userData);
//      return userData;
//    }
//    return null;
  // ignore: unnecessary_statements
//  } else (e){
//      // ignore: unnecessary_statements
//      e.toString();
//    };
  }


//  Future<void> resetPassword(String email) async {
//    await firebaseAuth.sendPasswordResetEmail(email: email);
//  }

  Future<FirebaseUser> signInWithMail(String emailT , String passwordT) async
  {

//    final bool isValid = EmailValidator.validate(emailT);
//
//    print('Email is valid? ' + (isValid ? 'yes' : 'no'));

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
            padding: const EdgeInsets.only(top: 95.0),


//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
                child : new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                   Text(
                  'Think',
                  style: TextStyle(
                    color: Global.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                    Text(
                      '+',
                      style: TextStyle(
                        color: Global.white,
                        fontSize: 80.0,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    Text(
                      'OYA',
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
                key: _formKey,
            child:new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextFormField(
                  validator: (val) => !val.contains('@')?'Invalid Email': null,
                  obscureText: false,
                  cursorColor: Color(0xff3282b8),
                  style: TextStyle(
                    color: Color(0xff3282b8),
                    fontSize: 14.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    labelStyle: TextStyle(color:Color(0xff3282b8)),
                    focusColor: Color(0xff3282b8),
                    filled: true,
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xff3282b8)),
                    ),
                    prefixIcon: Icon(
                        Icons.mail_outline,
                      size: 18,
                      color: Color(0xff3282b8),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        model.isVisible = !model.isVisible;
                      },
                      child: Icon(
                        model.isValid ? Icons.check : null,
                        size: 18,
                        color: Color(0xff3282b8),
                      ),
                    ),
                  ),
//                 validator: (email)=>EmailValidator.validate(email)? null:"Invalid email address",
//                  validator: (value){ if (value.isEmpty){ return 'Email can\'t be empty';}
//                  if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
//                    return 'Please a valid Email';
//                 }
//                  return  null; },
//                  controller: emailTextController,
                  onSaved: (value) => _email = value,
               ),
                 SizedBox(
                          height: 16.0,
                        ),
                 TextFormField(

                  validator: (value) => value.length < 6 ? 'Password too short' : null,
                   obscureText: model.isVisible ? false : true,
                   cursorColor: Color(0xff3282b8),
                   style: TextStyle(
                     color: Color(0xff3282b8),
                     fontSize: 14.0,
                   ),
                   decoration: InputDecoration(
                     hintText: 'Password',
                     labelStyle: TextStyle(color:Color(0xff3282b8)),
                     focusColor: Color(0xff3282b8),
                     filled: true,
                     enabledBorder: UnderlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                       borderSide: BorderSide.none,
                     ),
                     focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                       borderSide: BorderSide(color: Color(0xff3282b8)),
                     ),
                     prefixIcon: Icon(
                       Icons.lock_outline,
                       size: 18,
                       color: Color(0xff3282b8),
                     ),
                     suffixIcon: GestureDetector(
                       onTap: () {
                         model.isVisible = !model.isVisible;
                       },
                       child: Icon(
                         model.isVisible
                             ? Icons.visibility
                             : Icons.visibility_off,
                         size: 18,
                         color: Color(0xff3282b8),
                       ),
                     ),
                   ),

                  onSaved: (value) => _password = value,
                ),
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
                (errorMessage != ''
                    ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )

                    : Container()),

                SizedBox(
                  height: 17.0,
                ),
              ButtonWidget(
                  title: 'Sign in with Google',
                    hasBorder: false,
                onPressed: ()  {
//                  if (_formKey.currentState.validate()) {
//                    _formKey.currentState.save();
//                    toastMessage("Email: $_email\nPassword: $_password");
                   loading = true;
//                   showdialog(context);
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
                  }
//                  },
              ),
                SizedBox(
                  height: 8.0,
                ),
                ButtonWidget(
                  title: 'Login',
                  hasBorder: true,
                    // ignore: missing_return
                    onPressed: ()  {
                      loading = true;
//                    if (_formKey.currentState.validate()) {
//                       _formKey.currentState.save();
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
//                    }
                    },
    ),
                SizedBox(
                  height: 8.0,
                ),
                ButtonWidget(
                  title :('Sign Up'),
                  hasBorder: true,
                  onPressed: (){
//                    if (_formKey.currentState.validate()) {
//                      _formKey.currentState.save();
                      signUpWithMail(_email,_password);
//                      setState((){
//                        error = 'Could not sign in with those credentials';
//                      });
//                  }
                    },

                  ),
                 Row(
                  children: [
                    IconButton(icon: Icon(FontAwesomeIcons.qrcode,color: Color(0xff3282b8),), onPressed: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>
                          ScanQrClt()));

                    }), Text("Client Area",style: TextStyle(
                      color: Color(0xff3282b8),
                      fontSize: 14.0,
                    ),)
                  ],
                ),


              ],
    )),
    )],
    ));
  }

}





