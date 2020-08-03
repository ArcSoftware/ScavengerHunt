
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:scavenger_hunt/Models/exception_model.dart';
import 'package:scavenger_hunt/app_config.dart';

import '../main.dart';

class HuntScreen extends StatefulWidget{
  final AppConfig config;

  HuntScreen({Key key, this.config}) : super(key : key);

  @override
  _HState createState() => new _HState();
}

class _HState extends State<HuntScreen> {
  _HState();
  String _testInfo1 = "";
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scavenger Hunt"),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.question, color: Colors.red, size: 20), 
          onPressed: () { _scanQR();} 
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.barcode, color: Color(0xff72f200), size: 30), 
            onPressed: () { _scanQR();} 
          )
        ]
      ),
      body: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(child: Text(_testInfo1, style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.center,)),
            ]
          )
        ],
      )
    );
  }

  Future _scanQR() async {
    try {
      ScanResult scanResult = await BarcodeScanner.scan();
      if (scanResult.rawContent != "") 
        setState(() {
          _testInfo1 = scanResult.rawContent;
        });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        logPermissionDeniedEx(context, super.widget.config, new Exception("Camera permission was denied."));
      } else {
        logException(context, widget.config, "Store Home - ScanBarcode (PlatformEx)", e, true, null);
      }
    } on FormatException {
      return;
    } catch (e) {
      logException(context, widget.config, "Store Home - ScanBarcode", e, true, null);
    }
  }
}