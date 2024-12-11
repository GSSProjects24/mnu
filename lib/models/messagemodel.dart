import 'dart:convert';

Messages messagesFromJson(String str) => Messages.fromJson(json.decode(str));

String messagesToJson(Messages data) => json.encode(data.toJson());

class Messages {
  Messages({
    this.name,
    this.id,
    this.time,
    this.content,
    this.pic,
  });

  String ?name;
  int? id;
  DateTime? time;
  String? content;
  String? pic;

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
    name: json["name"],
    id: json["id"],
    time: DateTime.parse(json["time"]),
    content: json["content"],
    pic: json["pic"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "time": time?.toIso8601String(),
    "content": content,
    "pic": pic,
  };
}
