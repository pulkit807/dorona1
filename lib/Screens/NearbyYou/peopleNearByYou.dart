import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PeopleNearByYou extends StatefulWidget {
  String userId;
  PeopleNearByYou(this.userId);
  @override
  _PeopleNearByYouState createState() => _PeopleNearByYouState();
}

class _PeopleNearByYouState extends State<PeopleNearByYou> {
  MethodChannel channel = new MethodChannel("Location");
  bool ispincode = false;
  String pincode, adminArea, subAdminArea;
  double latitude, longitude;
  BitmapDescriptor positiveMarker, negativeMarker, mymarker;
  @override
  void initState() {
    // TODO: implement initState
    getPeopleNearBy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !ispincode
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection("Locations")
                  .doc(adminArea)
                  .collection(adminArea)
                  .doc(subAdminArea)
                  .collection(subAdminArea)
                  .doc(pincode)
                  .collection(pincode)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                Set<Marker> markers = Set();
                print(snapshot.data.docs.length);
                snapshot.data.docs.forEach((doc) {
                  if (doc.id != widget.userId) {
                    markers.add(
                      Marker(
                        markerId: MarkerId(doc.id),
                        position: LatLng(
                          doc.data()['latitude'],
                          doc.data()['longitude'],
                        ),
                        icon: doc.data()['status'] == "positive"
                            ? positiveMarker
                            : negativeMarker,
                        infoWindow: doc.data()['status'] == "positive"
                            ? InfoWindow(
                                title: "Covid positive",
                                snippet: Geolocator.distanceBetween(
                                            latitude,
                                            longitude,
                                            doc.data()['latitude'],
                                            doc.data()['longitude'])
                                        .toInt()
                                        .toString() +
                                    "m away from you.",
                              )
                            : InfoWindow(title: ""),
                      ),
                    );
                  }
                  markers.add(Marker(
                      markerId: MarkerId(widget.userId),
                      position: LatLng(latitude,longitude),
                      icon: mymarker,
                      infoWindow: InfoWindow(title: "My Location")));
                });
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      latitude,
                      longitude,
                    ),
                    zoom: 15,
                  ),
                  mapType: MapType.normal,
                  markers: markers,
                );
              },
            ),
    );
  }

  void getPeopleNearBy() async {
    Position currentPosition = await Geolocator.getLastKnownPosition(
      forceAndroidLocationManager: true,
    );
    if(currentPosition==null){
      currentPosition=await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
      );
    }
    final address = await channel.invokeMethod("getAddressFromCoordinates", {
      'latitude': currentPosition.latitude.toString(),
      'longitude': currentPosition.longitude.toString()
    });
    latitude = currentPosition.latitude;
    longitude = currentPosition.longitude;
    print(address);
    adminArea = address['adminArea'];
    subAdminArea = address['subAdminArea'];
    pincode = address['pincode'];
    positiveMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(20, 20)),
      "assets/images/coronamarker2.png",
    );
    negativeMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(20, 20)),
        "assets/images/negativeMarker.png");
    mymarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(20, 20)), "assets/images/mymarker.png");
    setState(() {
      ispincode = true;
    });
  }
}
