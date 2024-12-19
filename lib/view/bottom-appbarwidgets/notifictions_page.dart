import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mnu_app/theme/myfonts.dart';
import 'package:mnu_app/view/bottom-appbarwidgets/post_list_view_home.dart';
import 'package:mnu_app/view/homePage.dart';
// import 'package:mnu_app/main.dart';
// import 'package:mnu_app/view/bottom-appbarwidgets/single_post_view.dart';
import '../../models/pendngrequestmodel.dart';
import '../../controllers/sessioncontroller.dart';
import '../../main.dart';
import '../../models/notifications_model.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;

import '../../models/pendngrequestmodel.dart';
import '../profile/friend_requestlist.dart';
import '../profile/friends-profile.dart';
import '../widgets/custom_progress_indicator.dart';
import 'single_post_view.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    required this.user_ids,
  });
  final String user_ids;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<NotificationsModel> list;
  Future<PendingRequestModel> loadPendingList() async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data!.userId.toString()
    };

    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_pending_followrequest_list'),
        body: body);

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return PendingRequestModel.fromJson(jsonDecode(response.body));
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> notify() async {
    debugPrint('eeeeeeeee11111111111111111111111111111');
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString() ??
              '',
    };
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_notification_view_change_full'),
        body: body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return (jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<NotificationsModel> loadNotifications() async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString() ??
              '',
      "page": "1",
      "limit": "50"
    };
    final response = await http.post(
      Uri.parse(
          'http://mnuapi.graspsoftwaresolutions.com/api_push_notification'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return NotificationsModel.fromJson(jsonDecode(response.body));
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> clearAllNotification(String? userId) async {
    var body = {"user_id": userId};
    debugPrint(Get.find<SessionController>().session.value.data?.userId.toString());
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_push_notification_clearall'),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"});
    if (kDebugMode) {
      print(body);
    }
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return jsonDecode(response.body);
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    list = loadNotifications();
    notify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const HomePage());
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: clrschm.primary,
            title: const Text(
              'Notifications',
              style: TextStyle(color: Colors.white),
            ),
            automaticallyImplyLeading: false,
            actions: [
              badges.Badge(
                badgeStyle: badges.BadgeStyle(badgeColor: clrschm.primary),
                position: badges.BadgePosition.topStart(),
                badgeContent: FutureBuilder<PendingRequestModel>(
                    future: loadPendingList(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Text('');
                        }
                      }
                      return Text(
                        snapshot.data!.data!.followDetails!.totalReports!
                            .followCount
                            .toString(),
                        style: const TextStyle(color: Colors.white),
                      );
                    }),
                child: IconButton(
                  onPressed: () {
                    Get.to(() => const FriendRequests());
                  },
                  icon: const Icon(
                    Icons.person_add_alt_1_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              // IconButton(onPressed: () async {
              //  await loadNotifications();
              // },icon: Icon(Icons.person_add_alt_1_rounded),)
            ],
          ),
          body: FutureBuilder<NotificationsModel>(
            future: list,
            builder: (BuildContext context,
                AsyncSnapshot<NotificationsModel> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    // Clear Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (snapshot.data?.data?.status != false)
                          GestureDetector(
                            onTap: () async {
                              debugPrint(
                                  "clearId:${Get.find<SessionController>().session.value.data!.userId}");
                              debugPrint("list:${snapshot.data?.data?.status}");
                              var data = await clearAllNotification(
                                  Get.find<SessionController>()
                                      .session
                                      .value
                                      .data!
                                      .userId
                                      .toString());

                              if (data["data"]["status"] == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(data['message'])));
                                setState(() {
                                  list = loadNotifications();
                                  notify();
                                });
                              }
                              if (data["data"]["status"] == false) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(data['message'])));
                                Navigator.of(context).pop();
                              }
                            },
                            child: Container(
                              height: 30,
                              width: 60,
                              margin: const EdgeInsets.all(15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.black,
                                      width:
                                          1)), // Align to the right side of the container
                              child: const Text(
                                'Clear',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    // List of Notifications
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.data?.notifcationDetails
                                ?.notications?.length ??
                            0,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: clrschm.onPrimary,
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: ListTile(
                                        onTap: () {
                                          if (snapshot
                                                      .data
                                                      ?.data
                                                      ?.notifcationDetails
                                                      ?.notications?[index]
                                                      .category
                                                      .toString() ==
                                                  'post' ||
                                              snapshot
                                                      .data
                                                      ?.data
                                                      ?.notifcationDetails
                                                      ?.notications?[index]
                                                      .category
                                                      .toString() ==
                                                  'comment' ||
                                              snapshot
                                                      .data
                                                      ?.data
                                                      ?.notifcationDetails
                                                      ?.notications?[index]
                                                      .category
                                                      .toString() ==
                                                  'like') {
                                            Get.to(() => SinglePostView(
                                                  postId: snapshot
                                                          .data
                                                          ?.data
                                                          ?.notifcationDetails
                                                          ?.notications?[index]
                                                          .postDetails
                                                          ?.postId
                                                          .toString() ??
                                                      '',
                                                ));
                                          }
                                          if (snapshot
                                                  .data
                                                  ?.data
                                                  ?.notifcationDetails
                                                  ?.notications?[index]
                                                  .heading ==
                                              "follow accept.") {
                                            Get.to(() => FriendsProfile(
                                                  memberNo: snapshot
                                                          .data
                                                          ?.data
                                                          ?.notifcationDetails
                                                          ?.notications?[index]
                                                          .userDetails
                                                          ?.userId
                                                          .toString() ??
                                                      '',
                                                  name: '',
                                                ));
                                          }
                                        },
                                        dense: true,
                                        leading: CircleAvatar(
                                          backgroundImage: const AssetImage(
                                              'assets/profile.png'),
                                          foregroundImage: NetworkImage(
                                            snapshot
                                                        .data
                                                        ?.data
                                                        ?.notifcationDetails
                                                        ?.notications?[index]
                                                        .userDetails
                                                        ?.profileImg
                                                        ?.isNotEmpty ==
                                                    true
                                                ? snapshot
                                                        .data
                                                        ?.data
                                                        ?.notifcationDetails
                                                        ?.notications![index]
                                                        .userDetails
                                                        ?.profileImg
                                                        ?.toString() ??
                                                    ''
                                                : 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png',
                                          ),
                                        ),
                                        title: Text(snapshot
                                                .data
                                                ?.data
                                                ?.notifcationDetails
                                                ?.notications![index]
                                                .userDetails
                                                ?.name
                                                ?.toString() ??
                                            ''),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(snapshot
                                                    .data
                                                    ?.data
                                                    ?.notifcationDetails
                                                    ?.notications![index]
                                                    .heading
                                                    ?.toString() ??
                                                ''),
                                            Text(
                                              snapshot
                                                      .data!
                                                      .data!
                                                      .notifcationDetails!
                                                      .notications![index]
                                                      .message ??
                                                  '',
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.4)),
                                            ),
                                            (snapshot
                                                        .data!
                                                        .data!
                                                        .notifcationDetails!
                                                        .notications![index]
                                                        .postDetails!
                                                        .content
                                                        .toString()) ==
                                                    "null"
                                                ? Container()
                                                : Text(
                                                    snapshot
                                                        .data!
                                                        .data!
                                                        .notifcationDetails!
                                                        .notications![index]
                                                        .postDetails!
                                                        .content
                                                        .toString(),
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Text(
                                                  DateFormat('h:mm a').format(
                                                    DateFormat('HH:mm').parse(
                                                        snapshot
                                                                .data
                                                                ?.data
                                                                ?.notifcationDetails
                                                                ?.notications?[
                                                                    index]
                                                                .time ??
                                                            ''),
                                                  ),
                                                  style: const TextStyle(
                                                      fontSize: 8),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  DateFormat('MMMM d, y ')
                                                      .format(snapshot
                                                          .data!
                                                          .data!
                                                          .notifcationDetails!
                                                          .notications![index]
                                                          .date!),
                                                  style: const TextStyle(
                                                      fontSize: 8),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    (snapshot
                                                    .data!
                                                    .data!
                                                    .notifcationDetails!
                                                    .notications![index]
                                                    .postDetails !=
                                                null &&
                                            snapshot
                                                .data!
                                                .data!
                                                .notifcationDetails!
                                                .notications![index]
                                                .postDetails!
                                                .image
                                                .isNotEmpty)
                                        ? Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: 80,
                                                width: 150,
                                                child: InkWell(
                                                  onTap: () {
                                                    if (snapshot
                                                                .data
                                                                ?.data
                                                                ?.notifcationDetails
                                                                ?.notications?[
                                                                    index]
                                                                .category
                                                                .toString() ==
                                                            'post' ||
                                                        snapshot
                                                                .data
                                                                ?.data
                                                                ?.notifcationDetails
                                                                ?.notications?[
                                                                    index]
                                                                .category
                                                                .toString() ==
                                                            'comment' ||
                                                        snapshot
                                                                .data
                                                                ?.data
                                                                ?.notifcationDetails
                                                                ?.notications?[
                                                                    index]
                                                                .category
                                                                .toString() ==
                                                            'like') {
                                                      Get.to(
                                                          () => SinglePostView(
                                                                postId: snapshot
                                                                        .data
                                                                        ?.data
                                                                        ?.notifcationDetails
                                                                        ?.notications?[
                                                                            index]
                                                                        .postDetails
                                                                        ?.postId
                                                                        .toString() ??
                                                                    '',
                                                              ));
                                                    }
                                                    if (snapshot
                                                            .data
                                                            ?.data
                                                            ?.notifcationDetails
                                                            ?.notications?[
                                                                index]
                                                            .heading ==
                                                        "follow accept.") {
                                                      Get.to(
                                                          () => FriendsProfile(
                                                                memberNo: snapshot
                                                                        .data
                                                                        ?.data
                                                                        ?.notifcationDetails
                                                                        ?.notications?[
                                                                            index]
                                                                        .userDetails
                                                                        ?.userId
                                                                        .toString() ??
                                                                    '',
                                                                name: '',
                                                              ));
                                                    }
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Image.network(
                                                      snapshot
                                                          .data!
                                                          .data!
                                                          .notifcationDetails!
                                                          .notications![index]
                                                          .postDetails!
                                                          .image[0]
                                                          .toString(),
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : const Text(''),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return const Center(child: CustomProgressIndicator());
              }
            },
          )),
    );
  }
}
