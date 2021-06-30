import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:trainees_flutter/screens/gym/activities/activityDetails/activityMap/activityMap.dart';

class Activity {
  final String name;
  final String description;
  final String activityDate;
  final double latitude;
  final double longitude;
  Activity(this.name, this.description, this.activityDate, this.latitude, this.longitude);
}

class ActivityInfo extends StatelessWidget {
  final String name;
  final String description;
  final String activityDate;
  final double latitude;
  final double longitude;


  ActivityInfo(
      {Key? key,
        required this.name,
        required this.description,
        required this.activityDate,
      required this.latitude,
      required this.longitude})
      : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: (AppBar(
        backgroundColor: Colors.blue,
        title: Text(name),
        centerTitle: true,
        elevation: 0,
      )),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('Description',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(description)),
              ),

              Align(
                alignment: Alignment.center,
                child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('Activity Date',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(activityDate.split('T')[0])),
              ),
          Align(
            alignment: Alignment.center,
            child:
              Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text('Localization',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)))),
              SizedBox(
                width: 200,  // or use fixed size like 200
                height: MediaQuery.of(context).size.height - 280,
                child:ActivityMap(latitude: latitude, longitude: longitude),)
            ],
          ),
        ),
      ),
    );
  }


}
