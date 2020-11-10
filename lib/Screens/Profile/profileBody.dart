import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:dorona/colors1.dart';
import 'package:dorona/providers/userProvider.dart';
import 'package:dorona/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  String nightMapStyle;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  static final CameraPosition _kLake = CameraPosition(
      target: LatLng(37.43296265331129, -122.08832357078792),
      zoom: 19.151926040649414);
  Position currentPosition;
  bool isCurrentLocationLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isCurrentLocationLoading = true;
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    final delay = Duration(milliseconds: 500);
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElasticInDown(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: blueColor,
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            FadeIn(
              delay: delay,
              child: Text(
                userProvider.user.phoneNumber,
                style: subtitleTextFaded,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: size.width,
              child: FadeIn(
                delay: delay,
                child: Text(
                  "My Location",
                  style: simpleTextDrawer,
                ),
              ),
            ),
            FadeIn(
              delay: delay,
              child: Container(
                margin: EdgeInsets.all(10),
                width: size.width,
                height: 350,
                color: blueColor.withOpacity(0.1),
                child: isCurrentLocationLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(blueColor),
                      ))
                    : FadeIn(
                        child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(currentPosition.latitude,
                              currentPosition.longitude),
                          zoom: 17,
                        ),
                        circles: [
                          Circle(
                            fillColor: Colors.blue.withOpacity(0.3),
                            strokeWidth: 1,
                            strokeColor: Colors.blue.withOpacity(0.5),
                            radius: 50,
                            circleId: CircleId("dsfdsfds"),
                            center: LatLng(currentPosition.latitude,
                                currentPosition.longitude),
                          ),
                        ].toSet(),
                        markers: [
                          Marker(
                            markerId: MarkerId("asdasdas"),
                            position: LatLng(currentPosition.latitude,
                                currentPosition.longitude),
                          )
                        ].toSet(),
                        mapType: MapType.satellite,
                        zoomControlsEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          mapController = controller;
                          //changeMapMode();
                        },
                      )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getLocation() async {
    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      forceAndroidLocationManager: true
    );
    // Location location=Location();
    // currentPosition=await location.getLocation();
    setState(() {
      isCurrentLocationLoading = false;
    });
  }

  void changeMapMode() {
    getJsonFile('assets/mapStyles/night.json').then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    mapController.setMapStyle(mapStyle);
  }
}
