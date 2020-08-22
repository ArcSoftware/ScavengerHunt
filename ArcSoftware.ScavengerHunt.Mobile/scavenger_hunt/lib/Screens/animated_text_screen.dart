
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scavenger_hunt/Models/animated_text_model.dart';
import 'package:scavenger_hunt/app_config.dart';
import '../main.dart';

class AnimatedTextScreen extends StatefulWidget{
  final AppConfig config;
  final List<AnimatedText> animatedText;

  AnimatedTextScreen({Key key, @required this.config, @required this.animatedText}) : super(key : key);

  @override
  _ATState createState() => new _ATState();
}

class _ATState extends State<AnimatedTextScreen> with TickerProviderStateMixin {
  _ATState();

  Animation<int> _charCount;
  int _messageIndex = -1;
  String get _currentString => widget.animatedText[_messageIndex % widget.animatedText.length].text;

  Widget _actions = Container();
  bool _replayable = false;
  
  @override
  void initState() {
    _loadText();
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
        title: Text(""),
        leading: Container(),
        actions: <Widget>[
          
        ]
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: new EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
            child: _charCount == null ? null : new AnimatedBuilder(
              animation: _charCount,
              builder: (BuildContext context, Widget child) {
                String text = _currentString.substring(0, _charCount.value);
                return new Text(text, style: TextStyle(color: appGreenColor(), fontFamily: 'Courier New', fontSize: 20));
              },
            )
          ),
          Align(
            alignment: Alignment(0.0, 0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _actions
              ],
            ),
          ),
          Align(
            alignment: Alignment(0.0, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                (_replayable) ? RaisedButton(
                  elevation: 10.0,
                  onPressed: () {_loadText();},
                  textColor: appGreenColor(),
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 100.0),
                  color: Colors.transparent,
                  child: Row(
                    children: <Widget>[
                      Text("< Make me type it all again", style: TextStyle(fontSize: 11, fontFamily: 'Courier New')),
                    ],
                  ),
                ) : Container()
              ],
            ),
          ),
        ],
      )
    );
  }

  Future _loadText() async {
    setState(() {
      _messageIndex = (_replayable) ? 0 : _messageIndex + 1;
      _actions = Container();
    });

    _progressTextAnimation();
    // await Future.delayed(Duration(seconds: widget.animatedText[_messageIndex].delay));
  }

  Future _progressTextAnimation() async {
    AnimationController controller = new AnimationController(
      duration: Duration(milliseconds: widget.animatedText[_messageIndex].textSpeed),
      vsync: this,
    );
    setState(() {
      _charCount = new StepTween(begin: 0, end: _currentString.length)
        .animate(new CurvedAnimation(parent: controller, curve: Curves.easeIn));
    });
    await controller.forward();
    controller.dispose();

    await Future.delayed(Duration(microseconds: 300));
    setState(() {
      if (_messageIndex  != (widget.animatedText.length - 1)) {
        _actions = RaisedButton(
          elevation: 10.0,
          onPressed: () {_loadText();},
          textColor: appGreenColor(),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 100.0),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
          color: Colors.transparent,
          child: Row(
            children: <Widget>[
              Text("Continue >", style: TextStyle(fontSize: 20, fontFamily: 'Courier New'))
            ],
          ),
        );
        _replayable = false;
      } else {
        _actions = RaisedButton(
          elevation: 10.0,
          onPressed: () {_loadText();},
          textColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 100.0),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
          color: Color(0xff72f200),
          child: Row(
            children: <Widget>[
              Text("Pick a Hunt", style: TextStyle(fontSize: 20))
            ],
          ),
        );
        _replayable = true;
      }
    });
  }
}