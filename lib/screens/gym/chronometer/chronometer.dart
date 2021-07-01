import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pedometer/pedometer.dart';
import 'dart:math';
import 'package:percent_indicator/percent_indicator.dart';

class Session {
  int time = 0;

  Future<bool> createSession(String token, int time, double calories, double distance, int steps) async {
    try {
      http.Response a = await http.post(
        Uri.http('167.233.9.110', '/api/sessionsInsert/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ' + token,
        },
        body: jsonEncode(<String, dynamic>{
          'duration': time,
          'calories': calories,
          'distance': distance,
          'steps': steps
          // 'startDate': new DateTime.now(),
        }),
      );

      if (a.statusCode == 404) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}

class Chronometer extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => Chronometer(),
      ),
    );
  }

  @override
  _State createState() => _State();
}

class _State extends State<Chronometer> {
  final _isHours = true;
  bool isStopped = false;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onChange: (value) => print('onChange $value'),
    onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );

  final _scrollController = ScrollController();

  //Pedometer here
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _todaySteps = '0', _km = '0', _calories = '0';
  int _steps = 0;

  double _numerox = 0.0; //numero pasos
  double _convert = 0.0;
  double _kmx = 0.0;
  double burnedx = 0.0;
  double percent = 0.1;

  bool activityStatus = false;
  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));

    /// Pedometer init.
    initPlatformState();
  }

  void onStepCount(StepCount event) {

    if(activityStatus == false){
      _steps = event.steps;
    }

   int _finalSteps = event.steps - _steps;

    setState(() {
      if(activityStatus == true) {
        _todaySteps = _finalSteps.toString();
      }
    });

    var dist =
        int.parse(_todaySteps);
    double y = (dist + .0);

    setState(() {
      _numerox =
          y;
    });

    var long3 = (_numerox);
    long3 = double.parse(y.toStringAsFixed(2));
    var long4 = (long3 / 10000);

    int decimals = 1;
    num fac = pow(10, decimals);
    double d = long4;
    d = (d * fac).round() / fac;
    print("d: $d");

    getDistanceRun(_numerox);

    setState(() {
      _convert = d;
      print(_convert);
    });
  }

  void _startActivity(){
    activityStatus = true;
  }

  void _stopActivity(){
    activityStatus = false;
  }

  void _resetActivity(){
    _steps = _steps + int.parse(_todaySteps);
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  void onStepCountError(error) {
    setState(() {
      _todaySteps = 'Step Count\n not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;

      _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  //function to determine the distance run in kilometers using number of steps
  void getDistanceRun(double _numerox) {
    num distance = ((_numerox * 78) / 100000);
    distance = num.parse(distance.toStringAsFixed(2)); //dos decimales
    var distancekmx = distance * 34;
    distancekmx = num.parse(distancekmx.toStringAsFixed(2));
    //print(distance.runtimeType);
    setState(() {
      _km = "$distance";
      //print(_km);
    });
    setState(() {
      _kmx = double.parse(distancekmx.toStringAsFixed(2));
    });
  }

  //function to determine the calories burned in kilometers using number of steps
  void getBurnedRun() {
    setState(() {
      var calories = _kmx; //dos decimales
      _calories = calories.toString();
      //print(_calories);
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context)!.settings.arguments;
    final _session = Session();
    getBurnedRun();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /// Display stop watch time
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: StreamBuilder<int>(
                stream: _stopWatchTimer.rawTime,
                initialData: _stopWatchTimer.rawTime.value,
                builder: (context, snap) {
                  final value = snap.data!;
                  final displayTime =
                      StopWatchTimer.getDisplayTime(value, hours: _isHours);
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          displayTime,
                          style: const TextStyle(
                              fontSize: 40,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          value.toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            /// Display every minute.
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: StreamBuilder<int>(
                stream: _stopWatchTimer.minuteTime,
                initialData: _stopWatchTimer.minuteTime.value,
                builder: (context, snap) {
                  final value = snap.data;
                  print('Listen every minute. $value');
                  return Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  'minute',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Helvetica',
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  value.toString(),
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )),
                    ],
                  );
                },
              ),
            ),

            /// Display every second.
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: StreamBuilder<int>(
                stream: _stopWatchTimer.secondTime,
                initialData: _stopWatchTimer.secondTime.value,
                builder: (context, snap) {
                  final value = snap.data;
                  print('Listen every second. $value');
                  return Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  'second',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Helvetica',
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  value.toString(),
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              width: 250, //ancho
              height: 250, //largo tambien por numero height: 300
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment
                        .bottomCenter, //cambia la iluminacion del degradado
                    end: Alignment.topCenter,
                    colors: [Colors.lightBlue, Colors.blue],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(27.0),
                    bottomRight: Radius.circular(27.0),
                    topLeft: Radius.circular(27.0),
                    topRight: Radius.circular(27.0),
                  )),
              child: new CircularPercentIndicator(
                radius: 200.0,
                lineWidth: 13.0,
                animation: true,
                center: Container(
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.only(left: 20.0),
                        child: Icon(
                          Icons.directions_walk,
                          size: 30.0,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        //color: Colors.orange,
                        child: Text(
                          '$_todaySteps',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.yellow),
                        ),
                        // height: 50.0,
                        // width: 50.0,
                      ),
                    ],
                  ),
                ),
                //percent: 0.217,
                percent: _convert,
                footer: new Text(
                  "Steps:  $_todaySteps",
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      color: Colors.black),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.yellow,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Calories:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    _calories,
                    style: TextStyle(fontSize: 16),
                  ),
                  Icon(
                    Icons.local_fire_department_outlined,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Distance:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    _km,
                    style: TextStyle(fontSize: 16),
                  ),
                  Icon(
                    Icons.directions_run_outlined,
                    color: Colors.black,
                  ),
                ]),
                Divider(
                  height: 10,
                  thickness: 0,
                  color: Colors.white,
                ),
                Text(
                  'Pedestrian status:',
                  style: TextStyle(fontSize: 16),
                ),
                Icon(
                  _status == 'walking'
                      ? Icons.directions_walk
                      : _status == 'stopped'
                          ? Icons.accessibility_new
                          : Icons.error,
                  size: 20,
                ),
                Center(
                  child: Text(
                    _status,
                    style: _status == 'walking' || _status == 'stopped'
                        ? TextStyle(fontSize: 30)
                        : TextStyle(fontSize: 20, color: Colors.red),
                  ),
                )
              ],
            ),

            /// Lap time.
            Container(
              height: 10,
              margin: const EdgeInsets.all(8),
              child: StreamBuilder<List<StopWatchRecord>>(
                stream: _stopWatchTimer.records,
                initialData: _stopWatchTimer.records.value,
                builder: (context, snap) {
                  final value = snap.data!;
                  if (value.isEmpty) {
                    return Container();
                  }
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut);
                  });
                  print('Listen records. $value');
                  return ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      final data = value[index];
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              '${index + 1} ${data.displayTime}',
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(
                            height: 1,
                          )
                        ],
                      );
                    },
                    itemCount: value.length,
                  );
                },
              ),
            ),

            /// Button
            Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: RaisedButton(
                            padding: const EdgeInsets.all(4),
                            color: Colors.lightBlue,
                            shape: const StadiumBorder(),
                            onPressed: () async {
                              isStopped = true;
                              _stopWatchTimer.onExecute
                                  .add(StopWatchExecute.start);
                              _startActivity();
                            },
                            child: const Text(
                              'Start',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: RaisedButton(
                            padding: const EdgeInsets.all(4),
                            color: Colors.green,
                            shape: const StadiumBorder(),
                            onPressed: () async {
                              isStopped = true;
                              _stopWatchTimer.onExecute
                                  .add(StopWatchExecute.stop);
                            },
                            child: const Text(
                              'Stop',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: RaisedButton(
                            padding: const EdgeInsets.all(4),
                            color: Colors.red,
                            shape: const StadiumBorder(),
                            onPressed: () async {
                              _stopWatchTimer.onExecute
                                  .add(StopWatchExecute.reset);
                              _stopActivity();
                            },
                            child: const Text(
                              'Reset',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {


                      final res = await _session.createSession(
                          token.toString(), _stopWatchTimer.secondTime.value, double.parse(_calories), double.parse(_km), int.parse(_todaySteps));
                      if (res) {
                        _showToast(context, 'Session saved!');
                      } else {
                        _showToast(context, 'Error saving session');
                      }
                    },
                    child: const Text(
                      'Save Session',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
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
