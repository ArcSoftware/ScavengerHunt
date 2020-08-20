import 'dart:convert';

List<Hunt> huntFromJson(String str) => List<Hunt>.from(json.decode(str).map((x) => Hunt.fromJson(x)));

String huntToJson(List<Hunt> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Hunt {
    Hunt({
        this.huntName,
        this.createUserKey,
        this.createDate,
        this.lastLoadDate,
        this.id,
        this.isActive,
    });

    String huntName;
    int createUserKey;
    DateTime createDate;
    DateTime lastLoadDate;
    int id;
    bool isActive;

    factory Hunt.fromJson(Map<String, dynamic> json) => Hunt(
        huntName: json["huntName"],
        createUserKey: json["createUserKey"],
        createDate: DateTime.parse(json["createDate"]),
        lastLoadDate: json["lastLoadDate"] == null ? null : DateTime.parse(json["lastLoadDate"]),
        id: json["id"],
        isActive: json["isActive"],
    );

    Map<String, dynamic> toJson() => {
        "huntName": huntName,
        "createUserKey": createUserKey,
        "createDate": createDate.toIso8601String(),
        "lastLoadDate": lastLoadDate == null ? null : lastLoadDate.toIso8601String(),
        "id": id,
        "isActive": isActive,
    };
}