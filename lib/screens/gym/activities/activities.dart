import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trainees_flutter/screens/gym/activities/activityDetails/activityDetails.dart';

class Activity {
  List<dynamic>? activitiesList;

  Future<dynamic> getActivities(String gymId) async {
    try {
      final queryParameters = {
        'gymId': gymId,
      };
      http.Response res = await http.get(
        Uri.http('195.201.90.161:81', 'api/activity', queryParameters),
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

  _getActivities(String gymId) async {
    final res = await getActivities(gymId);
    final resDecoded = jsonDecode(res.body);

    this.activitiesList = resDecoded;
  }
}

class ListViewActivities extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListViewActivitiesState();
}

class _ListViewActivitiesState extends State<ListViewActivities> {

  Activity _activities = Activity();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    final argsSplitted = arguments.toString().split(",");
    final gymId = argsSplitted[0].trim();
    final userId = argsSplitted[1].trim();
print(userId);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: (AppBar(
          backgroundColor: Colors.blue,
          title: Text("Activities"),
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
            ],
          ),
        )),
        body: TabBarView(children: [
          FutureBuilder<dynamic>(
              future: _activities._getActivities(gymId),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (_activities.activitiesList != null) {
                  return _list(context, _activities.activitiesList, userId);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          Tab(icon: Icon(Icons.directions_transit)),
        ]),
      ),
    );
  }

  Widget _list(BuildContext context, List<dynamic>? _activitiesList, userId) {
print(userId);
    return ListView.builder(
        itemCount: _activitiesList!.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => ActivityInfo(name: _activitiesList[index]['name'],
                        description: _activitiesList[index]['description'],
                        activityDate: _activitiesList[index]['activity_date'],
                        latitude:_activitiesList[index]['latitude'],
                        longitude:_activitiesList[index]['longitude'])));
                  },
                  title: Text(_activitiesList[index]['name']),
                  subtitle: Text(_activitiesList[index]['description']),
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(index.isOdd
                          ? "https://images.unsplash.com/photo-1595078475328-1ab05d0a6a0e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=690&q=80"
                          : "https://images.unsplash.com/photo-1594381898411-846e7d193883?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=668&q=80")),
                  trailing: IconButton(
                      onPressed: () async{
                       await setUserActivity(_activitiesList[index]['id'].toString(), userId);
                      },
                      icon: Icon(Icons.forward_outlined))));
        });
  }

  Future<bool> setUserActivity(String activityId, String userId) async  {

    try {

      http.Response b = await http.post(
        Uri.http('195.201.90.161:81', 'api/activity/$activityId/athlete/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },

      );

      print(b.statusCode);
      return true;
    } catch(e){
      return false;
    }
  }
}
