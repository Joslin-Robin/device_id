import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _deviceid = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    postRequest();
    getdata();
  }

  Future<void> initPlatformState() async {
    String deviceId = await _getId();

    if (!mounted) return;

    setState(() {
      _deviceid = deviceId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(title: Text("Memo App"),backgroundColor: Colors.teal),
        body: new Center(
          child: new Text('Device Id:$_deviceid \n'),
        ),
      ),
    );
  }
  Future<http.Response> postRequest () async {
    var url ='https://cdn.smarter.com.ph:444/API/Account/ValidateUser';
    Map data = {
      'imei': '355922103711954'
    };
    //encode Map to JSON
    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: body
    );
    debugPrint("${response.statusCode}");
  }
    Future getdata() async {
        http.Response response= await http.post('https://cdn.smarter.com.ph:444/API/Account/ValidateUser?imei=355922103711954');
        debugPrint(response.body);
     }


  Future<String> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}