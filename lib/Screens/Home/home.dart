import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          RaisedButton(
            onPressed: () {
             FirebaseAuth auth= FirebaseAuth.instance;
             auth.signOut();
            },
            child: Text("sign out"),
          )
        ],
      ),
    );
  }
}
