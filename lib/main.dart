import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorona/Screens/Login/login.dart';
import 'package:dorona/colors1.dart';
import 'package:dorona/providers/bottomBarProvider.dart';
import 'package:dorona/providers/userProvider.dart';
import 'package:dorona/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

import 'Screens/Home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
        ChangeNotifierProvider.value(
          value: BottomBarProvider(),
        )
      ],
      child: MaterialApp(
        home: SplashScreen(
          seconds: 5,
          backgroundColor: Colors.white,
          navigateAfterSeconds: OnBoarding(),
          title: Text(
            "Dorona",
            style: splashtitle,
          ),
          loadingText: Text(
            "Door Raho Na!",
            style: splashtitle,
          ),
          loaderColor: Colors.red,
          image: Image.asset('assets/images/coronavirus.png'),
          photoSize: 120,
        ),
      ),
    );
  }
}
class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermissions();
  }
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if(!userProvider.issignedIn){
      print("listening");
      userProvider.registerUserChange();
    }
    return userProvider.issignedIn ? Home(userProvider.user) : Login();
  }
  void getPermissions()async{
    await requestPermission();
  }
}
