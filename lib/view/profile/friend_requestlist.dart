// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/sessioncontroller.dart';
import '../../models/pendngrequestmodel.dart';
import '../../theme/myfonts.dart';

import 'package:http/http.dart' as http;

import '../widgets/custom_progress_indicator.dart';

late String follower_user_id;
bool accept_status = true;

class FriendRequests extends StatefulWidget {
  const FriendRequests({Key? key}) : super(key: key);

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  bool acceptLoad = false;
  dynamic acceptId;
  Future<PendingRequestModel> loadPendingList() async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data!.userId.toString()
    };

    final response = await http.post(
        Uri.parse(
            'https://api.malayannursesunion.xyz/api_pending_followrequest_list'),
        body: body);

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return PendingRequestModel.fromJson(jsonDecode(response.body));
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> followRequest(String followerId) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "follower_user_id": followerId
    };
    final response = await http.post(
        Uri.parse(
            'https://api.malayannursesunion.xyz/api_followingrequest'),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  late Future<PendingRequestModel> list;

  @override
  void initState() {
    list = loadPendingList();
    debugPrint("acceptLoad:$acceptLoad");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: list,
            builder: (BuildContext context,
                AsyncSnapshot<PendingRequestModel> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount:
                      snapshot.data!.data?.followDetails?.followers?.length,
                  itemBuilder: (BuildContext context, int index) {
                    follower_user_id = snapshot.data!.data!.followDetails!
                        .followers![index]!.followerUserId
                        .toString();
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              onTap: () {
                                // Get.to(()=>FriendsProfile(memberNo: snapshot!.data!.data!.followDetails!.followers![index]!.id.toString(),));
                              },
                              leading: CircleAvatar(
                                backgroundImage:
                                    const AssetImage('assets/profile.png'),
                                foregroundImage: snapshot
                                                .data!
                                                .data!
                                                .followDetails!
                                                .followers![index]!
                                                .profileImage !=
                                            null &&
                                        snapshot
                                            .data!
                                            .data!
                                            .followDetails!
                                            .followers![index]!
                                            .profileImage!
                                            .isNotEmpty
                                    ? NetworkImage(snapshot
                                        .data!
                                        .data!
                                        .followDetails!
                                        .followers![index]!
                                        .profileImage!)
                                    : null,
                              ),
                              title: Container(
                                // width: 300,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Tooltip(
                                    message: snapshot.data!.data!.followDetails!
                                            .followers![index]!.name ??
                                        '',
                                    child: Container(
                                        //  width: 80,
                                        child: Text(
                                            snapshot.data!.data!.followDetails!
                                                    .followers![index]!.name ??
                                                '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: getText(context)
                                                .labelLarge
                                                ?.copyWith(
                                                    fontSize: 8,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                    //Text
                                  ), //Tooltip
                                ),
                              ), //,
                              // title: Tooltip(
                              //     triggerMode: TooltipTriggerMode.manual,
                              //     showDuration: const Duration(seconds: 1),
                              //
                              //     child: Container(width:80,child: Text(snapshot.data!.data!.followDetails!.followers![index]!.name ?? '',maxLines: 1,overflow:TextOverflow.ellipsis,softWrap:false,style:getText(context).button?.copyWith(fontSize: 8, fontWeight: FontWeight.bold)))),

                              trailing: SizedBox(
                                  width: Get.width * 0.45,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            accept_status = false;
                                          });
                                          var data = await acceptDecline(
                                              snapshot
                                                  .data!
                                                  .data!
                                                  .followDetails!
                                                  .followers![index]!
                                                  .id
                                                  .toString(),
                                              '1',
                                              Get.find<SessionController>()
                                                  .session
                                                  .value
                                                  .data!
                                                  .userId
                                                  .toString());

                                          // Get.find<SessionController>().session.value.data?.userId.toString();

                                          // data["data"]["status"] =
                                          //     is_following;

                                          if (data["data"]["status"] == true) {
                                            debugPrint(
                                                "isFollowing:${snapshot.data!.data!.followDetails!.followers![index]!.isFollowing}");

                                            if (snapshot
                                                    .data!
                                                    .data!
                                                    .followDetails!
                                                    .followers![index]!
                                                    .isFollowing !=
                                                true) {
                                              setState(() {
                                                followBackDialogue(
                                                    context, snapshot, index);
                                              });
                                            } else {
                                              setState(() {
                                                list = loadPendingList();
                                              });
                                              await followRequest(snapshot
                                                      .data!
                                                      .data!
                                                      .followDetails!
                                                      .followers![index]!
                                                      .followerUserId
                                                      .toString())
                                                  .then((value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            value['message'])));
                                                Navigator.of(context).pop();
                                              });
                                            }
                                          }
                                          if (data["data"]["status"] == false) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content:
                                                        Text(data['message'])));
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          backgroundColor: Colors.greenAccent,
                                          elevation: 4.0,
                                          minimumSize: const Size(30.0, 35.0),
                                        ),
                                        child: Text(
                                          'Accept',
                                          style: getText(context)
                                              .labelLarge
                                              ?.copyWith(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return const Center(
                                                    child:
                                                        CustomProgressIndicator());
                                              });
                                          var data = await acceptDecline(
                                              snapshot
                                                  .data!
                                                  .data!
                                                  .followDetails!
                                                  .followers![index]!
                                                  .id
                                                  .toString(),
                                              '2',
                                              Get.find<SessionController>()
                                                  .session
                                                  .value
                                                  .data!
                                                  .userId
                                                  .toString());

                                          if (data["data"]["status"] == true) {
                                            setState(() {
                                              list = loadPendingList();
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content:
                                                        Text(data['message'])));
                                            Navigator.of(context).pop();
                                          }
                                          if (data["data"]["status"] == false) {
                                            setState(() {
                                              list = loadPendingList();
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content:
                                                        Text(data['message'])));
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          backgroundColor: Colors.redAccent,
                                          elevation: 4.0,
                                          minimumSize: const Size(30.0, 35.0),
                                        ),
                                        child: Text(
                                          'Decline',
                                          style: getText(context)
                                              .labelLarge
                                              ?.copyWith(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ));
                  },
                );
              } else if (snapshot.hasError) {
                if (kDebugMode) {
                  print(snapshot.hasError);
                }

                return const Center(child: Text('No friend Request'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<dynamic> followBackDialogue(BuildContext context,
      AsyncSnapshot<PendingRequestModel> snapshot, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '    Would you like to follow back ?',
                style: TextStyle(fontSize: 16),
              )),
          content: ListTile(
            leading: CircleAvatar(
              backgroundImage: (snapshot.data?.data?.followDetails!
                              .followers![index]?.profileImage
                              ?.toString() ??
                          '')
                      .isNotEmpty
                  ? NetworkImage(snapshot.data?.data?.followDetails!
                          .followers![index]?.profileImage
                          ?.toString() ??
                      '')
                  : null,
            ),
            title: Text(
              snapshot.data!.data!.followDetails!.followers![index]!.name!,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Follow Back',
                style: getText(context).labelLarge?.copyWith(
                      fontSize: 16,
                    ),
              ),
              onPressed: () async {
                if (kDebugMode) {
                  print(snapshot.data!.data!.followDetails!.followers![index]!
                      .followerUserId
                      .toString());
                }
                setState(() {
                  list = loadPendingList();
                });
                Navigator.of(context).pop();
                await followRequest(snapshot.data!.data!.followDetails!
                        .followers![index]!.followerUserId
                        .toString())
                    .then((value) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(value['message'])));
                  Navigator.of(context).pop();
                });
              },
            ),
            TextButton(
              child: Text(
                'Cancel',
                style: getText(context).labelLarge?.copyWith(
                      fontSize: 16,
                    ),
              ),
              onPressed: () {
                setState(() {
                  list = loadPendingList();
                  acceptLoad = false;
                  debugPrint("loaderCancel:$acceptLoad");
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

Future<Map<String, dynamic>> acceptDecline(
    String id, String status, String userid) async {
  var body = {
    "follow_id": id,
    "accept_decline_status": status,
    "user_id": userid,
  };
  final response = await http.post(
      Uri.parse(
          'https://api.malayannursesunion.xyz/api_follow_accept_decline_request'),
      body: body);

  if (response.statusCode == 200) {
    debugPrint(response.body);
    return jsonDecode(response.body);
  } else {
    debugPrint(response.body);
    throw Exception('Failed to load data');
  }
}

void customLoading(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CustomProgressIndicator());
      });
}
