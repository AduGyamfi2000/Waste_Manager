import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/items.dart';
import '../models/userdata.dart';

class CurrentLocationPage extends StatefulWidget {
  const CurrentLocationPage({Key? key}) : super(key: key);

  @override
  CurrentLocationPageState createState() => CurrentLocationPageState();
}

class CurrentLocationPageState extends State<CurrentLocationPage> {
  late double latitude;
  late double longitude;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool mp = false;
  late List<Items> items;
  late DatabaseReference reference;
  late GoogleMapController mapController;
  int markerIndex = 10000;
  final CallsAndMessagesService _callsAndMessagesService =
      CallsAndMessagesService();

  @override
  void initState() {
    super.initState();
    getCurrentLocation();

    final reference = FirebaseDatabase.instance.ref('user');
    reference.once().then((DataSnapshot snapshot) {
          if (snapshot.exists) {
            var values = snapshot.value as Map<String, dynamic>;
            for (var key in values.keys) {
              if (key != FirebaseAuth.instance.currentUser!.uid) {
                MarkerId markerId = MarkerId("$markerIndex");
                UserData userInfo = UserData(
                    values[key]["name"],
                    values[key]["latitude"],
                    values[key]["longitude"],
                    values[key]["email"],
                    values[key]["mobile"],
                    values[key]["address"]);

                Marker marker = Marker(
                    markerId: markerId,
                    position: LatLng(userInfo.latitude, userInfo.longitude),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen),
                    infoWindow: InfoWindow(
                        title: userInfo.name,
                        onTap: () {
                          showBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return getBottomSheet(userInfo);
                              });
                        },
                        snippet: "click here to know more.."));

                setState(() {
                  markerIndex++;
                  markers[markerId] = marker;
                });
              }
            }
          }
        } as FutureOr Function(DatabaseEvent value));

    setMarkers();
  }

  void setMarkers() {
    Marker center1 = Marker(
        markerId: MarkerId("$markerIndex"),
        position: const LatLng(30.8836, 75.8248),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        infoWindow: InfoWindow(
            title: "COSMOS RECYCLING",
            onTap: () {
              showBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                        color: Colors.transparent,
                        child: const Text("COSMOS RECYCLING"));
                  });
            },
            snippet: "click here to know more.."));
    setState(() {
      markerIndex++;
      markers[MarkerId("$markerIndex")] = center1;
    });

    // Add more markers here
  }

  Future<Position> getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      setState(() {
        latitude = value.latitude;
        longitude = value.longitude;
      });
    });

    final GoogleMapController controller = mapController;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 15)));

    Marker marker = Marker(
        markerId: const MarkerId("0"),
        position: LatLng(latitude, longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: "Home"));

    setState(() {
      markers[const MarkerId("0")] = marker;
    });

    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Widget getBottomSheet(UserData userInfo) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.redAccent,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text(userInfo.name,
                          textScaleFactor: 1.4,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(userInfo.address,
                          textScaleFactor: 1.4,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 40),
              Row(children: <Widget>[
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    _callsAndMessagesService.call(userInfo.mobile);
                  },
                  child: const Icon(Icons.call, color: Colors.blue),
                ),
                Text(userInfo.mobile,
                    textScaleFactor: 1.2, style: const TextStyle()),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () {
                    _callsAndMessagesService.sendEmail(userInfo.email);
                  },
                  child: const Icon(Icons.mail, color: Colors.blue),
                ),
                Text(userInfo.email,
                    textScaleFactor: 1.2, style: const TextStyle()),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: GoogleMap(
        mapType: MapType.normal,
        scrollGesturesEnabled: true,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
        myLocationEnabled: true,
        compassEnabled: true,
        markers: Set<Marker>.of(markers.values),
        initialCameraPosition:
            CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}

class CallsAndMessagesService {
  void call(String number) => ("tel:$number");
  void sendSms(String number) => ("sms:$number");
  void sendEmail(String email) => ("mailto:$email");
}
