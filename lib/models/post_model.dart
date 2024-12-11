// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Post? postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post? data) => json.encode(data!.toJson());

class Post {
  Post({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
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
    this.postDetails,
    this.status,
  });

  PostDetails? postDetails;
  bool? status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    postDetails: PostDetails.fromJson(json["post_details"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "post_details": postDetails!.toJson(),
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
  int? limit;
  int? totalPage;
  int? curPage;
  int? nextPage;
  TotalReports? totalReports;
  List<PostElement?>? posts;

  factory PostDetails.fromJson(Map<String, dynamic> json) => PostDetails(
    start: json["start"],
    limit: int.parse(json["limit"].toString()),
    totalPage: int.parse(json["total_page"].toString()),
    curPage: int.parse(json["cur_page"].toString()),
    // nextPage:int.parse( json["next_page"].toString()),
    totalReports: TotalReports.fromJson(json["total_reports"]),
    posts: json["posts"] == null ? [] : List<PostElement?>.from(json["posts"]!.map((x) => PostElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "limit": limit,
    "total_page": totalPage,
    "cur_page": curPage,
    "next_page": nextPage,
    "total_reports": totalReports!.toJson(),
    "posts": posts == null ? [] : List<dynamic>.from(posts!.map((x) => x!.toJson())),
  };
}

class PostElement {
  PostElement({
    this.postId,
    this.userId,
    this.title,
    this.content,
    this.image,
    this.video,
    this.commentCount,
    this.comments,
    this.likeCount,
    this.isLiked,
  });

  int? postId;
  int? userId;
  String? title;
  String? content;
  List<dynamic>? image;
  dynamic video;
  int? commentCount;
  List<Comment?>? comments;
  int? likeCount;
  int? isLiked;

  factory PostElement.fromJson(Map<String, dynamic> json) => PostElement(
    postId: json["post_id"],
    userId: json["user_id"],
    title: json["title"],
    content: json["content"],
    image: json["image"].toString()=='0'?[]:json["image"],
    video: json["video"],
    commentCount: json["comment_count"],
    comments: json["comments"] == null ? [] : List<Comment?>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
    likeCount: json["like_count"],
    isLiked: json["is_liked"],
  );

  Map<String, dynamic> toJson() => {
    "post_id": postId,
    "user_id": userId,
    "title": title,
    "content": content,
    "image": image,
    "video": video,
    "comment_count": commentCount,
    "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x!.toJson())),
    "like_count": likeCount,
    "is_liked": isLiked,
  };
}

class Comment {
  Comment({
    this.commentId,
    this.userId,
    this.commentedUserName,
    this.comment,
    this.date,
    this.time,
  });

  int? commentId;
  int? userId;
  String? commentedUserName;
  String? comment;
  String? date;
  String? time;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    commentId: json["comment_id"],
    userId: json["user_id"],
    commentedUserName: json["commented_user_name"],
    comment: json["comment"],
    date: json["date"],
    time: json["time"],
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
