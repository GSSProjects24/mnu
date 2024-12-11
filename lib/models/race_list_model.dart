// To parse this JSON data, do
//
//     final racelist = racelistFromJson(jsonString);

import 'dart:convert';

Racelist racelistFromJson(String str) => Racelist.fromJson(json.decode(str));

String racelistToJson(Racelist data) => json.encode(data.toJson());

class Racelist {
    Racelist({
        this.success,
        this.data,
        this.message,
    });

    bool? success;
    Data? data;
    String? message;

    factory Racelist.fromJson(Map<String, dynamic> json) => Racelist(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
    );

  get name => null;

  get id => null;

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
    };
}

class Data {
    Data({
        this.race,
        this.status,
    });

    List<Race>? race;
    bool? status;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        race: json["race"] == null ? [] : List<Race>.from(json["race"]!.map((x) => Race.fromJson(x))),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "race": race == null ? [] : List<dynamic>.from(race!.map((x) => x.toJson())),
        "status": status,
    };
}

class Race {
    Race({
        this.id,
        this.name,
    });

    int? id;
    String? name;

    factory Race.fromJson(Map<String, dynamic> json) => Race(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
