// To parse this JSON data, do
//
//     final messagesModel = messagesModelFromJson(jsonString);

import 'dart:convert';
// import '/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
MessagesModel? messagesModelFromJson(String str) => MessagesModel.fromJson(json.decode(str));

String messagesModelToJson(MessagesModel? data) => json.encode(data!.toJson());

class MessagesModel {
  MessagesModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory MessagesModel.fromJson(Map<String, dynamic> json) => MessagesModel(
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
    this.result,
    this.status,
  });

  Result? result;
  bool? status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    result: Result.fromJson(json["result"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result!.toJson(),
    "status": status,
  };
}

class Result {
  Result({
    this.start,
    this.limit,
    this.totalPage,
    this.curPage,
    this.totalReports,
    this.msg,
  });

  String? start;
  String? limit;
  String? totalPage;
  String? curPage;
  TotalReports? totalReports;
  List<Msg?>? msg;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    start: json["start"].toString(),
    limit: json["limit"].toString(),
    totalPage: json["total_page"].toString(),
    curPage: json["cur_page"].toString(),
    totalReports: TotalReports.fromJson(json["total_reports"]),
    msg: json["msg"] == null ? [] : List<Msg?>.from(json["msg"]!.map((x) => Msg.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "limit": limit,
    "total_page": totalPage,
    "cur_page": curPage,
    "total_reports": totalReports!.toJson(),
    "msg": msg == null ? [] : List<dynamic>.from(msg!.map((x) => x!.toJson())),
  };
}

class Msg {
  Msg({
    this.chatId,
    this.message,
    this.seen,
    this.sender,
    this.delete,
    this.date,
    this.time,
  });

  int? chatId;
  String? message;
  int? seen;
  bool? sender;
  bool? delete;
  DateTime? date;
  String? time;

  factory Msg.fromJson(Map<String, dynamic> json) => Msg(
    chatId: json["chat_id"],
    message: json["message"],
    seen: json["seen"],
    sender: json["sender"],
    delete: json["delete"],
    date:  DateFormat("dd/MM/yyyy HH:mm:ss").parse("${json["date"]} ${json["time"]}"),
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "chat_id": chatId,
    "message": message,
    "seen": seen,
    "sender": sender,
    "delete": delete,

    "time": time,
  };
}





class TotalReports {
  TotalReports({
    this.messageCount,
  });

  int? messageCount;

  factory TotalReports.fromJson(Map<String, dynamic> json) => TotalReports(
    messageCount: json["message_count"],
  );

  Map<String, dynamic> toJson() => {
    "message_count": messageCount,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
