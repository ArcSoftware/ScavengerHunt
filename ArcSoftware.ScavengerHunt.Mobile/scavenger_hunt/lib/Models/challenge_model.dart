import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scavenger_hunt/Models/animated_text_model.dart';
import 'package:scavenger_hunt/main.dart';

List<Challenge> challengeFromJson(String str) => List<Challenge>.from(json.decode(str).map((x) => Challenge.fromJson(x)));

String challengeToJson(List<Challenge> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Challenge {
    Challenge({
        this.challengeName,
        this.huntKey,
        this.img,
        this.hint1,
        this.hint2,
        this.solutionText,
        this.solutionQr,
        this.solutionLat,
        this.solutionLong,
        this.solutionImg,
        this.betweenChallengeText,
        this.id,
        this.isActive,
    });

    String challengeName;
    int huntKey;
    String img;
    String hint1;
    String hint2;
    String solutionText;
    String solutionQr;
    double solutionLat;
    double solutionLong;
    String solutionImg;
    List<AnimatedText> betweenChallengeText;
    int id;
    bool isActive;

    factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        challengeName: json["challengeName"],
        huntKey: json["huntKey"],
        img: json["img"],
        hint1: json["hint1"],
        hint2: json["hint2"],
        solutionText: json["solutionText"],
        solutionQr: json["solutionQr"] == null ? null : json["solutionQr"],
        solutionLat: json["solutionLat"] == null ? null : json["solutionLat"],
        solutionLong: json["solutionLong"] == null ? null : json["solutionLong"],
        solutionImg: json["solutionImg"],
        betweenChallengeText: json["betweenChallengeText"] == null ? null : animatedTextFromJson(json["betweenChallengeText"]),
        id: json["id"],
        isActive: json["isActive"],
    );

    Map<String, dynamic> toJson() => {
        "challengeName": challengeName,
        "huntKey": huntKey,
        "hint1": hint1,
        "hint2": hint2,
        "solutionText": solutionText,
        "solutionQr": solutionQr == null ? null : solutionQr,
        "solutionLat": solutionLat == null ? null : solutionLat,
        "solutionLong": solutionLong == null ? null : solutionLong,
        "id": id,
        "isActive": isActive,
    };
}

class ChallengeCard {
  ChallengeCard({
    this.cardheader,
    this.bodyText,
    this.type
  });

  String cardheader;
  String bodyText;
  ChallengeCardType type;

  Color getChallengeCardColor() {
    switch (this.type) {
      case ChallengeCardType.challengeText:
        return Colors.white;
      case ChallengeCardType.hint:
        return Colors.red;
      case ChallengeCardType.solution:
        return appGreenColor();
      default:
        return appGreenColor();
    }
  }
}

enum ChallengeCardType {
  challengeText,
  hint,
  solution
}
