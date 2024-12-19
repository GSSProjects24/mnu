import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/sessioncontroller.dart';
import '../../main.dart';
import '../../models/RegisteredMembersModel.dart';
import 'package:http/http.dart' as http;

import '../../theme/myfonts.dart';
import '../admin/admin-post-view.dart';
import '../profile/suggestionprofile.dart';
import '../widgets/custom_progress_indicator.dart';

class SuggestionList extends StatefulWidget {
  const SuggestionList({Key? key}) : super(key: key);

  @override
  State<SuggestionList> createState() => _SuggestionListState();
}

class _SuggestionListState extends State<SuggestionList> {
  Future<RegisteredMembersModel> loadFriends({String? search}) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString()!,
      "search": search ?? ""
    };
    debugPrint(
        'user id ${Get.find<SessionController>().session.value.data?.userId.toString()!}');
    debugPrint('search : ${search}');
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_suggestion_member_list'),
        body: body);

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return RegisteredMembersModel.fromJson(jsonDecode(response.body));
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
    }
  }

  late Future<RegisteredMembersModel> list;
  TextEditingController search = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    list = loadFriends();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Suggestions',
              style: TextStyle(color: clrschm.onPrimary),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CustomFormField(
                    controller: search,
                    suffixIcon: const Icon(Icons.search),
                    labelText: '',
                    obscureText: false,
                    onChanged: (value) {
                      setState(() {
                        list = loadFriends(search: value ?? '');
                      });
                    },
                  ),
                ),
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<RegisteredMembersModel>(
              future: list,
              builder: (BuildContext context,
                  AsyncSnapshot<RegisteredMembersModel> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.data?.memberDetails?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        surfaceTintColor: Colors.white,
                        color: Colors.white,
                        child: ListTile(
                          onTap: () {
                            Get.to(() => SuggestionsProfile(
                                  userid: snapshot.data?.data
                                          ?.memberDetails?[index]?.userId
                                          .toString() ??
                                      '',
                                  imageurl: snapshot
                                          .data
                                          ?.data
                                          ?.memberDetails?[index]
                                          ?.profile_image ??
                                      '',
                                  isfollow: snapshot
                                          .data
                                          ?.data
                                          ?.memberDetails?[index]
                                          ?.isFollowRequest ??
                                      false,
                                ));
                          },
                          dense: true,
                          trailing: TextButton(
                            onPressed: () {
                              debugPrint(
                                  'Profile Image URL: ${snapshot.data?.data?.memberDetails?[index]?.profile_image}');
                              Get.to(() => SuggestionsProfile(
                                    userid: snapshot.data?.data
                                            ?.memberDetails?[index]?.userId
                                            .toString() ??
                                        '',
                                    imageurl: snapshot
                                            .data
                                            ?.data
                                            ?.memberDetails?[index]
                                            ?.profile_image ??
                                        '',
                                    isfollow: snapshot
                                            .data
                                            ?.data
                                            ?.memberDetails?[index]
                                            ?.isFollowRequest ??
                                        false,
                                  ));
                            },
                            child: const Text('view'),
                          ),
                          subtitle: Text(
                            snapshot.data?.data?.memberDetails?[index]
                                    ?.companyName ??
                                '',
                            style: getText(context)
                                .titleMedium!
                                .copyWith(fontSize: 10),
                          ),
                          title: Text(snapshot.data?.data?.memberDetails?[index]
                                  ?.memberName ??
                              ''),
                          leading: CircleAvatar(
                            backgroundImage:
                                const AssetImage('assets/profile.png'),
                            foregroundImage: NetworkImage(
                              snapshot.data?.data?.memberDetails?[index]
                                          ?.profile_image?.isNotEmpty ==
                                      true
                                  ? snapshot.data?.data?.memberDetails![index]
                                          ?.profile_image
                                          ?.toString() ??
                                      ''
                                  : 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png',
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Icon(Icons.error_outline));
                } else {
                  return CustomProgressIndicator();
                }
              }),
        ));
  }
}
