// To parse this JSON data, do
//
//     final memberModel = memberModelFromJson(jsonString);

import 'dart:convert';

MemberModel? memberModelFromJson(String str) =>
    MemberModel.fromJson(json.decode(str));

String memberModelToJson(MemberModel? data) => json.encode(data!.toJson());

class MemberModel {
  MemberModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
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
    this.profileId,
    this.memberName,
    this.newIcno,
    this.raceName,
    this.oldIcno,
    this.gender,
    this.dob,
    this.doj,
    this.address,
    this.postalCode,
    this.companyName,
    this.position,
    this.memberNo,
    this.employeeNo,
    this.telephoneNo,
    this.telephoneNoOffice,
    this.telephoneNoHp,
    this.emailId,
    this.basicSalary,
    this.entranceFee,
    this.monthlyFee,
    this.followersCount,
    this.followingCount,
    this.postCount,
    this.postHideCount,
    this.role,
    this.status,
    this.profile_image,
    this.followerUserId,
    this.isFollwing,
  });

  int? userId;
  int? profileId;
  String? memberName;
  String? newIcno;
  String? raceName;
  String? oldIcno;
  String? gender;
  String? dob;
  String? doj;
  String? address;
  String? postalCode;
  String? companyName;
  String? position;
  String? memberNo;
  String? employeeNo;
  String? telephoneNo;
  String? telephoneNoOffice;
  String? telephoneNoHp;
  String? emailId;
  dynamic basicSalary;
  String? entranceFee;
  String? monthlyFee;
  int? followersCount;
  int? followingCount;
  int? postCount;
  int? postHideCount;
  int? role;
  bool? status;
  String? profile_image;
  int? followerUserId;
  bool? isFollwing;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        profileId: json["profile_id"],
        memberName: json["member_name"],
        newIcno: json["new_icno"],
        raceName: json["race_name"],
        oldIcno: json["old_icno"],
        gender: json["gender"],
        dob: json["dob"],
        doj: json["doj"],
        address: json["address"],
        postalCode: json["postal_code"],
        companyName: json["company_name"],
        position: json["position"],
        memberNo: json["member_no"],
        employeeNo: json["employee_no"],
        telephoneNo: json["telephone_no"],
        telephoneNoOffice: json["telephone_no_office"],
        telephoneNoHp: json["telephone_no_hp"],
        emailId: json["email_id"],
        basicSalary: json["basic_salary"],
        entranceFee: json["entrance_fee"],
        monthlyFee: json["monthly_fee"],
        followersCount: json["followers_count"],
        followingCount: json["following_count"],
        postCount: json["post_count"],
        postHideCount: json["post_hide_count"],
        role: json["role"],
        status: json["status"],
        profile_image: json["profile_image"].toString() == '0'
            ? null
            : json["profile_image"],
        followerUserId: json["follower_user_id"],
        isFollwing: json["is_follwing"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "profile_id": profileId,
        "member_name": memberName,
        "new_icno": newIcno,
        "race_name": raceName,
        "old_icno": oldIcno,
        "gender": gender,
        "dob": dob,
        "doj": doj,
        "address": address,
        "postal_code": postalCode,
        "company_name": companyName,
        "position": position,
        "member_no": memberNo,
        "employee_no": employeeNo,
        "telephone_no": telephoneNo,
        "telephone_no_office": telephoneNoOffice,
        "telephone_no_hp": telephoneNoHp,
        "email_id": emailId,
        "basic_salary": basicSalary,
        "entrance_fee": entranceFee,
        "monthly_fee": monthlyFee,
        "followers_count": followersCount,
        "following_count": followingCount,
        "post_count": postCount,
        "post_hide_count": postHideCount,
        "role": role,
        "status": status,
        "follower_user_id": followerUserId,
        "is_follwing": isFollwing,
      };
}
