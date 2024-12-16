import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mnu_app/view/profile/hide_post_list.dart';
import 'package:photo_view/photo_view.dart';

import '../../controllers/sessioncontroller.dart';
import '../../main.dart';
import '../../models/member-model.dart';

import 'package:http/http.dart' as http;

import '../../models/sessionModel.dart';
import '../../theme/myfonts.dart';
import '../auth/landing-page.dart';
import '../chat/suggestionlist.dart';
import '../homePage.dart';
import '../profile/edit_profile.dart';
import '../profile/followers-page.dart';
import '../profile/following_Page.dart';
import '../profile/member card.dart';
import '../widgets/custom_progress_indicator.dart';
import 'post_list_view_home.dart';

class UsersProfile extends StatefulWidget {
  const UsersProfile({Key? key}) : super(key: key);

  @override
  State<UsersProfile> createState() => _UsersProfileState();
}

class _UsersProfileState extends State<UsersProfile> {
  String? imageurl;

  Future<MemberModel> loadMember() async {
    var body = {
      "mem_prof_id":
          Get.find<SessionController>().session.value.data?.userId.toString()
    };
    print(Get.find<SessionController>().session.value.data?.userId);
    final response = await http.post(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_getuser'),
        body: {
          "user_id": Get.find<SessionController>()
              .session
              .value
              .data
              ?.userId
              .toString(),
          "logged_user_id": Get.find<SessionController>()
              .session
              .value
              .data
              ?.userId
              .toString()
        });

    if (response.statusCode == 200) {
      print(response.body);
      return MemberModel.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
    return MemberModel();
  }

  Future<Map<String, dynamic>> tokenLogout() async {
    debugPrint("logout");
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString()
    };
    final response = await http.post(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_logout'),
        body: body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return (jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  late Future<MemberModel> member;
  @override
  void initState() {
    // TODO: implement initState
    member = loadMember();
    super.initState();
  }

  Future<void> showedit(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return SizedBox(
              height: Get.height * 0.80,
              child: EditProfile(
                  imageurl: imageurl ??
                      'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'));
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // backgroundColor: clrschm.secondary,
            actions: [
              IconButton(
                onPressed: () {
                  showedit(context).then((value) {
                    setState(() {
                      member = loadMember();
                    });
                  });

                  // Get.to(()=>EditProfile(
                  //   imageurl:imageurl??'' ,
                  //
                  //
                  // ));
                },
                icon: const Icon(Icons.edit),
                color: clrschm.onPrimary,
              ),
              IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await FirebaseMessaging.instance
                                        .unsubscribeFromTopic(
                                            Get.find<SessionController>()
                                                    .session
                                                    .value
                                                    .data
                                                    ?.userId
                                                    .toString() ??
                                                '');
                                    tokenLogout();
                                    Get.find<SessionController>()
                                        .session
                                        .value
                                        .logOut();
                                    Get.find<SessionController>()
                                        .session
                                        .value = Session();
                                    Navigator.of(context).pop();
                                    Get.offAll(() => const LandingPage());
                                    // setState(() {
                                    //   tokenLogout();
                                    // });
                                  },
                                  child: const Text('Yes')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    // setState(() {
                                    //   Get.to(() => const HomePage(
                                    //         selectedTab: 0,
                                    //       ));
                                    // });
                                  },
                                  child: const Text('No')),
                            ],
                            title: const Text('Logout'),
                            content: const Text('Are you sure?'),
                          ));
                  // Get.find<SessionController>().session.value.logOut();
                  // Get.find<SessionController>().session.value = Session();
                  // Get.to(() => LandingPage());
                },
                icon: const Icon(Icons.logout_rounded),
                color: clrschm.onPrimary,
              ),

              // IconButton(onPressed: (){
              //
              //   Get.to(()=>SettingsPage());
              //
              // }, icon: Icon(Icons.settings))
            ],
          ),
          body: FutureBuilder<MemberModel>(
              future: member,
              builder:
                  (BuildContext context, AsyncSnapshot<MemberModel> snapshot) {
                if (snapshot.hasData) {
                  imageurl = snapshot.data?.data?.profile_image;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              child: Image.asset(
                                'assets/back2.png',
                                fit: BoxFit.fitWidth,
                                width: Get.width * 1.1,
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12.0, top: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        snapshot.data?.data?.memberName ?? '',
                                        style: (getText(context).titleLarge)!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data?.data?.position
                                                  .toString() ==
                                              "null"
                                          ? ""
                                          : snapshot.data?.data?.position ?? '',
                                      style: getText(context)
                                          .titleMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: Get.width,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: Get.height * 0.08,
                              left: Get.width * 0.30,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    showMyDialog(
                                        context,
                                        snapshot.data?.data?.profile_image ??
                                            'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png');
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(200)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 70,
                                        backgroundImage: const AssetImage(
                                            'assets/profile.png'),
                                        foregroundImage: (snapshot.data?.data
                                                        ?.profile_image
                                                        ?.toString() ??
                                                    '')
                                                .isNotEmpty
                                            ? NetworkImage(snapshot
                                                    .data?.data?.profile_image
                                                    ?.toString() ??
                                                '')
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 260),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => Membercard());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      backgroundColor: const Color.fromARGB(
                                          255, 72, 65, 167), // Button color

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation:
                                          4, // Elevation value for the button
                                    ),
                                    child: const Text(
                                      'Member Card',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )),
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (snapshot.data?.data?.postCount
                                            .toString() !=
                                        'null') {
                                      bool? result =
                                          await Get.to(() => HomeListPostPage(
                                                title: 'My posts',
                                                apiurl: Get.find<
                                                                SessionController>()
                                                            .session
                                                            .value
                                                            .data
                                                            ?.userId
                                                            .toString() ==
                                                        "1"
                                                    ? "http://mnuapi.graspsoftwaresolutions.com/api_member_post_list"
                                                    : 'http://mnuapi.graspsoftwaresolutions.com/api_member_post_list',
                                                isMember: true,
                                              ));
                                      debugPrint("result:$result");
                                      if (result == null) {
                                        setState(() {
                                          member = loadMember();
                                        });
                                      } else if (result == true) {
                                        setState(() {
                                          member = loadMember();
                                        });
                                      }
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot.data?.data?.postCount
                                                    .toString() ==
                                                'null'
                                            ? '0'
                                            : snapshot.data?.data?.postCount
                                                    .toString() ??
                                                '',
                                        style: getText(context)
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Posts',
                                        style: getText(context).bodySmall,
                                        softWrap: false, // Avoids line breaks
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    if (snapshot.data?.data?.followersCount
                                            .toString() !=
                                        'null') {
                                      Get.to(() => const FollowersList());
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot.data?.data?.followersCount
                                                    .toString() ==
                                                'null'
                                            ? '0'
                                            : snapshot
                                                    .data?.data?.followersCount
                                                    .toString() ??
                                                '',
                                        style: getText(context)
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Followers',
                                        style: getText(context).bodySmall,
                                        softWrap: false, // Avoids line breaks
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    if (snapshot.data?.data?.followingCount
                                            .toString() !=
                                        'null') {
                                      Get.to(() => const FollowingList());
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot.data?.data?.followingCount
                                                    .toString() ==
                                                'null'
                                            ? '0'
                                            : snapshot
                                                    .data?.data?.followingCount
                                                    .toString() ??
                                                '',
                                        style: getText(context)
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                        softWrap: false, // Avoids line breaks
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Following',
                                        style: getText(context).bodySmall,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () async {
                                    debugPrint(
                                        "hideCount:${snapshot.data?.data?.postHideCount}");
                                    if (snapshot.data?.data?.postHideCount !=
                                        0) {
                                      bool? result = await Get.to(() =>
                                          const HidePostPage(
                                              title: "Hide Post",
                                              apiurl:
                                                  "http://mnuapi.graspsoftwaresolutions.com/api_post_hide_list"));
                                      debugPrint("result:$result");
                                      if (result == null) {
                                        setState(() {
                                          member = loadMember();
                                        });
                                      } else if (result == true) {
                                        setState(() {
                                          member = loadMember();
                                        });
                                      }
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot.data?.data?.postHideCount
                                                    .toString() ==
                                                'null'
                                            ? '0'
                                            : snapshot.data?.data?.postHideCount
                                                    .toString() ??
                                                '',
                                        style: getText(context)
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                        softWrap: false, // Avoids line breaks
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Hide Posts',
                                        style: getText(context).bodySmall,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => const SuggestionList());
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.groups,
                                        size: 28,
                                      ),
                                      Text(
                                        'Suggestions',
                                        style: getText(context).bodySmall,
                                        softWrap: false, // Avoids line breaks
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Social Details',
                            style: getText(context).titleLarge,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ListTile(
                              subtitle: Text(
                                snapshot.data?.data?.emailId ?? '',
                                style: getText(context).bodyMedium,
                              ),
                              leading: Icon(
                                Icons.email,
                                color: clrschm.primary,
                              ),
                              title: Text(
                                'Email',
                                style: getText(context)
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey),
                              )),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //       subtitle: Text(snapshot.data?.data?.dob??'',style: getText(context).titleMedium,),
                        //
                        //       leading: Icon(Icons.calendar_month,color: clrschm.primary,),
                        //       title: Text('DOB',style: getText(context).titleMedium?.copyWith(color: Colors.grey),)
                        //
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //       subtitle: Text(snapshot.data?.data?.newIcno??'',style: getText(context).titleMedium,),
                        //
                        //       leading: Icon(Icons.badge,color: clrschm.primary,),
                        //       title: Text('NRIC',style: getText(context).titleMedium?.copyWith(color: Colors.grey),)
                        //
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //       subtitle: Text(snapshot.data?.data?.employeeNo??'',style: getText(context).titleMedium,),
                        //
                        //       leading: Icon(Icons.engineering,color: clrschm.primary,),
                        //       title: Text('Employee Number',style: getText(context).titleMedium?.copyWith(color: Colors.grey),)
                        //
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //       subtitle: Text(snapshot.data?.data?.basicSalary.toString()??'',style: getText(context).titleMedium,),
                        //
                        //       leading: Icon(Icons.monetization_on,color: clrschm.primary,),
                        //       title: Text('Basic Salary',style: getText(context).titleMedium?.copyWith(color: Colors.grey),)
                        //
                        //   ),
                        // ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Member Details',
                            style: getText(context).titleLarge,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ListTile(
                            subtitle: Text(
                              snapshot.data?.data?.memberName.toString() ?? '',
                              style: getText(context).bodyMedium,
                            ),
                            leading: Icon(
                              Icons.person,
                              color: clrschm.primary,
                            ),
                            title: Text(
                              'User Name',
                              style: getText(context)
                                  .titleSmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ListTile(
                              subtitle: Text(
                                snapshot.data?.data?.companyName.toString() ??
                                    '',
                                style: getText(context).bodyMedium,
                              ),
                              leading: Icon(
                                Icons.work,
                                color: clrschm.primary,
                              ),
                              title: Text(
                                'Hospital Name',
                                style: getText(context)
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ListTile(
                            subtitle: Text(
                              snapshot.data?.data?.telephoneNo.toString() ==
                                      'null'
                                  ? ""
                                  : snapshot.data?.data?.telephoneNo ?? '',
                              style: getText(context).bodySmall,
                            ),
                            leading: Icon(
                              Icons.phone,
                              color: clrschm.primary,
                            ),
                            title: Text(
                              'Telephone No',
                              style: getText(context)
                                  .titleMedium
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ListTile(
                            subtitle: Text(
                              snapshot.data?.data?.doj == 'null'
                                  ? DateTime.now().toString()
                                  : snapshot.data?.data?.doj.toString() ?? '',
                              style: getText(context).bodyMedium,
                            ),
                            leading: Icon(
                              Icons.calendar_month,
                              color: clrschm.primary,
                            ),
                            title: Text(
                              'Date of Joining',
                              style: getText(context)
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //       subtitle: Text(snapshot.data?.data?.entranceFee??'',style: getText(context).titleMedium,),
                        //
                        //       leading: Icon(Icons.engineering,color: clrschm.primary,),
                        //       title: Text('Entrance Fee',style: getText(context).titleMedium?.copyWith(color: Colors.grey),)
                        //
                        //   )
                        // ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Icon(Icons.error_outline));
                } else {
                  return CustomProgressIndicator();
                }
              })),
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
