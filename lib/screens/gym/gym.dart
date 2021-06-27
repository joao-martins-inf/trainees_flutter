import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class User {

  int? gymId;

  getInfo(context)async {
    Future<dynamic> getUserInfo(String token) async {
      try {
        http.Response a = await http.get(
          Uri.http('167.233.9.110', '/api/users/userProfile'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ' + token,
          },
        );


        return a;
      } catch (e) {
        return false;
      }
    }
    final token = ModalRoute
        .of(context)!
        .settings
        .arguments;

    final res = await getUserInfo(token.toString());
    final decodedRes = jsonDecode(res.body);

    this.gymId = decodedRes['gym_id'];
  }


  @override
  String toString(){
    return 'gym:${gymId} ';
  }

}

class Gym extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _GymState();
}

class _GymState extends State<Gym> {
  final _user = User();

  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      body: Center(
        child:
        FutureBuilder<dynamic>(
            future: _user.getInfo(context),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {

              if (_user.gymId != null) {

                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      _classesButton(),
                      _sessionsButton(),
                    ]),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _scanButton(_user, token),
                          _evaluate() ,
                        ]),
                    ]  ,
              );
              } else {
             return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [_scanButton(_user, token)] ,
              );
              }
            }
        ),
      ),
    );
  }

  Widget _classesButton(){
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 150, height: 100),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          shadowColor: Colors.blueAccent,
          elevation: 5,
        ),
        onPressed: () {},
        label: Text('Classes', style: TextStyle(fontSize: 15.0)),
        icon: Icon(Icons.add),
      ),
    );
  }

  Widget _sessionsButton(){
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 150, height: 100),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          shadowColor: Colors.blueAccent,
          elevation: 5,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/chronometer');
        },
        label: Text('Session', style: TextStyle(fontSize: 15.0)),
        icon: Icon(Icons.eject),
      ),
    );
  }

  Widget _scanButton(_user, token){
    return  ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          width: 150, height: 100),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          shadowColor: Colors.blueAccent,
          elevation: 5,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/scan', arguments: ' ${_user.gymId
              .toString()},${token.toString()}');
        },
        label:  _user.gymId != null ? Text('Scan QR', style: TextStyle(fontSize: 15.0))
            : Text('Sign Up\nGym', style: TextStyle(fontSize: 15.0)),
        icon: Icon(Icons.vertical_align_bottom),
      ),
    );
  }



  Widget _evaluate(){
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          width: 150, height: 100),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          shadowColor: Colors.blueAccent,
          elevation: 5,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/evaluate');
        },
        label: Text('Evaluate', style: TextStyle(fontSize: 15.0)),
        icon: Icon(Icons.vertical_align_top),
      ),
    );
  }
}
