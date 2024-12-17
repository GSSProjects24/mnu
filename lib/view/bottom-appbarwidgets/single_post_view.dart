// import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/list_of_post_controller.dart';
import '../../controllers/sessioncontroller.dart';
import '../../main.dart';
import '../../models/single_post_view.dart';
import '../../theme/myfonts.dart';

import '../profile/friend_requestlist.dart';
import '../profile/suggestionprofile.dart';
import '../widgets/custom_progress_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

// Future<void>? _launched;
// Future<String> getDownloadDirectoryPath() async {
//   Directory? directory;
//   try {
//     if (Platform.isIOS) {
//       directory = await getApplicationDocumentsDirectory();
//     } else {
//       directory = Directory('/storage/emulates/0/Download');
//       if (!await directory.exists())
//         directory = await getApplicationDocumentsDirectory();
//     }
//   } catch (err, stack) {
//     print(err);
//   }
//   return directory!.path;
// }
Future<void> _launchInWebViewOrVC(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
    webViewConfiguration: const WebViewConfiguration(
        headers: <String, String>{'my_header_key': 'my_header_value'}),
  )) {
    throw Exception('Could not launch $url');
  }
}
// Future<void> _launchUniversalLinkIos(Uri url) async {
//   final bool nativeAppLaunchSucceeded = await launchUrl(
//     url,
//     mode: LaunchMode.externalNonBrowserApplication,
//   );
//   if (!nativeAppLaunchSucceeded) {
//     await launchUrl(
//       url,
//       mode: LaunchMode.inAppWebView,
//     );
//   }
// }

Future<void> downloadVideo(String url, String fileName) async {
  // final taskId = await FlutterDownloader.enqueue(
  //   url: url,
  //   savedDir: await getDownloadDirectoryPath(),
  //   fileName: fileName,
  //   showNotification:
  //       true, // Set this to false if you don't want to show the download notification
  //   openFileFromNotification:
  //       true, // Set this to true to open the downloaded file automatically when the user taps the notification
  // );
}

class SinglePostView extends StatefulWidget {
  const SinglePostView({
    Key? key,
    required this.postId,
  }) : super(key: key);
  final String postId;

  @override
  State<SinglePostView> createState() => _SinglePostViewState();
}

class _SinglePostViewState extends State<SinglePostView> {
  TextEditingController comment = TextEditingController();
  TextEditingController Replycomment = TextEditingController();
  late String userId;

  late Future<SinglePostViewModel> model;

  Future<SinglePostViewModel> loadSingle() async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString() ??
              '',
      "post_id": widget.postId,
    };
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_single_post_view'),
        body: body);
    print('**********+' + response.body);
    if (response.statusCode == 200) {
      print(response.body);
      return SinglePostViewModel.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    model = loadSingle();
    userId =
        Get.find<SessionController>().session.value.data!.userId.toString();
    Get.put(ListOfPostController());
    super.initState();
    debugPrint("welcome***************");
  }

  @override
  Widget build(BuildContext context) {
    // final Uri toLaunch =
    //     Uri();
    return FutureBuilder(
        future: model,
        builder: (BuildContext context,
            AsyncSnapshot<SinglePostViewModel> snapshot) {
          if (snapshot.hasData) {
            return DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Scaffold(
                  floatingActionButton: SizedBox(
                    height: Get.height * 0.06,
                    child: Card(
                      child: Row(
                        children: [
                          SizedBox(
                              height: Get.height * 0.07,
                              width: Get.width * 0.84,
                              child: CustomFormField(
                                obscureText: false,
                                controller: comment,
                                hintText: 'Comment here',
                              )),
                          IconButton(
                              onPressed: () {
                                showLoading(context);
                                Get.find<ListOfPostController>()
                                    .postComment(
                                        context: context,
                                        post_id: snapshot
                                                .data?.data.postDetails.postId
                                                .toString() ??
                                            '',
                                        comment_user_id:
                                            Get.find<SessionController>()
                                                .session
                                                .value
                                                .data!
                                                .userId
                                                .toString(),
                                        comment: comment.text)
                                    .then((value) async {
                                  model = loadSingle();

                                  Navigator.pop(context);

                                  setState(() {
                                    comment.clear();
                                  });
                                });
                              },
                              icon: Icon(Icons.send))
                        ],
                      ),
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  appBar: AppBar(),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                const AssetImage('assets/profile.png'),
                            // foregroundImage: NetworkImage(snapshot.data?.data
                            //         .postDetails.userDetails?.profileImg ??
                            //     ''),
                            foregroundImage: NetworkImage(
                              snapshot.data?.data.postDetails.userDetails
                                          ?.profileImg?.isNotEmpty ==
                                      true
                                  ? snapshot.data?.data.postDetails.userDetails
                                          ?.profileImg
                                          ?.toString() ??
                                      ''
                                  : 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png',
                            ),
                          ),
                          title: Text(snapshot
                                  .data?.data.postDetails.userDetails?.name ??
                              ''),
                          subtitle:
                              Text(snapshot.data?.data.postDetails.title ?? ''),
                          dense: true,
                          trailing: Flex(
                            mainAxisSize: MainAxisSize.min,
                            direction: Axis.horizontal,
                            children: [
                              GestureDetector(
                                child: LikeButton(
                                  isLiked:
                                      snapshot.data?.data.postDetails.isLiked ==
                                              1
                                          ? true
                                          : false,
                                  onTap: (value) async {
                                    customLoading(context);

                                    await Get.find<ListOfPostController>()
                                        .postLike(
                                            snapshot.data?.data.postDetails
                                                        .isLiked ==
                                                    1
                                                ? 0
                                                : 1,
                                            snapshot
                                                .data!.data.postDetails.postId!
                                                .toInt(),
                                            Get.find<SessionController>()
                                                .session
                                                .value
                                                .data!
                                                .userId!)
                                        .then((data) {
                                      model = loadSingle();
                                      setState(() {});
                                    }).whenComplete(
                                            () => Navigator.of(context).pop());

                                    // snapshot.post.value= await snapshot.loadPost('',limit,)!;

                                    // Navigator.of(context).pop();
                                  },
                                  size: 20,
                                ),
                              ),
                              Text(snapshot.data!.data.postDetails.likeCount
                                      .toString() ??
                                  ''),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: TabBar(
                            tabs: <Widget>[
                              Tab(
                                icon: Text(
                                  'Photos',
                                  style: getText(context).bodySmall,
                                ),
                              ),
                              Tab(
                                icon: Text(
                                  'Video',
                                  style: getText(context).bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: snapshot.data!.data.postDetails.image!
                        //               .isNotEmpty ||
                        //           snapshot
                        //               .data!.data.postDetails.video!.isNotEmpty
                        //       ? 300
                        //       : 100,
                        //   child: TabBarView(
                        //     children: <Widget>[
                        //       Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: SizedBox(
                        //           child: snapshot
                        //                   .data!.data.postDetails.image!.isEmpty
                        //               ? Padding(
                        //                   padding:
                        //                       const EdgeInsets.only(left: 14.0),
                        //                   child: ClipRRect(
                        //                     borderRadius:
                        //                         BorderRadius.circular(15),
                        //                     child: GestureDetector(
                        //                         onTap: () {
                        //                           showMyDialog(
                        //                               context, '', null);
                        //                         },
                        //                         child: const Center(
                        //                             child: Text('No Photos'))),
                        //                   ),
                        //                 )
                        //               : Padding(
                        //                   padding:
                        //                       const EdgeInsets.only(left: 12.0),
                        //                   child: CarouselSlider(
                        //                     options: CarouselOptions(
                        //                         height: 300.0,
                        //                         viewportFraction: 1,
                        //                         enableInfiniteScroll: false,
                        //                         disableCenter: false),
                        //                     items: snapshot
                        //                         .data!.data.postDetails.image!
                        //                         .map((i) {
                        //                       return Builder(
                        //                         builder:
                        //                             (BuildContext context) {
                        //                           return Padding(
                        //                             padding:
                        //                                 const EdgeInsets.all(
                        //                                     8.0),
                        //                             child: ClipRRect(
                        //                                 borderRadius:
                        //                                     BorderRadius
                        //                                         .circular(15),
                        //                                 child: GestureDetector(
                        //                                   onTap: () {
                        //                                     showMyDialog(
                        //                                         context,
                        //                                         null,
                        //                                         snapshot
                        //                                             .data!
                        //                                             .data
                        //                                             .postDetails!
                        //                                             .image
                        //                                             ?.map((e) =>
                        //                                                 e.toString())
                        //                                             .toList());
                        //                                   },
                        //                                   child: Image.network(
                        //                                     i,
                        //                                     fit:
                        //                                         BoxFit.fitWidth,
                        //                                     width: Get.width *
                        //                                         0.95,
                        //                                     loadingBuilder:
                        //                                         (context,
                        //                                             widget,
                        //                                             event) {
                        //                                       if (event
                        //                                               ?.expectedTotalBytes ==
                        //                                           event
                        //                                               ?.cumulativeBytesLoaded) {
                        //                                         return Image
                        //                                             .network(
                        //                                           i,
                        //                                           fit: BoxFit
                        //                                               .fitWidth,
                        //                                           width:
                        //                                               Get.width *
                        //                                                   0.95,
                        //                                         );
                        //                                       } else {
                        //                                         return CustomProgressIndicator();
                        //                                       }
                        //                                     },
                        //                                   ),
                        //                                 )),
                        //                           );
                        //                         },
                        //                       );
                        //                     }).toList(),
                        //                   ),
                        //                 ),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         child: snapshot
                        //                 .data!.data.postDetails.video!.isEmpty
                        //             ? Padding(
                        //                 padding:
                        //                     const EdgeInsets.only(left: 14.0),
                        //                 child: ClipRRect(
                        //                   borderRadius:
                        //                       BorderRadius.circular(15),
                        //                   child: GestureDetector(
                        //                       // onTap: () {
                        //                       //   showMyDialog(context,
                        //                       //       'http://mnuapi.graspsoftwaresolutions.com/public/images/user.png',null);
                        //                       // },
                        //                       child: Center(
                        //                     child: Text('No Videos'),
                        //                   )
                        //                       // Image.network(
                        //                       //   'http://mnuapi.graspsoftwaresolutions.com/public/images/user.png',
                        //                       //   fit: BoxFit.cover,
                        //                       // ),
                        //                       ),
                        //                 ),
                        //               )
                        //             : Padding(
                        //                 padding:
                        //                     const EdgeInsets.only(left: 12.0),
                        //                 child: CarouselSlider(
                        //                   options: CarouselOptions(
                        //                       height: 300.0,
                        //                       viewportFraction: 1,
                        //                       enableInfiniteScroll: false,
                        //                       disableCenter: false),
                        //                   items: snapshot
                        //                       .data!.data.postDetails.video!
                        //                       .map((i) {
                        //                     return Builder(
                        //                       builder: (BuildContext context) {
                        //                         return Padding(
                        //                           padding:
                        //                               const EdgeInsets.all(8.0),
                        //                           child: ClipRRect(
                        //                               borderRadius:
                        //                                   BorderRadius.circular(
                        //                                       15),
                        //                               child: GestureDetector(
                        //                                   // onTap: () {
                        //                                   //   showMyDialog(context,null,post.post.value.data!.postDetails!
                        //                                   //       .posts![widget.index]!.image?.map((e) => e.toString()).toList()
                        //                                   //   );
                        //                                   // },
                        //                                   child: VideoApp(
                        //                                 url: i.toString(),
                        //                               ))),
                        //                         );
                        //                       },
                        //                     );
                        //                   }).toList(),
                        //                 ),
                        //               ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: snapshot.data!.data.postDetails.image!
                                      .isNotEmpty ||
                                  snapshot
                                      .data!.data.postDetails.video!.isNotEmpty
                              ? 300
                              : 100,
                          child: TabBarView(
                            children: <Widget>[
                              // Tab 1: Image Carousel or "No Photos" Message
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: snapshot.data!.data.postDetails.image!
                                        .isNotEmpty
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: CarouselSlider(
                                          options: CarouselOptions(
                                            height: 300.0,
                                            viewportFraction: 1,
                                            enableInfiniteScroll: false,
                                            disableCenter: false,
                                          ),
                                          items: snapshot
                                              .data!.data.postDetails.image!
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
                                                      onTap: () {
                                                        showMyDialog(
                                                          context,
                                                          null,
                                                          snapshot
                                                              .data!
                                                              .data
                                                              .postDetails
                                                              .image!
                                                              .map((e) =>
                                                                  e.toString())
                                                              .toList(),
                                                        );
                                                      },
                                                      child: Image.network(
                                                        i,
                                                        fit: BoxFit.fitWidth,
                                                        width: Get.width * 0.95,
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
                                                              width: Get.width *
                                                                  0.95,
                                                            );
                                                          } else {
                                                            return CustomProgressIndicator();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      )
                                    : const Center(child: Text('No Photos')),
                              ),

                              // Tab 2: Video Carousel or "No Videos" Message
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: snapshot.data!.data.postDetails.video!
                                        .isNotEmpty
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: CarouselSlider(
                                          options: CarouselOptions(
                                            height: 300.0,
                                            viewportFraction: 1,
                                            enableInfiniteScroll: false,
                                            disableCenter: false,
                                          ),
                                          items: snapshot
                                              .data!.data.postDetails.video!
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
                                                      child: VideoApp(
                                                          url: i.toString()),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      )
                                    : const Center(child: Text('No Videos')),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              snapshot.data!.data.postDetails.content ?? '',
                            )),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.comment_rounded),
                          title: Text('Comments'),
                          trailing: Text(snapshot
                                  .data!.data.postDetails.commentCount
                                  .toString() ??
                              '0'),
                        ),
                        ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              snapshot.data!.data.postDetails.comments!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ExpansionTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    const AssetImage('assets/profile.png'),
                                // foregroundImage: NetworkImage(snapshot
                                //         .data!
                                //         .data
                                //         .postDetails
                                //         .comments![index]!
                                //         .profileImage
                                //         .toString() ??
                                //     ''),
                                foregroundImage: NetworkImage(
                                  snapshot
                                              .data
                                              ?.data
                                              .postDetails
                                              .comments![index]!
                                              .profileImage
                                              ?.isNotEmpty ==
                                          true
                                      ? snapshot.data?.data.postDetails
                                              .comments![index]!.profileImage
                                              ?.toString() ??
                                          ''
                                      : 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png',
                                ),
                              ),
                              title: Row(
                                children: [
                                  Container(
                                      width: 60,
                                      child: Text(
                                        snapshot
                                                .data!
                                                .data
                                                .postDetails
                                                .comments![index]
                                                ?.commentedUserName
                                                .toString() ??
                                            '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: getText(context)
                                            .bodySmall
                                            ?.copyWith(fontSize: 12),
                                        softWrap: false,
                                      )),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        snapshot.data!.data.postDetails
                                                .comments![index]!.date ??
                                            '',
                                        style: getText(context)
                                            .bodySmall
                                            ?.copyWith(fontSize: 8),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        DateFormat('h:mm a')
                                            .format(DateFormat('HH:mm').parse(
                                          snapshot.data!.data.postDetails
                                                  .comments![index]!.time ??
                                              '',
                                        )),
                                        style: getText(context)
                                            .bodySmall
                                            ?.copyWith(fontSize: 8),
                                      )
                                      // Text(
                                      //   snapshot.data!.data.postDetails.comments![index]!.time ?? '',
                                      //   style: getText(context).bodySmall?.copyWith(fontSize: 8),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Flex(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  direction: Axis.vertical,
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       snapshot.data!.data.postDetails.comments![index]!.date ?? '',
                                    //       style: getText(context).bodySmall?.copyWith(fontSize: 8),
                                    //     ),
                                    //     SizedBox(
                                    //       width: 5,
                                    //     ),
                                    //     Text(
                                    //       snapshot.data!.data.postDetails.comments![index]!.time ?? '',
                                    //       style: getText(context).bodySmall?.copyWith(fontSize: 8),
                                    //     ),
                                    //   ],
                                    // ),
                                    Text(
                                      '${snapshot.data?.data.postDetails.comments?[index]?.comment.toString() ?? ''} ',
                                      style: getText(context).titleMedium,
                                    ),
                                    //
                                    // Flexible(
                                    //   flex: 1,
                                    //   fit: FlexFit.tight,
                                    //   child: Column(
                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                    //     children: [
                                    //
                                    //     ],
                                    //   ),
                                    // ),
                                  ]),
                              // isThreeLine: true,
                              trailing: Flex(
                                mainAxisSize: MainAxisSize.min,
                                direction: Axis.horizontal,
                                children: [
                                  Text(snapshot.data!.data.postDetails
                                          .comments![index]!.replyComment.length
                                          .toString() ??
                                      '0'),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: SizedBox(
                                                  height: 200,
                                                  width: Get.width * 0.60,
                                                  child: Flex(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    direction: Axis.vertical,
                                                    children: [
                                                      ListTile(
                                                        leading: CircleAvatar(
                                                          backgroundImage:
                                                              const AssetImage(
                                                                  'assets/profile.png'),
                                                          // foregroundImage:
                                                          //     NetworkImage(snapshot
                                                          //             .data
                                                          //             ?.data
                                                          //             .postDetails
                                                          //             .comments?[
                                                          //                 index]
                                                          //             ?.profileImage! ??
                                                          //         ''),
                                                          foregroundImage:
                                                              NetworkImage(
                                                            snapshot
                                                                        .data
                                                                        ?.data
                                                                        .postDetails
                                                                        .comments?[
                                                                            index]
                                                                        ?.profileImage
                                                                        ?.isNotEmpty ==
                                                                    true
                                                                ? snapshot
                                                                        .data
                                                                        ?.data
                                                                        .postDetails
                                                                        .comments![
                                                                            index]!
                                                                        .profileImage
                                                                        ?.toString() ??
                                                                    ''
                                                                : 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png',
                                                          ),
                                                        ),
                                                        enabled: true,
                                                        title: Text(
                                                          '${snapshot.data?.data.postDetails.comments?[index]?.comment.toString() ?? ''} ',
                                                          style:
                                                              getText(context)
                                                                  .titleMedium,
                                                        ),
                                                        dense: true,
                                                      ),
                                                      CustomFormField(
                                                        obscureText: false,
                                                        controller:
                                                            Replycomment,
                                                        hintText:
                                                            'Comment here',
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            showLoading(
                                                                context);
                                                            Get.find<ListOfPostController>()
                                                                .postreplyComment(
                                                                    context:
                                                                        context,
                                                                    post_id: snapshot
                                                                            .data!
                                                                            .data
                                                                            .postDetails
                                                                            .postId
                                                                            .toString() ??
                                                                        '',
                                                                    parent_comment_id: snapshot
                                                                            .data
                                                                            ?.data
                                                                            .postDetails
                                                                            .comments![
                                                                                index]!
                                                                            .commentId
                                                                            .toString() ??
                                                                        '',
                                                                    comment:
                                                                        Replycomment
                                                                            .text)
                                                                .then(
                                                                    (value) async {
                                                              setState(() {});
                                                              model = loadSingle()
                                                                  .whenComplete(
                                                                      () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              });
                                                              print(Get.find<
                                                                      SessionController>()
                                                                  .session
                                                                  .value
                                                                  .data!
                                                                  .userId
                                                                  .toString());
                                                              setState(() {
                                                                Replycomment
                                                                    .clear();
                                                              });
                                                            });
                                                          },
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(
                                                                      clrschm
                                                                          .primary)),
                                                          child: Text(
                                                            'submit',
                                                            style:
                                                                getText(context)
                                                                    .bodySmall,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      icon: Icon(Icons.reply)),
                                  snapshot.data?.data.postDetails
                                              .comments![index]!.userId
                                              .toString() ==
                                          userId
                                      ? IconButton(
                                          onPressed: () async {
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible:
                                                  false, // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Please confirm'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: const <Widget>[
                                                        Text(
                                                            'Are you sure to delete this Comment'),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        onPressed: () async {
                                                          showLoading(context);

                                                          await Get.find<
                                                                  ListOfPostController>()
                                                              .CommentDelete(snapshot
                                                                      .data
                                                                      ?.data
                                                                      .postDetails
                                                                      .comments![
                                                                          index]!
                                                                      .commentId
                                                                      .toString() ??
                                                                  '')
                                                              .then((value) {
                                                            setState(() {});
                                                            model =
                                                                loadSingle();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                          // Get.find<ListOfPostController>()
                                                          //     .post
                                                          //     .value =
                                                          // await Get.find<ListOfPostController>()
                                                          //     .loadPost('', widget.limit,widget.apiurl!)!
                                                          //     .whenComplete(
                                                          //       () => Navigator.pop(context),);
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Ok')),
                                                    TextButton(
                                                      child:
                                                          const Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.delete),
                                        )
                                      : Text(''),
                                ],
                              ),
                              children: snapshot.data!.data.postDetails
                                  .comments![index]!.replyComment
                                  .map((e) => Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: ListTile(
                                            minLeadingWidth: 10,
                                            leading: CircleAvatar(
                                              radius: 10,
                                              backgroundImage: const AssetImage(
                                                  'assets/profile.png'),
                                              // foregroundImage: NetworkImage(
                                              //     e.profileImage ?? ''),
                                              foregroundImage: NetworkImage(
                                                e.profileImage?.isNotEmpty ==
                                                        true
                                                    ? e.profileImage
                                                            ?.toString() ??
                                                        ''
                                                    : 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png',
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(e.comment!),
                                              ],
                                            ),
                                            // trailing: Text('${e.date!} / ${e.time}'),
                                            title: Row(
                                              children: [
                                                Text(
                                                  e.commentedUserName!,
                                                  style: getText(context)
                                                      .bodySmall
                                                      ?.copyWith(fontSize: 10),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  '${e.date!} ${DateFormat('h:mm a').format(DateFormat('HH:mm').parse(
                                                    snapshot
                                                            .data!
                                                            .data
                                                            .postDetails
                                                            .comments![index]!
                                                            .time ??
                                                        '',
                                                  ))}',
                                                  style: getText(context)
                                                      .bodySmall
                                                      ?.copyWith(fontSize: 8),
                                                ),
                                              ],
                                            )),
                                      ))
                                  .toList(),
                              // dense: true,
                            );
                          },
                        ),
                        SizedBox(
                          height: Get.height * 0.05,
                        )
                      ],
                    ),
                  )),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Container(
                color: Colors.white, child: Icon(Icons.error_outline));
          } else {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        });
  }
}

class CustomFormField extends StatefulWidget {
  const CustomFormField(
      {Key? key,
      required this.controller,
      this.labelText,
      required this.obscureText,
      this.hintText,
      this.suffixIcon,
      this.viewIcon,
      this.validator,
      this.inputType,
      this.maxlines})
      : super(key: key);

  final TextEditingController? controller;

  final String? labelText;
  final bool obscureText;
  final String? hintText;
  final Widget? suffixIcon;
  final IconButton? viewIcon;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final int? maxlines;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  bool view = false;

  Widget build(BuildContext context) {
    //

    // view = widget.obscureText?true:false;

    return // Generated code for this yourName Widget...
        Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: TextFormField(
        keyboardType: widget.inputType,
        controller: widget.controller,
        validator: widget.validator,
        obscureText: view,
        decoration: InputDecoration(
          suffixIcon: widget.obscureText == false
              ? widget.suffixIcon
              : IconButton(
                  onPressed: () {
                    setState(() {
                      view = view ? false : true;
                    });
                  },
                  icon: view
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
          labelText: widget.labelText,
          hintText: widget.hintText,
          labelStyle: getText(context).bodyMedium?.copyWith(
                fontFamily: 'Outfit',
                color: Color(0xFF57636C),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
          hintStyle: getText(context).bodyMedium?.copyWith(
                fontFamily: 'Outfit',
                color: Color(0xFF57636C),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFF1F4F8),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFF1F4F8),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: clrschm.onError,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: clrschm.onError,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 10),
        ),
        style: getText(context).bodyLarge?.copyWith(
              fontFamily: 'Outfit',
              color: const Color(0xFF101213),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
        maxLines: widget.maxlines ?? 1,
      ),
    );
  }
}

Future<void> showMyDialog(
    BuildContext context, String? url, List<String>? urls) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Stack(
        children: [
          urls == null
              ? SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child:
                      // PhotoView(
                      //   imageProvider: NetworkImage(url!),
                      // )
                      PhotoView(
                    imageProvider: (url!.isNotEmpty &&
                            Uri.tryParse(url)?.hasAbsolutePath == true)
                        ? NetworkImage(url) as ImageProvider<Object>
                        : const AssetImage('assets/profile.png'),
                  ))
              : Container(
                  child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(urls[index]),
                      initialScale: PhotoViewComputedScale.contained * 0.8,
                      heroAttributes: PhotoViewHeroAttributes(tag: urls[index]),
                    );
                  },
                  itemCount: urls.length,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  // backgroundDecoration: widget.backgroundDecoration,
                  // pageController: widget.pageController,
                  // onPageChanged: onPageChanged,
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

class VideoApp extends StatefulWidget {
  const VideoApp({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController? _chewieController;
  double _aspectRatio = 16 / 9;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    print(widget.url);

    _videoPlayerController = VideoPlayerController.network(widget.url);

    _videoPlayerController.initialize().then((_) {
      final videoWidth = _videoPlayerController.value.size.width;
      final videoHeight = _videoPlayerController.value.size.height;
      _aspectRatio = videoWidth / videoHeight;

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.size.width /
            _videoPlayerController.value.size.height,
      );

      setState(() {
        _isInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Container(
          child: _isInitialized
              ? Chewie(
                  controller: _chewieController!,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
