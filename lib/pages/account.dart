import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '/pages/login.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  late DatabaseReference _databaseReference;
  late String _name;
  late String _address;
  late FirebaseAuth _auth;
  late String _mobile;
  late String _imageUrl;
  late File _imageFile;

  @override
  void initState() {
    super.initState();
    _databaseReference =
        FirebaseDatabase.instance.ref("user"); // Use ref() instead of reference
    _auth = FirebaseAuth.instance;
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    final snapshotName = await _databaseReference
        .child(_auth.currentUser!.uid)
        .child("name")
        .get(); // Use get() instead of once()
    final snapshotMobile = await _databaseReference
        .child(_auth.currentUser!.uid)
        .child("mobile")
        .get();
    final snapshotImage = await _databaseReference
        .child(_auth.currentUser!.uid)
        .child("image")
        .get();

    setState(() {
      _name = snapshotName.value
          as String; // Use snapshotName.value instead of snapshotName.value as String
      _mobile = snapshotMobile.value as String;
      _imageUrl = snapshotImage.value as String;
      _imageFile = File(_imageUrl);
    });

    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    }

    setState(() {
      _databaseReference
          .child(_auth.currentUser!.uid)
          .child("latitude")
          .set(position.latitude);
      _databaseReference
          .child(_auth.currentUser!.uid)
          .child("longitude")
          .set(position.longitude);
      _getAddress(position);
    });
  }

  Future<void> _getAddress(Position position) async {
    List<Placemark> placemarks;
    try {
      placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    }

    Placemark placeMark = placemarks[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;

    setState(() {
      _address =
          "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";
      _databaseReference
          .child(_auth.currentUser!.uid)
          .child("address")
          .set(_address);
    });
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _databaseReference
            .child(_auth.currentUser!.uid)
            .child("image")
            .set(_imageFile.path);
      });
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _name != '' && _address != '' && _mobile != ''
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImageFromGallery,
                    child: Container(
                      child: _imageFile.path != ''
                          ? CircleAvatar(
                              backgroundImage: FileImage(_imageFile),
                              maxRadius: 100,
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(File(_imageUrl)),
                              maxRadius: 100,
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _name,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold),
                    textScaleFactor: 1.5,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "mobile no. $_mobile",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold),
                    textScaleFactor: 1.2,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${_auth.currentUser!.email}",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold),
                    textScaleFactor: 1.2,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "address- $_address",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold),
                    textScaleFactor: 1.2,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final currentContext =
                          context; // Store the context in a local variable
                      _auth.signOut().then((_) {
                        Navigator.push(
                          currentContext, // Use the stored context
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.5)),
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text(
                      "logout",
                      textScaleFactor: 1.5,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          : const CircularProgressIndicator(color: Colors.redAccent),
    );
  }
}
