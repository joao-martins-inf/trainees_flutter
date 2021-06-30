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
        //print(a.statusCode);

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
    print(decodedResGym);
    this.gymName = decodedResGym['name'];
    this.gymLat = decodedResGym['latitude'];
    this.gymLong = decodedResGym['longitude'];
  }

  @override
  String toString() {
    return 'name:${name}, username:${username}, email:${email} ';
  }
}


class ActivityMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  const ActivityMap ({ Key? key, required this.latitude, required this.longitude }): super(key: key);

  @override
  State<ActivityMap> createState() => ActivityMapState();
}

class ActivityMapState extends State<ActivityMap> {
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



  @override
  Widget build(BuildContext context) {
  User _user = User();
print(widget.latitude);
    return new Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 14.4746,
        ),
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _newMapController = controller;

        },
      ),
      floatingActionButton: FutureBuilder(
          future: _user.getInfo(context),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (widget.latitude != null ) {
              return
                Column(crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          locatePosition();
                        },
                        label: Text('My Location'),
                        icon: Icon(Icons.person_outlined),
                      ),
                      SizedBox(height: 10,),
                      FloatingActionButton.extended(
                        onPressed: () {
                          goToActivity(widget.latitude, widget.longitude);
                        },
                        label: Text('Activity Location'),
                        icon: Icon(Icons.fitness_center_outlined),
                      ),
                    ]);
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Future<void> _goToActivity(double? lat, double? long) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition position = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat!, long!),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  void goToActivity(double? lat, double? long) {
    _goToActivity(lat!, long!);
  }
}
