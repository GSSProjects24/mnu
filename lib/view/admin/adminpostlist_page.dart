import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

import 'package:photo_view/photo_view.dart';

import 'package:readmore/readmore.dart';
import 'package:mnu_app/controllers/admin_post%20_controllers.dart';
import 'package:mnu_app/controllers/sessioncontroller.dart';
import 'package:mnu_app/view/admin/admin-post-view.dart';
import 'package:mnu_app/view/profile/create-post-page.dart';
import 'package:mnu_app/view/profile/friend_requestlist.dart';
import '../../theme/myfonts.dart';
import '../profile/suggestionprofile.dart';
import '../widgets/custom_progress_indicator.dart';

class AdminPostListPage extends StatefulWidget {
  const AdminPostListPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AdminPostListPage> createState() => _AdminPostListPageState();
}

class _AdminPostListPageState extends State<AdminPostListPage> {
  int Myindex = 1;
  bool isLoading = false;
  //flag to check if all items loaded
  bool isAllLoaded = false;
  late int totalreports;
  int limit = 20000;
  bool snapshotLoading = true;
  ScrollController scrollcontroller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState

    // postlist = loadPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'HQ Posts',
            style: getText(context)
                .headlineMedium
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
                  Get.to(() => PostCreatePage(
                        isEdit: false,
                      ));
                },
                icon: Icon(Icons.add_box_rounded))
          ],
        ),
        body: GetX<AdminPostController>(
          init: AdminPostController(),
          initState: (value) async {
            value.controller?.post.value =
                (await value.controller?.loadPost('', limit))!;
          },
          builder: ((snapshot) {
            if (snapshot.post.value.data != null) {
              totalreports = snapshot
                      .post.value.data?.postDetails?.totalReports?.postCount ??
                  0;

              return ListView.builder(
                controller: scrollcontroller
                  ..addListener(() {
                    if (scrollcontroller.position.pixels ==
                            scrollcontroller.position.maxScrollExtent &&
                        limit <= totalreports) {
                      setState(() {
                        isLoading = true;
                        limit += 15;
                      });

                      //simulate loading more items
                      Future.delayed(Duration(microseconds: 100), () {
                        if (limit <= totalreports && snapshotLoading) {
                          showLoading(context);
                          setState(() async {
                            snapshotLoading = false;

                            snapshot.post.value = (await snapshot
                                .loadPost('', limit)
                                .whenComplete(() {
                              Navigator.pop(context);
                              snapshotLoading = true;
                            }))!;

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
                  }),
                reverse: true,
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
                            onTap: () {
                              //   Get.to(() => FriendsProfile(
                              //     memberNo: snapshot
                              //         .post
                              //         .value
                              //         .data!
                              //         .postDetails!
                              //         .posts![index]!
                              //         .userDetails!
                              //         .userId
                              //         .toString(),
                              //     profileImage: snapshot
                              //         .post
                              //         .value
                              //         .data!
                              //         .postDetails!
                              //         .posts![index]!
                              //         .userDetails
                              //         ?.profileImg ??
                              //         '',
                              //     name: '',
                              //   ));
                              // },
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'),
                            ),
                            title: Text('Admin'),
                            subtitle: Text(snapshot.post.value?.data
                                    ?.postDetails?.posts![index]?.title
                                    .toString() ??
                                ""),
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
                                        showMyDialog(context, '');
                                      },
                                      child: Placeholder(
                                        fallbackHeight: 50,
                                        fallbackWidth: 300,
                                      ),
                                      // child: Image.network(
                                      //   'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png',
                                      //   fit: BoxFit.cover,
                                      // ),
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
                                                          showMyDialog(
                                                              context, i);
                                                        },
                                                        child: Image.network(
                                                          i,
                                                          fit: BoxFit.cover,
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

                                    var data = await snapshot
                                        .postLike(
                                            snapshot
                                                        .post
                                                        .value
                                                        .data
                                                        ?.postDetails
                                                        ?.posts![index]
                                                        ?.isLiked ==
                                                    1
                                                ? 0
                                                : 1,
                                            snapshot
                                                .post
                                                .value
                                                .data!
                                                .postDetails!
                                                .posts![index]!
                                                .postId!
                                                .toInt()!,
                                            Get.find<SessionController>()
                                                .session
                                                .value
                                                .data!
                                                .userId!)
                                        .then((data) {
                                      if (data["message"] ==
                                          "post like inserted.") {
                                        setState(() {
                                          snapshot
                                              .post!
                                              .value!
                                              .data!
                                              .postDetails!
                                              .posts![index]!
                                              .likeCount = snapshot
                                                  .post!
                                                  .value!
                                                  .data!
                                                  .postDetails!
                                                  .posts![index]!
                                                  .likeCount! +
                                              1;
                                          snapshot
                                              .post!
                                              .value!
                                              .data!
                                              .postDetails!
                                              .posts![index]!
                                              .isLiked = 1;
                                        });
                                      }
                                      if (data["message"] ==
                                          "post like deleted.") {
                                        setState(() {
                                          snapshot
                                              .post!
                                              .value!
                                              .data!
                                              .postDetails!
                                              .posts![index]!
                                              .likeCount = snapshot
                                                  .post!
                                                  .value!
                                                  .data!
                                                  .postDetails!
                                                  .posts![index]!
                                                  .likeCount! -
                                              1;
                                          snapshot
                                              .post!
                                              .value!
                                              .data!
                                              .postDetails!
                                              .posts![index]!
                                              .isLiked = 0;
                                        });
                                      }
                                      Navigator.of(context).pop();
                                    });

                                    // snapshot.post.value= await snapshot.loadPost('',limit,)!;

                                    // Navigator.of(context).pop();
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
                                    Get.to(() => AdminPostView(
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
