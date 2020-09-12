import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scavenger_hunt/MockApi/privateHunt.dart';
import 'package:scavenger_hunt/app_config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scavenger_hunt/main.dart';

class FinishedHuntScreen extends StatefulWidget{
  final AppConfig config;

  FinishedHuntScreen({Key key, @required this.config}) : super(key : key);

  @override
  _FHState createState() => new _FHState();
}

class _FHState extends State<FinishedHuntScreen> {
  _FHState();
  List<String> _imgList;
  String _subtitle = "";
  Color _subtitleColor = Colors.white;
  double _subtitleSize = 22;
  
  @override
  void initState() {
    MockApi mockApi = new MockApi();
    _imgList = mockApi.finishedHuntImgList;
    _loadPageAnimated();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            CarouselSlider(
              items: _imgList.map((item) => Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(item)
                  )
                )
              )).toList(),
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(milliseconds: 800),
                pauseAutoPlayInFiniteScroll: true,
                autoPlayCurve: Curves.easeInOutQuad,
                onPageChanged: (value, reason) {
                  _slideTransition(value);
                },
                scrollDirection: Axis.horizontal,
              )
            ), 
            Align(
              alignment: Alignment(0.0, 0.85),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(child: Text(_subtitle, style: TextStyle(color: _subtitleColor, fontSize: _subtitleSize)))
                ],
              ),
            )
          ],
        )
      )
    ;
  }

  //Util Functions
  Future _loadPageAnimated() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _subtitleSize = 22;
      _subtitle = "All of this in less than a year..";
    });
  }

  Future _slideTransition(value) async {
    HapticFeedback.heavyImpact();
    await Future.delayed(Duration(milliseconds: 200));
    HapticFeedback.mediumImpact();

    if ((value + 1) == _imgList.length) {
      setState(() {
        _subtitleSize = 36;
        _subtitleColor = appGreenColor();
        _subtitle = "Can you spot me?";
      });
    }
  }
}