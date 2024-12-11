import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:mnu_app/controllers/sessioncontroller.dart';
import 'package:mnu_app/models/hidePostListModel.dart';

import '../models/list_of_post_model.dart';
import '../models/single_post_view.dart';

class HidePostController extends GetxController {
  var data;
  var noPosts = false.obs;
  final Rx<HidePostListModel> post = HidePostListModel().obs;

  Future<Map<String, dynamic>> postComment(
      {required BuildContext context,
      required String post_id,
      required String comment_user_id,
      required String comment}) async {
    Map<String, dynamic> body = {
      "post_id": post_id,
      "comment_user_id": comment_user_id,
      "comment": comment
    };
    final response = await http.put(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_post_comment'),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      print(body);
      print(jsonDecode(response.body)["data"]["status"]);

      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> postreplyComment(
      {required BuildContext context,
      required String post_id,
      required String parent_comment_id,
      required String comment}) async {
    Map<String, dynamic> body = {
      "post_id": post_id,
      "comment_user_id":
          Get.find<SessionController>().session.value.data?.userId ?? '',
      "parent_commentid": parent_comment_id,
      "comment": comment
    };
    final response = await http.put(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_post_reply_comment'),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      print(body);
      print(jsonDecode(response.body)["data"]["status"]);

      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<HidePostListModel> hidePost(
      String? search, int limit, String url) async {
    final response = await http.post(Uri.parse(url), body: {
      "user_id":
          Get.find<SessionController>().session.value.data!.userId.toString(),
      "limit": limit.toString()
      // "search": search??''
    });

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      return HidePostListModel.fromJson(jsonDecode(response.body));
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> CommentDelete(String commentId) async {
    var body = {
      "user_id": '1',
      // Get.find<SessionController>().session.value.data?.userId.toString()??'',
      "comment_id": commentId
    };

    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_comment_delete'),
        body: body);

    if (response.statusCode == 200) {
      print(response.body);

      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> postLike(
      int like, int postId, int likeuserId) async {
    var body = {
      "like_unlike": like.toString(),
      "post_id": postId.toString(),
      "like_user_id": likeuserId.toString(),
    };

    final response = await http.post(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_post_like'),
        body: body);

    if (response.statusCode == 200) {
      print(response.body);

      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }
}
