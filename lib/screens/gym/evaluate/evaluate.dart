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

Future<bool> sendEvaluation(BuildContext context, String title, double rate) async  {
  final int newRate = rate.toInt();
  final arguments = ModalRoute.of(context)!.settings.arguments;
  final argsSplitted = arguments.toString().split(",");
  final gymId = argsSplitted[0].trim();
  final userId = argsSplitted[1].trim();

  try {
    http.Response a = await http.post(
      Uri.http('195.201.90.161:81', '/api/gym/$gymId/athlete/$userId/evaluation'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'grade': newRate,
        'comment': title,
      }),
    );
    print(a.statusCode);
    if(a.statusCode == 404){
      return false;
    }

    return true;
  } catch(e){
    return false;
  }
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
                  var c = await sendEvaluation(context,_controller.text, this.rate);
                  print(c);
                  if(c){
                    _showToast(context, 'Evaluation sended :D');
                  }else{
                    _showToast(context, 'Error, please try later D:');
                  }
                },
                child: Text("Save evaluation"),
              )
            )
          ],
        )
      ),
    );
  }
  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content:  Text(msg),
      ),
    );
  }
}

