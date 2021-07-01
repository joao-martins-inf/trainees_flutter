import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:trainees_flutter/screens/gym/machineInfo/machineInfo.dart';


class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  String? result;
  String? tokenState;
  String? gymIdState;
  String? userIdState;
  String? userNameState;
  QRViewController? controller;
  BuildContext? shareContext;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    //arguments
   final argsSplitted = arguments.toString().split(",");
    tokenState = argsSplitted[1].trim();
    gymIdState = argsSplitted[0].trim();
    userIdState = argsSplitted[2].trim();
    userNameState = argsSplitted[3].trim();

    shareContext = context;
    return Scaffold(
      appBar:(AppBar(
        backgroundColor: Colors.blue,
        title: Text("Scan QRCode"),
        centerTitle: true,
        elevation:0,
      )),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context,argsSplitted[0].trim(), argsSplitted[1].trim() )),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context, String gymId, String token) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: gymId != 'null' ?  _onQRViewCreated : _onQRViewSignUp,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  Future<dynamic> getMachineInfo(String userId, String machineId) async  {

    try {
      http.Response a = await http.get(
        Uri.http('195.201.90.161:81', '/api/athlete/$userId/machine/$machineId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },

      );
      return a;
    } catch(e){
      return false;
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData)async {
      setState(() {
        result = scanData.code;
      });

      if(result != null){
        controller.stopCamera();
        var res = await getMachineInfo(userIdState!, result.toString());

        final resDecoded = jsonDecode(utf8.decode(res.bodyBytes));

        String machineName = resDecoded['machine']['name'].toString();
        String machineDescription = resDecoded['machine']['description'].toString();
        final exercises = resDecoded['exercises'];

        Navigator.push(shareContext!, MaterialPageRoute(builder: (context) => MachineInfo(name: machineName, description: machineDescription, exercises: exercises)));
        return;
      }
    });
  }
  Future<bool> setUserGym(String token, int gymId, int userId, String name) async  {

    try {
      http.Response a = await http.put(
        Uri.http('167.233.9.110', '/api/setUserGym/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ' + token,
        },
        body: jsonEncode(<String, dynamic>{
          'gym_id': gymId,

        }),
      );

      http.Response b = await http.post(
    Uri.http('195.201.90.161:81', 'api/gym/$gymId/athlete/'),
    headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',

    },
    body: jsonEncode(<String, dynamic>{
    'id': userId,
    'name': name
    }),
    );

      return true;
    } catch(e){
      return false;
    }
  }

  void _onQRViewSignUp(QRViewController controller)  {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData.code;
      });
      if(result != null){
        controller.stopCamera();
        await setUserGym(tokenState!, int.parse(result!), int.parse(userIdState!), userNameState!);
        Navigator.pushReplacementNamed(shareContext!, '/home', arguments: tokenState);

        return;
      }


    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}