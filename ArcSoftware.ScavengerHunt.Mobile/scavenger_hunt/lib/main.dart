import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:scavenger_hunt/Models/apilog_model.dart';
import 'package:scavenger_hunt/Models/exception_model.dart';
import 'package:http/http.dart' as http;
import 'package:scavenger_hunt/Screens/login_screen.dart';

import 'app_config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scavenger Hunt',
      theme: ThemeData(
        primaryColor: Colors.black,
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          color: Colors.black87,
          iconTheme: IconThemeData(color: Colors.white)
        ),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 30, color: Colors.white),
          headline2: TextStyle(fontSize: 20, color: Colors.white),
          headline3: TextStyle(fontSize: 30, color: Colors.black, fontStyle: FontStyle.italic),
          headline4: TextStyle(color: Colors.white),
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white
      ),
        canvasColor: Colors.transparent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

SizedBox loading() {
  return SizedBox(
    height: 250, 
    child: Center(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.green)
      ),
    )
  );
}

Color appGreenColor() {
  return Color(0xff72f200);
}

Future<void> logException(BuildContext context, AppConfig config, String function, Exception e, bool displayMessage, String customDisplayMessage) async{
  try {
    var ex = (e != null) ? exceptionToString(e) : "Exception was null.";

    var apiLog = ApiLog(appVersion: config.appVersion, userKey: 1, platform: getPlatformLogType());
    http.post(config.apiUrl + "app/Log",
      headers: config.apiHeaders, 
      body: apiLogToJson(apiLog.logException(2, function, ex
    ))).timeout(const Duration(seconds: 10));
  } catch (e) {
    http.post(config.apiUrl + "app/Log",
      headers: config.apiHeaders, 
      body: lflAttemptBody(config, e)
    ).timeout(const Duration(seconds: 3));
  } finally {
    var alert = new AlertDialog(
      content: Text(customDisplayMessage ?? "An issue has occured: Email ${config.supportEmail} if this continues."),
      actions: <Widget>[
        FlatButton(
          child: const Text("Ok"),
          onPressed: () { Navigator.pop(context); },
        )
      ]
    );
    if (displayMessage) showDialog(context: context, builder: (BuildContext context) => alert
    );
  }
}

Future<void> logPermissionDeniedEx(BuildContext context, AppConfig config, Exception e) async{
  try {
    var apiLog = ApiLog(appVersion: config.appVersion, userKey: 1, platform: getPlatformLogType());
    http.post(config.apiUrl + "app/Log", headers: config.apiHeaders, 
      body: apiLogToJson(apiLog.logException(1, "Permission Check", e.toString()
    ))).timeout(const Duration(seconds: 10));
  } catch (e) {
    http.post(config.apiUrl + "app/Log",
      headers: config.apiHeaders, 
      body: lflAttemptBody(config, e)
    ).timeout(const Duration(seconds: 5));
  } finally {
    var alert = WillPopScope(
      onWillPop: () async { return false; },
      child: new AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height:170.0,child: Image.asset('images/Error.png', fit: BoxFit.contain)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(child: Text(e.toString(), 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.red))
                  )
                ],
              )
            ]
          )
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text("Close App", style: TextStyle(color: Colors.red)),
            onPressed: () { exit(0); },
          )
        ]
      )
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => alert
    );
  }
}