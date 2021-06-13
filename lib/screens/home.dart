import 'package:flutter/material.dart';
import 'package:trainees_flutter/screens/profile.dart';
import 'package:trainees_flutter/screens/gym/gym.dart';
import 'package:trainees_flutter/screens/history.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  List<String> get _appBarTitle => [
        "Home",
        "Subscribe to gym",
        "Profile",
      "History"
      ];

  List<Widget> get _children => [
        Profile(), // home
    Gym(), // QRCode
    Profile(),
    History(),//Profile
      ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(_appBarTitle[_currentIndex])),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.qr_code),
            label: "Subscribe",
          ),
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.person_rounded,
              size: 48,
            ),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
