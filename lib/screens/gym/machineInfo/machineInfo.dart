import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class Info {
  final String name;
  final String description;
  final exercises;
  Info(this.name, this.description, this.exercises);
}

class MachineInfo extends StatelessWidget {
  final String name;
  final String description;
  final List<dynamic> exercises;

  MachineInfo(
      {Key? key,
      required this.name,
      required this.description,
      required this.exercises})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    exercises.sort((a,b) => a['difficulty'].compareTo(b['difficulty']));
    print(exercises);
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
              SizedBox(height: 10),
              Align(alignment: Alignment.center, child: Text('Exercises',style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black))),
              Container(child: _exercisesView(context, exercises)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _exercisesView(context, exercises) {
    print(exercises.length);
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: exercises.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(children: [
            SizedBox(height: 5),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                child: Text('Name',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black))),
            Text(exercises[index]['name']),
            SizedBox(height: 5),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                child: Text('Description',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black))),
            Text(exercises[index]['description']),
            SizedBox(height: 5),
            Text('Difficulty: ${exercises[index]['difficulty']}',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
              child: Image.network(exercises[index]['photo_url']),
            ),
          ]);
        });
  }

}
