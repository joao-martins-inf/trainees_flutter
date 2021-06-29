import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  String? username;
  String? name;
  String? email;
  int? height;
  double? weight;
  int? gymId;
  String? gymName;
  double? gymLat;
  double? gymLong;

  getInfo(context) async {
    Future<dynamic> getUserInfo(String token) async {
      try {
        http.Response a = await http.get(
          Uri.http('167.233.9.110', '/api/users/userProfile'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ' + token,
          },
        );
        //print(a.statusCode);

        return a;
      } catch (e) {
        return false;
      }
    }

    Future<dynamic> getGymName(int gymId) async {
      try {
        http.Response a = await http.get(
          Uri.http('195.201.90.161:81', '/api/gym/$gymId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',

          },
        );


        return a;
      } catch (e) {
        return false;
      }
    }

    final token = ModalRoute.of(context)!.settings.arguments;

    final res = await getUserInfo(token.toString());
    final decodedRes = jsonDecode(res.body);

    this.username = decodedRes['username'];
    this.name = decodedRes['first_name'];
    this.email = decodedRes['email'];
    this.height = decodedRes['height'];
    this.weight = decodedRes['weight'];
    this.gymId = decodedRes['gym_id'];


    final gymRes = await getGymName(decodedRes['gym_id']);

    final decodedResGym = jsonDecode(gymRes.body);

    this.gymName = decodedResGym['name'];
    this.gymLat = decodedResGym['latitude'];
    this.gymLong = decodedResGym['longitude'];
  }

  Future<dynamic> _updateUser(User user, User updatedUser,
      BuildContext context) async {
    try {
      final token = ModalRoute.of(context)!.settings.arguments;
      print(user.height.runtimeType);
      http.Response a = await http.put(
        Uri.http('167.233.9.110', '/api/users/updateProfile/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ' + token.toString(),
        },
        body: jsonEncode(<String, dynamic>{

          'height': user.height != updatedUser.height
              ? updatedUser.height
              : user.height,
          'weight': user.weight != updatedUser.weight
              ? updatedUser.weight
              : user.weight,
        }),
      );
      return a;
    } catch (e) {
      return false;
    }
  }
  updateUser(user, updatedUser, context) async {
    final res = await _updateUser(user, updatedUser, context);
    print(res.statusCode);
  }

  @override
  String toString() {
    return 'name:${name}, username:${username}, email:${email} ';
  }
}

class Profile extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<Profile>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  final _user = User();

  final _userUpdate = User();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   // final _userUpdate = User();

    return new Scaffold(
      body: new Container(
        color: Colors.white,
        child: FutureBuilder<dynamic>(
            future: _user.getInfo(context),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (_user.username != null) {

                return _form(_user.name, _user.email, _user.username, _user.height, _user.weight, _user.gymName, null, null,_user, _userUpdate, context);
              } else {
                return Center(
                    child: CircularProgressIndicator()
                );
              }
            }),
      ),
    );
  }

  Widget _form(
      [String? name,
      String? email,
      String? username,
      int? height,
      double? weight,
        String? gymName,
      int? minRate,
      int? maxRate,
      User? user,
        User? updateUser,
        BuildContext? context,
      ]) {

    return new ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            new Container(
              height: 250.0,
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: new Stack(fit: StackFit.loose, children: <Widget>[
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              width: 140.0,
                              height: 140.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                  image: new ExactAssetImage(
                                      'assets/images/as.png'),
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 90.0, right: 100.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 25.0,
                                child: new Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )),
                    ]),
                  )
                ],
              ),
            ),
            new Container(
              color: Color(0xffFFFFFF),
              child: Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Personal Information',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                _status ? _getEditIcon() : new Container(),
                              ],
                            )
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Username',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                decoration: InputDecoration(
                                  hintText:
                                    username,
                                ),
                                enabled: false,
                                autofocus: !_status,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Gym Name',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                decoration: InputDecoration(
                                  hintText:
                                  gymName != null ? gymName : 'SignUp to a gym',
                                ),
                                enabled: false,
                                autofocus: !_status,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Name',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                decoration: InputDecoration(
                                  hintText:
                                  name != null ? name : 'Enter Your Name',
                                ),
                                enabled: false,
                                autofocus: !_status,
                                  onChanged: (value){
                                    _userUpdate.name = (value.toString());
                                  }
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Email',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                decoration: InputDecoration(
                                    hintText: email != null
                                        ? email
                                        : 'Enter your email'),
                                enabled: !_status,
                                  onChanged: (value){
                                   _userUpdate.email = (value.toString());
                                  }
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: new Text(
                                  'Height',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: new Text(
                                  'Weight',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: new TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintText: height != null
                                          ? '${height.toString()} cm'
                                          : "Enter height cm"),
                                  enabled: !_status,
                                    onChanged: (value){
                                      _userUpdate.height = int.parse(value);
                                    }
                                ),
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: new TextField(
                              keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: weight != null
                                        ? '${weight.toString()} kg'
                                        : "Enter weight kg"),
                                enabled: !_status,
                                  onChanged: (value){
                                    _userUpdate.weight = double.parse(value);
                                  }
                              ),
                              flex: 2,
                            ),
                          ],
                        )),

                    /*Padding(
    padding: EdgeInsets.only(
    left: 25.0, right: 25.0, top: 25.0),
    child: new Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    Expanded(
    child: Container(
    child: new Text(
    'Min Heart Rate',
    style: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold),
    ),
    ),
    flex: 2,
    ),
    Expanded(
    child: Container(
    child: new Text(
    'Max Heart Rate',
    style: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold),
    ),
    ),
    flex: 2,
    ),
    ],
    )),
    Padding(
    padding: EdgeInsets.only(
    left: 25.0, right: 25.0, top: 2.0),
    child: new Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    Flexible(
    child: Padding(
    padding: EdgeInsets.only(right: 10.0),
    child: new TextField(
    decoration:  InputDecoration(
    hintText: minRate != null ? minRate.toString() :  "Enter min heart rate"),
    enabled: !_status,
    ),
    ),
    flex: 2,
    ),

    Flexible(
    child: new TextField(
    decoration:  InputDecoration(
    hintText: maxRate != null ? maxRate.toString() : "Enter max heart rate"),
    enabled: !_status,
    ),
    flex: 2,
    ),
    ],
    )),*/
                    !_status ? _getActionButtons() : new Container(),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: new Text("Save"),
                onPressed: () async {
                  _userUpdate.updateUser(_user, _userUpdate, context);
                  setState(() {
                    _status = true;
                   // FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: new Text("Cancel"),
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
