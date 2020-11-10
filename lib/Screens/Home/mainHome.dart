import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorona/colors1.dart';
import 'package:dorona/providers/userProvider.dart';
import 'package:dorona/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            elevation: 6.0,
            child: Container(
              width: width,
              height: 100,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('status')
                    .doc(userProvider.user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return CircularProgressIndicator();
                  }
                  return Container(
                    // color: snapshot.data['status'] == 'negative'
                    //     ? greenColor
                    //     : Colors.red,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      snapshot.data['status'] == 'negative'
                          ? greenColor
                          : Colors.red,
                      snapshot.data['status'] == 'negative'
                          ? greenColor.withOpacity(0.8)
                          : Colors.red.withOpacity(0.8)
                    ])),
                    child: ListTile(
                      leading: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.only(top: 5),
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                        child: Image.asset(
                          "assets/images/medical-mask.png",
                        ),
                      ),
                      title: Text(
                        snapshot.data['status'] == 'negative'
                            ? "You are safe"
                            : "You are covid positive",
                        style: GoogleFonts.aleo(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: width,
            color: Color(0xFFF5F5F7),
            padding: EdgeInsets.only(top: 10, left: 10, bottom: 2),
            child: Text(
              "Preventions",
              style: titleTextStyle,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    "assets/images/hand_wash.svg",
                    placeholderBuilder: (context) {
                      return Shimmer.fromColors(
                        direction: ShimmerDirection.btt,
                        baseColor: Color(0xFFF5F5F7),
                        highlightColor: Colors.white,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Wash hands",
                    style: subtitleText,
                  )
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    "assets/images/use_mask.svg",
                    placeholderBuilder: (context) {
                      return Shimmer.fromColors(
                        direction: ShimmerDirection.btt,
                        baseColor: Color(0xFFF5F5F7),
                        highlightColor: Colors.white,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Wear mask",
                    style: subtitleText,
                  )
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    "assets/images/Clean_Disinfect.svg",
                    placeholderBuilder: (context) {
                      return Shimmer.fromColors(
                        direction: ShimmerDirection.btt,
                        baseColor: Color(0xFFF5F5F7),
                        highlightColor: Colors.white,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Clean Disinfect",
                    style: subtitleText,
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Card(
            child: Container(
              color: Color(0xFFF5F5F7),
              width: width * 0.9,
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/nurse.svg",
                  ),
                  Column(
                    children: [
                      Container(
                        width: width * 0.3,
                        child: Text(
                          "Dial 1075 for Medical Help!",
                          style: simpleTextDrawer,
                        ),
                      ),
                      Container(
                        width: width * 0.3,
                        child: Text(
                          "If any symptoms appear.",
                          style: subtitleTextSmall,
                        ),
                      )
                    ],
                  ),
                ],
              ), 
            ),
          ),
          RaisedButton(onPressed: ()async{
            print("inside");
            MethodChannel channel=MethodChannel("Location");
           String macAddress= await channel.invokeMethod("getBluetoothAddress");
           print(macAddress);
          })
        ],
      ),
    );
  }
}
