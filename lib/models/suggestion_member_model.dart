// To parse this JSON data, do
//
//     final suggestionMemberModel = suggestionMemberModelFromJson(jsonString);

import 'dart:convert';

SuggestionMemberModel? suggestionMemberModelFromJson(String str) =>
    SuggestionMemberModel.fromJson(json.decode(str));

String suggestionMemberModelToJson(SuggestionMemberModel? data) =>
    json.encode(data!.toJson());

class SuggestionMemberModel {
  SuggestionMemberModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory SuggestionMemberModel.fromJson(Map<String, dynamic> json) =>
      SuggestionMemberModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data!.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    this.userId,
    this.memberName,
    this.newIcno,
    this.oldIcno,
    this.gender,
    this.dob,
    this.address,
    this.postalCode,
    this.position,
    this.employeeNo,
    this.telephoneNo,
    this.telephoneNoOffice,
    this.telephoneNoHp,
    this.basicSalary,
    this.entranceFee,
    this.monthlyFee,
    this.role,
    this.status,
    this.profile_image,
    this.followersList,
  });

  int? userId;
  String? memberName;
  String? newIcno;
  String? oldIcno;
  String? gender;
  String? dob;
  String? address;
  String? postalCode;
  String? position;
  String? employeeNo;
  String? telephoneNo;
  String? telephoneNoOffice;
  String? telephoneNoHp;
  dynamic basicSalary;
  String? entranceFee;
  String? monthlyFee;
  String? profile_image;
  List<FollowersList>? followersList;
  String? role;
  bool? status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        memberName: json["member_name"],
        newIcno: json["new_icno"],
        oldIcno: json["old_icno"],
        gender: json["gender"],
        dob: json["dob"],
        address: json["address"],
        postalCode: json["postal_code"],
        position: json["position"],
        employeeNo: json["employee_no"],
        telephoneNo: json["telephone_no"],
        telephoneNoOffice: json["telephone_no_office"],
        telephoneNoHp: json["telephone_no_hp"],
        basicSalary: json["basic_salary"],
        entranceFee: json["entrance_fee"],
        monthlyFee: json["monthly_fee"],
        role: json["role"],
        profile_image:
            'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png',
        // json["profile_image"].toString()=='0'?'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png':json["profile_image"],
        status: json["status"],
        followersList: json["followers_list"] == null
            ? []
            : List<FollowersList>.from(
                json["followers_list"]!.map((x) => FollowersList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "member_name": memberName,
        "new_icno": newIcno,
        "old_icno": oldIcno,
        "gender": gender,
        "dob": dob,
        "address": address,
        "postal_code": postalCode,
        "position": position,
        "employee_no": employeeNo,
        "telephone_no": telephoneNo,
        "telephone_no_office": telephoneNoOffice,
        "telephone_no_hp": telephoneNoHp,
        "basic_salary": basicSalary,
        "entrance_fee": entranceFee,
        "monthly_fee": monthlyFee,
        "role": role,
        "status": status,
        "followers_list": followersList == null
            ? []
            : List<dynamic>.from(followersList!.map((x) => x.toJson())),
      };
}

class FollowersList {
  FollowersList({
    num? followPrimaryId,
    num? friendId,
    num? flag,
  }) {
    _followPrimaryId = followPrimaryId;
    _friendId = friendId;
    _flag = flag;
  }

  FollowersList.fromJson(dynamic json) {
    _followPrimaryId = json['follow_primary_id'];
    _friendId = json['friend_id'];
    _flag = json['flag'];
  }
  num? _followPrimaryId;
  num? _friendId;
  num? _flag;
  FollowersList copyWith({
    num? followPrimaryId,
    num? friendId,
    num? flag,
  }) =>
      FollowersList(
        followPrimaryId: followPrimaryId ?? _followPrimaryId,
        friendId: friendId ?? _friendId,
        flag: flag ?? _flag,
      );
  num? get followPrimaryId => _followPrimaryId;
  num? get friendId => _friendId;
  num? get flag => _flag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['follow_primary_id'] = _followPrimaryId;
    map['friend_id'] = _friendId;
    map['flag'] = _flag;
    return map;
  }
}
