import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class User {

  int? gymId;
  int? userId;
  String? name;
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
    this.userId = decodedRes['id'];
    this.name = decodedRes['first_name'];

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

              if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }

              if (_user.gymId != null) {

                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      _classesButton(_user, token),
                      _sessionsButton(token.toString()),
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
                    ],
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

  Widget _classesButton(_user, token){
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 150, height: 100),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          shadowColor: Colors.blueAccent,
          elevation: 5,
        ),
        onPressed: () { Navigator.pushNamed(context, '/activities', arguments:  '${_user.gymId
            .toString()},${_user.userId}');},
        label: Text('Group\nActivities', style: TextStyle(fontSize: 15.0)),
        icon: Icon(Icons.groups),

      ),
    );
  }

  Widget _sessionsButton(String token){
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
          Navigator.pushNamed(context, '/chronometer', arguments: token);
        },
        label: Text('Session', style: TextStyle(fontSize: 15.0)),
        icon: Icon(Icons.fitness_center),
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
          Navigator.pushNamed(context, '/scan', arguments: '${_user.gymId
              .toString()},${token.toString()},${_user.userId},${_user.name}');
        },
        label:  _user.gymId != null ? Text('Scan QR', style: TextStyle(fontSize: 15.0))
            : Text('Sign Up\nGym', style: TextStyle(fontSize: 15.0)),
        icon: Icon(Icons.qr_code_scanner_outlined),
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
          Navigator.pushNamed(context, '/evaluate', arguments: '${_user.gymId},${_user.userId}' );
        },
        label: Text('Evaluate', style: TextStyle(fontSize: 15.0)),
        icon: Icon(Icons.star_rate),
      ),
    );
  }
}
