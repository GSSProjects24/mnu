import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/sessioncontroller.dart';
import 'package:http/http.dart' as http;

import '../../models/followers-model.dart';
import '../../theme/color_schemes.g.dart';
import '../widgets/custom_progress_indicator.dart';
import 'friends-profile.dart';

class FollowersList extends StatefulWidget {
  const FollowersList({Key? key}) : super(key: key);

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
                  return CustomProgressIndicator();
                } else if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Center(child: Icon(Icons.error_outline));
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

// Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: Text(
  //           'Followers',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         actions: [],
  //       ),
  //       body: Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: TextField(
  //               controller: searchController,
  //               onChanged: (value) => filterFollowers(value),
  //               decoration: InputDecoration(
  //                 hintText: 'Search followers...',
  //                 prefixIcon: Icon(Icons.search),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(8.0),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Expanded(
  //             child: FutureBuilder(
  //                 future: followers,
  //                 builder:
  //                     (BuildContext context, AsyncSnapshot<FollowersModel> snapshot) {
  //                   if (snapshot.hasData) {
  //                     // totalPage = snapshot.data!.data!.followDetails!.totalPage!;
  //                     return ListView.builder(
  //                       itemCount:
  //                           snapshot.data?.data?.followDetails?.followers?.length ??
  //                               0,
  //                       itemBuilder: (BuildContext context, int index) {
  //                         return Card(
  //                           child: ListTile(
  //                             onTap: () {
  //                               // Get.to(() => ChatScreen(
  //                               //       receiverId: snapshot.data?.data?.followDetails!.followers![index]?.followersId.toString() ?? '',
  //                               //       receiverImageUrl: snapshot.data?.data?.followDetails?.followers![index]?.profileImage.toString() ?? '',
  //                               //       Name: snapshot.data?.data?.followDetails?.followers?[index]?.name ?? '',
  //                               //     ));
  //                               Get.to(() => FriendsProfile(
  //                                   memberNo: snapshot.data?.data?.followDetails
  //                                           ?.followers?[index]?.followersId
  //                                           .toString() ??
  //                                       '',
  //                                   name: snapshot.data?.data?.followDetails
  //                                           ?.followers?[index]?.name ??
  //                                       ''));
  //                             },
  //                             leading: CircleAvatar(
  //                               radius: 15,
  //                               foregroundImage: NetworkImage(snapshot
  //                                       .data
  //                                       ?.data
  //                                       ?.followDetails
  //                                       ?.followers?[index]
  //                                       ?.profileImage ??
  //                                   ''),
  //                               backgroundImage: AssetImage('assets/MNU-Logo.png'),
  //                             ),
  //                             title: Text(
  //                               snapshot.data?.data?.followDetails?.followers?[index]
  //                                       ?.name ??
  //                                   '',
  //                               style: TextStyle(fontSize: 10),
  //                             ),
  //                             // trailing: TextButton(
  //                             //     onPressed: () {
  //                             //       unfollow(snapshot.data?.data?.followDetails?.followers?[index]?.followersId.toString() ?? '').then((value) {
  //                             //         setState(() {
  //                             //           followers = loadFollowers();
  //                             //         });
  //                             //       });
  //                             //     },
  //                             //     child: Text('Unfollow')),
  //                           ),
  //                         );
  //                       },
  //                     );
  //                   } else if (snapshot.hasError) {
  //                     print(snapshot.error.toString());
  //                     if (snapshot.error.toString() ==
  //                         "type 'Null' is not a subtype of type 'Map<String, dynamic>'") {
  //                       return Center(child: Text('No followers'));
  //                     }
  //
  //                     return Center(child: Icon(Icons.error_outline));
  //                   } else {
  //                     return CustomProgressIndicator();
  //                   }
  //                 }),
  //           ),
  //         ],
  //       ));
  // }
}
