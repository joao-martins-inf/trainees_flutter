import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  String? username;
  String? name;
  String? email;
  int? height;
  int? weight;
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
        print(a.statusCode);

        return a;
      } catch (e) {
        return false;
      }
    }
    final token = ModalRoute.of(context)!.settings.arguments;

    final res = await getUserInfo(token.toString());
    final decodedRes = jsonDecode(res.body);
print(decodedRes);
    this.username = decodedRes['username'];
    this.name = decodedRes['first_name'];
    this.email = decodedRes['email'];
    this.height = decodedRes['height'];
    this.weight = decodedRes['weight'];
    this.gymId = decodedRes['gymId'];


  }

  @override
  String toString(){
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _user = User();

    return new Scaffold(
        body: new Container(
          color: Colors.white,
          child: FutureBuilder<dynamic>(
              future: _user.getInfo(context),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {

               if (_user.username != null) {
                  print(_user);
                return _form(_user.name, _user.email);
               } else {
                return CircularProgressIndicator();
               }
              }
        ),),);
  }

  Widget _form([String? name, String? email, int? height, int? weight, int? minRate, int? maxRate]){

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
         padding: EdgeInsets.only(
         left: 25.0, right: 25.0, top: 25.0),
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
         padding: EdgeInsets.only(
         left: 25.0, right: 25.0, top: 25.0),
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
         padding: EdgeInsets.only(
         left: 25.0, right: 25.0, top: 2.0),
         child: new Row(
         mainAxisSize: MainAxisSize.max,
         children: <Widget>[
         new Flexible(
         child: new TextField(
         decoration:  InputDecoration(
         hintText: name != null ? name : 'Enter Your Name',
         ),
         enabled: !_status,
         autofocus: !_status,

         ),
         ),
         ],
         )),
         Padding(
         padding: EdgeInsets.only(
         left: 25.0, right: 25.0, top: 25.0),
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
         padding: EdgeInsets.only(
         left: 25.0, right: 25.0, top: 2.0),
         child: new Row(
         mainAxisSize: MainAxisSize.max,
         children: <Widget>[
         new Flexible(
         child: new TextField(
         decoration:  InputDecoration(
         hintText: email != null ? email : 'Enter your email'),
         enabled: !_status,
         ),
         ),
         ],
         )),


         Padding(
         padding: EdgeInsets.only(
         left: 25.0, right: 25.0, top: 25.0),
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
         hintText: height != null ? height.toString() : "Enter height"),
         enabled: !_status,
         ),
         ),
         flex: 2,
         ),

         Flexible(
         child: new TextField(
         decoration:  InputDecoration(
         hintText: weight != null ? weight.toString() : "Enter weight"),
    enabled: !_status,
    ),
    flex: 2,
    ),
    ],
    )),

    Padding(
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
    )),
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