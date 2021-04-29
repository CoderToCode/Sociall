import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sociall/utils/CommonData.dart';

import '../main.dart';
import 'login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              GestureDetector(
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onTap: () {
                  CommonData.clearLoggedInUserData();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
            ],
            title: Text('Sociall'),
          ),
          body: Center(child: Text('Hello World')),
        ));
  }
}
