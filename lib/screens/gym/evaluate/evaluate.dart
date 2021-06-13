import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class Evaluation {

  final String? title;
  final int rate;

  Evaluation({required this.rate, this.title});

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      rate: json['rate'],
      title: json['title'],
    );
  }
}

Future<http.Response> createAlbum(String title, double rate) {
  final int newRate = rate.toInt();
  return http.post(
    Uri.parse('http://116.203.32.183:81/api/gym/2/athlete/1/evaluation'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'rate': newRate,
      'comment': title,
    }),
  );
}



class Evaluate extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _EvaluateState();

}

class _EvaluateState extends State<Evaluate> {
  final TextEditingController _controller = TextEditingController();
  double rate = 0;
  Future<Evaluation>? _futureAlbum;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:(AppBar(
        backgroundColor: Colors.blue,
        title: Text("Gym Evaluation"),
        centerTitle: true,
        elevation:0,
      )),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding:EdgeInsets.symmetric(horizontal:16.0),
                child:

            TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Write an opinion about the gym",
                ),
              controller: _controller,
            ),
            ),
          Padding(
            padding:EdgeInsets.symmetric(vertical:16.0),
            child:

            RatingBar.builder(
              initialRating: 3,
              itemCount: 5,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                  case 1:
                    return Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.redAccent,
                    );
                  case 2:
                    return Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                  case 3:
                    return Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );
                  default:
                    return Text("hello");
                }
              },
              onRatingUpdate: (rating) {
                this.rate = rating;
              },
          ),
          ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child:
              OutlinedButton(
                onPressed:  () async {
                  var c = await createAlbum(_controller.text, this.rate);
                  print(c);
                  print(c);
                  print(c);
                },
                child: Text("Save evaluation"),
              )
            )
          ],
        )
      ),
    );
  }

}

