import 'dart:convert';

import 'package:scavenger_hunt/Models/challenge_model.dart';

class MockApi {
  String huntListRet;
  List<Challenge> challengeListRet;

  MockApi() {   
    huntListRet = 
      '[{"huntName":"Test","createUserKey": 1,"createDate": "2020-08-19T11:15:59.37", "lastLoadDate": null, "id": 1, "isActive": true}]';
  }
}