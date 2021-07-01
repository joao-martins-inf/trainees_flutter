import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context)!.settings.arguments;
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
                  onPressed: () {quitGym(token.toString(), context);},
                  label: Text('Quit Gym', style: TextStyle(fontSize: 15.0)),
                  icon: Icon(Icons.sentiment_dissatisfied_outlined),
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
                  icon: Icon(Icons.logout),
                ),
              ),
            ]),

          ],
        ),
      ),
    );
  }

  void _quitGym(String token, BuildContext context)async {
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


    Future<bool> setUserGym(String token, int gymId, int userId,BuildContext context) async  {

      try {
        http.Response res = await http.put(
          Uri.http('167.233.9.110', '/api/setUserGym/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ' + token,
          },
          body: jsonEncode(<String, dynamic>{
            'gym_id': null,
          }),
        );
//SUBSITUIR POR ENDPOINT PARA SAIR DO GINÁSIO
       http.Response b = await http.delete(
          Uri.http('195.201.90.161:81', 'api/gym/$gymId/athele/userId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',

          },
        );
      if(res.statusCode == 200){
        _showToast(context, 'Gym quit successfully');
        Navigator.pushReplacementNamed(context, '/home', arguments: token);
      }

        return true;
      } catch(e){
        return false;
      }
    }




    final res = await getUserInfo(token);
    final decodedRes = jsonDecode(res.body);

    int gymId =  decodedRes['gym_id'];
    int userId = decodedRes['id'];

    await setUserGym(token, gymId, userId, context);


  }

  void quitGym(String token, BuildContext context){
    _quitGym(token, context);
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
