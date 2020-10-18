import 'package:dorona/colors1.dart';
import 'package:dorona/my_custom_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dorona/styles.dart';
import 'package:flutter/cupertino.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                child: Icon(
                  Icons.person_pin,
                  size: 100,
                  color: iconColor,
                ),
              ),
              Divider(
                color: iconColor,
              ),
              ListTile(
                leading: Icon(
                  MyCustomIcons.qrcode,
                  size: 30,
                  color: iconColor,
                ),
                title: Text(
                  "Generate/Scan QR code",
                  style: simpleTextDrawer,
                ),
              ),
              ListTile(
                leading: Icon(
                  MyCustomIcons.phone,
                  size: 30,
                  color: iconColor,
                ),
                title: Text(
                  "Call Helpline",
                  style: simpleTextDrawer,
                ),
              ),
              ListTile(
                leading: Icon(
                  MyCustomIcons.cog_outline,
                  size: 30,
                  color: iconColor,
                ),
                title: Text(
                  "Settings",
                  style: simpleTextDrawer,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  size: 30,
                  color: iconColor,
                ),
                title: Text(
                  "Sign out",
                  style: simpleTextDrawer,
                ),
                onTap: (){
                  FirebaseAuth auth=FirebaseAuth.instance;
                  auth.signOut();
                },
              ),
              Divider(
                color: iconColor,
              ),
              ListTile(
                title: Text(
                  "Privacy Policy",
                  style: simpleTextDrawer,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
