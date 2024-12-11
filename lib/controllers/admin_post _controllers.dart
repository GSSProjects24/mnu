import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../models/post_model.dart';
import 'sessioncontroller.dart';

class AdminPostController extends GetxController {
  final post = Post().obs;

  Future<Map<String, dynamic>> postComment(
      {required BuildContext context,
      required String post_id,
      required String comment_user_id,
      required String comment}) async {
    final response = await http.put(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_post_comment'),
        body: {
          "post_id": post_id,
          "comment_user_id": comment_user_id,
          "comment": comment
        });

    if (response.statusCode == 200) {
      print(jsonDecode(response.body)["data"]["status"]);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonDecode(response.body)["message"])));

      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Post> loadPost(String? search, int limit) async {
    final response = await http.post(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_post_list'),
        body: {
          "user_id": Get.find<SessionController>()
                  .session
                  .value
                  .data!
                  .userId
                  .toString() ??
              '',
          // "search": search.toString()??'',
          "page": '1',
          "limit": limit.toString()
        });

    if (response.statusCode == 200) {
      print(response.body);
      return Post.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
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
      print(jsonDecode(response.body)["data"]["status"]);

      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }
}
