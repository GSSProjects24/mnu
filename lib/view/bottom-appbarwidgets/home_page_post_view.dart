import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/list_of_post_controller.dart';
import '../../controllers/sessioncontroller.dart';
import '../../main.dart';
import '../../theme/myfonts.dart';
import '../profile/suggestionprofile.dart';
import '../widgets/custom_progress_indicator.dart';

class HomePostView extends StatefulWidget {
  const HomePostView({
    Key? key,
    required this.index,
    required this.limit,
    required this.apiurl,
  }) : super(key: key);

  final int index;
  final int limit;
  final String apiurl;

  @override
  State<HomePostView> createState() => _HomePostViewState();
}

class _HomePostViewState extends State<HomePostView> {
  TextEditingController comment = TextEditingController();
  TextEditingController replyComment = TextEditingController();
  late String userId;

  @override
  void initState() {
    // TODO: implement initState
    userId =
        Get.find<SessionController>().session.value.data!.userId.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          floatingActionButton: SizedBox(
            height: Get.height * 0.05,
            child: Card(
              child: Row(
                children: [
                  SizedBox(
                      height: Get.height * 0.05,
                      width: Get.width * 0.85,
                      child: CustomFormField(
                        obscureText: false,
                        controller: comment,
                        hintText: 'Comment Here',
                      )),
                  IconButton(
                      onPressed: () {
                        showLoading(context);
                        Get.find<ListOfPostController>()
                            .postComment(
                                context: context,
                                post_id: Get.find<ListOfPostController>()
                                        .post
                                        .value
                                        .data!
                                        .postDetails
                                        ?.posts![widget.index]!
                                        .postId
                                        .toString() ??
                                    '',
                                comment_user_id: Get.find<SessionController>()
                                    .session
                                    .value
                                    .data!
                                    .userId
                                    .toString(),
                                comment: comment.text)
                            .then((value) async {
                          Get.find<ListOfPostController>().post.value =
                              await Get.find<ListOfPostController>()
                                  .loadPost('', widget.limit, widget.apiurl!,)!
                                  .whenComplete(() => Navigator.pop(context));
                          debugPrint(Get.find<SessionController>()
                              .session
                              .value
                              .data!
                              .userId
                              .toString());
                          setState(() {
                            comment.clear();
                          });
                        });
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          appBar: AppBar(),
          body: GetBuilder<ListOfPostController>(
              initState: (value) {},
              builder: (post) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              const AssetImage('assets/profile.png'),
                          foregroundImage: NetworkImage(post
                                  .post
                                  .value
                                  .data!
                                  .postDetails!
                                  .posts![widget.index]!
                                  .userDetails!
                                  .profileImg!
                                  .isEmpty
                              ? ''
                              : post
                                  .post
                                  .value
                                  .data!
                                  .postDetails!
                                  .posts![widget.index]!
                                  .userDetails!
                                  .profileImg!),
                        ),
                        title: Text(post.post.value.data!.postDetails!
                                .posts![widget.index]!.userDetails!.name ??
                            ''),
                        subtitle: Text(post.post.value.data!.postDetails!
                                .posts![widget.index]!.title ??
                            ''),
                        dense: true,
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
                      SizedBox(
                        height: 300,
                        child: TabBarView(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: Get.height * 0.30,
                                width: Get.width * 0.95,
                                child: post.post.value.data!.postDetails!
                                        .posts![widget.index]!.image!.isEmpty
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 14.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: GestureDetector(
                                            onTap: () {
                                              showMyDialog(context, '', null);
                                            },
                                            child: Image.network(
                                              '',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: CarouselSlider(
                                          options: CarouselOptions(
                                              height: 300.0,
                                              viewportFraction: 1,
                                              enableInfiniteScroll: false,
                                              disableCenter: false),
                                          items: post
                                              .post
                                              .value
                                              .data!
                                              .postDetails!
                                              .posts![widget.index]!
                                              .image!
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
                                                              post
                                                                  .post
                                                                  .value
                                                                  .data!
                                                                  .postDetails!
                                                                  .posts![widget
                                                                      .index]!
                                                                  .image
                                                                  ?.map((e) => e
                                                                      .toString())
                                                                  .toList());
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
                                                        ),
                                                      )),
                                                );
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.30,
                              width: Get.width * 0.95,
                              child: post.post.value.data!.postDetails!
                                      .posts![widget.index]!.video!.isEmpty
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(left: 14.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: GestureDetector(
                                            // onTap: () {
                                            //   showMyDialog(context,
                                            //       'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png',null);
                                            // },
                                            child: const Center(
                                          child: Text('No Videos'),
                                        )
                                            // Image.network(
                                            //   'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png',
                                            //   fit: BoxFit.cover,
                                            // ),
                                            ),
                                      ),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: CarouselSlider(
                                        options: CarouselOptions(
                                            height: 300.0,
                                            viewportFraction: 1,
                                            enableInfiniteScroll: false,
                                            disableCenter: false),
                                        items: post
                                            .post
                                            .value
                                            .data!
                                            .postDetails!
                                            .posts![widget.index]!
                                            .video!
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
                                                        child: VideoApp(
                                                      url: i.toString(),
                                                    ))),
                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            post.post.value.data?.postDetails
                                    ?.posts![widget.index]?.content ??
                                '',
                          )),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.comment_rounded),
                        title: const Text('Comments'),
                        trailing: Text(post.post.value.data?.postDetails
                                ?.posts![widget.index]?.commentCount
                                .toString() ??
                            '0'),
                      ),
                      ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: post.post.value.data?.postDetails
                                ?.posts![widget.index]?.commentCount ??
                            0,
                        itemBuilder: (BuildContext context, int index) {
                          return ExpansionTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  const AssetImage('assets/profile.png'),
                              foregroundImage: NetworkImage(post
                                  .post
                                  .value
                                  .data!
                                  .postDetails!
                                  .posts![widget.index]!
                                  .comments![index]!
                                  .profileImage!),
                            ),
                            title: Text(post
                                    .post
                                    .value
                                    .data!
                                    .postDetails
                                    ?.posts![widget.index]
                                    ?.comments![index]
                                    ?.commentedUserName
                                    .toString() ??
                                ''),
                            subtitle: Flex(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                direction: Axis.vertical,
                                children: [
                                  Text(
                                    post
                                            .post
                                            .value
                                            .data
                                            ?.postDetails
                                            ?.posts![widget.index]!
                                            .comments![index]!
                                            .date ??
                                        '',
                                    style: getText(context)
                                        .bodySmall
                                        ?.copyWith(fontSize: 8),
                                  ),
                                  Text(
                                    '${post.post.value.data?.postDetails?.posts![widget.index]?.comments?[index]?.comment.toString() ?? ''} ',
                                    style: getText(context).titleSmall,
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
                                IconButton(
                                    onPressed: () {
                                      TextEditingController text =
                                          TextEditingController();

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
                                                        foregroundImage:
                                                            NetworkImage(post
                                                                    .post
                                                                    .value
                                                                    .data
                                                                    ?.postDetails
                                                                    ?.posts![widget
                                                                        .index]!
                                                                    .comments?[
                                                                        index]
                                                                    ?.profileImage! ??
                                                                ''),
                                                      ),
                                                      enabled: true,
                                                      title: Text(
                                                        '${post.post.value.data?.postDetails?.posts![widget.index]?.comments?[index]?.comment.toString() ?? ''} ',
                                                        style: getText(context)
                                                            .titleSmall,
                                                      ),
                                                      dense: true,
                                                    ),
                                                    CustomFormField(
                                                      obscureText: false,
                                                      controller: replyComment,
                                                      hintText: 'Comment Here',
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          showLoading(context);
                                                          Get.find<
                                                                  ListOfPostController>()
                                                              .postreplyComment(
                                                                  context:
                                                                      context,
                                                                  post_id: Get.find<ListOfPostController>()
                                                                          .post
                                                                          .value
                                                                          .data!
                                                                          .postDetails
                                                                          ?.posts![widget
                                                                              .index]!
                                                                          .postId
                                                                          .toString() ??
                                                                      '',
                                                                  parent_comment_id: post
                                                                          .post
                                                                          .value
                                                                          .data
                                                                          ?.postDetails
                                                                          ?.posts![widget
                                                                              .index]
                                                                          ?.comments?[
                                                                              index]
                                                                          ?.commentId
                                                                          .toString() ??
                                                                      '',
                                                                  comment:
                                                                      replyComment
                                                                          .text)
                                                              .then(
                                                                  (value) async {
                                                            Get.find<
                                                                    ListOfPostController>()
                                                                .post
                                                                .value = await Get
                                                                    .find<
                                                                        ListOfPostController>()
                                                                .loadPost(
                                                                    '',
                                                                    widget
                                                                        .limit,
                                                                    widget
                                                                        .apiurl!)!
                                                                .whenComplete(() =>
                                                                    Navigator.pop(
                                                                        context));
                                                            debugPrint(Get.find<
                                                                    SessionController>()
                                                                .session
                                                                .value
                                                                .data!
                                                                .userId
                                                                .toString());
                                                            setState(() {
                                                              replyComment
                                                                  .clear();
                                                            });
                                                            Navigator.pop(
                                                                context);
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
                                    icon: const Icon(Icons.reply)),
                                post
                                            .post
                                            .value
                                            .data
                                            ?.postDetails
                                            ?.posts![widget.index]!
                                            .comments![index]!
                                            .userId
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
                                                    const SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
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
                                                            .CommentDelete(post
                                                                    .post
                                                                    .value
                                                                    .data
                                                                    ?.postDetails
                                                                    ?.posts![widget
                                                                        .index]!
                                                                    .comments![
                                                                        index]!
                                                                    .commentId
                                                                    .toString() ??
                                                                '');
                                                        Get.find<
                                                                ListOfPostController>()
                                                            .post
                                                            .value = await Get.find<
                                                                ListOfPostController>()
                                                            .loadPost(
                                                                '',
                                                                widget.limit,
                                                                widget.apiurl!)!
                                                            .whenComplete(
                                                              () =>
                                                                  Navigator.pop(
                                                                      context),
                                                            );
                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('Ok')),
                                                  TextButton(
                                                    child: const Text('Cancel'),
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
                                        icon: const Icon(Icons.delete),
                                      )
                                    : const Text(''),
                              ],
                            ),
                            children: post
                                .post
                                .value
                                .data!
                                .postDetails!
                                .posts![widget.index]!
                                .comments![index]!
                                .replyComment!
                                .map((e) => Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: ListTile(
                                        minLeadingWidth: 10,
                                        leading: CircleAvatar(
                                          radius: 10,
                                          backgroundImage: const AssetImage(
                                              'assets/profile.png'),
                                          foregroundImage: NetworkImage(
                                              e.profileImage ?? ''),
                                        ),
                                        title: Text(e!.comment!),
                                      ),
                                    ))
                                .toList(),
                            // dense: true,
                          );

                          //   messages[index].id==123? Row(
                          //
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: CircleAvatar(
                          //         backgroundImage: NetworkImage('https://images.pexels.com/photos/1689731/pexels-photo-1689731.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                          //       ),
                          //     ),
                          //
                          //     Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Card(child: Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Text('hi its a nice post'),
                          //       ),),
                          //     )
                          //   ],
                          // ):Row(
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Card(child: Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Text('hi its a nice post'),
                          //       ),),
                          //     )
                          //   ],
                          // ) ;
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.05,
                      )
                    ],
                  ),
                );
              })),
    );
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
  final Widget? suffixIcon;
  final IconButton? viewIcon;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final int? maxlines;
  final String? hintText;

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
            borderSide: BorderSide(
              color: Color(0xFFF1F4F8),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
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
          contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
        ),
        style: getText(context).bodyLarge?.copyWith(
              fontFamily: 'Outfit',
              color: Color(0xFF101213),
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
                  child: PhotoView(
                    imageProvider: NetworkImage(url!),
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
  late ChewieController _chewieController;
  double _aspectRatio = 9 / 21;
  @override
  initState() {
    super.initState();
    debugPrint(widget.url);
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
      materialProgressColors:
          ChewieProgressColors(backgroundColor: Colors.grey),
      allowedScreenSleep: false,
      allowFullScreen: true,

      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      videoPlayerController: _videoPlayerController,
      aspectRatio: 1.823,
      autoInitialize: true,
      autoPlay: false,
      showControls: true,
      fullScreenByDefault: true,
      //   zoomAndPan: true
    );
    //    double _calculateAspectRatio() {
    //   // Get the screen dimensions
    //   Size screenSize = MediaQuery.of(context).size;
    //   double screenWidth = screenSize.width;
    //   double screenHeight = screenSize.height;

    //   // Calculate the aspect ratio
    //   double aspectRatio = screenWidth / screenHeight;

    //   return aspectRatio;
    // }
    _chewieController.addListener(() {
      if (_chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('${_videoPlayerController.value.aspectRatio}******************************************');
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Container(
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       _controller.value.isPlaying
      //           ? _controller.pause()
      //           : _controller.play();
      //     });
      //   },
      //   child: Icon(
      //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
      //   ),
      // ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
