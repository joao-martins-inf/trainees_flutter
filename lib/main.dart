import 'package:flutter/material.dart';
import 'package:trainees_flutter/screens/home.dart';
import 'package:trainees_flutter/screens/login.dart';


void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

