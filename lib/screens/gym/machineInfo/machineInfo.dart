import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class Machine {

  final String? title;
  final int rate;

  Machine({required this.rate, this.title});

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      rate: json['rate'],
      title: json['title'],
    );
  }
}


class MachineInfo extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _MachineInfoState();

}

class _MachineInfoState extends State<MachineInfo> {
  final TextEditingController _controller = TextEditingController();
  double rate = 0;



  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;


    final argsSplitted = arguments.toString().split(",");
    final machineName = argsSplitted[0].trim();
    final machineDescription = argsSplitted[1].trim();
    final exercises = argsSplitted[2].trim();

 // print(exercises);
    return Scaffold(
      appBar:(AppBar(
        backgroundColor: Colors.blue,
        title: Text('$machineName'),
        centerTitle: true,
        elevation:0,
      )),
      body:Center(
        child: Padding(
            padding:EdgeInsets.symmetric(vertical:16.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding:EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
                    child: Text('Description', style: TextStyle(fontSize: 16.0 ,fontWeight:FontWeight.bold,color: Colors.black))


                ),
                Padding(
                    padding:EdgeInsets.symmetric(horizontal:16.0),
                    child: Text('${machineDescription}')


                ),
              ],
            ),
        ),

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

