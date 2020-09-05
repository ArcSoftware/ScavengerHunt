
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scavenger_hunt/Mock/mock_api.dart';
import 'package:scavenger_hunt/Models/hunt_model.dart';
import 'package:scavenger_hunt/Screens/challenge_screen.dart';
import 'package:scavenger_hunt/app_config.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class HuntScreen extends StatefulWidget{
  final AppConfig config;

  HuntScreen({Key key, @required this.config}) : super(key : key);

  @override
  _HState createState() => new _HState();
}

class _HState extends State<HuntScreen> {
  _HState();
  List<Hunt> _huntsList = new List();
  bool _loading = false;
  
  @override
  void initState() {
    super.initState();
    _getHunts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a Hunt"),
        leading: Container(),
        actions: <Widget>[
          
        ]
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset('images/img1.png')
          ),
          // Align(
          //   alignment: Alignment(0.0, 1),
          //   child: Container(
          //     height: 120, 
          //     width: MediaQuery.of(context).size.width,
          //     decoration: new BoxDecoration(
          //       color: Colors.red[900],
          //       borderRadius: new BorderRadius.all(const Radius.circular(20.0),
          //       )
          //     ),
          //     padding: EdgeInsets.only(top: 2, bottom: 2),
          //       child: Column(
          //         children: <Widget>[
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: <Widget>[
          //               Text("Kaitlyn", style: TextStyle(color: appGreenColor(), fontSize: 26))
          //             ],
          //           ),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: <Widget>[
          //               Flexible(
          //                 child: Text("By: Jake", style: TextStyle(color: Colors.grey, fontSize: 14)),
          //               )
          //             ],
          //           )
          //         ]
          //       )
          //     )
          // ),
          Container(
            height: MediaQuery.of(context).size.height * 0.90, 
            width: MediaQuery.of(context).size.width ,
            padding: EdgeInsets.fromLTRB(00.0, 30.0, 0.0, 0.0),
            child: Scrollbar(
              child: RefreshIndicator(
                color: Colors.green,
                displacement: 15.0,
                child: ListView.builder(
                  padding: EdgeInsets.all(0.0),
                  itemCount: _huntsList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    var hunt = _huntsList[i];
                    return Card(
                      color: Colors.grey[900],
                      child: Padding(
                        padding: EdgeInsets.only(top: 2, bottom: 2),
                          child: ListTile(
                          onTap: (){ _loadHunt(hunt.id); },
                          title: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(DateFormat('E, MM-dd-yyyy hh:mm a').format(hunt.createDate), style: TextStyle(color: appGreenColor(), fontSize: 13))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text("${hunt.huntName}", style: TextStyle(color: Colors.white, fontSize: 18),),
                                  )
                                ],
                              ),
                            ],
                          ),
                          subtitle: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text("By: Jake", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                  )
                                ],
                              )
                            ]
                          ), 
                          trailing: Icon(Icons.arrow_forward_ios, color: appGreenColor()),
                        ))
                      );
                    }
                  ),
              onRefresh: () async {_getHunts(); } )
            )
          ),
          (_loading) ? loading() : Container()
        ],
      )
    );
  }

  Future _getHunts() async {
    setState(() {
      _huntsList.clear();
      _loading = true;
    });

    try {
      // final r = RetryOptions(maxAttempts: 2);
      // var huntCall = await r.retry(
      //   () => http.get(widget.config.apiUrl + "company/GetAllHunts",
      //   headers: widget.config.apiHeaders).timeout(const Duration(seconds: 10)),
      //   retryIf: (e) => e is SocketException || e is TimeoutException);
      // validateContainsData(huntCall);

      var mockApi = new MockApi();
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        // _huntsList = huntFromJson(huntCall.body);
        _huntsList = huntFromJson(mockApi.huntListRet);
      });

    } catch (e) {
      logException(context, widget.config, "Hunt Screen - GetAllHunts", e, false,  null);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future _loadHunt(int challengeKey) async {
    setState(() {
      _huntsList.clear();
      _loading = true;
    });

    try {
      // final r = RetryOptions(maxAttempts: 2);
      // var challengeCall = await r.retry(
      //   () => http.get(widget.config.apiUrl + "company/GetChallenges?challengeKey=" + challengeKey,
      //   headers: widget.config.apiHeaders).timeout(const Duration(seconds: 10)),
      //   retryIf: (e) => e is SocketException || e is TimeoutException);
      // validateContainsData(huntCall);

      var mockApi = new MockApi();
      await Future.delayed(const Duration(seconds: 1));

      // var challengeList = challengeFromJson(challengeCall.body);
      var challengeList = mockApi.challengeListRet;
      
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => new ChallengeScreen(config: widget.config, challengeList: challengeList, challengeIndex: 0)
      )).whenComplete(() => { _getHunts()});


    } catch (e) {
      logException(context, widget.config, "Hunt Screen - LoadHunt", e, false,  null);
      _getHunts();
    } 
  }
}