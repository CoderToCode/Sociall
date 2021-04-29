import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sociall/ui/reset.dart';
import 'home.dart';
import 'package:sociall/utils/CommonData.dart';
import 'package:sociall/utils/Constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isHidden = true;
  bool validateEmail = false;
  bool validatePassword = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FacebookLogin facebookLogin = FacebookLogin();
  bool isSignIn = false;
  bool _saving = false;
  FirebaseUser user;
  Future<void> signIn() async {
    //final forState = formKey.currentState;

    try {
      //Center(child: CircularProgressIndicator(backgroundColor: Colors.black,strokeWidth: 50,));
      final FirebaseUser user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text))
          .user;

      // var d = await Firestore.instance
      //     .collection('users')
      //     .document(emailController.text)
      //     .get()
      //     .then((DocumentSnapshot) async {
      // name = DocumentSnapshot.data['name'];
      // usn = DocumentSnapshot.data['usn'];
      // role = DocumentSnapshot.data['role'];
      // block = DocumentSnapshot.data['block'];
      // room = DocumentSnapshot.data['room'];
      // mobile = DocumentSnapshot.data['mobile'];
      // print("name : $name");
      final prefs = await SharedPreferences.getInstance();

      //   prefs.setString(Constants.loggedInUserRole, role);
      //   prefs.setString(Constants.loggedInUserBlock, block);
      //   prefs.setString(Constants.loggedInUserRoom, room);
      //   prefs.setString(Constants.loggedInUserMobile, mobile);
      //   prefs.setString(Constants.loggedInUserName, name);
      prefs.setString(Constants.isLoggedIn, 'true');
      //   //  print("Constants name : ${Constants.loggedInUserMobile}");
      //   print(DocumentSnapshot.data.toString());
      // });
      _saving = false;
      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
      // else
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (context) => AdminDashboard()));
    } catch (e) {
      print(e.message);
      _saving = false;
      setState(() {});
      // Toast.show(e.message, context,
      //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Welcome to",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF1C1C1C),
            height: 2,
          ),
        ),
        Text(
          "HOMELAND",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1C1C),
            letterSpacing: 2,
            height: 1,
          ),
        ),
        Text(
          "Please login to continue",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF1C1C1C),
            height: 1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Email / Username',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Color(0xFFD9BC43),
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Color(0xFFECCB45),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: passwordController,
          obscureText: _isHidden,
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Color(0xFFD9BC43),
              fontWeight: FontWeight.bold,
            ),
            suffix: InkWell(
              onTap: _togglePasswordView,
              child: Icon(
                _isHidden ? Icons.visibility : Icons.visibility_off,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Color(0xFFECCB45),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFF1C1C1C),
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF1C1C1C).withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                emailController.text.isEmpty
                    ? validateEmail = true
                    : validateEmail = false;
                passwordController.text.isEmpty
                    ? validatePassword = true
                    : validatePassword = false;
              });
              if (!validateEmail && !validatePassword) {
                //isLoading==false? CircularProgressIndicator(),signIn():
                _saving = true;
                signIn();
              }
            },
            child: Center(
              child: Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF3D657),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ResetScreen())),
          child: Text(
            "FORGOT PASSWORD?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C1C1C),
              height: 1,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Or Signup with",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF3F3C31),
            height: 1,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(Entypo.facebook_with_circle),
                iconSize: 32,
                color: Color(0xFF3F3C31),
                onPressed: () {
                  loginWithfacebook();
                }),
            SizedBox(
              width: 24,
            ),
            IconButton(
              icon: Icon(Entypo.google__with_circle),
              iconSize: 32,
              color: Color(0xFF3F3C31),
              onPressed: () {
                handleSignIn();
              },
            ),
          ],
        )
      ],
    );
  }

  Future<void> handleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    AuthResult result = (await _auth.signInWithCredential(credential));

    user = result.user;
    setState(() {
      isSignIn = true;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  Future loginWithfacebook() async {
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);

    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: accessToken.token);
    var a = await _auth.signInWithCredential(credential);
    setState(() {
      isSignIn = true;
      user = a.user;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }
  //Future<void> signInWithGoogle() async {
  //   final googleSignIn = GoogleSignIn();
  //   final googleUser = await googleSignIn.signIn();
  //   if (googleUser != null) {
  //     final googleAuth = await googleUser.authentication;
  //     if (googleAuth.idToken != null) {
  //       final userCredential = await _firebaseAuth.signInWithCredential(
  //         GoogleAuthProvider.getCredential(
  //             idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
  //       );
  //       if (userCredential.user != null) {
  //         Navigator.pushReplacement(
  //             context, MaterialPageRoute(builder: (context) => Home()));
  //       }
  //       return userCredential.user;
  //     }
  //   } else {
  //     // throw FirebaseAuthException(
  //     //   message: "Sign in aborded by user",
  //     //   code: "ERROR_ABORDER_BY_USER",
  //     // );
  //     print("Error");
  //   }
  // }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
