import 'package:dorona/Screens/Profile/profileBody.dart';
import 'package:dorona/colors1.dart';
import 'package:dorona/styles.dart';
import 'package:flutter/material.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: blueColor),
        title: Text(
          "My Profile",
          style: titleTextStyle,
        ),
      ),
      body: ProfileBody(),
    );
  }
}