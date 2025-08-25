import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/sessioncontroller.dart';
import 'package:http/http.dart' as http;

import '../../models/followers-model.dart';
import '../../theme/color_schemes.g.dart';
import '../widgets/custom_progress_indicator.dart';
import 'friends-profile.dart';

class FollowersList extends StatefulWidget {
  const FollowersList({super.key});

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {
  Future<FollowersModel> loadFollowers() async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "page": '1',
      "limit": '10000'
    };
    if (kDebugMode) {
      print(Get.find<SessionController>().session.value.data?.userId);
    }
    final response = await http.post(
        Uri.parse(
            'https://api.malayannursesunion.xyz/api_followers_list'),
        body: body);

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return FollowersModel.fromJson(jsonDecode(response.body));
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> unfollow(String followersId) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "follower_id": followersId
    };
    if (kDebugMode) {
      print(Get.find<SessionController>().session.value.data?.userId);
    }
    final response = await http.post(
        Uri.parse(
            'https://api.malayannursesunion.xyz/api_unfollow_request'),
        body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      ;
      throw Exception('Failed to load data');
    }
  }

  List<Follower>? allFollowers = [];
  List<Follower>? filteredFollowers = [];
  TextEditingController searchController = TextEditingController();
  void filterFollowers(String query) {
    final filtered = allFollowers?.where((follower) {
      final name = follower.name?.toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();
      return name.contains(searchQuery);
    }).toList();

    setState(() {
      filteredFollowers = filtered;
    });
  }

  late Future<FollowersModel> followers;

  ScrollController scrollcontroller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    //

    followers = loadFollowers();
    super.initState();
    followers.then((followerData) {
      setState(() {
        // Using whereType<Follower>() to filter out any null entries
        allFollowers = followerData.data?.followDetails?.followers
            ?.whereType<Follower>()
            .toList();
        filteredFollowers = allFollowers;
      });
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Followers',
          style: TextStyle(color: Colors.white),
        ),
        actions: [],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 45,
              child: TextField(
                controller: searchController,
                onChanged: (value) => filterFollowers(value),
                decoration: InputDecoration(
                  hintText: 'Search followers...',
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
            child: FutureBuilder(
              future: followers,
              builder: (BuildContext context,
                  AsyncSnapshot<FollowersModel> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomProgressIndicator();
                } else if (snapshot.hasError) {
                  if (kDebugMode) {
                    print(snapshot.error.toString());
                  }
                  return const Center(child: Icon(Icons.error_outline));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: filteredFollowers?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      final follower = filteredFollowers?[index];
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Get.to(() => FriendsProfile(
                                  memberNo:
                                      follower?.followersId.toString() ?? '',
                                  name: follower?.name ?? '',
                                ));
                          },
                          leading: CircleAvatar(
                            radius: 15,
                            foregroundImage: NetworkImage(
                              follower?.profileImage?.isNotEmpty == true
                                  ? follower!.profileImage!
                                  : 'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png',
                            ),
                            backgroundImage:
                                const AssetImage('assets/MNU-Logo.png'),
                          ),
                          title: Text(
                            follower?.name ?? '',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No followers'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
