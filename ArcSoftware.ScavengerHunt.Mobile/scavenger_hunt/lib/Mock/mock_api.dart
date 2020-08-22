import 'dart:convert';

import 'package:scavenger_hunt/Models/challenge_model.dart';

class MockApi {
  String firstLoginTextRet;
  String huntListRet;
  List<Challenge> challengeListRet;

  MockApi() {
    firstLoginTextRet = 
      '[{"text":"Kaitlyn, my lover.", "textSpeed": 800, "delay": 3}, {"text":"I was thinking about that last attempt at a scavenger hunt and I felt I needed to redeem myself.", "textSpeed": 6000, "delay": 7}, {"text":"As I was thinking of folding hints into paper notes.. I was like.. why am I doing this?... I am a software engineer. Why don\'t I create an app to do my work for me.", "textSpeed": 6000, "delay": 8}, {"text":"So here is my attempt.", "textSpeed": 600, "delay": 2}, {"text":"The rules are simple. 1) You will go around town searching for clues. 2) Clues will always be some kind of barcode to scan. Scan by clicking the barcode at the top of the clue\'s page. 3) If you get stuck or just need a GPS location, click the ? mark icon for another hint.", "textSpeed": 15000, "delay": 18},{"text":"Have fun, and I love you!", "textSpeed": 600, "delay": 3}]';
    huntListRet = 
      '[{"huntName":"Test","createUserKey": 1,"createDate": "2020-08-19T11:15:59.37", "lastLoadDate": null, "id": 1, "isActive": true}]';
  }
}