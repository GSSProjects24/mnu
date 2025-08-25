import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/sessioncontroller.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../../models/following_model.dart';
import '../../theme/color_schemes.g.dart';
import 'friends-profile.dart';

class FollowingList extends StatefulWidget {
  const FollowingList({super.key});

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  int page = 1;
  int totalPage = 1;
  int limit = 13;
  Future<FollowingModel?> loadFollowing() async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString() ??
              '',
      "page": page.toString(),
      "limit": '10000',
      "logged_user_id":
          Get.find<SessionController>().session.value.data?.userId.toString()
    };

    try {
      final response = await http.post(
        Uri.parse(
            'https://api.malayannursesunion.xyz/api_following_list'),
        body: body,
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final jsonResponse = json.decode(response.body);
        return FollowingModel.fromJson(jsonResponse);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error loading following data: $e');
      return null;
    }
  }


  Future<Map<String, dynamic>> unfollow({required String following}) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "follower_id": following
    };
    if (kDebugMode) {
      print(Get.find<SessionController>().session.value.data?.userId);
    }
    final response = await http.post(
        Uri.parse(
            'https://api.malayannursesunion.xyz/api_unfollow_request'),
        body: body);
    if (kDebugMode) {
      print(body);
    }

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return jsonDecode(response.body);
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
    }
  }

  bool isLoading = false;
  bool isAllLoaded = false;
  int totalreports = -1;


  late Future<FollowingModel?> following;
  @override
  void initState() {
    following = loadFollowing();
    super.initState();
    searchController = TextEditingController();
    following = loadFollowing().then((model) {
      if (model != null) {
        allFollowers = model.data!.followDetails.followers;
        filteredFollowers = allFollowers;
      }
      return model;
    });
    // Listen for changes in the search text
    searchController.addListener(() {
      filterFollowers();
    });
  }

  void dispose() {
    searchController.dispose(); // Clean up the controller when not needed
    super.dispose();
  }

  late TextEditingController searchController;
  List<Follower> filteredFollowers = [];
  List<Follower> allFollowers = [];
  void filterFollowers() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredFollowers = allFollowers
          .where((follower) => follower.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Friends',
          style: TextStyle(color: clrschm.onPrimary),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 45,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search friends...',
                  suffixIcon: Icon(
                    Icons.search,
                    color: lightColorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<FollowingModel?>(
              future: following,
              builder: (BuildContext context,
                  AsyncSnapshot<FollowingModel?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    snapshot.data?.data == null ||
                    snapshot.data!.data!.followDetails.followers.isEmpty) {
                  return Center(child: Text('No following'));
                } else {
                  if (filteredFollowers.isEmpty && allFollowers.isEmpty) {
                    allFollowers = snapshot.data!.data!.followDetails.followers;
                    filteredFollowers = allFollowers;
                  }
                  return ListView.builder(
                    itemCount: filteredFollowers.length,
                    itemBuilder: (BuildContext context, int index) {
                      Follower follower = filteredFollowers[index];
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Get.to(
                              () => FriendsProfile(
                                memberNo: follower.followingId.toString(),
                                name: follower.name,
                                isFollowing: true,
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            radius: 15,
                            foregroundImage: NetworkImage(
                              follower.profileImage.isNotEmpty == true
                                  ? follower.profileImage
                                  : 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png',
                            ),
                            backgroundImage:
                                const AssetImage('assets/MNU-Logo.png'),
                          ),
                          title: Text(
                            follower.name,
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),

          // Expanded(
          //   child: FutureBuilder<FollowingModel?>(
          //     future: following,
          //     builder: (BuildContext context, AsyncSnapshot<FollowingModel?> snapshot) {
          //       if (snapshot.hasData) {
          //         return ListView.builder(
          //           itemCount: filteredFollowers.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             Follower follower = filteredFollowers[index];
          //             return Card(
          //               child: ListTile(
          //                 onTap: () {
          //                   Get.to(
          //                         () => FriendsProfile(
          //                       memberNo: follower.followingId.toString(),
          //                       name: follower.name ?? '',
          //                       isFollowing: true,
          //                     ),
          //                   );
          //                 },
          //                 leading: CircleAvatar(
          //                   radius: 15,
          //                   foregroundImage: NetworkImage(follower.profileImage ?? ''),
          //                   backgroundImage: AssetImage('assets/MNU-Logo.png'),
          //                 ),
          //                 title: Text(
          //                   follower.name ?? '',
          //                   style: TextStyle(fontSize: 10),
          //                 ),
          //               ),
          //             );
          //           },
          //         );
          //       } else if (snapshot.hasError) {
          //         return Center(child: Text(snapshot.error.toString()));
          //       } else if (snapshot.connectionState == ConnectionState.waiting) {
          //         return CustomProgressIndicator();
          //       }
          //       return CustomProgressIndicator();
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class loadPagination {
  ScrollController scrollcontroller = ScrollController();
  bool isLoading = false;

  int page = 1;
  int totalPage = 1;

  Function()? onEnd;
  Function()? onStart;

  void Function() loadFunction(
    BuildContext context,
  ) {
    return () {
      if ((scrollcontroller.position.pixels ==
              scrollcontroller.position.maxScrollExtent) &&
          (page <= totalPage)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Loading......')));

        onEnd;
      }

      if ((scrollcontroller.position.pixels ==
              scrollcontroller.position.maxScrollExtent) &&
          (page == totalPage)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Maximum page Reached')));
      }
    };
  }
}
