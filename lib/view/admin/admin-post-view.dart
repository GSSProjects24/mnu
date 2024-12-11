import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mnu_app/controllers/admin_post%20_controllers.dart';
import '../../controllers/sessioncontroller.dart';
import '../../main.dart';
import '../../theme/myfonts.dart';
import '../profile/suggestionprofile.dart';

class AdminPostView extends StatefulWidget {
  const AdminPostView({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<AdminPostView> createState() => _AdminPostViewState();
}

class _AdminPostViewState extends State<AdminPostView> {
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
                      labelText: 'Comment Here',
                    )),
                IconButton(
                    onPressed: () {
                      Get.find<AdminPostController>()
                          .postComment(
                              context: context,
                              post_id: Get.find<AdminPostController>()
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
                        Get.find<AdminPostController>().post.value =
                            await Get.find<AdminPostController>()
                                .loadPost('', 100);
                        print(Get.find<SessionController>()
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
                    icon: Icon(Icons.send))
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(),
        body: GetBuilder<AdminPostController>(builder: (post) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: const AssetImage(
                                          'assets/profile.png'),
                    foregroundImage: const AssetImage(
                                          'assets/profile.png'),
                  ),
                  title: Text('Rampowiz'),
                  subtitle: Text('12 m ago'),
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
                                // showMyDialog(context,  'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png' )
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
                                            // showMyDialog(context, i);
                                          },
                                          child: Image.network(
                                            i,
                                            fit: BoxFit.cover,
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
                    )
                    //            ReadMoreText(
                    //
                    //     widget.post.data?.postDetails?.posts![widget.index?.content??'',
                    //              trimLength: 80,
                    //              trimMode: TrimMode.Line,
                    //              trimCollapsedText: 'Show more',
                    //              // trimExpandedText: 'Show less',
                    //              colorClickableText: Colors.grey,
                    //
                    //              moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey),
                    //              lessStyle:TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey) ,
                    // ),
                    ),
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
                        backgroundImage: AssetImage('assets/MNU-Logo.png'),
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
                              style: getText(context).bodyMedium,
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
                      isThreeLine: true,
                      trailing: IconButton(
                        onPressed: () async {
                          showLoading(context);

                          await Get.find<AdminPostController>().CommentDelete(
                              post
                                      .post
                                      .value
                                      .data
                                      ?.postDetails
                                      ?.posts![widget.index]!
                                      .comments![index]!
                                      .commentId
                                      .toString() ??
                                  '');
                          Get.find<AdminPostController>().post.value =
                              await Get.find<AdminPostController>()
                                  .loadPost('', 10000)!
                                  .whenComplete(() => Navigator.pop(context));
                          setState(() {});
                        },
                        icon: Icon(Icons.delete),
                      ),
                      dense: true,
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
      this.maxlines,
      this.onChanged})
      : super(key: key);

  final TextEditingController? controller;
  final String labelText;
  final bool obscureText;
  final Widget? suffixIcon;
  final IconButton? viewIcon;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final int? maxlines;
  final void Function(String)? onChanged;

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
      padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
      child: TextFormField(
        onChanged: widget.onChanged ?? (value) {},
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
