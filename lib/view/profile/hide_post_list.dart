import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mnu_app/controllers/hide_post_controller.dart';

import 'package:photo_view/photo_view.dart';

import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../controllers/sessioncontroller.dart';
import '../../models/notifications_model.dart';
import '../../models/sessionModel.dart';
import '../../models/single_post_view.dart';
import '../../theme/myfonts.dart';
import 'package:http/http.dart' as http;

import 'package:mnu_app/view/bottom-appbarwidgets/single_post_view.dart'
    as video;
import '../homePage.dart';
import '../profile/create-post-page.dart';
import '../profile/suggestionprofile.dart';
import '../widgets/custom_progress_indicator.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class HidePostPage extends StatefulWidget {
  const HidePostPage(
      {super.key,
      required this.title,
      required this.apiurl,
      this.isMember,
      this.isHq,
      this.isHome});
  final String title;
  final String apiurl;
  final bool? isMember;
  final bool? isHq;
  final bool? isHome;

  @override
  State<HidePostPage> createState() => _HidePostPageState();
}

class _HidePostPageState extends State<HidePostPage>
    with TickerProviderStateMixin {
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Session c = Session();
  bool isLoading = false;
  //flag to check if all items loaded
  bool isAllLoaded = false;
  late int totalreports;
  int limit = 20;
  bool snapshotLoading = true;
  ScrollController scrollcontroller = ScrollController();

  Future<Map<String, dynamic>> deleteMyPost(String id) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "post_id": id,
      "comment": ''
    };
    if (kDebugMode) {
      print(Get.find<SessionController>().session.value.data?.userId);
    }
    final response = await http.put(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_post_delete'),
        body: body);

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return jsonDecode(response.body);
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<SinglePostViewModel> viewCountPostGetFromSinglePost(String id) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "post_id": id,
    };
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_single_post_view'),
        body: body);
    if (response.statusCode == 200) {
      debugPrint(response.body);

      return SinglePostViewModel.fromJson(jsonDecode(response.body));
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    // postlist = loadPost();
    super.initState();
  }

  Future<Map<String, dynamic>> postViewCount(String id) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "post_id": id,
    };
    debugPrint(
        "UserId${Get.find<SessionController>().session.value.data?.userId}");
    final response = await http.put(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_post_view_add'),
        body: body);

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return jsonDecode(response.body);
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
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
      return NotificationsModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future unHide(String postId) async {
    debugPrint('block request start');
    var body = {
      "post_id": postId,
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
    };
    debugPrint(
        'user id ${Get.find<SessionController>().session.value.data?.userId} follower user id $postId');
    debugPrint(
        'api url http://mnuapi.graspsoftwaresolutions.com/api_post_unhide');
    final response = await http.post(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_post_unhide'),
        body: body);

    if (response.statusCode == 200) {
      isAllLoaded = true;
      isLoading = false;
      debugPrint(response.body);
      return jsonDecode(response.body);
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse('');
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint("Pop action ************.");
      },
      child: Scaffold(
        appBar: AppBar(
          leading: widget.isHome == true
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset('assets/MNU-Logo.png',
                        height: Get.height * 0.08, width: Get.width * 0.08),
                  ),
                )
              : BackButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    setState(() {});
                  },
                ),
          title: Text(
            widget.title,
            style: getText(context)
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: GetX<HidePostController>(
            init: HidePostController(),
            initState: (value) async {
              value.controller?.post.value =
                  (await value.controller?.hidePost('', limit, widget.apiurl))!;
            },
            builder: ((snapshot) {
              final posts = snapshot.post.value.data?.postDetails?.posts;
              if (posts == null ||
                  posts.isEmpty ||
                  snapshot.post.value.data?.status == false) {
                debugPrint("snapTrue:${snapshot.post.value.data?.status}");
                debugPrint("member${widget.isMember}");
                if (widget.isMember == null) {
                  return const Center(
                    child: CustomProgressIndicator(),
                  );
                } else {
                  debugPrint("snap:${snapshot.post.value.data?.status}");
                  return const Center(
                    child: Text('No posts found'),
                  );
                }
              }

              totalreports = snapshot
                      .post.value.data?.postDetails?.totalReports?.postCount ??
                  0;

              return ListView.builder(
                controller: scrollcontroller
                  ..addListener(() {
                    if (scrollcontroller.position.pixels ==
                        scrollcontroller.position.maxScrollExtent) {
                      setState(() {
                        isLoading = true;
                        limit += 15;
                      });

                      Future.delayed(const Duration(microseconds: 100),
                          () async {
                        if (snapshotLoading) {
                          showLoading(context);
                          snapshot.post.value = (await snapshot
                              .hidePost('', limit, widget.apiurl)
                              .whenComplete(() {
                            Navigator.pop(context);
                          }));
                          setState(() {
                            snapshotLoading = true;
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isAllLoaded = false;
                            isLoading = false;
                          });
                        }
                      });
                    }
                  }),
                itemCount:
                    snapshot.post.value.data?.postDetails?.posts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Card(
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            dense: true,
                            onTap: () {},
                            leading: CircleAvatar(
                              radius: 23,
                              backgroundImage: const NetworkImage(
                                  'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'),
                              foregroundImage: (snapshot
                                              .post
                                              .value
                                              .data!
                                              .postDetails!
                                              .posts![index]
                                              .userDetails!
                                              .profileImg
                                              ?.toString() ??
                                          '')
                                      .isNotEmpty
                                  ? NetworkImage(snapshot
                                          .post
                                          .value
                                          .data!
                                          .postDetails!
                                          .posts![index]
                                          .userDetails!
                                          .profileImg
                                          ?.toString() ??
                                      '')
                                  : null,
                            ),
                            title: Text(
                              snapshot.post.value.data?.postDetails
                                      ?.posts![index].userDetails!.name
                                      .toString() ??
                                  '',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Flex(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              direction: Axis.vertical,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  snapshot.post.value.data?.postDetails
                                          ?.posts![index].date
                                          .toString() ??
                                      '',
                                  style: const TextStyle(fontSize: 10),
                                ),
                                Text(
                                  snapshot.post.value.data?.postDetails
                                              ?.posts![index].title ==
                                          null
                                      ? ''
                                      : snapshot.post.value.data?.postDetails
                                              ?.posts![index].title
                                              .toString() ??
                                          "",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            trailing:
                                snapshot.post.value.data!.postDetails!
                                            .posts![index].userDetails!.userId
                                            .toString() ==
                                        '1'
                                    ? null
                                    : widget.isMember == true
                                        ? PopupMenuButton(
                                            elevation: 10,
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                    child: TextButton(
                                                  onPressed: () {
                                                    Get.to(() => PostCreatePage(
                                                          isEdit: true,
                                                          urls: snapshot
                                                              .post
                                                              .value
                                                              .data
                                                              ?.postDetails
                                                              ?.posts![index]
                                                              .image,
                                                          video: snapshot
                                                              .post
                                                              .value
                                                              .data
                                                              ?.postDetails
                                                              ?.posts![index]
                                                              .video,
                                                          content: snapshot
                                                              .post
                                                              .value
                                                              .data
                                                              ?.postDetails
                                                              ?.posts![index]
                                                              ?.content,
                                                          title: snapshot
                                                              .post
                                                              .value
                                                              .data
                                                              ?.postDetails
                                                              ?.posts![index]
                                                              ?.title,
                                                          postId: snapshot
                                                              .post
                                                              .value
                                                              .data
                                                              ?.postDetails
                                                              ?.posts![index]
                                                              ?.postId
                                                              .toString(),
                                                        ));
                                                  },
                                                  child: const Text('Edit'),
                                                )),
                                                PopupMenuItem(
                                                    child: TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Are you sure to delete this post'),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      'Cancel')),
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    showLoading(
                                                                        context);
                                                                    deleteMyPost(
                                                                            snapshot.post.value.data?.postDetails?.posts![index]?.postId.toString() ??
                                                                                '')
                                                                        .then(
                                                                            (value) async {
                                                                      if (value[
                                                                              "data"]
                                                                          [
                                                                          "status"]) {
                                                                        Get.find<HidePostController>().post.value = (await snapshot.hidePost(
                                                                            '',
                                                                            limit,
                                                                            widget.apiurl));

                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    });
                                                                  },
                                                                  child: const Text(
                                                                      'Delete'))
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: const Text('Delete'),
                                                ))
                                              ];
                                            },
                                          )
                                        : (snapshot
                                                    .post
                                                    .value
                                                    .data!
                                                    .postDetails!
                                                    .posts![index]
                                                    .userDetails!
                                                    .userId
                                                    .toString()) ==
                                                Get.find<SessionController>()
                                                    .session
                                                    .value
                                                    .data
                                                    ?.userId
                                                    .toString()
                                            ? Text('')
                                            : PopupMenuButton(
                                                itemBuilder: (itemBuilder) => [
                                                      PopupMenuItem(
                                                          child: TextButton(
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title:
                                                                      const Text(
                                                                    'Hide this content?',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: const Text(
                                                                            'Cancel')),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        debugPrint(
                                                                            'url ${widget.apiurl} limit $limit');
                                                                        debugPrint(
                                                                            'PostId ${snapshot.post.value.data!.postDetails!.posts![index]!.postId}');
                                                                        showLoading(
                                                                            context); // Show loading spinner
                                                                        try {
                                                                          var response =
                                                                              await unHide(
                                                                            snapshot.post.value.data!.postDetails!.posts![index]!.postId.toString(),
                                                                          );
                                                                          debugPrint(
                                                                              "Full Response: $response");

                                                                          if (response != null &&
                                                                              response["data"] != null) {
                                                                            final bool?
                                                                                status =
                                                                                response["data"]["status"];
                                                                            final String?
                                                                                message =
                                                                                response["data"]["message"];

                                                                            if (status ==
                                                                                true) {
                                                                              debugPrint("Success: $message");
                                                                              Get.snackbar("Unhide Successfully", "", snackPosition: SnackPosition.BOTTOM);

                                                                              if (mounted) {
                                                                                try {
                                                                                  // Perform the async operation outside setState
                                                                                  var updatedPost = await snapshot.hidePost(
                                                                                    '',
                                                                                    limit,
                                                                                    widget.apiurl,
                                                                                  );

                                                                                  // Update the state synchronously
                                                                                  setState(() {
                                                                                    Get.find<HidePostController>().post.value = updatedPost;
                                                                                  });
                                                                                } catch (e) {
                                                                                  debugPrint("Error updating post: $e");
                                                                                  // Handle errors appropriately
                                                                                }
                                                                              }
                                                                              Navigator.pop(context, true);
                                                                              Navigator.pop(context, true);
                                                                            } else {
                                                                              final String? errorMsg = response["data"]["error_msg"];
                                                                              debugPrint("Failure: ${errorMsg ?? "Unknown error"}");
                                                                              Get.snackbar("Failed", errorMsg ?? "Something went wrong", snackPosition: SnackPosition.BOTTOM);
                                                                              Navigator.pop(context, true);
                                                                              Navigator.pop(context, true);
                                                                            }
                                                                          } else {
                                                                            debugPrint("Invalid response format.");
                                                                            Get.snackbar("Error",
                                                                                "Invalid response format.",
                                                                                snackPosition: SnackPosition.BOTTOM);
                                                                            Navigator.pop(context,
                                                                                true);
                                                                            Navigator.pop(context,
                                                                                true);
                                                                          }
                                                                        } catch (e) {
                                                                          debugPrint(
                                                                              "Exception: $e");
                                                                        } finally {
                                                                          Navigator.pop(
                                                                              context,
                                                                              true);
                                                                          Navigator.pop(
                                                                              context,
                                                                              true);
                                                                          // Ensure loading spinner is dismissed
                                                                        }
                                                                      },
                                                                      child: const Text(
                                                                          'Unhide'),
                                                                    )
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: const Row(
                                                          children: [
                                                            Icon(Icons
                                                                .remove_red_eye_outlined),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text('Unhide'),
                                                          ],
                                                        ),
                                                      ))
                                                    ]),
                          ),
                          snapshot.post.value.data!.postDetails!.posts![index]
                                      .image!.isEmpty &&
                                  snapshot.post.value.data!.postDetails!
                                      .posts![index].video!.isEmpty
                              ? Container()
                              : SizedBox(
                                  height: Get.height * 0.30,
                                  width: Get.width * 0.95,
                                  child: CustomCarouselSlider(
                                    items: snapshot.post.value.data!
                                            .postDetails!.posts![index]!.image!
                                            .map((i) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          postViewCount(snapshot
                                                              .post
                                                              .value
                                                              .data!
                                                              .postDetails!
                                                              .posts![index]
                                                              .postId
                                                              .toString());
                                                          showDialog(
                                                                  context: context,
                                                                  builder:
                                                                      (context) {
                                                                    return SizedBox(
                                                                      height: Get
                                                                          .height,
                                                                      width: Get
                                                                          .width,
                                                                      child: video.SinglePostView(
                                                                          postId: snapshot
                                                                              .post
                                                                              .value
                                                                              .data!
                                                                              .postDetails!
                                                                              .posts![index]
                                                                              .postId
                                                                              .toString()),
                                                                    );
                                                                  })
                                                              .then(
                                                                  (value) async {
                                                            Get.find<
                                                                    HidePostController>()
                                                                .post
                                                                .value = await Get
                                                                    .find<
                                                                        HidePostController>()
                                                                .hidePost(
                                                                    '',
                                                                    limit,
                                                                    widget
                                                                        .apiurl);
                                                          });
                                                        },
                                                        child: Image.network(
                                                          i,
                                                          fit: BoxFit.fitWidth,
                                                          width:
                                                              Get.width * 0.95,
                                                          loadingBuilder:
                                                              (context, widget,
                                                                  event) {
                                                            if (event
                                                                    ?.expectedTotalBytes ==
                                                                event
                                                                    ?.cumulativeBytesLoaded) {
                                                              return Image
                                                                  .network(
                                                                i,
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                                width:
                                                                    Get.width *
                                                                        0.95,
                                                              );
                                                            } else {
                                                              return const CustomProgressIndicator();
                                                            }
                                                          },
                                                        ))),
                                              );
                                            },
                                          );
                                        }).toList() +
                                        snapshot.post.value.data!.postDetails!
                                            .posts![index].video!
                                            .map((i) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: GestureDetector(

                                                        // onTap: () {
                                                        //   showMyDialog(context,null,post.post.value.data!.postDetails!
                                                        //       .posts![widget.index]!.image?.map((e) => e.toString()).toList()
                                                        //   );
                                                        // },
                                                        onTap: () {
                                                          postViewCount(snapshot
                                                              .post
                                                              .value
                                                              .data!
                                                              .postDetails!
                                                              .posts![index]!
                                                              .postId
                                                              .toString());
                                                        },
                                                        child: video.VideoApp(
                                                          url: i.toString(),
                                                        ))),
                                              );
                                            },
                                          );
                                        }).toList(),
                                  ),
                                ),
                          ButtonBar(
                            buttonHeight: 5,
                            buttonMinWidth: 3,
                            alignment: MainAxisAlignment.start,
                            children: [
                              // const SizedBox(
                              //   width: 8,
                              // ),
                              // SizedBox(
                              //   width: Get.width * 0.02,
                              // ),
                              // Row(
                              //   children: [
                              //     GestureDetector(
                              //       child: LikeButton(
                              //         isLiked: snapshot
                              //                     .post
                              //                     .value
                              //                     .data!
                              //                     .postDetails!
                              //                     .posts![index]!
                              //                     .isLiked ==
                              //                 1
                              //             ? true
                              //             : false,
                              //         onTap: (value) async {
                              //           customLoading(context);
                              //
                              //           var data = await snapshot
                              //               .postLike(
                              //                   snapshot
                              //                               .post
                              //                               .value
                              //                               .data
                              //                               ?.postDetails
                              //                               ?.posts![index]
                              //                               ?.isLiked ==
                              //                           1
                              //                       ? 0
                              //                       : 1,
                              //                   snapshot
                              //                       .post
                              //                       .value
                              //                       .data!
                              //                       .postDetails!
                              //                       .posts![index]!
                              //                       .postId!
                              //                       .toInt(),
                              //                   Get.find<SessionController>()
                              //                       .session
                              //                       .value
                              //                       .data!
                              //                       .userId!)
                              //               .then((data) {
                              //             if (data["message"] ==
                              //                 "post like inserted.") {
                              //               setState(() {
                              //                 snapshot
                              //                     .post
                              //                     .value
                              //                     .data!
                              //                     .postDetails!
                              //                     .posts![index]
                              //                     .likeCount = snapshot
                              //                         .post
                              //                         .value
                              //                         .data!
                              //                         .postDetails!
                              //                         .posts![index]!
                              //                         .likeCount! +
                              //                     1;
                              //                 snapshot
                              //                     .post
                              //                     .value
                              //                     .data!
                              //                     .postDetails!
                              //                     .posts![index]!
                              //                     .isLiked = 1;
                              //               });
                              //             }
                              //             if (data["message"] ==
                              //                 "post like deleted.") {
                              //               setState(() {
                              //                 snapshot
                              //                     .post
                              //                     .value
                              //                     .data!
                              //                     .postDetails!
                              //                     .posts![index]!
                              //                     .likeCount = snapshot
                              //                         .post
                              //                         .value
                              //                         .data!
                              //                         .postDetails!
                              //                         .posts![index]!
                              //                         .likeCount! -
                              //                     1;
                              //                 snapshot
                              //                     .post
                              //                     .value
                              //                     .data!
                              //                     .postDetails!
                              //                     .posts![index]!
                              //                     .isLiked = 0;
                              //               });
                              //             }
                              //             Navigator.of(context).pop();
                              //           });
                              //
                              //           // snapshot.post.value= await snapshot.loadPost('',limit,)!;
                              //
                              //           // Navigator.of(context).pop();
                              //         },
                              //         size: 20,
                              //       ),
                              //     ),
                              //     Text(snapshot.post.value.data!.postDetails
                              //             ?.posts![index]?.likeCount
                              //             .toString() ??
                              //         ''),
                              //   ],
                              // ),
                              // Row(
                              //   children: [
                              //     InkWell(
                              //         onTap: () {
                              //           showDialog(
                              //               context: context,
                              //               builder: (context) {
                              //                 return SizedBox(
                              //                   height: Get.height,
                              //                   width: Get.width,
                              //                   child: video.SinglePostView(
                              //                       postId: snapshot
                              //                           .post
                              //                           .value
                              //                           .data!
                              //                           .postDetails!
                              //                           .posts![index]!
                              //                           .postId
                              //                           .toString()),
                              //                 );
                              //               }).then((value) async {
                              //             Get.find<HidePostController>()
                              //                     .post
                              //                     .value =
                              //                 await Get.find<HidePostController>()
                              //                     .hidePost(
                              //                         '', limit, widget.apiurl);
                              //           });
                              //           // Get.to(() => HomePostView(
                              //           //       index: index,
                              //           //   limit: limit,
                              //           //   apiurl: widget.apiurl,
                              //           //     ));
                              //         },
                              //         child: const SizedBox(
                              //           width: 30,
                              //           height: 30,
                              //           child: Icon(
                              //             Icons.comment_rounded,
                              //             size: 20,
                              //           ),
                              //         )),
                              //     Text(snapshot.post.value.data!.postDetails
                              //             ?.posts![index]?.commentCount
                              //             .toString() ??
                              //         ''),
                              //   ],
                              // ),
                              // Row(
                              //   children: [
                              //     const Icon(Icons.remove_red_eye),
                              //     const SizedBox(
                              //       width: 8,
                              //     ),
                              //     // FutureBuilder<SinglePostViewModel>(
                              //     //     future: viewCountPostGetFromSinglePost(snapshot.post.value.data!.postDetails!.posts![index]!.postId.toString()),
                              //     //     builder: (context, snapshot) {
                              //     //       return Text(snapshot.data!.data.postDetails.views.toString());
                              //     //     }),
                              //     FutureBuilder<SinglePostViewModel>(
                              //         future: viewCountPostGetFromSinglePost(
                              //             snapshot.post.value.data!.postDetails!
                              //                 .posts![index]!.postId
                              //                 .toString()),
                              //         builder: (context, snapshot) {
                              //           if (snapshot.connectionState ==
                              //               ConnectionState.waiting) {
                              //             return const Text("0");
                              //             // return Container(
                              //             //   height: 20,
                              //             //   width: 20,
                              //             //   child: CircularProgressIndicator(
                              //             //     color: Colors.grey,
                              //             //   ),
                              //             // );
                              //           } else if (snapshot.connectionState ==
                              //               ConnectionState.done) {
                              //             if (snapshot.hasError) {
                              //               return const Text('0');
                              //             } else {
                              //               return Text(snapshot
                              //                   .data!.data.postDetails.views
                              //                   .toString());
                              //             }
                              //           } else {
                              //             return const Text('0');
                              //           }
                              //         }),
                              //   ],
                              // ),

                              if (Get.find<SessionController>()
                                      .session
                                      .value
                                      .data!
                                      .role ==
                                  1)
                                PopupMenuButton(
                                    itemBuilder: (itemBuilder) => [
                                          PopupMenuItem(
                                              child: TextButton(
                                            onPressed: () {
                                              Get.to(() => PostCreatePage(
                                                    isEdit: true,
                                                    urls: snapshot
                                                        .post
                                                        .value
                                                        .data
                                                        ?.postDetails
                                                        ?.posts![index]
                                                        .image,
                                                    video: snapshot
                                                        .post
                                                        .value
                                                        .data
                                                        ?.postDetails
                                                        ?.posts![index]
                                                        .video,
                                                    content: snapshot
                                                        .post
                                                        .value
                                                        .data
                                                        ?.postDetails
                                                        ?.posts![index]
                                                        .content,
                                                    title: snapshot
                                                        .post
                                                        .value
                                                        .data
                                                        ?.postDetails
                                                        ?.posts![index]
                                                        .title,
                                                    postId: snapshot
                                                        .post
                                                        .value
                                                        .data
                                                        ?.postDetails
                                                        ?.posts![index]
                                                        .postId
                                                        .toString(),
                                                  ));
                                            },
                                            child: const Text('Edit'),
                                          )),
                                          PopupMenuItem(
                                              child: TextButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Are you sure to delete this post'),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'cancel')),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              showLoading(
                                                                  context);
                                                              deleteMyPost(snapshot
                                                                          .post
                                                                          .value
                                                                          ?.data
                                                                          ?.postDetails
                                                                          ?.posts![
                                                                              index]
                                                                          ?.postId
                                                                          .toString() ??
                                                                      '')
                                                                  .then(
                                                                      (value) async {
                                                                if (value[
                                                                        "data"][
                                                                    "status"]) {
                                                                  Get.find<HidePostController>()
                                                                          .post
                                                                          .value =
                                                                      (await snapshot.hidePost(
                                                                          '',
                                                                          limit,
                                                                          widget
                                                                              .apiurl));

                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              });
                                                            },
                                                            child: const Text(
                                                                'Delete'))
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: const Text('Delete'),
                                          ))
                                        ])
                              else
                                Text('')
                            ],
                          ),
                          (snapshot.post.value.data!.postDetails?.posts![index]
                                          .content!
                                          .contains("http") ==
                                      true ||
                                  snapshot.post.value.data!.postDetails
                                          ?.posts![index]!.content!
                                          .contains("https") ==
                                      true)
                              ? TextButton(
                                  onPressed: () {
                                    _launchInBrowser(Uri.parse(
                                        "${snapshot.post.value.data!.postDetails?.posts![index]?.content}"));

                                    // launchUrlString(" ${snapshot.post.value.data!.postDetails?.posts![index]?.content} ");
                                  },
                                  child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: ReadMoreText(
                                        ' ${snapshot.post.value.data!.postDetails?.posts![index]?.content} ',
                                        textAlign: TextAlign.start,
                                        // trimLines: 2,

                                        trimLength: 80,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: 'Show more',
                                        // trimExpandedText: 'Show less',
                                        colorClickableText: Colors.grey,

                                        moreStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                        lessStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      )))
                              //  Linkify(
                              //     onOpen: (link) async {
                              //       if (await canLaunch(link.url)) {
                              //         await launch(link.url);
                              //       } else {
                              //         throw 'Could not launch $link';
                              //       }
                              //     },
                              //     text:
                              //         ' ${snapshot.post.value.data!.postDetails?.posts![index]?.content} ' ??
                              //             '',
                              //   )
                              : Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                    child: ReadMoreText(
                                      // '${snapshot.post.value?.data?.postDetails?.posts![index]?.userDetails!.name.toString() ?? ''}:
                                      ' ${snapshot.post.value.data!.postDetails?.posts![index]?.content} ' ??
                                          '',
                                      textAlign: TextAlign.start,
                                      // trimLines: 2,

                                      trimLength: 80,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'Show more',
                                      // trimExpandedText: 'Show less',
                                      colorClickableText: Colors.grey,

                                      moreStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                      lessStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                },
              );
            })),
      ),
    );
  }
}

class CustomCarouselSlider extends StatefulWidget {
  const CustomCarouselSlider({
    super.key,
    this.items,
  });

  final List<Widget>? items;

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  int _myIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
            options: CarouselOptions(
                height: 300.0,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                disableCenter: false,
                onPageChanged: (value, _) {
                  setState(() {
                    _myIndex = value;
                  });
                }),
            items: widget.items),
        Align(
          alignment: Alignment.bottomCenter,
          child: CarouselIndicator(
            activeColor: Colors.red,
            color: Colors.grey,
            count: widget.items!.length == 0 ? 1 : widget.items!.length,
            index: _myIndex,
          ),
        ),
      ],
    );
  }
}

Future<void> showMyDialog(BuildContext context, String url) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Stack(
        children: [
          SizedBox(
              width: Get.width,
              height: Get.height,
              child: PhotoView(
                imageProvider: (url.isNotEmpty &&
                        Uri.tryParse(url)?.hasAbsolutePath == true)
                    ? NetworkImage(url) as ImageProvider<Object>
                    : const AssetImage('assets/profile.png'),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close')),
          )
        ],
      );
    },
  );
}

Future<void> showMyDialog2(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const SingleChildScrollView(
          child: ListBody(
            mainAxis: Axis.horizontal,
            children: <Widget>[],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
