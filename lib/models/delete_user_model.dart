// To parse this JSON data, do
//
//     final deleteUserModel = deleteUserModelFromJson(jsonString);

import 'dart:convert';

DeleteUserModel deleteUserModelFromJson(String str) => DeleteUserModel.fromJson(json.decode(str));

String deleteUserModelToJson(DeleteUserModel data) => json.encode(data.toJson());

class DeleteUserModel {
  bool? success;
  Data? data;
  String? message;

  DeleteUserModel({
    this.success,
    this.data,
    this.message,
  });

  factory DeleteUserModel.fromJson(Map<String, dynamic> json) => DeleteUserModel(
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
  bool? status;
  String? errorMsg;

  Data({
    this.status,
    this.errorMsg,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    errorMsg: json["error_msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "error_msg": errorMsg,
  };
}
