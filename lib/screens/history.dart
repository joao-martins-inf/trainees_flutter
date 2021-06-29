import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<TrainningSession> fetchSession() async {
  final response = await http.get(Uri.parse('http://167.233.9.110'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return TrainningSession.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load sessions');
  }
}

class TrainningSession {
  final DateTime duration;
  // final int calories;
  final int minHeartRate;
  final int maxHeartRate;
  final DateTime date;

  TrainningSession({
    required this.duration,
    // required this.calories,
    required this.minHeartRate,
    required this.maxHeartRate,
    required this.date,
  });

  factory TrainningSession.fromJson(Map<String, dynamic> json) {
    return TrainningSession(
      duration: json['duration'],
      //calories: json['calories'],
      minHeartRate: json['minHeartRate'],
      maxHeartRate: json['maxHeartRate'],
      date: json['date'],
    );
  }
}

class History extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late Future<TrainningSession> futureTrainnigSession;

  @override
  void initState() {
    super.initState();
    futureTrainnigSession = fetchSession();
  }

  @override
  Widget build(BuildContext context) {
    //Delete this and add a future builder when you the endpoint is ready
    final List<Object> entries = <Object>[
      {"Duration": "3h", "calories": '2', "date": '3/2/2020'},
      {"Duration": "3h", "Calories": '2', "Date": '3/2/2020'},
    ];
    final List<int> colorCodes = <int>[600, 500, 100];

    return FutureBuilder<TrainningSession>(
        future: futureTrainnigSession,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  color: Colors.amber[colorCodes[index]],
                  child: Center(child: Text(' ${entries[index]}')),
                );
              },
              separatorBuilder: (BuildContext context,
                  int index) => const Divider(),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        }
    );


  }
}

