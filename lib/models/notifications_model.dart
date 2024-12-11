// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) =>
    NotificationsModel.fromJson(json.decode(str));

// String notificationsModelToJson(NotificationsModel data) => json.encode(data.toJson());

class NotificationsModel {
  NotificationsModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );
}

class Data {
  Data({
    this.notifcationDetails,
    this.status,
    this.errorMsg,
  });

  NotifcationDetails? notifcationDetails;
  bool? status;
  dynamic errorMsg;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        notifcationDetails: json["notifcation_details"] == null
            ? null
            : NotifcationDetails.fromJson(json["notifcation_details"]),
        status: json["status"],
        errorMsg: json["error_msg"],
      );
}

class NotifcationDetails {
  NotifcationDetails({
    this.start,
    this.limit,
    this.totalPage,
    this.curPage,
    this.nextPage,
    this.totalReports,
    this.notications,
  });

  String? start;
  String? limit;
  String? totalPage;
  String? curPage;
  String? nextPage;
  TotalReports? totalReports;
  List<Notications>? notications;

  factory NotifcationDetails.fromJson(Map<String, dynamic> json) =>
      NotifcationDetails(
        start: json["start"].toString(),
        limit: json["limit"].toString(),
        totalPage: json["total_page"].toString(),
        curPage: json["cur_page"].toString(),
        nextPage: json["next_page"].toString(),
        totalReports: json["total_reports"] == null
            ? null
            : TotalReports.fromJson(json["total_reports"]),
        notications: json["notications"] == null
            ? []
            : List<Notications>.from(
                json["notications"]!.map((x) => Notications.fromJson(x))),
      );
}

class Notications {
  Notications({
    this.pushId,
    this.userId,
    this.date,
    this.time,
    this.category,
    this.heading,
    this.message,
    this.userDetails,
    this.postDetails,
    this.flag,
  });

  int? pushId;
  int? userId;
  DateTime? date;
  String? time;
  String? category;
  String? heading;
  String? message;
  UserDetails? userDetails;
  PostDetails? postDetails;
  num? flag;

  factory Notications.fromJson(Map<String, dynamic> json) => Notications(
        pushId: json["push_id"],
        userId: json["user_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
        category: json["category"],
        heading: json["heading"],
        message: json["message"],
        flag: json["flag"],
        userDetails: json["user_details"] == null
            ? null
            : UserDetails.fromJson(json["user_details"]),
        postDetails: json["post_details"] == null
            ? PostDetails(image: [], video: [])
            : PostDetails.fromJson(json["post_details"]),
      );
}

class PostDetails {
  PostDetails({
    this.postId,
    this.title,
    this.content,
    required this.image,
    required this.video,
    this.date,
    this.time,
    this.comments,
  });

  int? postId;
  String? title;
  String? content;
  List<dynamic?> image;
  List<dynamic?> video;
  String? date;
  String? time;
  List<Comment>? comments;

  factory PostDetails.fromJson(Map<String, dynamic> json) => PostDetails(
        postId: json["post_id"],
        title: json["title"],
        content: json["content"],
        image: json["image"].toString() == '0' ? [] : json["image"],
        video: json["video"].toString() == '0' ? [] : json["video"],
        date: json["date"] ?? '',
        time: json["time"],
        comments: json["comments"] == null
            ? []
            : List<Comment>.from(
                json["comments"]!.map((x) => Comment.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //   "post_id": postId,
  //   "title": title,
  //   "content": content,
  //   "image": image,
  //   "video": video,
  //   "date": dateValues.reverse[date],
  //   "time": time,
  //   "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
  // };
}

class Comment {
  Comment({
    this.commentId,
    this.userId,
    this.commentedUserName,
    this.profileImage,
    this.comment,
    this.date,
    this.time,
    this.replyComment,
  });

  int? commentId;
  int? userId;
  String? commentedUserName;
  String? profileImage;
  String? comment;
  String? date;
  String? time;
  List<Comment>? replyComment;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        commentId: json["comment_id"],
        userId: json["user_id"],
        commentedUserName: json["commented_user_name"],
        profileImage: json["profile_image"],
        comment: json["comment"],
        date: json["date"],
        time: json["time"],
        replyComment: json["reply_comment"] == null
            ? []
            : List<Comment>.from(
                json["reply_comment"]!.map((x) => Comment.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //   "comment_id": commentId,
  //   "user_id": userId,
  //   "commented_user_name": commentedUserNameValues.reverse[commentedUserName],
  //   "profile_image": profileImage,
  //   "comment": comment,
  //   "date": dateValues.reverse[date],
  //   "time": time,
  //   "reply_comment": replyComment == null ? [] : List<dynamic>.from(replyComment!.map((x) => x.toJson())),
  // };
}

class UserDetails {
  UserDetails({
    this.userId,
    this.name,
    this.icNoNew,
    this.companyNames,
    this.profileImg,
  });

  int? userId;
  String? name;
  String? icNoNew;
  String? companyNames;
  String? profileImg;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        userId: json["user_id"],
        name: json["name"],
        icNoNew: json["ic_no_new"],
        companyNames: json["company_names"],
        profileImg: json["profile_img"],
      );

  // Map<String, dynamic> toJson() => {
  //   "user_id": userId,
  //   "name": nameValues.reverse[name],
  //   "ic_no_new": icNoNewValues.reverse[icNoNew],
  //   // "company_names": companyNamesValues.reverse[companyNames],
  //   "profile_img": profileImg,
  // };
}

// enum Name { MUHAMAD_FAZUWAN_BIN_ZAINAL_ABIDIN, AMIRUL_RASRIQ_BIN_RAZALI, MUHAMMAD_SYAMIM_BIN_ZAINAL_ABIDIN, ROSADILAH_BT_MOHD_TEH, ADMIN, MUHAMMAD_AZRIN_BIN_ISMAIL }
//
// final nameValues = EnumValues({
//   "Admin": Name.ADMIN,
//   "AMIRUL RASRIQ BIN RAZALI": Name.AMIRUL_RASRIQ_BIN_RAZALI,
//   "MUHAMAD FAZUWAN BIN ZAINAL ABIDIN": Name.MUHAMAD_FAZUWAN_BIN_ZAINAL_ABIDIN,
//   "MUHAMMAD AZRIN BIN ISMAIL": Name.MUHAMMAD_AZRIN_BIN_ISMAIL,
//   "MUHAMMAD SYAMIM BIN ZAINAL ABIDIN": Name.MUHAMMAD_SYAMIM_BIN_ZAINAL_ABIDIN,
//   "ROSADILAH BT MOHD TEH": Name.ROSADILAH_BT_MOHD_TEH
// });

class TotalReports {
  TotalReports({
    this.noticationCount,
    this.unseenCount,
  });

  int? noticationCount;
  int? unseenCount;

  factory TotalReports.fromJson(Map<String, dynamic> json) => TotalReports(
        noticationCount: json["notication_count"],
        unseenCount: json["unseen_count"],
      );

  Map<String, dynamic> toJson() => {
        "notication_count": noticationCount,
        "unseen_count": unseenCount,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
