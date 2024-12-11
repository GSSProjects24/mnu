import 'dart:convert';





MemberPostModel? memberPostModelFromJson(String str) => MemberPostModel.fromJson(json.decode(str));

String memberPostModelToJson(MemberPostModel? data) => json.encode(data!.toJson());

class MemberPostModel {
  MemberPostModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory MemberPostModel.fromJson(Map<String, dynamic> json) => MemberPostModel(
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
  List<Post?>? posts;

  factory PostDetails.fromJson(Map<String, dynamic> json) => PostDetails(
    start: json["start"],
    limit: int.parse(json["limit"]),
    totalPage: json["total_page"],
    curPage: int.parse(json["cur_page"]),
    nextPage: json["next_page"],
    totalReports: TotalReports.fromJson(json["total_reports"]),
    posts: json["posts"] == null ? [] : List<Post?>.from(json["posts"]!.map((x) => Post.fromJson(x))),
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

class Post {
  Post({
    this.postId,
    this.title,
    this.content,
    this.image,
    this.video,
    this.userDetails,
    this.commentCount,
    this.comments,
    this.likeCount,
    this.isLiked,
  });

  int? postId;
  String? title;
  String? content;
  List<dynamic>? image;
  dynamic video;
  UserDetails? userDetails;
  int? commentCount;
  List<Comment?>? comments;
  int? likeCount;
  int? isLiked;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    postId: json["post_id"],
    title: json["title"],
    content: json["content"],
    image: json["image"].toString()=='0'?[]:json["image"],
    video: json["video"],
    userDetails: UserDetails.fromJson(json["user_details"]),
    commentCount: json["comment_count"],
    comments: json["comments"] == null ? [] : List<Comment?>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
    likeCount: json["like_count"],
    isLiked: json["is_liked"],
  );

  Map<String, dynamic> toJson() => {
    "post_id": postId,
    "title": title,
    "content": content,
    "image": image,
    "video": video,
    "user_details": userDetails!.toJson(),
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
  IcNoNew? icNoNew;
  CompanyNames? companyNames;
  String? profileImg;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    userId: json["user_id"],
    name: json["name"],
    icNoNew: icNoNewValues!.map[json["ic_no_new"]],
    companyNames: companyNamesValues!.map[json["company_names"]],
    profileImg: json["profile_img"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name":name,
    "ic_no_new": icNoNewValues.reverse![icNoNew],
    "company_names": companyNamesValues.reverse![companyNames],
    "profile_img": profileImg,
  };
}

enum CompanyNames { DENSO_M_SDN_BHD }

final companyNamesValues = EnumValues({
  "DENSO (M) SDN BHD": CompanyNames.DENSO_M_SDN_BHD
});

enum IcNoNew { THE_950424145377 }

final icNoNewValues = EnumValues({
  "950424-14-5377": IcNoNew.THE_950424145377
});





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
