import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  String? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    //arguments
   final argsSplitted = arguments.toString().split(",");

    return Scaffold(
      appBar:(AppBar(
        backgroundColor: Colors.blue,
        title: Text("Scan QRCode"),
        centerTitle: true,
        elevation:0,
      )),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context,argsSplitted[0], argsSplitted[1] )),
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

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code;
      });
      print(scanData.code);

    });
  }

  Future<bool> setUserGym(String token, int gymId) async  {

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
      return true;
    } catch(e){
      return false;
    }
  }

  void _onQRViewSignUp(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code;
      });
      print(scanData.code);

    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}