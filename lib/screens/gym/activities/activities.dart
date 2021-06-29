import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Activity {

  Future<dynamic> getACtivities(String gymId) async {
    try {
      http.Response res = await http.get(
        Uri.http('195.201.90.161:81', 'api/activity/$gymId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',

        },
      );
      print(res.statusCode);
      print(res.body);

      return res;
    } catch (e) {
      return false;
    }
  }
}


class ListViewActivities extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListViewActivitiesState();
}

class _ListViewActivitiesState extends State<ListViewActivities> {
  final titles = ["List 1", "List 2", "List 3"];
  final subtitles = [
    "Here is list 1 subtitle",
    "Here is list 2 subtitle",
    "Here is list 3 subtitle"
  ];



  final icons = [Icons.ac_unit, Icons.access_alarm, Icons.access_time];
  Activity _activities = Activity();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    final argsSplitted = arguments.toString().split(",");
    final gymId = argsSplitted[0].trim();
    final userId = argsSplitted[1].trim();

    return Scaffold(
      appBar: (AppBar(
        backgroundColor: Colors.blue,
        title: Text("Activities"),
        centerTitle: true,
        elevation: 0,
      )),
      body: FutureBuilder<dynamic>(
          future: _activities.getACtivities(gymId),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (userId != null) {

              return _list(context);
            } else {
              return Center(
                  child: CircularProgressIndicator()
              );
            }
          })



    );
  }

  Widget _list(BuildContext context){
   return ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                  onTap: () {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(titles[index] + ' pressed!'),
                    ));
                  },
                  title: Text(titles[index]),
                  subtitle: Text(subtitles[index]),
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
                  trailing: Icon(Icons.access_time)));
        });
  }
}
