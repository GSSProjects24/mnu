import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';

import '../../controllers/member-post-controller.dart';
import '../../controllers/sessioncontroller.dart';
import '../../models/member-postlist-model.dart';

import '../widgets/custom_loading.dart';
import '../widgets/custom_progress_indicator.dart';

import 'package:photo_view/photo_view.dart';

import '../../theme/myfonts.dart';
import 'create-post-page.dart';
import 'friend_requestlist.dart';
import 'member-post-view.dart';
import 'package:http/http.dart' as http;

class MemberPostListPage extends StatefulWidget {
  const MemberPostListPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MemberPostListPage> createState() => _MemberPostListPageState();
}

class _MemberPostListPageState extends State<MemberPostListPage> {
  late Future<MemberPostModel> postlist;

  int Myindex = 1;
  // ScrollController scrollController= ScrollController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  Future<Map<String, dynamic>> deleteMyPost(String id) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "post_id": id,
      "comment": ''
    };
    print(Get.find<SessionController>().session.value.data?.userId);
    final response = await http.put(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_post_delete'),
        body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Your Posts',
            style: getText(context)
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          actions: [
            // IconButton(onPressed: () {
            //   Get.to(()=>FriendList());
            // }, icon: Icon(Icons.chat_bubble)),
            // IconButton(
            //     // onPressed: () async {
            //     //   Get.find<SessionController>().session.value.logOut();
            //     //   Get.find<SessionController>().session.value = Session();
            //     //
            //     //   setState(() {});
            //     // },
            //     icon: Icon(Icons.logout)),
            IconButton(
                onPressed: () async {
                  Get.to(() => const PostCreatePage(
                        isEdit: false,
                      ));
                },
                icon: const Icon(Icons.add_box_rounded))
          ],
        ),
        body: GetX<MemberPostController>(
          init: MemberPostController(),
          initState: (value) async {
            value.controller?.post.value = await value.controller?.loadPost(
                    Get.find<SessionController>()
                            .session
                            .value
                            .data
                            ?.userId
                            .toString() ??
                        '',
                    10000) ??
                MemberPostModel();
          },
          builder: ((snapshot) {
            if (snapshot.post.value.data != null) {
              return ListView.builder(
                itemCount:
                    snapshot.post.value?.data?.postDetails?.posts?.length ?? 0,
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
                                backgroundImage:
                                    const AssetImage('assets/profile.png'),
                                foregroundImage: NetworkImage(snapshot
                                        .post
                                        .value
                                        .data!
                                        .postDetails!
                                        .posts![index]!
                                        .userDetails!
                                        .profileImg!
                                        .isEmpty
                                    ? 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'
                                    : snapshot
                                        .post
                                        .value
                                        .data!
                                        .postDetails!
                                        .posts![index]!
                                        .userDetails!
                                        .profileImg!),
                              ),
                              title: Text(snapshot.post.value?.data?.postDetails
                                      ?.posts![index]?.userDetails!.name
                                      .toString() ??
                                  ''),
                              subtitle: Text(snapshot.post.value?.data
                                      ?.postDetails?.posts![index]?.title ??
                                  ""),
                              trailing: PopupMenuButton(
                                elevation: 10,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                        child: TextButton(
                                      onPressed: () {
                                        debugPrint(
                                            "ImageEdit:${snapshot.post.value.data?.postDetails?.posts![index]?.image}");
                                        Get.to(() => PostCreatePage(
                                              isEdit: true,
                                              urls: snapshot
                                                  .post
                                                  .value
                                                  .data
                                                  ?.postDetails
                                                  ?.posts![index]
                                                  ?.image,
                                              video: snapshot
                                                  .post
                                                  .value
                                                  .data
                                                  ?.postDetails
                                                  ?.posts![index]
                                                  ?.video,
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
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('cancel')),
                                                  TextButton(
                                                      onPressed: () async {
                                                        showLoading(context);
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
                                                          if (value["data"]
                                                              ["status"]) {
                                                            Get.find<
                                                                    MemberPostController>()
                                                                .post
                                                                .value = await snapshot.loadPost(
                                                                    Get.find<SessionController>()
                                                                            .session
                                                                            .value
                                                                            .data
                                                                            ?.userId
                                                                            .toString() ??
                                                                        '',
                                                                    10000) ??
                                                                MemberPostModel();

                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        });
                                                      },
                                                      child: Text('Delete'))
                                                ],
                                              );
                                            });
                                      },
                                      child: Text('Delete'),
                                    ))
                                  ];
                                },
                              )
                              // IconButton(icon: Icon(Icons.more_vert),onPressed: (){
                              //
                              //   Get.to(()=>PostCreatePage(isEdit: true,urls:snapshot.post.value?.data?.postDetails?.posts![index]?.image ,
                              //   content:snapshot.post.value?.data?.postDetails?.posts![index]?.content ,
                              //     title: snapshot.post.value?.data?.postDetails?.posts![index]?.title,
                              //     postId:snapshot.post.value?.data?.postDetails?.posts![index]?.postId.toString() ,
                              //
                              //   ));
                              //
                              // },),
                              ),
                          SizedBox(
                            height: Get.height * 0.30,
                            width: Get.width * 0.95,
                            child: snapshot.post.value.data!.postDetails!
                                    .posts![index]!.image!.isEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: GestureDetector(
                                      onTap: () {
                                        showMyDialog(context,
                                            'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png');
                                      },
                                      child: Image.network(
                                        'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      CarouselSlider(
                                        options: CarouselOptions(
                                            height: 300.0,
                                            viewportFraction: 1,
                                            enableInfiniteScroll: false,
                                            disableCenter: false,
                                            onPageChanged: (value, _) {
                                              setState(() {
                                                Myindex = value;
                                              });
                                            }),
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
                                                          Get.to(() =>
                                                              MemberPostView(
                                                                index: index,
                                                              ));
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
                                                              return CustomProgressIndicator();
                                                            }
                                                          },
                                                        ))),
                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                      Positioned(
                                        left: Get.width * 0.40,
                                        top: Get.height * 0.27,
                                        child: SizedBox(
                                          height: 25,
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Center(
                                                child: ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: snapshot
                                                          .post
                                                          .value
                                                          .data!
                                                          .postDetails!
                                                          .posts![index]!
                                                          .image!
                                                          .length ??
                                                      0,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: CircleAvatar(
                                                        radius: 5,
                                                        backgroundColor:
                                                            index == Myindex
                                                                ? Colors.red
                                                                : Colors.grey,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          ButtonBar(
                            buttonHeight: 5,
                            buttonMinWidth: 5,
                            alignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Get.width * 0.02,
                              ),
                              GestureDetector(
                                child: LikeButton(
                                  isLiked: snapshot
                                              .post
                                              .value
                                              .data!
                                              .postDetails!
                                              .posts![index]!
                                              .isLiked ==
                                          1
                                      ? true
                                      : false,
                                  onTap: (value) async {
                                    customLoading(context);

                                    snapshot.postLike(
                                        snapshot.post.value.data?.postDetails
                                                    ?.posts![index]?.isLiked ==
                                                1
                                            ? 0
                                            : 1,
                                        snapshot.post.value.data!.postDetails!
                                            .posts![index]!.postId!
                                            .toInt()!,
                                        Get.find<SessionController>()
                                            .session
                                            .value
                                            .data!
                                            .userId!);
                                    snapshot.post.value =
                                        (await snapshot.loadPost(
                                            Get.find<SessionController>()
                                                    .session
                                                    .value
                                                    .data
                                                    ?.userId
                                                    .toString() ??
                                                '',
                                            10000))!;
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  },
                                  size: 20,
                                ),
                              ),
                              Text(snapshot.post.value!.data!.postDetails
                                      ?.posts![index]?.likeCount
                                      .toString() ??
                                  ''),
                              IconButton(
                                  onPressed: () {
                                    Get.to(() => MemberPostView(
                                          index: index,
                                        ));
                                  },
                                  icon: Icon(
                                    Icons.comment_rounded,
                                    size: 20,
                                  )),
                              Text(snapshot.post.value!.data!.postDetails
                                      ?.posts![index]?.commentCount
                                      .toString() ??
                                  ''),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            child: ReadMoreText(
                              snapshot.post.value!.data!.postDetails
                                      ?.posts![index]?.content ??
                                  '',
                              textAlign: TextAlign.start,
                              // trimLines: 2,

                              trimLength: 80,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              // trimExpandedText: 'Show less',
                              colorClickableText: Colors.grey,

                              moreStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              lessStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            if (snapshot.post.value.data == null) {
              return Center(
                child: CustomProgressIndicator(),
              );
            }
            return Center(
              child: CustomProgressIndicator(),
            );
          }),
        ));
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
        content: SingleChildScrollView(
          child: ListBody(
            mainAxis: Axis.horizontal,
            children: const <Widget>[],
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
