import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/sessioncontroller.dart';
import '../../main.dart';
import '../../models/suggestion_member_model.dart';
import 'package:http/http.dart' as http;
import '../../theme/myfonts.dart';
import '../chat/suggestionlist.dart';
import '../widgets/custom_progress_indicator.dart';

class SuggestionsProfile extends StatefulWidget {
  const SuggestionsProfile({
    Key? key,
    required this.userid,
    required this.imageurl,
    required this.isfollow,
  }) : super(key: key);

  final String userid;
  final String imageurl;
  final bool isfollow;

  @override
  State<SuggestionsProfile> createState() => _SuggestionsProfileState();
}

class _SuggestionsProfileState extends State<SuggestionsProfile> {
  bool? follow;

  Future<SuggestionMemberModel> loadMember() async {
    // var body = {
    //   "mem_prof_id":
    //       Get.find<SessionController>().session.value.data?.userId.toString()
    // };
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_edit_member_profile'),
        body: {"user_id": widget.userid});

    if (response.statusCode == 200) {
      print(response.body);
      return SuggestionMemberModel.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> followRequest() async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "follower_user_id": widget.userid
    };
    print(Get.find<SessionController>().session.value.data?.userId);
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_followingrequest'),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"});
    print(body);
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> cancelRequest() async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "follower_id": widget.userid
    };
    print(Get.find<SessionController>().session.value.data?.userId);
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_cancel_follow_request'),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"});
    print(body);
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  late Future<SuggestionMemberModel> member;
  @override
  void initState() {
    setState(() {
      follow = widget.isfollow;
      print('${follow} dddd');
    });
    member = loadMember();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            actions: [],
          ),
          body: FutureBuilder<SuggestionMemberModel>(
              future: member,
              builder: (BuildContext context,
                  AsyncSnapshot<SuggestionMemberModel> snapshot) {
                if (snapshot.hasData) {
                  final bool isFriend = snapshot.data?.data?.followersList?.any(
                        (follower) =>
                            follower.friendId ==
                            int.tryParse(Get.find<SessionController>()
                                    .session
                                    .value
                                    .data
                                    ?.userId
                                    .toString() ??
                                ''),
                      ) ??
                      false;

                  debugPrint("isFriend:${snapshot.data?.data?.followersList}");
                  debugPrint(
                      "isFriend:${Get.find<SessionController>().session.value.data?.userId}");
                  debugPrint("userId:${widget.userid}");
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
                                    Text(
                                      '${snapshot.data?.data?.memberName ?? ''}',
                                      style: getText(context)
                                          .headlineSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                    Text(snapshot.data?.data?.position ?? '',
                                        style: getText(context)
                                            .titleLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                            )),
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
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(200)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 50,
                                      backgroundImage: const AssetImage(
                                          'assets/profile.png'),
                                      foregroundImage: NetworkImage(
                                        widget.imageurl.isNotEmpty == true
                                            ? widget.imageurl.toString() ?? ''
                                            : 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),

                        follow == false
                            ? Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (isFriend != true) {
                                        showLoading(context);

                                        followRequest().then((value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text(value['message'])));
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SuggestionList()),
                                          );
                                        });
                                        setState(() {
                                          follow = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Get.width * 0.20),
                                      child:
                                          Text(isFriend ? 'Friend' : 'Follow'),
                                    )))
                            : Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (isFriend != true) {
                                        showLoading(context);
                                        cancelRequest().then((value) => {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          value['message']))),
                                              Navigator.of(context).pop(),
                                              Navigator.of(context).pop(),
                                              Navigator.of(context).pop(),
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SuggestionList()),
                                              )
                                            });
                                        setState(() {
                                          follow = false;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Get.width * 0.20),
                                      child: const Text('Cancel Request'),
                                    )),
                              ),

                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Social Details ',
                            style: getText(context).titleLarge,
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //       subtitle: Text(
                        //         snapshot.data?.data?.memberName ?? '',
                        //         style: getText(context).titleMedium,
                        //       ),
                        //       leading: Icon(
                        //         Icons.email,
                        //         color: clrschm.primary,
                        //       ),
                        //       title: Text(
                        //         'Email',
                        //         style: getText(context).titleMedium?.copyWith(color: Colors.grey),
                        //       )),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //       subtitle: Text(snapshot.data?.data?.dob??'',style: getText(context).titleMedium,),

                        //       leading: Icon(Icons.calendar_month,color: clrschm.primary,),
                        //       title: Text('DOB',style: getText(context).titleMedium?.copyWith(color: Colors.grey),)

                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //       subtitle: Text(snapshot.data?.data?.newIcno??'',style: getText(context).titleMedium,),

                        //       leading: Icon(Icons.badge,color: clrschm.primary,),
                        //       title: Text('NRIC',style: getText(context).titleMedium?.copyWith(color: Colors.grey),)

                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //       subtitle: Text(snapshot.data?.data?.employeeNo??'',style: getText(context).titleMedium,),

                        //       leading: Icon(Icons.engineering,color: clrschm.primary,),
                        //       title: Text('Employee Number',style: getText(context).titleMedium?.copyWith(color: Colors.grey),)

                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //       subtitle: Text(snapshot.data?.data?.basicSalary.toString()??'',style: getText(context).titleMedium,),

                        //       leading: Icon(Icons.monetization_on,color: clrschm.primary,),
                        //       title: Text('Basic Salary',style: getText(context).titleMedium?.copyWith(color: Colors.grey),)

                        //   ),
                        // ),

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ListTile(
                            subtitle: Text(
                              snapshot.data?.data?.memberName ?? '',
                              style: getText(context).titleMedium,
                            ),
                            leading: Icon(
                              Icons.person,
                              color: clrschm.primary,
                            ),
                            title: Text(
                              'User Name',
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
                              snapshot.data?.data?.telephoneNo ?? '',
                              style: getText(context).titleMedium,
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
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //       subtitle: Text(snapshot.data?.data?.gender??'',style: getText(context).titleMedium,),

                        //       leading: Icon(Icons.man,color: clrschm.primary,),
                        //       title: Text('Gender',style: getText(context).titleMedium?.copyWith(color: Colors.grey),)

                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //       subtitle:Text(snapshot.data?.data?.address??'',style: getText(context).titleMedium,),

                        //       leading: Icon(Icons.location_city,color: clrschm.primary,),
                        //       title: Text('Address',style: getText(context).titleMedium?.copyWith(color: Colors.grey),)

                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //       subtitle:Text(snapshot.data?.data?.postalCode??'',style: getText(context).titleMedium,),

                        //       leading: Icon(Icons.contact_mail,color: clrschm.primary,),
                        //       title: Text('Pincode',style: getText(context).titleMedium?.copyWith(color: Colors.grey),)

                        //   ),
                        // ),

                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: ListTile(
                        //       subtitle: Text(snapshot.data?.data?.entranceFee??'',style: getText(context).titleMedium,),

                        //       leading: Icon(Icons.engineering,color: clrschm.primary,),
                        //       title: Text('Entrance Fee',style: getText(context).titleMedium?.copyWith(color: Colors.grey),)

                        //   ),
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

Future<void> showLoading(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return CustomProgressIndicator();
    },
  );
}
