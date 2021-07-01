import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trainees_flutter/screens/gym/activities/activityDetails/activityDetails.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';

class Activity {
  List<dynamic>? activitiesList;
  List<dynamic>? userActivities;
  Future<dynamic> getActivities(String gymId) async {
    try {
      final queryParameters = {
        'gymId': gymId,
      };
      http.Response res = await http.get(
        Uri.http('195.201.90.161:80', 'api/activity', queryParameters),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return res;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> getUserActivities(String userId) async {
    try {
      http.Response res = await http.get(
        Uri.http('195.201.90.161:80', '/api/activity/athlete/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      return res;
    } catch (e) {
      return false;
    }
  }

  _getActivities(String gymId, String userId) async {
    final res = await getActivities(gymId);
    final resActivities = jsonDecode(res.body);
    final res2 = await getUserActivities(userId);
    final resUserActivities = jsonDecode(res2.body);

    //Map userActivitiesList

    //If some user id is one of the elements of activities list remove it
    resUserActivities.forEach((userAct) {
      var person = resActivities
          .singleWhere((element) => element['id'] == userAct['id'], orElse: () {
        return null;
      });

      if (person != null) {
        resActivities.removeWhere((element) => element['id'] == person['id']);
      }
    });
  print(resUserActivities);
    this.userActivities = resUserActivities;
    this.activitiesList = resActivities;
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
              Tab(
                  icon: Icon(Icons.fitness_center_outlined),
                  child: Text('Activities')),
              Tab(
                  icon: Icon(Icons.directions_bike),
                  child: Text('User Activities')),
            ],
          ),
        )),
        body: TabBarView(children: [
          FutureBuilder<dynamic>(
              future: _activities._getActivities(gymId, userId),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (_activities.activitiesList != null) {
                  return _list(context, _activities.activitiesList, userId,
                      _activities.userActivities);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          FutureBuilder<dynamic>(
              future: _activities._getActivities(gymId, userId),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (_activities.activitiesList != null) {
                  return _listUserActivities(
                      context,
                      _activities.userActivities,
                      userId,
                      _activities.activitiesList,
                  gymId);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ]),
      ),
    );
  }

  Widget _list(BuildContext context, List<dynamic>? _activitiesList, userId,
      List<dynamic>? _userActivities) {
    return ListView.builder(
        itemCount: _activitiesList!.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActivityInfo(
                                name: _activitiesList[index]['name'],
                                description: _activitiesList[index]
                                    ['description'],
                                activityDate: _activitiesList[index]
                                    ['activity_date'],
                                latitude: _activitiesList[index]['latitude'],
                                longitude: _activitiesList[index]['longitude'],
                                id: _activitiesList[index]['id'])));
                  },
                  title: Text(_activitiesList[index]['name']),
                  subtitle: Text(_activitiesList[index]['description']),
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(index.isOdd
                          ? "https://images.unsplash.com/photo-1595078475328-1ab05d0a6a0e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=690&q=80"
                          : "https://images.unsplash.com/photo-1594381898411-846e7d193883?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=668&q=80")),
                  trailing: IconButton(
                      onPressed: () async {
                        final resActivities = _activitiesList;
                        final resUserActivities = _userActivities;

                        resUserActivities!.forEach((userAct) {
                          var person = resActivities.singleWhere(
                              (element) => element['id'] == userAct['id'],
                              orElse: () {
                            return null;
                          });

                          if (person != null) {
                            resActivities.removeWhere(
                                (element) => element['id'] == person['id']);
                          }
                        });

                        setState(() {
                          _activities.userActivities = resUserActivities;
                          _activities.activitiesList = resActivities;
                        });

                        await setUserActivity(
                            _activitiesList[index]['id'].toString(), userId);
                      },
                      icon: Icon(Icons.forward_outlined))));
        });
  }

  Widget _listUserActivities(
      BuildContext context,
      List<dynamic>? _userActivitiesList,
      userId,
      List<dynamic>? _activitiesList,
      gymId) {
    bool presence(int value) {
      var exists = false;
      _userActivitiesList![value]['registered_users'].forEach((element) {
        if (element['athlete_id'] == userId && element['present'] == true) {
          exists = true;
        }
      });
      return exists;
    }

    return ListView.builder(
        itemCount: _userActivitiesList!.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ActivityInfo(
                            name: _userActivitiesList[index]['name'],
                            description: _userActivitiesList[index]
                                ['description'],
                            activityDate: _userActivitiesList[index]
                                ['activity_date'],
                            latitude: _userActivitiesList[index]['latitude'],
                            longitude: _userActivitiesList[index]['longitude'],
                            id: _userActivitiesList[index]['id'])));
              },
              title: Text(_userActivitiesList[index]['name']),
              subtitle: Text(_userActivitiesList[index]['description']),
              leading: presence(index) ? null :  Transform.rotate(
                  angle: 180 * pi / 180,
                  child: IconButton(
                      onPressed: () async {
                        final resActivities = _activitiesList;
                        final resUserActivities = _userActivitiesList;

                        resActivities!.forEach((userAct) {
                          var person = resUserActivities.singleWhere(
                              (element) => element['id'] == userAct['id'],
                              orElse: () {
                            return null;
                          });

                          if (person != null) {
                            resUserActivities.removeWhere(
                                (element) => element['id'] == person['id']);
                          }
                        });

                        setState(() {
                          _activities.userActivities = resUserActivities;
                          _activities.activitiesList = resActivities;
                        });

                        //DO THE UNREGISTER OF THE ACTIVITY
                        await deleteUserActivity(
                            _userActivitiesList[index]['id'].toString(),
                            userId);
                      },
                      icon: Icon(Icons.forward_outlined))),
              trailing: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        primary: Colors.white,
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: presence(index)
                          ?
                          null
                          : () async {
                        setUserPresenceByActivity(
                            _userActivitiesList[index],
                            userId,
                            _userActivitiesList[index]['latitude'],
                            _userActivitiesList[index]['longitude'],
                          gymId
                        );
                      },
                      child: const Text('Present'),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<bool> setUserPresenceByActivity(
      activity, String userId, double lat, double long, gymId) async {
    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double distance = sqrt(pow((currentPosition.latitude - lat), 2) +
          pow((currentPosition.longitude - long), 2));

      distance = distance < 0 ? distance * (-1.0) : distance;

      bool distanceMinor50Km = distance < 500000000000000000 ? true : false;

      if (distanceMinor50Km) {
        http.Response b = await http.post(
          Uri.http('195.201.90.161:80',
              'api/activity/${activity['id']}/athlete/$userId/presence'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        await _activities._getActivities(gymId, userId);


      } else {
        _showToast(context, "You are too far :(");

        return false;
      }
      _showToast(context, "You are present! Go hard!");

      return true;
    } catch (e) {
      _showToast(context, "You are too far :(");
      return false;
    }
  }

  Future<bool> setUserActivity(String activityId, String userId) async {
    try {
      http.Response b = await http.post(
        Uri.http(
            '195.201.90.161:80', 'api/activity/$activityId/athlete/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      _showToast(context, "Sign in with success");
      return true;
    } catch (e) {
      _showToast(context, "Error signing in ");

      return false;
    }
  }

  Future<bool> deleteUserActivity(String activityId, String userId) async {
    try {
      http.Response b = await http.delete(
        Uri.http(
            '195.201.90.161:80', 'api/activity/$activityId/athlete/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      _showToast(context, "Sign out with success");

      return true;
    } catch (e) {
      _showToast(context, "Error signing out ");

      return false;
    }
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }
}
