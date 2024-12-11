// To parse this JSON data, do
//
//     final companynames = companynamesFromJson(jsonString);

import 'dart:convert';

Companynames companynamesFromJson(String str) => Companynames.fromJson(json.decode(str));

String companynamesToJson(Companynames data) => json.encode(data.toJson());

class Companynames {
  Companynames({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory Companynames.fromJson(Map<String, dynamic> json) => Companynames(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    this.company,
    this.status,
  });

  List<Company>? company;
  bool? status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        company: json["company"] == null ? [] : List<Company>.from(json["company"]!.map((x) => Company.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "company": company == null ? [] : List<dynamic>.from(company!.map((x) => x.toJson())),
        "status": status,
      };
}

class Company {
  Company({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
