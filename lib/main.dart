import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainees_flutter/blocs/auth/auth_repository.dart';
import 'package:trainees_flutter/screens/home.dart';
import 'package:trainees_flutter/screens/login.dart';
import 'package:trainees_flutter/screens/register.dart';
import 'package:trainees_flutter/screens/profile.dart';
import 'package:trainees_flutter/screens/gym/qrScanner/qrScanner.dart';
import 'package:trainees_flutter/screens/gym/evaluate/evaluate.dart';
import 'package:trainees_flutter/screens/gym/chronometer/chronometer.dart';


void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      /*home: RepositoryProvider(
        create: (context) => AuthRepository(),
        child:Login(),

      ),*/
      initialRoute: '/login',
      routes: {
        '/home':(context) => Home(),
        '/scan': (context) => QRViewExample(),

        '/evaluate': (context) => Evaluate(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/chronometer': (context) => Chronometer(),
        '/profile': (context) => Profile(),
      },
    );
  }
}

