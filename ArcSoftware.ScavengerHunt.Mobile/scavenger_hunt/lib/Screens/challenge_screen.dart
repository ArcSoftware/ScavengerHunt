import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:scavenger_hunt/Models/challenge_model.dart';
import 'package:scavenger_hunt/Screens/animated_text_screen.dart';
import 'package:scavenger_hunt/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class ChallengeScreen extends StatefulWidget{
  final AppConfig config;
  final List<Challenge> challengeList;
  final int challengeIndex;

  ChallengeScreen({Key key, @required this.config, @required this.challengeList, @required this.challengeIndex}) : super(key : key);

  @override
  _CState createState() => new _CState();
}

class _CState extends State<ChallengeScreen> {
  _CState();
  Timer _gpsTimer;
  final _gpsQueryInterval = const Duration(seconds: 5);
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = new TextEditingController();


  Challenge _challenge;
  List<ChallengeCard> _shownCards = new List();
  bool _first, _inRange;
  
  @override
  void initState() {
    _challenge = widget.challengeList[widget.challengeIndex];
    _first = true;
    _inRange = false;
    _gpsTimer = new Timer.periodic(_gpsQueryInterval, (timer) {_checkLocation();});
    _loadPageAnimated();
    super.initState();
  }

  @override
  void dispose() {
    _gpsTimer.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (_inRange) ?
                Icon(Icons.gps_fixed, size: 25, color: appGreenColor()):
                Icon(Icons.gps_not_fixed, size: 25, color: Colors.red),
              Padding(padding: EdgeInsets.only(left: 5)),
              Text((_inRange) ? "In GPS Range!" :"Challenge ${(widget.challengeIndex + 1)}")
            ],
          ),
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.question, color: Colors.red, size: 20), 
            onPressed: () { 
              _helpButton();
            } 
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.barcode, color: Color(0xff72f200), size: 30), 
              onPressed: () { _searchBarcode(); } 
            )
          ]
        ),
        body: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedCrossFade(
                  duration: const Duration(seconds: 2),
                  firstChild: Stack(
                    children: <Widget>[
                      SizedBox(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(appGreenColor()),
                          strokeWidth: 12.0,
                        )
                      ),
                      SizedBox(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        child: Icon(FontAwesomeIcons.search, color: Colors.white, size: 300)
                      ),
                    ],
                  ),
                  secondChild: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(_challenge.img)
                      )
                    )
                  ),
                  crossFadeState: _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  sizeCurve: Curves.elasticInOut,
                )
              ]
            ),
            ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .52, bottom: 30),
                itemCount: _shownCards.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  var card = _shownCards[i];
                  var color = card.getChallengeCardColor();
                  var icon;
                  if (_shownCards[i].type == ChallengeCardType.challengeText) {
                    icon = FontAwesomeIcons.search;
                  } else if (_shownCards[i].type == ChallengeCardType.hint) {
                    icon = FontAwesomeIcons.question;
                  } else {
                    icon = FontAwesomeIcons.info;
                  }
              
                  return Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 50),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(2, 0, 2, 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: color,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20.0)), 
                            color: Colors.black, 
                            boxShadow: [BoxShadow(color: color, blurRadius: 15.0)]
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: ListTile(
                              onTap: (){ },
                              title: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(card.cardheader, style: TextStyle(color: appGreenColor(), fontSize: 13))
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 5)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(card.bodyText, style: TextStyle(color: Colors.white, fontSize: 18)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          )
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 80,
                          padding: EdgeInsets.fromLTRB(2, 20, 2, 20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: color,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20.0)), 
                            color: Colors.grey[900], 
                            boxShadow: [BoxShadow(color: color, blurRadius: 5.0)]),
                          child: Align(
                            alignment: Alignment.center, 
                            child: Icon(icon, color: appGreenColor(), size: 30) 
                          ),
                        )
                      )
                    ],
                  );
                }
              )
          ],
        )
      )
    ;
  }

  Future _loadPageAnimated() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _first = false;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _shownCards.add(new ChallengeCard(
        cardheader: 'Challenge', 
        bodyText: _challenge.challengeName, 
        type: ChallengeCardType.challengeText
      ));
    });
  }

  Future _addCard() async {
    if (_shownCards.length == 0) return;
    setState(() {
      if (_shownCards.length == 1) {
        _shownCards.add(new ChallengeCard(
          cardheader: 'Hint 1', 
          bodyText: _challenge.hint1,
          type: ChallengeCardType.hint  
        ));
      } else if (_shownCards.length == 2) {
        _shownCards.add(new ChallengeCard(
          cardheader: 'Hint 2', 
          bodyText: _challenge.hint2,
          type: ChallengeCardType.hint  
        ));
      } else {
        _shownCards.add(new ChallengeCard(
          cardheader: 'Solution', 
          bodyText: _challenge.solutionText,
          type: ChallengeCardType.solution  
        ));
      } 
      
    });
    await Future.delayed(Duration(milliseconds: 500));
    _scrollController.animateTo(
    _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.ease,
    );
  }

  Future _helpButton() async {
    var buttonText = "I need a hint!";
    if (_shownCards.length == 2) {
      buttonText = "Another Hint!";
    } else if (_shownCards.length >= 3) {
      buttonText = "View Solution";
    }

    var alert = new AlertDialog(
      backgroundColor: Colors.black45,
      elevation: 5000,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            (_shownCards.length >= 3) ? 
              Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: RaisedButton(
                  elevation: 10.0,
                  onPressed: () {  
                    _launchUrl("https://maps.apple.com/?q=${_challenge.solutionLat},${_challenge.solutionLong}");
                  },
                  textColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 47.0),
                  shape: new RoundedRectangleBorder(side: BorderSide(color: Colors.blue, width: 4), borderRadius: new BorderRadius.circular(10.0)),
                  color: Colors.black,
                  child: Text("View Location", style: TextStyle(fontSize: 20, color: Colors.white)),
                )
              ) : Container(),
            (_shownCards.length <= 3) ?
              RaisedButton(
                elevation: 10.0,
                onPressed: () {  
                  _addCard();
                  Navigator.of(context).pop();
                },
                textColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 20.0, ),
                shape: new RoundedRectangleBorder(
                  side: BorderSide(color: (_shownCards.length < 3) ? Colors.red : appGreenColor(), width: 4), 
                  borderRadius: new BorderRadius.circular(10.0)),
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(buttonText, style: TextStyle(fontSize: 20, color: Colors.white))
                  ] 
                )
              ) :  
              RaisedButton(
                elevation: 10.0,
                onPressed: () {  
                  _launchUrl("tel:${widget.config.supportPhone}");
                },
                textColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 20.0, ),
                shape: new RoundedRectangleBorder(
                  side: BorderSide(color: Colors.red, width: 4), 
                  borderRadius: new BorderRadius.circular(10.0)),
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Call For Help", style: TextStyle(fontSize: 20, color: Colors.red))
                  ] 
                )
              )
          ], 
        )
      )
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  Future _solutionCheck(String barcode, bool scanned) async {
    bool correct = barcode == _challenge.solutionQr; 
    var icon = correct ? FontAwesomeIcons.check : FontAwesomeIcons.code;
    var message = correct ? 
      (widget.challengeIndex == 0 ) ? "Well done!" :
       "Correct! ${_challenge.solutionText}" : "I'm sorry, but this is not the solution.";

    var alert = new AlertDialog(
      backgroundColor: Colors.black45,
      elevation: 5000,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, color: correct ? Colors.green : Colors.red),
              ],
            ), 
            Row(
              children: <Widget>[
                Flexible(child: Text(message, style: TextStyle(color: Colors.white)))
              ],
            )
          ], 
        )
      ), 
      actions: <Widget>[
        correct ? 
          FlatButton(
            child: Text("Continue!", style: TextStyle(color: appGreenColor())),
            onPressed: () {
              var proceedRoute = MaterialPageRoute(
                builder: (context) => new ChallengeScreen(config: widget.config, challengeList: widget.challengeList, 
                  challengeIndex: (widget.challengeIndex + 1))
              );

              if (_challenge.betweenChallengeText == null) {
                Navigator.push(context, proceedRoute);
              } else {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => new AnimatedTextScreen(config: widget.config, animatedText: _challenge.betweenChallengeText,
                    proceedRoute: proceedRoute, proceedText: "Next Challenge!")));
              }
            }
          ) :
          FlatButton(
            child: const Text("Try again", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
            }
          )
      ]
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  Future _searchBarcode() async {
    var alert = new AlertDialog(
      backgroundColor: Colors.black45,
      elevation: 5000,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        side: BorderSide(color: appGreenColor(), width: 3)
      ),
      content:  SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Text("Scan", style: TextStyle(color: Colors.white)),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff72f200), width: 4),
                  color: Colors.black,
                  shape: BoxShape.circle
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _scanQR();
                  },
                  icon: Icon(Icons.center_focus_weak, color: Colors.red),
                  iconSize: 70,
                ))
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text("OR", style: TextStyle(color: Colors.grey)),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff72f200), width: 4),
                  color: Colors.black,
                  shape: BoxShape.circle
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _typeSearchBarcode();
                  },
                  icon: Icon(FontAwesomeIcons.iCursor, color: Colors.white),
                  iconSize: 70,
                ))
            ),
            Center(
              child: Text("Type", style: TextStyle(color: Colors.white)),
            ),
          ], 
        )
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text("Back", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ]
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  Future _typeSearchBarcode() async {
    setState(() {
      _searchController.clear();
    });
    
    var alert = new StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        bool validUPCCheck() { 
          return (_searchController.text.length != 0 && ( _searchController.text.length >= 5));
        }

        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height:170.0,child: Image.asset('images/SampleBarcode.png', fit: BoxFit.contain)),
                Center(
                  child: Text("Type a UPC", style: TextStyle(color: Colors.black)),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, 
                      color: validUPCCheck() ? Colors.green : Colors.red),
                    borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
                    color: Colors.grey[300]
                  ),
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      (_searchController.text.length != 0 && _searchController.text.length == 6) ?
                        Text("051000-",style: TextStyle(color: Colors.grey[800],fontSize: 16)): Container(), 
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle
                          ),
                          height: 54,
                          child: TextField(
                            controller: _searchController,
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: "  Type a UPC number..",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 11),
                              contentPadding: EdgeInsets.all(0.0),
                            ),
                            onChanged: (value) {
                              setState(() {}); 
                            },
                            onSubmitted: (value) { 
                              if (validUPCCheck()) {
                                Navigator.of(context).pop();
                                _solutionCheck(value, false);
                              }
                            }
                            )
                          ),
                        ),
                      (validUPCCheck()) ? 
                        IconButton(
                          icon: Icon(Icons.search, color: Colors.green),
                          iconSize: 30,
                          onPressed: () {
                            Navigator.of(context).pop();
                            _solutionCheck(_searchController.text, false);
                          },
                        ): 
                        IconButton(
                          icon: Icon(Icons.search, color: Colors.red),
                          iconSize: 30,
                          onPressed: () {},
                        )
                    ],
                  )
                ),
              ], 
            )
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text("Close", style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            (_searchController.text.length != 0 && _searchController.text.length >= 5) ? 
            FlatButton(
              child: const Text("Check", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
                _solutionCheck(_searchController.text, false);
              },
            ): Container()
          ]
        );
      }
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  Future _scanQR() async {
    try {
      ScanResult scanResult = await BarcodeScanner.scan();
      if (scanResult.rawContent != "") _solutionCheck(scanResult.rawContent, false);
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

  Future _checkLocation() async {
    var location = new Location();
    var locationData = await location.getLocation();
    if(locationData == null) throw new PlatformException(code: "PERMISSION_DENIED");

    var p = 0.017453292519943295; // Pi / 180
    var c = cos;
    var a = 0.5 - c((_challenge.solutionLat - locationData.latitude) * p)/2 + 
      c(locationData.latitude * p) * c(_challenge.solutionLat * p) * (1 - c((_challenge.solutionLong - locationData.longitude) * p)) / 2;
    var d = 12642 * asin(sqrt(a)); // 2 * R; R = 6371km
    print(d);
    setState(() {
      _inRange = (d < 1.60934);
    });
  }

  Future _launchUrl(String url) async {
    var command = url;
    if (await canLaunch(command)) {
      launch(command).timeout(const Duration(seconds: 15));
    } else {
      throw 'Could not launch $url';
    }
  }
}