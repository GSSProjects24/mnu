import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:mnu_app/controllers/sessioncontroller.dart';

import '../models/MessagesModel.dart';

bool isLoading = true;

class MessagesController extends GetxController {
  final Messages = MessagesModel().obs;

  Future<MessagesModel> futureMessage(
    String receiverId,
    String limit,
  ) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data!.userId.toString()!,
      "receiver_id": receiverId,
      "page": '1',
      "limit": limit
    };
    final response = await http.post(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_chat_list'),
        body: body);

    if (response.statusCode == 200) {
      // print(response.body);
      return MessagesModel.fromJson(jsonDecode(response.body));
    } else {
      // print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> futureSeen(String receiverId) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data!.userId.toString()!,
      "receiver_id": receiverId
    };
    final response = await http.put(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_user_chat_seen'),
        body: body);

    if (response.statusCode == 200) {
      // print(response.body);
      return jsonDecode(response.body);
    } else {
      // print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> futureDeleteMulti(
      String receiverId, List<String?> list) async {
    Map<String, dynamic> body = {
      "user_id":
          Get.find<SessionController>().session.value.data!.userId.toString()!,
      "chat_id": list.toList(),
      "status": 1
    };
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_usermultiple_chat_delete'),
        headers: {"Content-Type": 'application/json'},
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> futuresend(
      String receiverId, String messages) async {
    var body = {
      "sender_id":
          Get.find<SessionController>().session.value.data!.userId.toString() ??
              '',
      "receiver_id": receiverId,
      "message": messages
    };
    final response = await http.post(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_user_chat'),
        body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> futureSenderChatDelete(
      String chatId, String status) async {
    var body = {"status": status, "chat_id": chatId};
    final response = await http.put(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_user_sender_chat_delete'),
        body: body);

    if (response.statusCode == 200) {
      print(body);
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> futureReceiverChatDelete(
      String chatId, String status) async {
    var body = {
      "status": status,
      "chat_id": chatId,
      "user_id":
          Get.find<SessionController>().session.value.data!.userId.toString() ??
              ''
    };
    final response = await http.put(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_user_receiver_chat_delete'),
        body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> futureOverallChatDelete(
      String chatId, String status) async {
    var body = {
      "status": status,
      "chat_id": chatId,
      "user_id":
          Get.find<SessionController>().session.value.data!.userId.toString() ??
              '',
    };
    final response = await http.put(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_user_chat_overall_delete'),
        body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  void senderDelete(
      {required String chatId,
      required String status,
      required String receiverId,
      required String limit}) {
    futureSenderChatDelete(chatId, status).then((value) async {
      if (value["data"]["status"] == true) {
        isLoading = false;

        Messages.value = await futureMessage(receiverId, limit);
        update();
        isLoading = true;
        loadMessages(receiverId: receiverId, limit: limit);
      }
    });
  }

  void ReceiverDelete(
      {required String chatId,
      required String status,
      required String receiverId}) {
    futureReceiverChatDelete(chatId, status).then((value) async {
      if (value["data"]["status"] == true) {
        update();
      }
    });
  }

  void overAllchatDelete(
      {required String chatId,
      required String status,
      required String receiverId}) {
    futureOverallChatDelete(chatId, status).then((value) async {
      if (value["data"]["status"] == true) {}
    });
  }

  void sendMessgae({required String receiverId, required String message}) {
    futuresend(receiverId, message).then((value) async {
      if (value["data"]["status"] == true) {}
    });
  }

  void loadMessages({required String receiverId, required String limit}) async {
    MessagesModel? messages;

    while (isLoading) {
      Messages.value = await futureMessage(receiverId, limit);
      update();

      await futureSeen(receiverId);

      if (isLoading == false) {
        print('**********************loading Stopped*********************');
        break;
      }
    }

    print('**********************loading Stopped*********************');
  }
}
