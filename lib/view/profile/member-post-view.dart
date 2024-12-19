import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../controllers/member-post-controller.dart';
import '../../controllers/sessioncontroller.dart';
import '../../main.dart';
import '../../theme/myfonts.dart';
import '../admin/adminpostlist_page.dart';
import '../widgets/custom_loading.dart';
import '../widgets/custom_progress_indicator.dart';

class MemberPostView extends StatefulWidget {
  const MemberPostView({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<MemberPostView> createState() => _MemberPostViewState();
}

class _MemberPostViewState extends State<MemberPostView> {
  TextEditingController comment = TextEditingController();
  String userId =
      Get.find<SessionController>().session.value.data!.userId.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      labelText: 'Comment here',
                    )),
                IconButton(
                    onPressed: () {
                      Get.find<MemberPostController>()
                          .postComment(
                              context: context,
                              post_id: Get.find<MemberPostController>()
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
                        Get.find<MemberPostController>().post.value =
                            (await Get.find<MemberPostController>()
                                .loadPost(userId, 1000))!;
                        if (kDebugMode) {
                          print(Get.find<SessionController>()
                              .session
                              .value
                              .data!
                              .userId
                              .toString());
                        }
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(),
        body: GetBuilder<MemberPostController>(builder: (post) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: const AssetImage('assets/profile.png'),
                    foregroundImage: NetworkImage(post
                            .post
                            .value
                            .data!
                            .postDetails!
                            .posts![widget.index]!
                            .userDetails!
                            .profileImg!
                            .isEmpty
                        ? 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'
                        : post.post.value.data!.postDetails!
                            .posts![widget.index]!.userDetails!.profileImg!),
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
                  height: Get.height * 0.30,
                  width: Get.width * 0.95,
                  child: post.post.value.data!.postDetails!
                          .posts![widget.index]!.image!.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: ClipRRect(
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
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: CarouselSlider(
                            options: CarouselOptions(
                                height: 300.0,
                                viewportFraction: 1,
                                enableInfiniteScroll: false,
                                disableCenter: false),
                            items: post.post.value.data!.postDetails!
                                .posts![widget.index]!.image!
                                .map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: GestureDetector(
                                          onTap: () {
                                            showMyDialog2(
                                                context,
                                                null,
                                                post
                                                    .post
                                                    .value
                                                    .data!
                                                    .postDetails!
                                                    .posts![widget.index]!
                                                    .image
                                                    ?.map((e) => e.toString())
                                                    .toList());
                                          },
                                          child: Image.network(
                                            i,
                                            fit: BoxFit.fitWidth,
                                            width: Get.width,
                                            loadingBuilder:
                                                (context, widget, event) {
                                              if (event?.expectedTotalBytes ==
                                                  event
                                                      ?.cumulativeBytesLoaded) {
                                                return Image.network(
                                                  i,
                                                  fit: BoxFit.fitWidth,
                                                  width: Get.width * 0.95,
                                                );
                                              } else {
                                                return CustomProgressIndicator();
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
                Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      post.post.value.data?.postDetails?.posts![widget.index]
                              ?.content ??
                          '',
                    )),
                Divider(),
                ListTile(
                  leading: Icon(Icons.comment_rounded),
                  title: Text('Comments'),
                  trailing: Text(post.post.value.data?.postDetails
                          ?.posts![widget.index]?.commentCount
                          .toString() ??
                      '0'),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: post.post.value.data?.postDetails
                          ?.posts![widget.index]?.commentCount ??
                      0,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: const AssetImage('assets/profile.png'),
                        foregroundImage: AssetImage('assets/MNU-Logo.png'),
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
                              style: getText(context).titleMedium,
                            ),
                            //
                          ]),
                      isThreeLine: true,
                      trailing: post
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
                                showLoading(context);

                                await Get.find<MemberPostController>()
                                    .CommentDelete(post
                                            .post
                                            .value
                                            .data
                                            ?.postDetails
                                            ?.posts![widget.index]!
                                            .comments![index]!
                                            .commentId
                                            .toString() ??
                                        '');
                                Get.find<MemberPostController>().post.value =
                                    (await Get.find<MemberPostController>()
                                        .loadPost(userId, 10000)!
                                        .whenComplete(
                                            () => Navigator.pop(context)))!;
                                setState(() {});
                              },
                              icon: Icon(Icons.delete),
                            )
                          : Text(''),
                      dense: true,
                    );
                  },
                ),
                SizedBox(
                  height: Get.height * 0.05,
                )
              ],
            ),
          );
        }));
  }
}

class CustomFormField extends StatefulWidget {
  const CustomFormField(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.obscureText,
      this.suffixIcon,
      this.viewIcon,
      this.validator,
      this.inputType,
      this.maxlines})
      : super(key: key);

  final TextEditingController? controller;
  final String labelText;
  final bool obscureText;
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

Future<void> showMyDialog2(
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
              : PhotoViewGallery.builder(
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
                ),
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
