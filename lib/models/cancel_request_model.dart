// To parse this JSON data, do
//
//     final cancelRequestmodel = cancelRequestmodelFromJson(jsonString);

import 'dart:convert';

CancelRequestmodel cancelRequestmodelFromJson(String str) => CancelRequestmodel.fromJson(json.decode(str));

String cancelRequestmodelToJson(CancelRequestmodel data) => json.encode(data.toJson());

class CancelRequestmodel {
    CancelRequestmodel({
        this.success,
        this.data,
        this.message,
    });

    bool? success;
    Data? data;
    String? message;

    factory CancelRequestmodel.fromJson(Map<String, dynamic> json) => CancelRequestmodel(
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
        this.status,
        this.errorMsg,
    });

    bool? status;
    dynamic errorMsg;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        errorMsg: json["error_msg"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error_msg": errorMsg,
    };
}
