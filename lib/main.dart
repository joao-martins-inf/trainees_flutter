import 'package:flutter/material.dart';
import 'package:trainees_flutter/screens/home.dart';
import 'package:trainees_flutter/screens/login.dart';
import 'package:trainees_flutter/screens/register.dart';
import 'package:trainees_flutter/screens/gym/qrScanner/qrScanner.dart';
import 'package:trainees_flutter/screens/gym/evaluate/evaluate.dart';


void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home':(context) => Home(),
        '/scan': (context) => QRViewExample(),
        '/evaluate': (context) => Evaluate(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
      },
    );
  }
}

