import 'package:flutter/material.dart';
import 'package:trainees_flutter/screens/profile.dart';
import 'package:trainees_flutter/screens/gym/gym.dart';
import 'package:trainees_flutter/screens/history.dart';
import 'package:trainees_flutter/screens/health.dart';
import 'package:trainees_flutter/screens/settings/settings.dart';
import 'package:trainees_flutter/screens/map.dart';
import 'dart:convert';


class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  List<String> get _appBarTitle => [
        "Profile",
        "Map",
        "Gym",
      "History",
    "Settings"
      ];

  List<Widget> get _children => [
    Profile(), // home// QRCode
    MapSample(),
    Gym(),
    History(),
    Settings()//Profile
      ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context)!.settings.arguments ;


    return Scaffold(
      appBar: AppBar(
        title:  Text(_appBarTitle[_currentIndex]),
        centerTitle: true,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: [

          BottomNavigationBarItem(
            icon: new Icon(
              Icons.person_rounded,
           //   size: 48,
            ),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.qr_code),
            label: "Gym",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.list_outlined),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
