import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sociall/utils/Constants.dart';
import 'home.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isHidden = true;
  bool _saving = false;
  bool validateEmail = false;
  bool validatePassword = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<void> signUp() async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      FirebaseUser user = result.user;
      print(user);
      user.sendEmailVerification();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } catch (e) {
      _saving = false;
      setState(() {});
      print(e.message);
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
          "Sign up with",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFF3D657),
            height: 2,
          ),
        ),
        Text(
          "HOMELAND",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF3D657),
            letterSpacing: 2,
            height: 1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          style: TextStyle(color: Color(0xFFF3D657)),
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          onChanged: (value) {
            setState(() {
              value.isEmpty ? validateEmail = true : validateEmail = false;
            });
          },
          decoration: InputDecoration(
            hintText: 'Enter Email / Username',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Color(0xFF3F3C31),
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
            fillColor: Colors.grey.withOpacity(0.1),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          style: TextStyle(color: Color(0xFFF3D657)),
          obscureText: _isHidden,
          controller: passwordController,
          onChanged: (value) {
            setState(() {
              value.isEmpty
                  ? validatePassword = true
                  : validatePassword = false;
            });
          },
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Color(0xFF3F3C31),
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
            fillColor: Colors.grey.withOpacity(0.1),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFF3D657),
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFF3D657).withOpacity(0.2),
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

              if (!(validatePassword && validateEmail)) {
                _saving = true;
                signUp();
              }
            },
            child: Center(
              child: Text(
                "SIGN UP",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C1C1C),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          "Or Signup with",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFF3D657),
            height: 1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(Entypo.facebook_with_circle),
                iconSize: 32,
                color: Color(0xFFF3D657),
                onPressed: () {
                  // signUpWithFacebook();
                }),
            SizedBox(
              width: 24,
            ),
            IconButton(
              icon: Icon(Entypo.google__with_circle),
              iconSize: 32,
              color: Color(0xFFF3D657),
              onPressed: () {
                //   _googleSignUp();
              },
            ),
          ],
        )
      ],
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  // Future<void> _googleSignUp() async {
  //   try {
  //     final GoogleSignIn _googleSignIn = GoogleSignIn(
  //       scopes: ['email'],
  //     );
  //     final FirebaseAuth _auth = FirebaseAuth.instance;

  //     final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.getCredential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final FirebaseUser user =
  //         (await _auth.signInWithCredential(credential)).user;
  //     print("signed in " + user.displayName);

  //     final prefs = await SharedPreferences.getInstance();

  //     prefs.setString(Constants.isLoggedIn, 'true');

  //     _saving = false;
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => Home()));
  //     return user;
  //   } catch (e) {
  //     print(e.message);
  //   }
  // }

  // Future<void> signUpWithFacebook() async {
  //   try {
  //     var facebookLogin = new FacebookLogin();
  //     var result = await facebookLogin.logIn(['email']);

  //     if (result.status == FacebookLoginStatus.loggedIn) {
  //       final AuthCredential credential = FacebookAuthProvider.getCredential(
  //         accessToken: result.accessToken.token,
  //       );
  //       final FirebaseUser user =
  //           (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  //       print('signed in ' + user.displayName);
  //       return user;
  //     }
  //   } catch (e) {
  //     print(e.message);
  //   }
  // }
}
