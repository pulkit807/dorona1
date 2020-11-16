import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorona/Screens/NearbyYou/peopleNearByYou.dart';
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
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: CircularProgressIndicator());
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
                      subtitle: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return PeopleNearByYou(userProvider.user.uid);
                          }));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: snapshot.data['status'] == 'negative'
                                  ? greenColor
                                  : Colors.red,
                              border:
                                  Border.all(color: Colors.white70, width: 5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "See others nearby you!",
                                style: buttonText,
                              ),
                              Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                              )
                            ],
                          )),
                        ),
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
                          radius: 40,
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
                          radius: 40,
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
                          radius: 40,
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
                    height: 160,
                    width: 160,
                    placeholderBuilder: (context) {
                      return Shimmer.fromColors(
                          child: Container(
                            width: 160,
                            height: 160,
                          ),
                          baseColor: Color(0xFFF5F5F7),
                          highlightColor: Colors.white);
                    },
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
          // RaisedButton(onPressed: () async {
        
          // })
        ],
      ),
    );
  }
}
