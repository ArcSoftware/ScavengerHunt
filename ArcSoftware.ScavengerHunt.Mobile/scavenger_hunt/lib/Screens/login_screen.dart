import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scavenger_hunt/Mock/mock_api.dart';
import 'package:scavenger_hunt/Models/animated_text_model.dart';
import 'package:scavenger_hunt/Screens/animated_text_screen.dart';
import 'package:scavenger_hunt/app_config.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LSS createState() => _LSS();
}

class _LSS extends State<LoginScreen> {
  AppConfig _config;
  DeviceInfoPlugin _deviceInfo;
  String _message;
  Widget _buttonOrLoad;

  @override
  void initState() {
    super.initState();
    _config = new AppConfig();
    _deviceInfo = DeviceInfoPlugin();
    _message = "Please sign in..";
    _buttonOrLoad = buttonOrLoading(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(" "),
      // ),
      body: Stack(
        children: <Widget> [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(70.0)),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      // App logo to go here
                      // SizedBox(
                      //   height:200.0,
                      //   child:
                      //   CachedNetworkImage(
                      //     imageUrl: "${config.apiUrl}file/public/logo.png",
                      //     placeholder: (context, url) => new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.green)),
                      //     errorWidget: (context, url, error) => new Icon(Icons.error, color: Colors.red),
                      //   )
                      // ),
                      Padding(padding: EdgeInsets.all(20),),
                      Text("Welcome!", style: Theme.of(context).textTheme.headline1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                         Flexible(child: Text(_message, style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.center,)),
                        ]
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment(0.0, 0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buttonOrLoad
              ],
            ),
          ),
          Align(
            alignment: Alignment(0.0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(_config.appVersion, style: TextStyle(color: Colors.white),)
              ],
            ),
          )
        ]
      ),
    );
  }

  Widget buttonOrLoading(bool button){
    if (button) {
      return RaisedButton(
        elevation: 10.0,
        onPressed: login,
        textColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 100.0),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        color: Color(0xff72f200),
        child: Row(
          children: <Widget>[
            Text("Sign in", style: TextStyle(fontSize: 20))
          ],
        ),
      );
    }
    else {
      return CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.green));
    }
  }

  void login() async {
    try {
      setState(() {
        _message = "Attempting to sign you in, please wait.";
        _buttonOrLoad = buttonOrLoading(false);
      });
        
      //Get Device Info
      if (Platform.isIOS) {
        var info = await _deviceInfo.iosInfo;
        setState(() {
          _config.deviceInfo = "Model:${info.utsname.machine}|Name:${info.name}|OSVersion:${info.systemVersion}";
        });
      } else {
        var info = await _deviceInfo.androidInfo;
        setState(() {
          _config.deviceInfo = "Model:${info.model}|Name:${info.id}|OSVersion:${info.product}"; 
        });
      }

      _config.updateHeaders();
       await Future.delayed(const Duration(seconds: 1));
       
      setState(() {
        _message = "Communicating with server.";
      });
      // await http.post(_config.apiUrl + "app/Log",
      //   headers: _config.apiHeaders, 
      //   body: apiLogToJson(new ApiLog(
      //     LogType.security.index, 
      //     LogSeverity.info.index,
      //     LogPlatform.iOS,
      //     _config.deviceInfo,
      //     _config.appVersion,
      //     1, "User is attempting to login." ))).timeout(const Duration(seconds: 10));

      //If login Ok()

      //Check permissions
      try {
        if(await Permission.camera.request().isDenied) 
          throw new Exception("Camera permission was denied. Access to camera is required to identify and scan barcodes.");
        Location location = new Location();
        if(!(await location.requestService())) 
          throw new Exception("Device location services are not enabled. Device location is required to identify if a user is within the destination boundary.");
        if(!(await location.requestPermission()))
          throw new Exception("Location app permission was denied. Location is required to identify if a user is within the destination boundary.");
      } catch (e) {
        logPermissionDeniedEx(context, _config, e);
        return;
      }

      //Get questions
      setState(() {
        _message = "Getting Hunt Info.";
      });

      // final r = RetryOptions(maxAttempts: 2);
      // var loginTextCall = await r.retry(
      //   () => http.get(_config.apiUrl + "animation/LoginText",
      //   headers: _config.apiHeaders).timeout(const Duration(seconds: 10)),
      //   retryIf: (e) => e is SocketException || e is TimeoutException);
      // validateContainsData(loginTextCall);

      var mockApi = new MockApi();
      await Future.delayed(const Duration(seconds: 1));
      var animatedText = animatedTextFromJson(mockApi.firstLoginTextRet);

      Navigator.push(context, MaterialPageRoute(
        builder: (context) => new AnimatedTextScreen(config: _config, animatedText: animatedText)
      )).whenComplete(() => {
        setState(() {
          _message = "Thanks for using Scavenger Hunt.";
          _buttonOrLoad = buttonOrLoading(true);
        })});


    } catch (e) {
      setState(() {
        _message = "Please try again..";
        _buttonOrLoad = buttonOrLoading(true);
      });
      logException(context, _config, "AccountScreen - login", e, true, null);
    }
  }
}