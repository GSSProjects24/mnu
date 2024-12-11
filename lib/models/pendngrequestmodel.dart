// To parse this JSON data, do
//
//     final pendingRequestModel = pendingRequestModelFromJson(jsonString);

import 'dart:convert';

PendingRequestModel? pendingRequestModelFromJson(String str) => PendingRequestModel.fromJson(json.decode(str));

String pendingRequestModelToJson(PendingRequestModel? data) => json.encode(data!.toJson());

class PendingRequestModel {
  PendingRequestModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory PendingRequestModel.fromJson(Map<String, dynamic> json) => PendingRequestModel(
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
    this.totalReports,
    this.followers,
  });

  int? start;
  int? limit;
  int? totalPage;
  int? curPage;
  TotalReports? totalReports;
  List<Follower?>? followers;

  factory FollowDetails.fromJson(Map<String, dynamic> json) => FollowDetails(
        start: json["start"],
        limit: json["limit"],
        totalPage: json["total_page"],
        curPage: json["cur_page"],
        totalReports: TotalReports.fromJson(json["total_reports"]),
        followers: json["followers"] == null ? [] : List<Follower?>.from(json["followers"]!.map((x) => Follower.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "limit": limit,
        "total_page": totalPage,
        "cur_page": curPage,
        "total_reports": totalReports!.toJson(),
        "followers": followers == null ? [] : List<dynamic>.from(followers!.map((x) => x!.toJson())),
      };
}

class Follower {
  Follower({
    this.id,
    this.name,
    this.profileImage,
     this.followerUserId,
        this.isFollowing,
    
  });

  int? id;
  String? name;
  String? profileImage;
   int? followerUserId;
  bool? isFollowing;

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
        id: json["id"],
        name: json["name"],
        profileImage: json["profile_image"],
         followerUserId: json["follower_user_id"],
        isFollowing: json["is_following"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_image": profileImage,
         "follower_user_id": followerUserId,
        "is_following": isFollowing,
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
