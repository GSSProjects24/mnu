import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/MesssagesController.dart';
import '../../controllers/sessioncontroller.dart';
import '../../main.dart';
import '../../models/MessagesModel.dart';
import '../../theme/myfonts.dart';
import '../homePage.dart';
import '../profile/friends-profile.dart';
import '../profile/suggestionprofile.dart';
import '../widgets/custom_progress_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {Key? key,
      required this.receiverId,
      required this.receiverImageUrl,
      required this.Name})
      : super(key: key);

  final String receiverId;
  final String receiverImageUrl;
  final String Name;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController message = TextEditingController();
  int? deleteIndex;
  int? chatindex;

  List<String?> delete = [];
  bool isSenderSelected = false;
  bool isReceiverSelected = false;

  int? ReceiverDeleIndex;

  bool isLoading = false;
  //flag to check if all items loaded
  bool isAllLoaded = false;

  int limit = 100;
  int totalreports = -1;

  void moveToEnd() {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      scrollController.jumpTo(scrollController.position.minScrollExtent + 25);
    });
  }

  Future sendPushNotifications(
      {required String message,
      String? receiverId,
      String? imageUrl,
      String? userName}) async {
    var body = {
      "title": Get.find<SessionController>().session.value.data!.username,
      "description": message,
      "userid": '',
      "receiverid":
          Get.find<SessionController>().session.value.data!.userId.toString(),
      "username": Get.find<SessionController>().session.value.data!.username,
      "imageurl": image,
      "topic": receiverId
    };
    final response = await http.post(
        Uri.parse(
            'https://us-central1-mnuapp-66a6f.cloudfunctions.net/addMessage2'),
        body: body);

    if (response.statusCode == 200) {
      //
      try {
        final decodedResponse = jsonDecode(response.body);
        print('API Response: $decodedResponse');
        return decodedResponse;
      } catch (e) {
        // Handle plain text or non-JSON response
        print('API Response (Non-JSON): ${response.body}');
        return response.body;
      }
    } else {
      throw Exception('Failed to load data: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> futureOverallChatDelete(
      {required String status, String? chatId}) async {
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
    // print('${chatId}dddddddddddddddddddddddddddddddddddddddddddddddddddddddd');

    if (response.statusCode == 200) {
      // print('${chatId}dddddddddddddddddddddddddddddddddddddddddddddddddddddddd${response.body}');
      return jsonDecode(response.body);
    } else {
      // print(
      //     '${response.body}ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp');
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messageController = Get.put(MessagesController());
    return StreamBuilder(
        stream: Stream.periodic(const Duration(milliseconds: 100))
            .asyncMap((event) async {
          await Get.find<MessagesController>()
              .futureSeen(widget.receiverId.toString());
          return Get.find<MessagesController>()
              .futureMessage(widget.receiverId, limit.toString());
        }),
        builder: (BuildContext context, AsyncSnapshot<MessagesModel> snapshot) {
          if (snapshot.hasData) {
            totalreports =
                snapshot.data?.data?.result?.totalReports?.messageCount ?? 0;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                leadingWidth: 40,
                elevation: 10,
                title: ListTile(
                  dense: true,
                  leading: GestureDetector(
                    onTap: () {
                      Get.to(() => FriendsProfile(
                          memberNo: widget.receiverId, name: widget.Name));
                    },
                    child: CircleAvatar(
                      // backgroundImage: NetworkImage(widget.receiverImageUrl ==
                      //         '0'
                      //     ? 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'
                      //     : widget.receiverImageUrl),
                      backgroundImage: (widget.receiverImageUrl.isNotEmpty &&
                              widget.receiverImageUrl != '0')
                          ? NetworkImage(widget.receiverImageUrl)
                          : const NetworkImage(
                              'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'),
                    ),
                  ),
                  title: Text(
                    widget.Name,
                    style: getText(context).titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                    maxLines: 2,
                  ),
                ),
                // centerTitle: true,
                actions: [
                  delete.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              delete = [];
                            });
                          },
                          icon: const Icon(Icons.deselect))
                      : const Text(''),
                  delete.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              showLoading(context);
                                              messageController
                                                  .futureDeleteMulti(
                                                      widget.receiverId, delete)
                                                  .then((value) {
                                                isReceiverSelected = false;
                                                delete = [];

                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: const Text('Delete for me')),
                                        delete.length <= 1 &&
                                                isReceiverSelected == false
                                            ? TextButton(
                                                onPressed: () {
                                                  // print(chatindex);
                                                  Navigator.pop(context);
                                                  showLoading(context);
                                                  delete.forEach((e) async {
                                                    await futureOverallChatDelete(
                                                            status: '1',
                                                            chatId: e)
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                    });
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Everyone'))
                                            : const SizedBox(),
                                        TextButton(
                                            onPressed: () {
                                              isReceiverSelected = false;
                                              delete = [];
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No')),
                                      ],
                                      content:
                                          const Text('Are you sure delete?'),
                                    ));
                            // showLoading(context);
                            // messageController.futureDeleteMulti(widget.receiverId, delete).then((value) {
                            //   delete = [];

                            //   Navigator.pop(context);
                            // });

                            // setState(() {});
                          },
                          icon: const Icon(Icons.delete))
                      : const Text(''),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        isReceiverSelected = false;
                        delete = [];
                      },
                      child: SizedBox(
                        height: Get.height * 0.82,
                        child: ListView.separated(
                          controller: scrollController
                            ..addListener(() {
                              if (scrollController.position.pixels ==
                                  scrollController.position.maxScrollExtent) {
                                if (!isLoading && !isAllLoaded) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  //simulate loading more items
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    if (snapshot.data!.data!.result!
                                            .totalReports!.messageCount! <=
                                        totalreports!) {
                                      setState(() {
                                        limit += 100;
                                        isLoading = false;
                                      });
                                    } else {
                                      setState(() {
                                        isAllLoaded = true;
                                        isLoading = false;
                                      });
                                    }
                                  });
                                }

                                // limit += 15;
                              }
                            }),
                          itemCount:
                              snapshot.data?.data?.result?.msg?.length ?? 0,
                          reverse: true,
                          itemBuilder: (BuildContext context, int index) {
                            chatindex = index;

                            //
                            // if(snapshot.data?.data?.result?.msg![index]?.delete!=true){
                            //
                            //   if (snapshot
                            //       .data?.data?.result?.msg![index]?.sender ==
                            //       true) {
                            //     return
                            //       SelectionArea(
                            //         child: InkWell(
                            //           radius: 200,
                            //           onTap: () {
                            //             setState(() {
                            //               delete.contains(snapshot.data!.data!.result!
                            //                   .msg![index]!.chatId
                            //                   .toString())
                            //                   ? delete.retainWhere((element) =>
                            //               element !=
                            //                   snapshot.data!.data!.result!
                            //                       .msg![index]!.chatId
                            //                       .toString())
                            //                   : null;
                            //             });
                            //           },
                            //           onLongPress: () {
                            //             setState(() {
                            //               // deleteIndex = index;
                            //               delete.add(snapshot
                            //                   .data!.data!.result!.msg![index]!.chatId
                            //                   .toString());
                            //             });
                            //           },
                            //           child: BubbleSpecialOne(
                            //             text: snapshot.data?.data?.result?.msg![index]
                            //                 ?.message ??
                            //                 '',
                            //             isSender: true,
                            //             seen: snapshot.data!.data!.result!
                            //                 .msg![index]!.sender ==
                            //                 false
                            //                 ? false
                            //                 : snapshot.data!.data!.result!
                            //                 .msg![index]!.seen ==
                            //                 1,
                            //             delivered: snapshot.data!.data!.result!
                            //                 .msg![index]!.sender ==
                            //                 false
                            //                 ? false
                            //                 : snapshot.data!.data!.result!
                            //                 .msg![index]!.seen ==
                            //                 0,
                            //             sent: snapshot.data!.data!.result!
                            //                 .msg![index]!.sender ==
                            //                 false
                            //                 ? false
                            //                 : snapshot.data!.data!.result!
                            //                 .msg![index]!.seen ==
                            //                 0,
                            //             color: delete.contains(snapshot.data!.data!
                            //                 .result!.msg![index]!.chatId
                            //                 .toString())
                            //                 ?
                            //             Colors.blue:Colors.purpleAccent.withOpacity(0.3),
                            //             tail: true,
                            //             textStyle: TextStyle(
                            //               fontSize: 20,
                            //               color: Colors.black,
                            //             ),
                            //           ),
                            //         ),
                            //       );
                            //   }
                            //
                            //
                            //
                            //   return SelectionArea(
                            //     child: InkWell(
                            //       radius: 200,
                            //       onTap: () {
                            //         setState(() {
                            //           delete.contains(snapshot.data!.data!.result!
                            //               .msg![index]!.chatId
                            //               .toString())
                            //               ? delete.retainWhere((element) =>
                            //           element !=
                            //               snapshot.data!.data!.result!
                            //                   .msg![index]!.chatId
                            //                   .toString())
                            //               : null;
                            //         });
                            //       },
                            //       onLongPress: () {
                            //         setState(() {
                            //           // deleteIndex = index;
                            //           delete.add(snapshot
                            //               .data!.data!.result!.msg![index]!.chatId
                            //               .toString());
                            //         });
                            //       },
                            //       child: BubbleSpecialOne(
                            //         text: snapshot.data?.data?.result?.msg![index]
                            //             ?.message ??
                            //             '',
                            //         isSender: false,
                            //         seen: snapshot.data!.data!.result!.msg![index]!
                            //             .sender ==
                            //             false
                            //             ? false
                            //             : snapshot.data!.data!.result!.msg![index]!
                            //             .seen ==
                            //             1,
                            //         delivered: snapshot.data!.data!.result!
                            //             .msg![index]!.sender ==
                            //             false
                            //             ? false
                            //             : snapshot.data!.data!.result!.msg![index]!
                            //             .seen ==
                            //             0,
                            //         sent: snapshot.data!.data!.result!.msg![index]!
                            //             .sender ==
                            //             false
                            //             ? false
                            //             : snapshot.data!.data!.result!.msg![index]!
                            //             .seen ==
                            //             0,
                            //         color: delete.contains(snapshot.data!.data!
                            //             .result!.msg![index]!.chatId
                            //             .toString())
                            //             ?
                            //         Colors.blue:Colors.lightGreenAccent.withOpacity(0.3),
                            //         tail: true,
                            //         textStyle: TextStyle(
                            //           fontSize: 20,
                            //           color: Colors.black,
                            //         ),
                            //       ),
                            //     ),
                            //   );
                            //
                            //
                            //
                            // }

                            return (snapshot.data!.data!.result!.msg![index]!
                                            .sender ==
                                        true &&
                                    snapshot.data!.data!.result!.msg![index]!
                                            .delete ==
                                        false)
                                ? InkWell(
                                    radius: 200,
                                    onTap: () {
                                      setState(() {
                                        delete.contains(snapshot.data!.data!
                                                .result!.msg![index]!.chatId
                                                .toString())
                                            ? delete.retainWhere((element) =>
                                                element !=
                                                snapshot.data!.data!.result!
                                                    .msg![index]!.chatId
                                                    .toString())
                                            : null;
                                      });
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        // deleteIndex = index;
                                        isSenderSelected = true;
                                        delete.add(snapshot.data!.data!.result!
                                            .msg![index]!.chatId
                                            .toString());
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Expanded(
                                            flex: 5, child: Text('')),
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4,
                                                right: 6,
                                                top: 8,
                                                bottom: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Card(
                                                      elevation: 1,
                                                      color: delete.contains(
                                                              snapshot
                                                                  .data!
                                                                  .data!
                                                                  .result!
                                                                  .msg![index]!
                                                                  .chatId
                                                                  .toString())
                                                          ? Colors.blue
                                                          : Colors.white
                                                              .withOpacity(0.8),
                                                      surfaceTintColor:
                                                          Colors.white,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 4,
                                                                    right: 8,
                                                                    left: 8),
                                                            child: SelectableText(
                                                                autofocus: true,
                                                                snapshot
                                                                        .data
                                                                        ?.data
                                                                        ?.result
                                                                        ?.msg![
                                                                            index]
                                                                        ?.message ??
                                                                    ''),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 5,
                                                      bottom: 5,
                                                      child: SizedBox(
                                                        width: 25,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            snapshot
                                                                        .data
                                                                        ?.data
                                                                        ?.result
                                                                        ?.msg![
                                                                            index]
                                                                        ?.seen ==
                                                                    0
                                                                ? const Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                    ),
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomRight,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .done,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const Padding(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                5),
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomRight,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .done_all,
                                                                        color: Colors
                                                                            .blue,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        DateFormat.jm().format(
                                                            snapshot
                                                                .data!
                                                                .data!
                                                                .result!
                                                                .msg![index]!
                                                                .date!),
                                                        style: const TextStyle(
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      // SizedBox(
                                                      //   width: 5,
                                                      // ),
                                                      // Text(
                                                      //   DateFormat('d/M/yyy')
                                                      //       .format(snapshot
                                                      //           .data!
                                                      //           .data!
                                                      //           .result!
                                                      //           .msg![index]!
                                                      //           .date!),
                                                      //   style: TextStyle(
                                                      //       fontSize: 8,
                                                      //       fontWeight:
                                                      //           FontWeight.bold),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   height: 35,
                                        //   child: CircleAvatar(
                                        //     foregroundImage: NetworkImage(
                                        //         widget.receiverImageUrl == '0' ? 'https://www.nuteaiw.org/assets/flogo.png' : widget.receiverImageUrl),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  )
                                : (snapshot.data!.data!.result!.msg![index]!
                                                .sender ==
                                            false &&
                                        snapshot.data!.data!.result!
                                                .msg![index]!.delete ==
                                            false)
                                    ? InkWell(
                                        radius: 200,
                                        onTap: () {
                                          setState(() {
                                            delete.contains(snapshot.data!.data!
                                                    .result!.msg![index]!.chatId
                                                    .toString())
                                                ? delete.retainWhere(
                                                    (element) =>
                                                        element !=
                                                        snapshot
                                                            .data!
                                                            .data!
                                                            .result!
                                                            .msg![index]!
                                                            .chatId
                                                            .toString())
                                                : null;
                                          });
                                        },
                                        onLongPress: () {
                                          setState(() {
                                            isReceiverSelected = true;
                                            delete.add(snapshot.data!.data!
                                                .result!.msg![index]!.chatId
                                                .toString());
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Flexible(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(1.0),
                                                    // child: CircleAvatar(
                                                    //   backgroundImage: NetworkImage(widget.receiverImageUrl == '0'
                                                    //       ? 'https://www.nuteaiw.org/assets/flogo.png'
                                                    //       : widget.receiverImageUrl),
                                                    // ),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 5,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Card(
                                                      elevation: 1,
                                                      color: delete.contains(
                                                              snapshot
                                                                  .data!
                                                                  .data!
                                                                  .result!
                                                                  .msg![index]!
                                                                  .chatId
                                                                  .toString())
                                                          ? Colors.blue
                                                          : Colors.white
                                                              .withOpacity(0.8),
                                                      surfaceTintColor:
                                                          Colors.white,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 6,
                                                                    left: 8,
                                                                    right: 8,
                                                                    bottom: 6),
                                                            child: SelectableText(
                                                                snapshot
                                                                        .data
                                                                        ?.data
                                                                        ?.result
                                                                        ?.msg![
                                                                            index]
                                                                        ?.message ??
                                                                    ''),
                                                          ),
                                                          // SizedBox(
                                                          //   width: 40,
                                                          //   child: Row(
                                                          //     mainAxisAlignment:
                                                          //         MainAxisAlignment
                                                          //             .end,
                                                          //     children: [
                                                          //       Padding(
                                                          //         padding:
                                                          //             const EdgeInsets
                                                          //                     .all(
                                                          //                 8.0),
                                                          //         // child: Column(
                                                          //         //   children: [
                                                          //         //     Text(
                                                          //         //       DateFormat.jm().format(snapshot.data!.data!.result!.msg![index]!.date!),
                                                          //         //       style: getText(context).bodySmall,
                                                          //         //     ),
                                                          //         //     Text(
                                                          //         //       DateFormat.yMEd().format(snapshot.data!.data!.result!.msg![index]!.date!),
                                                          //         //       style: TextStyle(fontSize: 8),
                                                          //         //     ),
                                                          //         //   ],
                                                          //         // ),
                                                          //       ),
                                                          //     ],
                                                          //   ),
                                                          // )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Flexible(
                                                    flex: 1, child: Text(''))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${DateFormat.jm().format(snapshot.data!.data!.result!.msg![index]!.date!)}',
                                                    style: const TextStyle(
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  // SizedBox(
                                                  //   width: 5,
                                                  // ),
                                                  // Text(
                                                  //   DateFormat('d/M/yyy').format(
                                                  //       snapshot
                                                  //           .data!
                                                  //           .data!
                                                  //           .result!
                                                  //           .msg![index]!
                                                  //           .date!),
                                                  //   style: TextStyle(
                                                  //       fontSize: 8,
                                                  //       fontWeight:
                                                  //           FontWeight.bold),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox();
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            if (snapshot
                                    .data?.data?.result?.msg![index]?.delete !=
                                true) {
                              if (index != 0 &&
                                  DateFormat.MMMMd().format(snapshot.data!.data!
                                          .result!.msg![index]!.date!) !=
                                      DateFormat.MMMMd().format(snapshot
                                          .data!
                                          .data!
                                          .result!
                                          .msg![index - 1]!
                                          .date!)) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 120,
                                      height: 40,
                                      child: Card(
                                        color: Colors.white,
                                        child: Center(
                                            child: Text(
                                                DateFormat('MMM dd, yyyy')
                                                    .format(snapshot
                                                        .data!
                                                        .data!
                                                        .result!
                                                        .msg![index]!
                                                        .date!)
                                                    .toString())),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }

                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.08,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: Card(
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: SizedBox(
                            width: Get.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: // Generated code for this emailAddress Widget...
                                        SizedBox(
                                      height: Get.height * 0.1,
                                      child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        controller: message,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(8.0),
                                          enabledBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          hintMaxLines: 3,
                                          hintText: "Type your message",
                                          hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .color,
                                          ),
                                        ),
                                        maxLines: null,
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        onPressed: () async {
                                          if (message.text.isEmpty == false) {
                                            Get.find<MessagesController>()
                                                .futuresend(widget.receiverId,
                                                    message.text)
                                                .then((value) {
                                              if (value["data"]["status"]) {
                                                sendPushNotifications(
                                                    message: message.text,
                                                    receiverId:
                                                        widget.receiverId);
                                                message.clear();
                                              }
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Please enter some Text')));
                                          }
                                        },
                                        icon: const Icon(Icons.send)))
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError &&
              snapshot.error.toString() !=
                  "'Null' is not a subtype of type 'Map<String, dynamic>") {
            print(snapshot.error.toString());

            return Scaffold(
              appBar: AppBar(
                elevation: 10,
                leadingWidth: 40,
                title: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundImage: const AssetImage('assets/profile.png'),
                    foregroundImage: (widget.receiverImageUrl.isNotEmpty &&
                            widget.receiverImageUrl != '0')
                        ? NetworkImage(widget.receiverImageUrl)
                        : const NetworkImage(
                            'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'),
                  ),
                  title: Text(
                    widget.Name,
                    style: getText(context).titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: clrschm.onPrimary),
                    maxLines: 2,
                  ),
                ),
                //centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                        height: Get.height * 0.82,
                        child: Container(
                          color: Colors.white,
                          child: const Center(
                            child: Text('There is no Messages'),
                          ),
                        )),
                    SizedBox(
                      height: Get.height * 0.08,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Card(
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: SizedBox(
                            width: Get.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: // Generated code for this emailAddress Widget...
                                        SizedBox(
                                      height: Get.height * 0.15,
                                      child: TextFormField(
                                        controller: message,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(10.0),
                                          enabledBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          hintText: "Type your message",
                                          hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .color,
                                          ),
                                        ),
                                        maxLines: null,
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        onPressed: () async {
                                          print('${widget.receiverId} ddsds d');
                                          if (message.text.isEmpty == false) {
                                            // snapshot.data!.message !=
                                            //     message.text;
                                            Get.find<MessagesController>()
                                                .futuresend(widget.receiverId,
                                                    message.text)
                                                .then((value) {
                                              if (value["data"]["status"]) {
                                                message.clear();
                                              }
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Please enter some Text')));
                                          }
                                        },
                                        icon: const Icon(Icons.send)))
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const CustomProgressIndicator();
          }
        });
  }
}

Future<void> showMyDialog(
    {required BuildContext context,
    void Function()? deleteForme,
    void Function()? deleteForReceiver,
    required bool isReceiver,
    void Function()? receiverChatDelete}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Messages'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Please select the options'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          isReceiver
              ? const Text('')
              : TextButton(
                  child: const Text('Delete for me'),
                  onPressed: deleteForme,
                ),
          isReceiver
              ? const Text('')
              : TextButton(
                  child: const Text('Delete for Everyone'),
                  onPressed: deleteForReceiver,
                ),
          isReceiver == false
              ? const Text('')
              : TextButton(
                  child: const Text('Delete'),
                  onPressed: receiverChatDelete,
                ),
        ],
      );
    },
  );
}
