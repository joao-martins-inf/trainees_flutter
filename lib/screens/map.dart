import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  String? username;
  String? name;
  String? email;
  int? height;
  double? weight;
  int? gymId;
  String? gymName;
  double? gymLat;
  double? gymLong;

  getInfo(context) async {
    Future<dynamic> getUserInfo(String token) async {
      try {
        http.Response a = await http.get(
          Uri.http('167.233.9.110', '/api/users/userProfile'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ' + token,
          },
        );


        return a;
      } catch (e) {
        return false;
      }
    }

    Future<dynamic> getGymName(int gymId) async {
      try {
        http.Response a = await http.get(
          Uri.http('195.201.90.161:81', '/api/gym/$gymId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        return a;
      } catch (e) {
        return false;
      }
    }

    final token = ModalRoute.of(context)!.settings.arguments;

    final res = await getUserInfo(token.toString());
    final decodedRes = jsonDecode(res.body);

    this.username = decodedRes['username'];
    this.name = decodedRes['first_name'];
    this.email = decodedRes['email'];
    this.height = decodedRes['height'];
    this.weight = decodedRes['weight'];
    this.gymId = decodedRes['gym_id'];

    final gymRes = await getGymName(decodedRes['gym_id']);

    final decodedResGym = jsonDecode(gymRes.body);

    this.gymName = decodedResGym['name'];
    this.gymLat = decodedResGym['latitude'];
    this.gymLong = decodedResGym['longitude'];
  }

  @override
  String toString() {
    return 'name:${name}, username:${username}, email:${email} ';
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _newMapController;
  Position? currentPosition;

  var geolocator = Geolocator();

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition =
        LatLng(currentPosition!.latitude, currentPosition!.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    _newMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    User _user = User();

    return new Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _newMapController = controller;
          locatePosition();
        },
      ),
      floatingActionButton: FutureBuilder(
          future: _user.getInfo(context),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (_user.gymLat != null && _user.gymLong != null) {
              return
               Column(crossAxisAlignment: CrossAxisAlignment.end,
                   mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    locatePosition();
                  },
                  label: Text('Go to my location'),
                  icon: Icon(Icons.person_outlined),
                ),
                      SizedBox(height: 10,),
                FloatingActionButton.extended(
                  onPressed: () {
                    goToGym(_user.gymLat, _user.gymLong);
                  },
                  label: Text('Go to the gym'),
                  icon: Icon(Icons.fitness_center_outlined),
                ),

              ]);
            } else if(_user.gymLat == null){
              return FloatingActionButton.extended(
                onPressed: () {
                  locatePosition();
                },
                label: Text('Go to my location'),
                icon: Icon(Icons.person_outlined),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Future<void> _goToTheGym(double? lat, double? long) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition position = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat!, long!),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  void goToGym(double? lat, double? long) {
    _goToTheGym(lat!, long!);
  }
}
