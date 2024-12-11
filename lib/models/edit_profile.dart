// To parse this JSON data, do
//
//     final editProfileModel = editProfileModelFromJson(jsonString);

import 'dart:convert';

EditProfileModel? editProfileModelFromJson(String str) =>
    EditProfileModel.fromJson(json.decode(str));

String editProfileModelToJson(EditProfileModel? data) =>
    json.encode(data!.toJson());

class EditProfileModel {
  EditProfileModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory EditProfileModel.fromJson(Map<String, dynamic> json) =>
      EditProfileModel(
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
    this.memProfId,
    this.memberName,
    this.newIcno,
    this.oldIcno,
    this.gender,
    this.dob,
    this.doj,
    this.address,
    this.postalCode,
    this.position,
    this.employeeNo,
    this.memberNo,
    this.telephoneNo,
    this.telephoneNoOffice,
    this.telephoneNoHp,
    this.Salary,
    this.entranceFee,
    this.monthlyFee,
    this.status,
    this.pf_no,
    this.doe,
    this.readOnly
  });

  int? memProfId;
  String? memberName;
  String? newIcno;
  String? oldIcno;
  String? gender;
  String? dob;
  String? doj;
  String? address;
  String? postalCode;
  String? position;
  String? employeeNo;
  String? memberNo;

  String? telephoneNo;
  String? telephoneNoOffice;
  String? telephoneNoHp;
  dynamic Salary;
  String? entranceFee;
  String? monthlyFee;
  String? pf_no;
  String? doe;
  bool? status;
  List<String>? readOnly;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      memProfId: json["mem_prof_id"],
      memberName: json["member_name"],
      newIcno: json["new_icno"],
      oldIcno: json["old_icno"],
      //gender: json["gender"].toString().isEmpty ? 'male' : json["gender"],
      gender: json["gender"].toString().isEmpty ? 'others' : json["gender"],
      dob: json["dob"],
      doj: json["doj"],
      address: json["address"],
      postalCode: json["postal_code"],
      position: json["position"],
      employeeNo: json["employee_no"],
      memberNo: json["member_no"],
      telephoneNo: json["telephone_no"],
      telephoneNoOffice: json["telephone_no_office"],
      telephoneNoHp: json["telephone_no_hp"],
      Salary: json["salary"],
      entranceFee: json["entrance_fee"],
      monthlyFee: json["monthly_fee"],
      status: json["status"],
      pf_no: json["pf_no"],
      doe: json["doe"],
     
       readOnly:
          (json['read_only'] as List<dynamic>?)?.map((e) => e as String).toList(),
      );

  Map<String, dynamic> toJson() => {
        "mem_prof_id": memProfId,
        "member_name": memberName,
        "new_icno": newIcno,
        "old_icno": oldIcno,
        "gender": gender,
        "dob": dob,
        "doj": doj,
        "address": address,
        "postal_code": postalCode,
        "position": position,
        "employee_no": employeeNo,
        "member_no": memberNo,
        "telephone_no": telephoneNo,
        "telephone_no_office": telephoneNoOffice,
        "telephone_no_hp": telephoneNoHp,
        "salary": Salary,
        "entrance_fee": entranceFee,
        "monthly_fee": monthlyFee,
        "status": status,
        "pf_no": pf_no,
        "doe": doe,
        "read_only":readOnly
      };
}
