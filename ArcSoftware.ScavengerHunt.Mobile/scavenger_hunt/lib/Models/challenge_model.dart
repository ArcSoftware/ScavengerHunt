import 'dart:convert';

List<Challenge> challengeFromJson(String str) => List<Challenge>.from(json.decode(str).map((x) => Challenge.fromJson(x)));

String challengeToJson(List<Challenge> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Challenge {
    Challenge({
        this.challengeName,
        this.huntKey,
        this.hint1,
        this.hint2,
        this.solutionText,
        this.solutionQr,
        this.solutionLat,
        this.solutionLong,
        this.id,
        this.isActive,
    });

    String challengeName;
    int huntKey;
    String hint1;
    String hint2;
    String solutionText;
    String solutionQr;
    int solutionLat;
    int solutionLong;
    int id;
    bool isActive;

    factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        challengeName: json["challengeName"],
        huntKey: json["huntKey"],
        hint1: json["hint1"],
        hint2: json["hint2"],
        solutionText: json["solutionText"],
        solutionQr: json["solutionQr"] == null ? null : json["solutionQr"],
        solutionLat: json["solutionLat"] == null ? null : json["solutionLat"],
        solutionLong: json["solutionLong"] == null ? null : json["solutionLong"],
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