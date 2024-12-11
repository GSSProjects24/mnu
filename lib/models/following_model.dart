// To parse this JSON data, do
//
//     final followingModel = followingModelFromJson(jsonString);

import 'dart:convert';

FollowingModel followingModelFromJson(String str) => FollowingModel.fromJson(json.decode(str));

String followingModelToJson(FollowingModel data) => json.encode(data.toJson());

class FollowingModel {
  FollowingModel({
    required this.success,
    this.data, // Nullable to handle null data case
    required this.message,
  });

  bool success;
  Data? data; // Nullable data
  String message;

  factory FollowingModel.fromJson(Map<String, dynamic> json) => FollowingModel(
    success: json["success"],
    data: json["data"] != null ? Data.fromJson(json["data"]) : null,
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };
}
// class FollowingModel {
//   FollowingModel({
//     required this.success,
//     required this.data,
//     required this.message,
//   });
//
//   bool success;
//   Data data;
//   String message;
//
//   factory FollowingModel.fromJson(Map<String, dynamic> json) => FollowingModel(
//     success: json["success"],
//     data: Data.fromJson(json["data"]),
//     message: json["message"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "data": data.toJson(),
//     "message": message,
//   };
// }

class Data {
  Data({
    required this.followDetails,
    required this.status,
  });

  FollowDetails followDetails;
  bool status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    followDetails: FollowDetails.fromJson(json["follow_details"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "follow_details": followDetails.toJson(),
    "status": status,
  };
}

class FollowDetails {
  FollowDetails({
    required this.start,
    required this.limit,
    required this.totalPage,
    required this.curPage,
    required this.nextPage,
    required this.totalReports,
    required this.followers,
  });

  String start;
  String limit;
  String totalPage;
  String curPage;
  String nextPage;
  TotalReports totalReports;
  List<Follower> followers;

  factory FollowDetails.fromJson(Map<String, dynamic> json) => FollowDetails(
    start: json["start"].toString(),
    limit: json["limit"].toString(),
    totalPage: json["total_page"].toString(),
    curPage: json["cur_page"].toString(),
    nextPage: json["next_page"].toString(),
    totalReports: TotalReports.fromJson(json["total_reports"]),
    followers: List<Follower>.from(json["followers"].map((x) => Follower.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "limit": limit,
    "total_page": totalPage,
    "cur_page": curPage,
    "next_page": nextPage,
    "total_reports": totalReports.toJson(),
    "followers": List<dynamic>.from(followers.map((x) => x.toJson())),
  };
}

class Follower {
  Follower({
    required this.followingId,
    required this.name,
    required this.profileImage,
  });

  int followingId;
  String name;
  String profileImage;

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
    followingId: json["following_id"],
    name: json["name"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "following_id": followingId,
    "name": name,
    "profile_image": profileImage,
  };
}

class TotalReports {
  TotalReports({
    required this.followCount,
  });

  int followCount;

  factory TotalReports.fromJson(Map<String, dynamic> json) => TotalReports(
    followCount: json["follow_count"],
  );

  Map<String, dynamic> toJson() => {
    "follow_count": followCount,
  };
}
