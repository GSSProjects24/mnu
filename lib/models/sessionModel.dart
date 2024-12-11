import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

Session sessionFromJson(String str) => Session.fromJson(json.decode(str));

String sessionToJson(Session data) => json.encode(data.toJson());

class Session {
  Session({this.success, this.data, this.message, this.isOnboarding = false});

  bool? success;
  Data? data;
  String? message;
  bool? isOnboarding;

  login(Map<String, dynamic> value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_id', value["data"]["user_id"].toString());
    await prefs.setString('name', value["data"]["name"]);
    await prefs.setString('username', value["data"]["username"]);
    await prefs.setString('email', value["data"]["email"]);
    await prefs.setString('role', value["data"]["role"].toString());
    await prefs.setString('icno', value["data"]["icno"]);
    await prefs.setString('member_no', value["data"]["member_no"]);
    await prefs.setString('companyname', value["data"]["companyname"]);
    await prefs.setString(
        'profile_image',
        value["data"]["profile_image"] == '0'
            ? ''
            : value["data"]["profile_image"]);
    await prefs.setString('status', value["data"]["status"].toString());
  }

  logOut() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('user_id');
    await prefs.remove('name');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('role');
    await prefs.remove('icno');
    await prefs.remove('member_no');
    await prefs.remove('companyname');
    await prefs.remove('status');
    await prefs.remove('profile_image');
  }

  static Future<Data?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    Data? myData = Data();
    var uid = prefs.getString('user_id') ?? '';
    if (uid.isNotEmpty) {
      myData.userId = int.parse(uid);
    }
    myData.name = prefs.getString('name');
    myData.username = prefs.getString('username');
    myData.email = prefs.getString('email');
    var role = prefs.getString('role') ?? '';
    if (role.isNotEmpty) {
      myData.role = int.parse(role);
    }
    myData.icno = prefs.getString('icno');
    myData.memberNo = prefs.getString('member_no');
    myData.companyname = prefs.getString('companyname');
    myData.status = prefs.getString('status') == 'true' ? true : false;
    myData.profile_image = prefs.getString('profile_image');

    return myData;
  }

  Future<void> setOnboard() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isOnboarding', true);
  }

  Future<void> loadOnboard() async {
    final prefs = await SharedPreferences.getInstance();

    var data = await prefs.getBool('isOnboarding');

    isOnboarding = data!;
  }

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data ?? null,
        "message": message,
      };
}

class Data {
  Data(
      {this.userId,
      this.name,
      this.username,
      this.email,
      this.role,
      this.icno,
      this.memberNo,
      this.companyname,
      this.status,
      this.profile_image});

  int? userId;
  String? name;
  String? username;
  String? email;
  int? role;
  String? icno;
  String? memberNo;
  String? companyname;
  String? profile_image;

  bool? status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        role: json["role"],
        icno: json["icno"],
        memberNo: json["member_no"].toString(),
        companyname: json["companyname"],
        profile_image: json["profile_image"].toString() == '0'
            ? Container()
            : json["profile_image"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "username": username,
        "email": email,
        "role": role,
        "icno": icno,
        "member_no": memberNo,
        "companyname": companyname,
        "status": status,
      };
}
