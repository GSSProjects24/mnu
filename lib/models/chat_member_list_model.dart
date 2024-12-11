// To parse this JSON data, do
//
//     final chatMemberListModel = chatMemberListModelFromJson(jsonString);

import 'dart:convert';

ChatMemberListModel? chatMemberListModelFromJson(String str) =>
    ChatMemberListModel.fromJson(json.decode(str));

String chatMemberListModelToJson(ChatMemberListModel? data) =>
    json.encode(data!.toJson());

class ChatMemberListModel {
  ChatMemberListModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory ChatMemberListModel.fromJson(Map<String, dynamic> json) =>
      ChatMemberListModel(
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
    this.memberId,
    this.memberName,
    this.unseenMessageCount,
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
    this.profileImage,
  });

  int? userId;
  int? memberId;
  String? memberName;
  int? unseenMessageCount;
  String? newIcno;
  dynamic raceName;
  dynamic oldIcno;
  dynamic gender;
  String? dob;
  String? doj;
  dynamic address;
  dynamic postalCode;
  dynamic companyName;
  dynamic position;
  String? memberNo;
  dynamic employeeNo;
  dynamic telephoneNo;
  dynamic telephoneNoOffice;
  dynamic telephoneNoHp;
  String? emailId;
  dynamic basicSalary;
  dynamic entranceFee;
  dynamic monthlyFee;
  int? role;
  String? profileImage;

  factory MemberDetail.fromJson(Map<String, dynamic> json) => MemberDetail(
        userId: json["user_id"],
        memberId: json["member_id"],
        memberName: json["member_name"],
        unseenMessageCount: json["unseen_message_count"],
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
        role: json["role"],
        profileImage: json["profile_image"].toString() == '0'
            ? 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'
            : json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "member_id": memberId,
        "member_name": memberName,
        "unseen_message_count": unseenMessageCount,
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
        "profile_image": profileImage,
      };
}
