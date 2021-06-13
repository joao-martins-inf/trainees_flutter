import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 150, height: 100),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shadowColor: Colors.blueAccent,
                    elevation: 5,
                  ),
                  onPressed: () {},
                  label: Text('Change\nsecurity\ncode', style: TextStyle(fontSize: 15.0)),
                  icon: Icon(Icons.add),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 150, height: 100),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shadowColor: Colors.blueAccent,
                    elevation: 5,
                  ),
                  onPressed: () {Navigator.pushNamed(context, '/login');},
                  label: Text('Logout', style: TextStyle(fontSize: 15.0)),
                  icon: Icon(Icons.eject),
                ),
              ),
            ]),

          ],
        ),
      ),
    );
  }
}
