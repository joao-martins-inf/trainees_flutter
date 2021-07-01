import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:health/health.dart';

import 'package:flutter/foundation.dart' show TargetPlatform;

class TrainningSession {
  List<dynamic>? sessions;

  getSessions(context) async {
    Future<dynamic> getUserInfo(String token) async {
      try {
        http.Response a = await http.get(
          Uri.http('167.233.9.110', '/api/userSessions/'),
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

    final token = ModalRoute.of(context)!.settings.arguments;
    final res = await getUserInfo(token.toString());

    final resDecoded = jsonDecode(res.body);

    this.sessions = resDecoded;
  }
}

class History extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

class _HistoryState extends State<History> {
  TrainningSession trainnigSession = TrainningSession();
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  @override
  void initState() {
    super.initState();
  }

  Future fetchData() async {
    /// Get everything from midnight until now
    DateTime startDate = DateTime(2020, 11, 07, 0, 0, 0);
    DateTime endDate = DateTime(2025, 11, 07, 23, 59, 59);

    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.DISTANCE_WALKING_RUNNING,
      HealthDataType.STEPS,

    ];

    setState(() => _state = AppState.FETCHING_DATA);

    /// You MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);

    int steps = 0;

    if (accessWasGranted) {
      try {
        /// Fetch new data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(startDate, endDate, types);

        /// Save all the new data points
        _healthDataList.addAll(healthData);
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      /// Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      /// Print the results
      _healthDataList.forEach((x) {

        steps += x.value.round();
      });



      /// Update the UI to display the results
      setState(() {
        _state =
            _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {

      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return ListView.builder(
        itemCount: _healthDataList.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = _healthDataList[index];
          return Card(
              child: ListTile(
                  onTap: () {},
                  title: Text("${p.typeString}: ${p.value}"),
                  subtitle: Text(
                      '${p.unitString}\n${p.dateFrom} - ${p.dateTo}'),
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(index.isOdd
                          ? "https://images.unsplash.com/photo-1595078475328-1ab05d0a6a0e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=690&q=80"
                          : "https://images.unsplash.com/photo-1594381898411-846e7d193883?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=668&q=80")),
                  trailing: Icon(Icons.bookmark_added,color: Colors.green)));

        });
  }

  Widget _contentNoData() {
    return Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Text('');
  }

  Widget _authorizationNotGranted() {
    return Text('''Authorization not given.
        For Android please check your OAUTH2 client ID is correct in Google Developer Console.
         For iOS check your permissions in Apple Health.''');
  }

  Widget _content() {
    if (_state == AppState.DATA_READY)
      return _contentDataReady();
    else if (_state == AppState.NO_DATA)
      return _contentNoData();
    else if (_state == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();

    return _contentNotFetched();
  }

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    return FutureBuilder<dynamic>(
        future: trainnigSession.getSessions(context),
        builder: (context, snapshot) {
          if (trainnigSession.sessions != null) {
           if( platform == TargetPlatform.iOS ) {
            return SingleChildScrollView(
               physics: ScrollPhysics(),
               child: Column(children: <Widget>[
                 SizedBox(
                   height: 10,
                 ),
                 Text('Click for Sync SmartWatch'),
                 IconButton(
                   onPressed: () {
                     fetchData();
                   },
                   icon: Icon(Icons.watch_outlined),
                   tooltip: 'Click for Sync SmartWatch',
                   splashRadius: 20.0,
                   splashColor: Colors.blue,
                 ),
                 _list(context, trainnigSession.sessions),
                 SizedBox(
                   height: 10,
                 ),
                 _content()
               ]),
             );
           }else {
             return _list(context, trainnigSession.sessions);
           }
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget _list(BuildContext context, List<dynamic>? _sessionsList) {
    _sessionsList!.sort((a, b) => a['startDate'].compareTo(b['startDate']));

    if (_sessionsList.length == 0) {
      return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
            Icon(
              Icons.sentiment_very_dissatisfied,
              color: Colors.black,
              size: 48.0,
            ),
            Text('You need to pratice more!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ]));
    }
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _sessionsList.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                  onTap: () {},
                  title: Text(_sessionsList[index]['startDate'].split('T')[0]),
                  subtitle: Text(
                      'calories:${_sessionsList[index]['calories']} distance:${_sessionsList[index]['distance']}\nduration:${_sessionsList[index]['duration']}'),
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(index.isOdd
                          ? "https://images.unsplash.com/photo-1595078475328-1ab05d0a6a0e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=690&q=80"
                          : "https://images.unsplash.com/photo-1594381898411-846e7d193883?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=668&q=80")),
                  trailing: Icon(Icons.bookmark_added,color: Colors.green)));
        });
  }
}
