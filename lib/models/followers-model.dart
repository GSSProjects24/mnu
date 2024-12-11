// To parse this JSON data, do
//
//     final followersModel = followersModelFromJson(jsonString);

import 'dart:convert';

FollowersModel? followersModelFromJson(String str) =>
    FollowersModel.fromJson(json.decode(str));

String followersModelToJson(FollowersModel? data) =>
    json.encode(data!.toJson());

class FollowersModel {
  FollowersModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory FollowersModel.fromJson(Map<String, dynamic> json) => FollowersModel(
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
    this.followDetails,
    this.status,
  });

  FollowDetails? followDetails;
  bool? status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        followDetails: FollowDetails.fromJson(json["follow_details"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "follow_details": followDetails!.toJson(),
        "status": status,
      };
}

class FollowDetails {
  FollowDetails({
    this.start,
    this.limit,
    this.totalPage,
    this.curPage,
    this.nextPage,
    this.totalReports,
    this.followers,
  });

  int? start;
  String? limit;
  String? totalPage;
  String? curPage;
  String? nextPage;
  TotalReports? totalReports;
  List<Follower?>? followers;

  factory FollowDetails.fromJson(Map<String, dynamic> json) => FollowDetails(
        start: json["start"],
        limit: json["limit"].toString(),
        totalPage: json["total_page"].toString(),
        curPage: json["cur_page"].toString(),
        nextPage: json["next_page"].toString(),
        totalReports: TotalReports.fromJson(json["total_reports"]),
        followers: json["followers"] == null
            ? []
            : List<Follower?>.from(
                json["followers"]!.map((x) => Follower.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "limit": limit,
        "total_page": totalPage,
        "cur_page": curPage,
        "next_page": nextPage,
        "total_reports": totalReports!.toJson(),
        "followers": followers == null
            ? []
            : List<dynamic>.from(followers!.map((x) => x!.toJson())),
      };
}

class Follower {
  Follower({
    this.followersId,
    this.name,
    this.profileImage,
  });

  int? followersId;
  String? name;
  String? profileImage;

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
        followersId: json["followers_id"],
        name: json["name"],
        profileImage: json["profile_image"] == 0
            ? 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'
            : json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "followers_id": followersId,
        "name": name,
        "profile_image": profileImage,
      };
}

class TotalReports {
  TotalReports({
    this.followCount,
  });

  int? followCount;

  factory TotalReports.fromJson(Map<String, dynamic> json) => TotalReports(
        followCount: json["follow_count"],
      );

  Map<String, dynamic> toJson() => {
        "follow_count": followCount,
      };
}
