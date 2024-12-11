/// success : true
/// data : {"post_details":{"start":0,"limit":150,"total_page":1,"cur_page":1,"total_reports":{"post_count":3},"posts":[{"post_id":183,"title":"function","views":0,"content":"hgbjjj","image":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756deb09549d.jpeg","https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756deb095984.jpeg"],"video":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756deb09ac34.mp4"],"date":"09/12/2024","time":"20:12:32","user_details":{"user_id":581,"name":"jaya","ic_no_new":"125323562323","company_names":"MNU","profile_img":""},"comment_count":5,"comments":[{"comment_id":69,"user_id":554,"commented_user_name":"gayu","profile_image":"","comment":"super cute 🥰","date":"09/12/2024","time":"20:14:06","reply_comment":[{"comment_id":70,"user_id":581,"commented_user_name":"jayakumari","profile_image":0,"comment":"","date":"09/12/2024","time":"20:17:08"},{"comment_id":71,"user_id":581,"commented_user_name":"jayakumari","profile_image":0,"comment":"thanks","date":"09/12/2024","time":"20:17:19"}]},{"comment_id":68,"user_id":554,"commented_user_name":"gayu","profile_image":"","comment":"nice 👍","date":"09/12/2024","time":"20:13:47","reply_comment":[{"comment_id":72,"user_id":581,"commented_user_name":"jayakumari","profile_image":0,"comment":"🙏","date":"09/12/2024","time":"20:17:42"}]}],"like_count":0,"is_liked":0},{"post_id":182,"title":"temple","views":0,"content":"most popular temples","image":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756dcb18bc69.jpeg","https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756dcb18c0f6.jpeg"],"video":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756dcb1b1e09.mp4"],"date":"09/12/2024","time":"20:04:01","user_details":{"user_id":581,"name":"jaya","ic_no_new":"125323562323","company_names":"MNU","profile_img":""},"comment_count":0,"comments":[],"like_count":0,"is_liked":0},{"post_id":180,"title":"my post","views":1,"content":"hgfbhj","image":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/67569e4e54d5c.jpeg"],"video":[],"date":"09/12/2024","time":"15:36:57","user_details":{"user_id":581,"name":"jaya","ic_no_new":"125323562323","company_names":"MNU","profile_img":""},"comment_count":0,"comments":[],"like_count":0,"is_liked":0}]},"status":true,"error_msg":""}
/// message : "Post detail found."

class HidePostListModel {
  HidePostListModel({
    bool? success,
    Data? data,
    String? message,
  }) {
    _success = success;
    _data = data;
    _message = message;
  }

  HidePostListModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
  }
  bool? _success;
  Data? _data;
  String? _message;
  HidePostListModel copyWith({
    bool? success,
    Data? data,
    String? message,
  }) =>
      HidePostListModel(
        success: success ?? _success,
        data: data ?? _data,
        message: message ?? _message,
      );
  bool? get success => _success;
  Data? get data => _data;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['message'] = _message;
    return map;
  }
}

/// post_details : {"start":0,"limit":150,"total_page":1,"cur_page":1,"total_reports":{"post_count":3},"posts":[{"post_id":183,"title":"function","views":0,"content":"hgbjjj","image":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756deb09549d.jpeg","https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756deb095984.jpeg"],"video":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756deb09ac34.mp4"],"date":"09/12/2024","time":"20:12:32","user_details":{"user_id":581,"name":"jaya","ic_no_new":"125323562323","company_names":"MNU","profile_img":""},"comment_count":5,"comments":[{"comment_id":69,"user_id":554,"commented_user_name":"gayu","profile_image":"","comment":"super cute 🥰","date":"09/12/2024","time":"20:14:06","reply_comment":[{"comment_id":70,"user_id":581,"commented_user_name":"jayakumari","profile_image":0,"comment":"","date":"09/12/2024","time":"20:17:08"},{"comment_id":71,"user_id":581,"commented_user_name":"jayakumari","profile_image":0,"comment":"thanks","date":"09/12/2024","time":"20:17:19"}]},{"comment_id":68,"user_id":554,"commented_user_name":"gayu","profile_image":"","comment":"nice 👍","date":"09/12/2024","time":"20:13:47","reply_comment":[{"comment_id":72,"user_id":581,"commented_user_name":"jayakumari","profile_image":0,"comment":"🙏","date":"09/12/2024","time":"20:17:42"}]}],"like_count":0,"is_liked":0},{"post_id":182,"title":"temple","views":0,"content":"most popular temples","image":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756dcb18bc69.jpeg","https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756dcb18c0f6.jpeg"],"video":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756dcb1b1e09.mp4"],"date":"09/12/2024","time":"20:04:01","user_details":{"user_id":581,"name":"jaya","ic_no_new":"125323562323","company_names":"MNU","profile_img":""},"comment_count":0,"comments":[],"like_count":0,"is_liked":0},{"post_id":180,"title":"my post","views":1,"content":"hgfbhj","image":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/67569e4e54d5c.jpeg"],"video":[],"date":"09/12/2024","time":"15:36:57","user_details":{"user_id":581,"name":"jaya","ic_no_new":"125323562323","company_names":"MNU","profile_img":""},"comment_count":0,"comments":[],"like_count":0,"is_liked":0}]}
/// status : true
/// error_msg : ""

class Data {
  Data({
    PostDetails? postDetails,
    bool? status,
    String? errorMsg,
  }) {
    _postDetails = postDetails;
    _status = status;
    _errorMsg = errorMsg;
  }

  Data.fromJson(dynamic json) {
    _postDetails = json['post_details'] != null
        ? PostDetails.fromJson(json['post_details'])
        : null;
    _status = json['status'];
    _errorMsg = json['error_msg'];
  }
  PostDetails? _postDetails;
  bool? _status;
  String? _errorMsg;
  Data copyWith({
    PostDetails? postDetails,
    bool? status,
    String? errorMsg,
  }) =>
      Data(
        postDetails: postDetails ?? _postDetails,
        status: status ?? _status,
        errorMsg: errorMsg ?? _errorMsg,
      );
  PostDetails? get postDetails => _postDetails;
  bool? get status => _status;
  String? get errorMsg => _errorMsg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_postDetails != null) {
      map['post_details'] = _postDetails?.toJson();
    }
    map['status'] = _status;
    map['error_msg'] = _errorMsg;
    return map;
  }
}

/// start : 0
/// limit : 150
/// total_page : 1
/// cur_page : 1
/// total_reports : {"post_count":3}
/// posts : [{"post_id":183,"title":"function","views":0,"content":"hgbjjj","image":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756deb09549d.jpeg","https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756deb095984.jpeg"],"video":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756deb09ac34.mp4"],"date":"09/12/2024","time":"20:12:32","user_details":{"user_id":581,"name":"jaya","ic_no_new":"125323562323","company_names":"MNU","profile_img":""},"comment_count":5,"comments":[{"comment_id":69,"user_id":554,"commented_user_name":"gayu","profile_image":"","comment":"super cute 🥰","date":"09/12/2024","time":"20:14:06","reply_comment":[{"comment_id":70,"user_id":581,"commented_user_name":"jayakumari","profile_image":0,"comment":"","date":"09/12/2024","time":"20:17:08"},{"comment_id":71,"user_id":581,"commented_user_name":"jayakumari","profile_image":0,"comment":"thanks","date":"09/12/2024","time":"20:17:19"}]},{"comment_id":68,"user_id":554,"commented_user_name":"gayu","profile_image":"","comment":"nice 👍","date":"09/12/2024","time":"20:13:47","reply_comment":[{"comment_id":72,"user_id":581,"commented_user_name":"jayakumari","profile_image":0,"comment":"🙏","date":"09/12/2024","time":"20:17:42"}]}],"like_count":0,"is_liked":0},{"post_id":182,"title":"temple","views":0,"content":"most popular temples","image":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756dcb18bc69.jpeg","https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756dcb18c0f6.jpeg"],"video":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756dcb1b1e09.mp4"],"date":"09/12/2024","time":"20:04:01","user_details":{"user_id":581,"name":"jaya","ic_no_new":"125323562323","company_names":"MNU","profile_img":""},"comment_count":0,"comments":[],"like_count":0,"is_liked":0},{"post_id":180,"title":"my post","views":1,"content":"hgfbhj","image":["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/67569e4e54d5c.jpeg"],"video":[],"date":"09/12/2024","time":"15:36:57","user_details":{"user_id":581,"name":"jaya","ic_no_new":"125323562323","company_names":"MNU","profile_img":""},"comment_count":0,"comments":[],"like_count":0,"is_liked":0}]

class PostDetails {
  PostDetails({
    int? start,
    String? limit,
    int? totalPage,
    int? curPage,
    TotalReports? totalReports,
    List<Posts>? posts,
  }) {
    _start = start;
    _limit = limit;
    _totalPage = totalPage;
    _curPage = curPage;
    _totalReports = totalReports;
    _posts = posts;
  }

  PostDetails.fromJson(dynamic json) {
    _start = json['start'];
    _limit = json['limit'];
    _totalPage = json['total_page'];
    _curPage = json['cur_page'];
    _totalReports = json['total_reports'] != null
        ? TotalReports.fromJson(json['total_reports'])
        : null;
    if (json['posts'] != null) {
      _posts = [];
      json['posts'].forEach((v) {
        _posts?.add(Posts.fromJson(v));
      });
    }
  }
  int? _start;
  String? _limit;
  int? _totalPage;
  int? _curPage;
  TotalReports? _totalReports;
  List<Posts>? _posts;
  PostDetails copyWith({
    int? start,
    String? limit,
    int? totalPage,
    int? curPage,
    TotalReports? totalReports,
    List<Posts>? posts,
  }) =>
      PostDetails(
        start: start ?? _start,
        limit: limit ?? _limit,
        totalPage: totalPage ?? _totalPage,
        curPage: curPage ?? _curPage,
        totalReports: totalReports ?? _totalReports,
        posts: posts ?? _posts,
      );
  int? get start => _start;
  String? get limit => _limit;
  int? get totalPage => _totalPage;
  int? get curPage => _curPage;
  TotalReports? get totalReports => _totalReports;
  List<Posts>? get posts => _posts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['start'] = _start;
    map['limit'] = _limit;
    map['total_page'] = _totalPage;
    map['cur_page'] = _curPage;
    if (_totalReports != null) {
      map['total_reports'] = _totalReports?.toJson();
    }
    if (_posts != null) {
      map['posts'] = _posts?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// post_id : 183
/// title : "function"
/// views : 0
/// content : "hgbjjj"
/// image : ["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756deb09549d.jpeg","https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756deb095984.jpeg"]
/// video : ["https://mnuapi.graspsoftwaresolutions.com/public/storage/uploads/posts/6756deb09ac34.mp4"]
/// date : "09/12/2024"
/// time : "20:12:32"
/// user_details : {"user_id":581,"name":"jaya","ic_no_new":"125323562323","company_names":"MNU","profile_img":""}
/// comment_count : 5
/// comments : [{"comment_id":69,"user_id":554,"commented_user_name":"gayu","profile_image":"","comment":"super cute 🥰","date":"09/12/2024","time":"20:14:06","reply_comment":[{"comment_id":70,"user_id":581,"commented_user_name":"jayakumari","profile_image":0,"comment":"","date":"09/12/2024","time":"20:17:08"},{"comment_id":71,"user_id":581,"commented_user_name":"jayakumari","profile_image":0,"comment":"thanks","date":"09/12/2024","time":"20:17:19"}]},{"comment_id":68,"user_id":554,"commented_user_name":"gayu","profile_image":"","comment":"nice 👍","date":"09/12/2024","time":"20:13:47","reply_comment":[{"comment_id":72,"user_id":581,"commented_user_name":"jayakumari","profile_image":0,"comment":"🙏","date":"09/12/2024","time":"20:17:42"}]}]
/// like_count : 0
/// is_liked : 0

class Posts {
  Posts({
    int? postId,
    String? title,
    int? views,
    String? content,
    List<String>? image,
    List<String>? video,
    String? date,
    String? time,
    UserDetails? userDetails,
    int? commentCount,
    List<Comments>? comments,
    int? likeCount,
    int? isLiked,
  }) {
    _postId = postId;
    _title = title;
    _views = views;
    _content = content;
    _image = image;
    _video = video;
    _date = date;
    _time = time;
    _userDetails = userDetails;
    _commentCount = commentCount;
    _comments = comments;
    _likeCount = likeCount;
    _isLiked = isLiked;
  }

  Posts.fromJson(dynamic json) {
    _postId = json['post_id'];
    _title = json['title'];
    _views = json['views'];
    _content = json['content'];
    _image = json['image'] != null ? json['image'].cast<String>() : [];
    _video = json['video'] != null ? json['video'].cast<String>() : [];
    _date = json['date'];
    _time = json['time'];
    _userDetails = json['user_details'] != null
        ? UserDetails.fromJson(json['user_details'])
        : null;
    _commentCount = json['comment_count'];
    if (json['comments'] != null) {
      _comments = [];
      json['comments'].forEach((v) {
        _comments?.add(Comments.fromJson(v));
      });
    }
    _likeCount = json['like_count'];
    _isLiked = json['is_liked'];
  }
  int? _postId;
  String? _title;
  int? _views;
  String? _content;
  List<String>? _image;
  List<String>? _video;
  String? _date;
  String? _time;
  UserDetails? _userDetails;
  int? _commentCount;
  List<Comments>? _comments;
  int? _likeCount;
  int? _isLiked;
  Posts copyWith({
    int? postId,
    String? title,
    int? views,
    String? content,
    List<String>? image,
    List<String>? video,
    String? date,
    String? time,
    UserDetails? userDetails,
    int? commentCount,
    List<Comments>? comments,
    int? likeCount,
    int? isLiked,
  }) =>
      Posts(
        postId: postId ?? _postId,
        title: title ?? _title,
        views: views ?? _views,
        content: content ?? _content,
        image: image ?? _image,
        video: video ?? _video,
        date: date ?? _date,
        time: time ?? _time,
        userDetails: userDetails ?? _userDetails,
        commentCount: commentCount ?? _commentCount,
        comments: comments ?? _comments,
        likeCount: likeCount ?? _likeCount,
        isLiked: isLiked ?? _isLiked,
      );
  int? get postId => _postId;
  String? get title => _title;
  int? get views => _views;
  String? get content => _content;
  List<String>? get image => _image;
  List<String>? get video => _video;
  String? get date => _date;
  String? get time => _time;
  UserDetails? get userDetails => _userDetails;
  int? get commentCount => _commentCount;
  List<Comments>? get comments => _comments;
  int? get likeCount => _likeCount;
  int? get isLiked => _isLiked;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['post_id'] = _postId;
    map['title'] = _title;
    map['views'] = _views;
    map['content'] = _content;
    map['image'] = _image;
    map['video'] = _video;
    map['date'] = _date;
    map['time'] = _time;
    if (_userDetails != null) {
      map['user_details'] = _userDetails?.toJson();
    }
    map['comment_count'] = _commentCount;
    if (_comments != null) {
      map['comments'] = _comments?.map((v) => v.toJson()).toList();
    }
    map['like_count'] = _likeCount;
    map['is_liked'] = _isLiked;
    return map;
  }
}

/// comment_id : 69
/// user_id : 554
/// commented_user_name : "gayu"
/// profile_image : ""
/// comment : "super cute 🥰"
/// date : "09/12/2024"
/// time : "20:14:06"
/// reply_comment : [{"comment_id":70,"user_id":581,"commented_user_name":"jayakumari","profile_image":0,"comment":"","date":"09/12/2024","time":"20:17:08"},{"comment_id":71,"user_id":581,"commented_user_name":"jayakumari","profile_image":0,"comment":"thanks","date":"09/12/2024","time":"20:17:19"}]

class Comments {
  Comments({
    int? commentId,
    int? userId,
    String? commentedUserName,
    String? profileImage,
    String? comment,
    String? date,
    String? time,
    List<ReplyComment>? replyComment,
  }) {
    _commentId = commentId;
    _userId = userId;
    _commentedUserName = commentedUserName;
    _profileImage = profileImage;
    _comment = comment;
    _date = date;
    _time = time;
    _replyComment = replyComment;
  }

  Comments.fromJson(dynamic json) {
    _commentId = json['comment_id'];
    _userId = json['user_id'];
    _commentedUserName = json['commented_user_name'];
    _profileImage = json['profile_image'];
    _comment = json['comment'];
    _date = json['date'];
    _time = json['time'];
    if (json['reply_comment'] != null) {
      _replyComment = [];
      json['reply_comment'].forEach((v) {
        _replyComment?.add(ReplyComment.fromJson(v));
      });
    }
  }
  int? _commentId;
  int? _userId;
  String? _commentedUserName;
  String? _profileImage;
  String? _comment;
  String? _date;
  String? _time;
  List<ReplyComment>? _replyComment;
  Comments copyWith({
    int? commentId,
    int? userId,
    String? commentedUserName,
    String? profileImage,
    String? comment,
    String? date,
    String? time,
    List<ReplyComment>? replyComment,
  }) =>
      Comments(
        commentId: commentId ?? _commentId,
        userId: userId ?? _userId,
        commentedUserName: commentedUserName ?? _commentedUserName,
        profileImage: profileImage ?? _profileImage,
        comment: comment ?? _comment,
        date: date ?? _date,
        time: time ?? _time,
        replyComment: replyComment ?? _replyComment,
      );
  int? get commentId => _commentId;
  int? get userId => _userId;
  String? get commentedUserName => _commentedUserName;
  String? get profileImage => _profileImage;
  String? get comment => _comment;
  String? get date => _date;
  String? get time => _time;
  List<ReplyComment>? get replyComment => _replyComment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['comment_id'] = _commentId;
    map['user_id'] = _userId;
    map['commented_user_name'] = _commentedUserName;
    map['profile_image'] = _profileImage;
    map['comment'] = _comment;
    map['date'] = _date;
    map['time'] = _time;
    if (_replyComment != null) {
      map['reply_comment'] = _replyComment?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// comment_id : 70
/// user_id : 581
/// commented_user_name : "jayakumari"
/// profile_image : 0
/// comment : ""
/// date : "09/12/2024"
/// time : "20:17:08"

class ReplyComment {
  ReplyComment({
    int? commentId,
    int? userId,
    String? commentedUserName,
    int? profileImage,
    String? comment,
    String? date,
    String? time,
  }) {
    _commentId = commentId;
    _userId = userId;
    _commentedUserName = commentedUserName;
    _profileImage = profileImage;
    _comment = comment;
    _date = date;
    _time = time;
  }

  ReplyComment.fromJson(dynamic json) {
    _commentId = json['comment_id'];
    _userId = json['user_id'];
    _commentedUserName = json['commented_user_name'];
    _profileImage = json['profile_image'];
    _comment = json['comment'];
    _date = json['date'];
    _time = json['time'];
  }
  int? _commentId;
  int? _userId;
  String? _commentedUserName;
  int? _profileImage;
  String? _comment;
  String? _date;
  String? _time;
  ReplyComment copyWith({
    int? commentId,
    int? userId,
    String? commentedUserName,
    int? profileImage,
    String? comment,
    String? date,
    String? time,
  }) =>
      ReplyComment(
        commentId: commentId ?? _commentId,
        userId: userId ?? _userId,
        commentedUserName: commentedUserName ?? _commentedUserName,
        profileImage: profileImage ?? _profileImage,
        comment: comment ?? _comment,
        date: date ?? _date,
        time: time ?? _time,
      );
  int? get commentId => _commentId;
  int? get userId => _userId;
  String? get commentedUserName => _commentedUserName;
  int? get profileImage => _profileImage;
  String? get comment => _comment;
  String? get date => _date;
  String? get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['comment_id'] = _commentId;
    map['user_id'] = _userId;
    map['commented_user_name'] = _commentedUserName;
    map['profile_image'] = _profileImage;
    map['comment'] = _comment;
    map['date'] = _date;
    map['time'] = _time;
    return map;
  }
}

/// user_id : 581
/// name : "jaya"
/// ic_no_new : "125323562323"
/// company_names : "MNU"
/// profile_img : ""

class UserDetails {
  UserDetails({
    int? userId,
    String? name,
    String? icNoNew,
    String? companyNames,
    String? profileImg,
  }) {
    _userId = userId;
    _name = name;
    _icNoNew = icNoNew;
    _companyNames = companyNames;
    _profileImg = profileImg;
  }

  UserDetails.fromJson(dynamic json) {
    _userId = json['user_id'];
    _name = json['name'];
    _icNoNew = json['ic_no_new'];
    _companyNames = json['company_names'];
    _profileImg = json['profile_img'];
  }
  int? _userId;
  String? _name;
  String? _icNoNew;
  String? _companyNames;
  String? _profileImg;
  UserDetails copyWith({
    int? userId,
    String? name,
    String? icNoNew,
    String? companyNames,
    String? profileImg,
  }) =>
      UserDetails(
        userId: userId ?? _userId,
        name: name ?? _name,
        icNoNew: icNoNew ?? _icNoNew,
        companyNames: companyNames ?? _companyNames,
        profileImg: profileImg ?? _profileImg,
      );
  int? get userId => _userId;
  String? get name => _name;
  String? get icNoNew => _icNoNew;
  String? get companyNames => _companyNames;
  String? get profileImg => _profileImg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['name'] = _name;
    map['ic_no_new'] = _icNoNew;
    map['company_names'] = _companyNames;
    map['profile_img'] = _profileImg;
    return map;
  }
}

/// post_count : 3

class TotalReports {
  TotalReports({
    int? postCount,
  }) {
    _postCount = postCount;
  }

  TotalReports.fromJson(dynamic json) {
    _postCount = json['post_count'];
  }
  int? _postCount;
  TotalReports copyWith({
    int? postCount,
  }) =>
      TotalReports(
        postCount: postCount ?? _postCount,
      );
  int? get postCount => _postCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['post_count'] = _postCount;
    return map;
  }
}
