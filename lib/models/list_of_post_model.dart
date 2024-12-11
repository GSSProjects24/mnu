// To parse this JSON data, do
//
//     final listOfPostModel = listOfPostModelFromJson(jsonString);

import 'dart:convert';
class ListOfPostModel {
  ListOfPostModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory ListOfPostModel.fromJson(Map<String, dynamic> json) => ListOfPostModel(
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

class Data {
  Data({
    this.postDetails,
    this.status,
  });

  PostDetails? postDetails;
  bool? status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    postDetails: json["post_details"] != null ? PostDetails.fromJson(json["post_details"]) : null,
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "post_details": postDetails?.toJson(),
    "status": status,
  };
}

class PostDetails {
  PostDetails({
    this.start,
    this.limit,
    this.totalPage,
    this.curPage,
    this.nextPage,
    this.totalReports,
    this.posts,
  });

  int? start;
  String? limit;
  String? totalPage;
  String? curPage;
  String? nextPage;
  TotalReports? totalReports;
  List<Post?>? posts;

  factory PostDetails.fromJson(Map<String, dynamic> json) => PostDetails(
    start: json["start"],
    limit: json["limit"]?.toString(),
    totalPage: json["total_page"]?.toString(),
    curPage: json["cur_page"]?.toString(),
    nextPage: json["next_page"]?.toString(),
    totalReports: json["total_reports"] != null ? TotalReports.fromJson(json["total_reports"]) : null,
    posts: json["posts"] != null
        ? List<Post?>.from(json["posts"].map((x) => x != null ? Post.fromJson(x) : null))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "limit": limit,
    "total_page": totalPage,
    "cur_page": curPage,
    "next_page": nextPage,
    "total_reports": totalReports?.toJson(),
    "posts": posts != null ? List<dynamic>.from(posts!.map((x) => x?.toJson())) : [],
  };
}

class Post {
  Post(
      {this.postId,
      this.title,
      this.content,
      this.image,
      this.video,
      this.userDetails,
      this.commentCount,
      this.comments,
      this.likeCount,
      this.isLiked,
      this.date,
      this.time});

  int? postId;
  String? title;
  String? content;
  List<dynamic>? image;
  List<dynamic>? video;
  UserDetails? userDetails;
  int? commentCount;
  List<Comment?>? comments;
  int? likeCount;
  int? isLiked;
  String? date;
  String? time;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        postId: json["post_id"],
        title: json["title"],
        content: json["content"],
        image: json["image"].toString() == '0' ? [] : json["image"],
        video: json["video"].toString() == '0' ? [] : json["video"],
        userDetails: UserDetails.fromJson(json["user_details"]),
        commentCount: json["comment_count"],
        comments: json["comments"] == null
            ? []
            : List<Comment?>.from(
                json["comments"]!.map((x) => Comment.fromJson(x))),
        likeCount: json["like_count"],
        isLiked: json["is_liked"],
        date: json["date"]!.toString(),
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "title": title,
        "content": content,
        "image": image,
        "video": video,
        "user_details": userDetails!.toJson(),
        "comment_count": commentCount,
        "comments": comments == null
            ? []
            : List<dynamic>.from(comments!.map((x) => x!.toJson())),
        "like_count": likeCount,
        "is_liked": isLiked,
      };
}

class Comment {
  Comment(
      {this.commentId,
      this.userId,
      this.commentedUserName,
      this.comment,
      this.date,
      this.time,
      this.replyComment,
      this.profileImage});

  int? commentId;
  int? userId;
  String? commentedUserName;
  String? comment;
  String? date;
  String? time;
  String? profileImage;
  List<Comment>? replyComment;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        commentId: json["comment_id"],
        userId: json["user_id"],
        commentedUserName: json["commented_user_name"],
        profileImage: json["profile_image"].toString() == '0'
            ? 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'
            : json["profile_image"],
        comment: json["comment"],
        date: json["date"],
        time: json["time"],
        replyComment: json["reply_comment"] == null
            ? []
            : List<Comment>.from(
                json["reply_comment"]!.map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "user_id": userId,
        "commented_user_name": commentedUserName,
        "comment": comment,
        "date": date,
        "time": time,
      };
}

enum CommentedUserName { RAMPOWIZ, HASSAN, DENNY, ADMIN, RAJESH, RAMPOWIZARD }

final commentedUserNameValues = EnumValues({
  "admin": CommentedUserName.ADMIN,
  "DENNY": CommentedUserName.DENNY,
  "HASSAN": CommentedUserName.HASSAN,
  "rajesh": CommentedUserName.RAJESH,
  "Rampowiz": CommentedUserName.RAMPOWIZ,
  "rampowizard": CommentedUserName.RAMPOWIZARD
});

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

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "ic_no_new": icNoNew,
        "company_names": companyNames,
        "profile_img": profileImg,
      };
}

class TotalReports {
  TotalReports({
    this.postCount,
  });

  int? postCount;

  factory TotalReports.fromJson(Map<String, dynamic> json) => TotalReports(
        postCount: json["post_count"],
      );

  Map<String, dynamic> toJson() => {
        "post_count": postCount,
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
