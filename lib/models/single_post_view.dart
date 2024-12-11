// To parse this JSON data, do
//
//     final singlePostViewModel = singlePostViewModelFromJson(jsonString);

import 'dart:convert';

SinglePostViewModel singlePostViewModelFromJson(String str) =>
    SinglePostViewModel.fromJson(json.decode(str));

String singlePostViewModelToJson(SinglePostViewModel data) =>
    json.encode(data.toJson());

class SinglePostViewModel {
  SinglePostViewModel({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  Data data;
  String message;

  factory SinglePostViewModel.fromJson(Map<String, dynamic> json) =>
      SinglePostViewModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    required this.postDetails,
    required this.status,
    this.errorMsg,
  });

  PostDetails postDetails;
  bool status;
  dynamic errorMsg;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        postDetails: PostDetails.fromJson(json["post_details"]),
        status: json["status"],
        errorMsg: json["error_msg"],
      );

  Map<String, dynamic> toJson() => {
        "post_details": postDetails.toJson(),
        "status": status,
        "error_msg": errorMsg,
      };
}

class PostDetails {
  PostDetails(
      {this.postId,
      this.userId,
      this.views,
      this.title,
      this.content,
      this.image,
      this.video,
      this.date,
      this.time,
      this.commentCount,
      this.comments,
      this.likeCount,
      this.userDetails,
      this.isLiked});

  int? postId;
  int? userId;
  int? views;
  String? title;
  String? content;
  List<String>? image;
  List<String>? video;
  String? date;
  String? time;
  UserDetails? userDetails;
  int? commentCount;
  List<Comment?>? comments;
  int? likeCount;
  int? isLiked;

  factory PostDetails.fromJson(Map<String, dynamic> json) => PostDetails(
        postId: json["post_id"],
        userId: json["user_id"],
        views: json["views"],
        title: json["title"],
        content: json["content"],
        image: List<String>.from(json["image"].map((x) => x)),
        video: List<String>.from(json["video"].map((x) => x)),
        date: json["date"],
        time: json["time"],
        commentCount: json["comment_count"],
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
        likeCount: json["like_count"],
        userDetails: UserDetails.fromJson(json["user_details"]),
        isLiked: json["is_liked"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "user_id": userId,
        "title": title,
        "content": content,
        "image": List<dynamic>.from(image!.map((x) => x)),
        "video": List<dynamic>.from(video!.map((x) => x)),
        "date": date,
        "time": time,
        "comment_count": commentCount,
        "comments": List<dynamic>.from(comments!.map((x) => x?.toJson())),
        "like_count": likeCount,
      };
}

class Comment {
  Comment({
    required this.commentId,
    required this.userId,
    required this.commentedUserName,
    required this.profileImage,
    required this.comment,
    required this.date,
    required this.time,
    required this.replyComment,
  });

  int commentId;
  int userId;
  String commentedUserName;
  String? profileImage;
  String comment;
  String date;
  String time;
  List<ReplyComment> replyComment;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        commentId: json["comment_id"],
        userId: json["user_id"],
        commentedUserName: json["commented_user_name"],
        profileImage: json["profile_image"] == '0'
            ? 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'
            : json["profile_image"],
        comment: json["comment"],
        date: json["date"],
        time: json["time"],
        replyComment: List<ReplyComment>.from(
            json["reply_comment"].map((x) => ReplyComment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "user_id": userId,
        "commented_user_name": commentedUserName,
        "profile_image": profileImage,
        "comment": comment,
        "date": date,
        "time": time,
        "reply_comment":
            List<dynamic>.from(replyComment.map((x) => x.toJson())),
      };
}

class ReplyComment {
  ReplyComment({
    required this.commentId,
    required this.userId,
    required this.commentedUserName,
    required this.profileImage,
    required this.comment,
    required this.date,
    required this.time,
  });

  int? commentId;
  int? userId;
  String? commentedUserName;
  String? profileImage;
  String? comment;
  String? date;
  String? time;

  factory ReplyComment.fromJson(Map<String, dynamic> json) => ReplyComment(
        commentId: json["comment_id"],
        userId: json["user_id"],
        commentedUserName: json["commented_user_name"],
        profileImage: json["profile_image"].toString() == '0'
            ? 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'
            : json["profile_image"],
        comment: json["comment"],
        date: json["date"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "user_id": userId,
        "commented_user_name": commentedUserName,
        "profile_image": profileImage,
        "comment": comment,
        "date": date,
        "time": time,
      };
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
        profileImg: json["profile_img"].toString() == '0'
            ? 'http://mnumalaysia.blogspot.com/'
            : json["profile_img"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "ic_no_new": icNoNew,
        "company_names": companyNames,
        "profile_img": profileImg,
      };
}
