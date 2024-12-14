import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:mnu_app/view/homePage.dart';

import '../../controllers/sessioncontroller.dart';
import '../../main.dart';
import '../../models/chat_member_list_model.dart';
import '../admin/admin-post-view.dart';
import '../widgets/custom_progress_indicator.dart';
import 'chat_screen.dart';
import 'chatlist2.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  ScrollController scrollcontroller = ScrollController();

  double height = 0;
  double appbarheight = 50;

  Future<ChatMemberListModel> loadRecentMembers() async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data!.userId.toString()
    };
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_chat_member_list'),
        body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return ChatMemberListModel.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> chatdelete({required String reciverId}) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data!.userId.toString(),
      "receiver_id": reciverId
    };
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_user_chat_delete'),
        body: body);
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  late Future<ChatMemberListModel> list;
  bool isSelected = false;
  int? selectedindex;
  String? receiverID;

  @override
  void initState() {
    list = loadRecentMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedindex = null;
          isSelected = false;
        });
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomePage(
              selectedTab: 0,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title:
                Text('Recent chat', style: TextStyle(color: clrschm.onPrimary)),
            automaticallyImplyLeading: false,
            actions: [
              isSelected
                  ? IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text('Are you sure delete?'),
                              actions: [
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () {
                                    chatdelete(reciverId: receiverID ?? '')
                                        .then((value) => setState(() {
                                              list = loadRecentMembers();
                                              setState(() {
                                                selectedindex = null;
                                                isSelected = false;
                                              });
                                            }));
                                    print('2222222');
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete))
                  : const SizedBox()
            ],
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: clrschm.primary,
              onPressed: () {
                Get.to(() => const ChatList2());
              },
              child: const Icon(
                Icons.chat_bubble,
                color: Colors.white,
              )),
          body: StreamBuilder<ChatMemberListModel>(
              stream: Stream.periodic(const Duration(microseconds: 1))
                  .asyncMap((event) async {
                return loadRecentMembers();
              }),
              builder: (BuildContext context,
                  AsyncSnapshot<ChatMemberListModel> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.data?.memberDetails?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                          ),
                          child: ListTile(
                            dense: true,
                            selected: selectedindex == index,

                            onLongPress: () {
                              setState(() {
                                selectedindex = index;
                                isSelected = true;
                                receiverID = snapshot
                                    .data?.data?.memberDetails![index]?.userId
                                    .toString();
                              });
                            },
                            onTap: () {
                              Get.to(() => ChatScreen(
                                    receiverId: snapshot.data?.data
                                            ?.memberDetails![index]?.userId
                                            .toString() ??
                                        '',
                                    receiverImageUrl: snapshot
                                            .data
                                            ?.data
                                            ?.memberDetails![index]
                                            ?.profileImage
                                            .toString() ??
                                        '',
                                    Name: snapshot
                                            .data
                                            ?.data
                                            ?.memberDetails![index]
                                            ?.memberName ??
                                        '',
                                  ));
                            },
                            title: Text(snapshot.data?.data
                                    ?.memberDetails![index]?.memberName ??
                                ''),
                            // subtitle: Text(snapshot.data?.data?.memberDetails![index]?.companyName ?? 'Company Name'),
                            leading: CircleAvatar(
                              foregroundImage: (snapshot
                                              .data
                                              ?.data
                                              ?.memberDetails![index]
                                              ?.profileImage
                                              ?.toString() ??
                                          '')
                                      .isNotEmpty
                                  ? NetworkImage(snapshot.data?.data
                                          ?.memberDetails![index]?.profileImage
                                          ?.toString() ??
                                      '')
                                  : null,
                              backgroundImage: const NetworkImage(
                                  "https://marketplace.canva.com/EAFEits4-uw/1/0/1600w/canva-boy-cartoon-gamer-animated-twitch-profile-photo-oEqs2yqaL8s.jpg"),
                            ),
                            trailing: snapshot
                                        .data!
                                        .data!
                                        .memberDetails![index]!
                                        .unseenMessageCount ==
                                    0
                                ? Text('')
                                : Stack(
                                    children: [
                                      Icon(
                                        Icons.notifications,
                                        size: 26,
                                      ), // Your trailing widget
                                      Positioned(
                                        top: -3,
                                        right: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            snapshot
                                                .data!
                                                .data!
                                                .memberDetails![index]!
                                                .unseenMessageCount
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            // trailing:TextButton(  child:Text('Delete Chat'),onPressed:(){
                            //
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //
                            //         content: Text('Are you sure delete?'),
                            //         actions: [
                            //           TextButton(
                            //             child: Text('Yes'),
                            //             onPressed: () {
                            //
                            //               chatdelete(reciverId: snapshot.data!.data!.memberDetails![index]!.userId.toString() ?? '' ).then((value) =>  setState(() {
                            //                 list = loadRecentMembers();
                            //
                            //               }));
                            //               print('2222222');
                            //               Navigator.of(context).pop();
                            //             },
                            //           ),
                            //           TextButton(
                            //             child: Text('Close'),
                            //             onPressed: () {
                            //               Navigator.of(context).pop();
                            //             },
                            //           ),
                            //         ],
                            //       );
                            //     },
                            //   );
                            // }
                            // ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Icon(Icons.error_outline));
                } else {
                  return Center(child: CustomProgressIndicator());
                }
              })),
    );
  }
}
