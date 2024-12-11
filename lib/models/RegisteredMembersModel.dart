// To parse this JSON data, do
//
//     final registeredMembersModel = registeredMembersModelFromJson(jsonString);

import 'dart:convert';

RegisteredMembersModel? registeredMembersModelFromJson(String str) =>
    RegisteredMembersModel.fromJson(json.decode(str));

String registeredMembersModelToJson(RegisteredMembersModel? data) =>
    json.encode(data!.toJson());

class RegisteredMembersModel {
  RegisteredMembersModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory RegisteredMembersModel.fromJson(Map<String, dynamic> json) =>
      RegisteredMembersModel(
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
    this.memberDetails,
    this.status,
  });

  List<MemberDetail?>? memberDetails;
  bool? status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        memberDetails: json["member_details"] == null
            ? []
            : List<MemberDetail?>.from(
                json["member_details"]!.map((x) => MemberDetail.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "member_details": memberDetails == null
            ? []
            : List<dynamic>.from(memberDetails!.map((x) => x!.toJson())),
        "status": status,
      };
}

class MemberDetail {
  MemberDetail({
    this.userId,
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
    this.role,
    this.profile_image,
    this.isFollowRequest,
  });

  int? userId;
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
  String? profile_image;
  int? role;
  bool? isFollowRequest;

  factory MemberDetail.fromJson(Map<String, dynamic> json) => MemberDetail(
        userId: json["user_id"],
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
        profile_image: json["profile_image"].toString() == '0'
            ? 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'
            : json["profile_image"],
        role: json["role"],
        isFollowRequest: json["is_follow_request"] == 0 ? false : true,
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
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
        "role": role,
        "is_follow_request": isFollowRequest,
      };
}
