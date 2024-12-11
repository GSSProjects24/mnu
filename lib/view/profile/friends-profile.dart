import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mnu_app/models/campany_model.dart';
import 'package:mnu_app/view/profile/friend_requestlist.dart';
import 'package:photo_view/photo_view.dart';

import '../../controllers/sessioncontroller.dart';
import '../../main.dart';
import '../../models/followers-model.dart';
import '../../models/member-model.dart';
import 'package:http/http.dart' as http;
import '../../theme/myfonts.dart';
import '../chat/chat_screen.dart';
import '../homePage.dart';
import '../widgets/custom_progress_indicator.dart';

class FriendsProfile extends StatefulWidget {
  const FriendsProfile({
    Key? key,
    required this.memberNo,
    required this.name,
    this.profileImage,
    this.isFollowing,
    this.isfollower,
    this.profileId,
  }) : super(key: key);
  final String? profileId;
  final String memberNo;
  final String name;
  final profileImage;
  final bool? isFollowing;
  final bool? isfollower;

  @override
  State<FriendsProfile> createState() => _FriendsProfileState();
}

class _FriendsProfileState extends State<FriendsProfile> {
  bool isFollwing = false;
  Future<MemberModel> loadMember() async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
    };
    print(Get.find<SessionController>().session.value.data?.userId);
    final response = await http.post(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_getuser'),
        body: {
          "user_id": widget.memberNo,
          "logged_user_id": Get.find<SessionController>()
              .session
              .value
              .data
              ?.userId
              .toString(),
        });

    if (response.statusCode == 200) {
      print(response.body);
      return MemberModel.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> unfollow(String followersId) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "follower_id": followersId
    };
    print(Get.find<SessionController>().session.value.data?.userId);
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_unfollow_request'),
        body: body);
    print('${body}bbbbbbbbbbbbbbbbb');

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> companyupdatenamelist(
      String userId, String newCompanyName, String followerUserId) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "changed_user_id": followerUserId,
      "company_name": newCompanyName
    };

    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_update_company_name'),
        body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Companynames> fetchCompany() async {
    final response = await http.get(Uri.parse(
        'http://mnuapi.graspsoftwaresolutions.com/api_company_detail'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Companynames.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<FollowersModel> loadFollowers() async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "page": '1',
      "limit": '10000'
    };
    print(Get.find<SessionController>().session.value.data?.userId);
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_followers_list'),
        body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return FollowersModel.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  late Future<MemberModel> member;
  late Future<FollowersModel> followers;

  ScrollController scrollcontroller = ScrollController();
  Companynames? companynames;

  @override
  void initState() {
    // TODO: implement initState
    followers = loadFollowers();
    member = loadMember();
    super.initState();

    fetchCompany().then((value) {
      setState(() {
        companynames = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(

              // actions: [
              //
              //   IconButton(onPressed: (){
              //
              //     Get.to(()=>SettingsPage());
              //
              //   }, icon: Icon(Icons.settings))
              //
              //
              // ],
              ),
          body: FutureBuilder<MemberModel>(
              future: member,
              builder:
                  (BuildContext context, AsyncSnapshot<MemberModel> snapshot) {
                if (snapshot.hasData) {
                  print(" ADSASDASDADASDSA${snapshot.data?.data?.companyName}");
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
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        snapshot.data?.data?.memberName ?? '',
                                        style: getText(context)
                                            .bodyMedium!
                                            .copyWith(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data?.data?.position ?? '',
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
                              top: Get.height * 0.09,
                              left: Get.width * 0.35,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    showMyDialog(
                                        context,
                                        snapshot.data?.data?.profile_image ??
                                            'http://mnuapi.graspsoftwaresolutions.com/public/images/user.png');
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(200)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 50,
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
                            )
                          ],
                        ),
                        widget.isFollowing != true
                            ? Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => ChatScreen(
                                            receiverId:
                                                widget.memberNo.toString(),
                                            receiverImageUrl:
                                                widget.profileImage.toString(),
                                            Name: snapshot
                                                    .data?.data?.memberName ??
                                                ''.toString(),
                                          ));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Get.width * 0.10),
                                      child: const Text('Message'),
                                    )))
                            // : Text(''),
                            // widget.isfollower != true
                            : Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.to(() => ChatScreen(
                                                receiverId:
                                                    widget.memberNo.toString(),
                                                receiverImageUrl: widget
                                                    .profileImage
                                                    .toString(),
                                                Name: snapshot.data?.data
                                                        ?.memberName ??
                                                    ''.toString(),
                                              ));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Get.width * 0.03),
                                          child: const Text('Message'),
                                        )),
                                    ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    content: const Text(
                                                        'Are you sure?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child:
                                                            const Text('Yes'),
                                                        onPressed: () {
                                                          unfollow(snapshot
                                                                      .data
                                                                      ?.data
                                                                      ?.userId
                                                                      .toString() ??
                                                                  '')
                                                              .then((value) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text("Unfollowed Sucessfully")));
                                                          });
                                                          Get.to(() =>
                                                              const HomePage());
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: const Text('No'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  ));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Get.width * 0.005),
                                          child: const Text('Unfollow'),
                                        ))
                                  ],
                                ),
                              ),
                        //  :Text('')
                        const Divider(),

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
                              snapshot.data?.data?.emailId ?? '',
                              style: getText(context).bodySmall,
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
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ListTile(
                            subtitle: Text(
                              snapshot.data?.data?.memberName.toString() ?? '',
                              style: getText(context).bodySmall,
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
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //     subtitle: Text(
                        //       snapshot.data?.data?.companyName ?? 'sfdzsd' ,
                        //       style: getText(context).bodySmall,
                        //     ),
                        //     leading: Icon(
                        //       Icons.person,
                        //       color: clrschm.primary,
                        //     ),
                        //     title: Text(
                        //       'Hosptial Name',
                        //       style: getText(context)
                        //           .titleSmall
                        //           ?.copyWith(color: Colors.grey),
                        //     ),
                        //   ),
                        // ),
                        if (Get.find<SessionController>()
                                .session
                                .value
                                .data!
                                .role ==
                            1)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ListTile(
                              subtitle: Text(
                                snapshot.data?.data?.companyName.toString() ??
                                    '',
                                style: getText(context).bodySmall,
                              ),
                              leading: Icon(
                                Icons.work,
                                color: clrschm.primary,
                              ),
                              title: Text(
                                'Hosptial Name',
                                style: getText(context)
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: SizedBox(
                                              height: 130,
                                              child: Card(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child:
                                                          DropdownButtonFormField(
                                                              menuMaxHeight:
                                                                  300,
                                                              isExpanded: true,
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Hospital Name/Nama Hospital',
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                contentPadding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            20,
                                                                            24,
                                                                            16,
                                                                            16),
                                                              ),
                                                              items: companynames
                                                                  ?.data!
                                                                  .company!
                                                                  .map<
                                                                      DropdownMenuItem<
                                                                          Company>>((Company
                                                                      value) {
                                                                return DropdownMenuItem(
                                                                  value: value,
                                                                  child: Text(value
                                                                          .name!
                                                                          .substring(
                                                                              0,
                                                                              1)
                                                                          .toUpperCase() +
                                                                      value
                                                                          .name!
                                                                          .substring(
                                                                              1)
                                                                          .toLowerCase()),
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  companyupdatenamelist(
                                                                          '1',
                                                                          value!
                                                                              .name!,
                                                                          snapshot
                                                                              .data!
                                                                              .data!
                                                                              .followerUserId!
                                                                              .toString())
                                                                      .then(
                                                                          (value) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(const SnackBar(
                                                                            content:
                                                                                Text("Hosptial detail updated successfully")));
                                                                  });
                                                                  Get.to(() =>
                                                                      const HomePage());
                                                                });
                                                              }),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ListTile(
                              subtitle: Text(
                                snapshot.data?.data?.companyName.toString() ??
                                    '',
                                style: getText(context).bodySmall,
                              ),
                              leading: Icon(
                                Icons.work,
                                color: clrschm.primary,
                              ),
                              title: Text(
                                'Hosptial Name',
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
                              snapshot.data?.data?.telephoneNo ?? '',
                              style: getText(context).bodySmall,
                            ),
                            leading: Icon(
                              Icons.phone,
                              color: clrschm.primary,
                            ),
                            title: Text(
                              'Telephone No',
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
                              snapshot.data?.data?.doj ?? '',
                              style: getText(context).bodySmall,
                            ),
                            leading: Icon(
                              Icons.calendar_month,
                              color: clrschm.primary,
                            ),
                            title: Text(
                              'DOJ',
                              style: getText(context)
                                  .titleSmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(child: Icon(Icons.error_outline));
                } else {
                  return const CustomProgressIndicator();
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
                imageProvider: NetworkImage(
                  (url.isNotEmpty)
                      ? url
                      : 'http://mnuapi.graspsoftwaresolutions.com/public/images/user.png',
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close')),
          )
        ],
      );
    },
  );
}
