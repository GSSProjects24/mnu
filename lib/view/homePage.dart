import 'dart:convert';
import 'package:badges/badges.dart' as badge;
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mnu_app/view/auth/landing-page.dart';
import 'package:mnu_app/view/bottom-appbarwidgets/hqListPage.dart';
import 'package:mnu_app/view/widgets/thankyouDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/sessioncontroller.dart';
import '../main.dart';
import '../models/member-model.dart';
import '../models/notifications_model.dart';
import 'bottom-appbarwidgets/post_list_view_home.dart';
import 'bottom-appbarwidgets/userprofile.dart';
import 'chat/chat_list.dart';
import 'chat/chat_screen.dart';
import 'package:http/http.dart' as http;

String image = '';
Future<void> loadOnboards() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool('isOnboarding', true);
}

class HomePage extends StatefulWidget {
  final selectedTab;
  const HomePage({Key? key, this.selectedTab}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? profileimage;
  bool? showbadge = true;
  Future<bool> getOnboards() async {
    final prefs = await SharedPreferences.getInstance();

    var value = prefs.getBool('isOnboardeds');

    return value!;
  }

  late Future<bool> onBoardeds;

// getprofileimage() async{
//   final SharedPreferences prefs= await SharedPreferences.getInstance();

//   profileimage = prefs.getString('profile_image');

//   print('${profileimage}');
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['User'] == 'chat') {
      Get.to(ChatScreen(
          receiverId: message.data['receiverid'],
          receiverImageUrl: 'test',
          Name: 'Rampo'));
    }
  }

  Future<NotificationsModel> loadNotifications() async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString() ??
              '',
      "page": "1",
      "limit": "50"
    };
    final response = await http.post(
      Uri.parse(
          'http://mnuapi.graspsoftwaresolutions.com/api_push_notification'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // print(response.body);
      return NotificationsModel.fromJson(jsonDecode(response.body));
    } else {
      // print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Future<Map<String?, dynamic>> tokens() async {
  //   var body = {"user_id": Get.find<SessionController>().session.value.data?.userId.toString() ?? '', "token": messaging.getToken()};
  //   final response = await http.post(Uri.parse('http://api.nuteaiw.org/api_user_token'));
  //   if (response.statusCode == 200) {
  //     print('${messaging.getToken()} done*******%%%%%%%%%%%%%%%%%S');
  //     return jsonDecode((response.body));
  //   } else {
  //     print('${messaging.getToken()} Falied');
  //     throw Exception('Failed to load album');
  //   }
  // }
  Future<void> tokens(String token) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString() ??
              '',
      "token": token
    };
    final response = await http.post(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_user_token'),
        body: body);
    if (response.statusCode == 200) {
      print('${token} done*******%%%%%%%%%%%%%%%%%S');
      await FirebaseMessaging.instance.subscribeToTopic(
          Get.find<SessionController>().session.value.data?.userId.toString() ??
              '');

      var responseData = jsonDecode((response.body));
      // return {'token': body['token'], 'data': responseData};
    } else {
      // print('${messaging.getToken()} Falied');
      throw Exception('Failed to load album');
    }
  }

  Future<MemberModel> loadMember() async {
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

      var responseData = jsonDecode((response.body));
      if (mounted) {
        setState(() {
          profileimage = responseData['data']['profile_image'];
          image = profileimage ?? '';
        });
      }
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
    return MemberModel();
  }

  List<Widget> bottombarwidgets = [
    const HomeListPostPage(
        title: 'Timeline',
        apiurl: 'http://mnuapi.graspsoftwaresolutions.com/api_post_list',
        isHome: true),
    // LazyListView(),
    const ChatList(),
    const HQListPostPage(
        title: 'HQ posts',
        apiurl: 'http://mnuapi.graspsoftwaresolutions.com/api_admin_post_list',
        isHq: true),
    const UsersProfile(),
    // const NotificationsPage(
    //   user_ids: '',
    // ),
  ];

  int _selectedindex = 0;
  late Future<String?> token;
  callApis() async {
    if (widget.selectedTab == 0) {
      setState(() {
        _selectedindex = 0;
        loadMember();
      });
    }
    if (widget.selectedTab == 1) {
      setState(() {
        _selectedindex = 1;
        loadMember();
      });
    }
    if (widget.selectedTab == 2) {
      setState(() {
        _selectedindex = 2;
        loadMember();
      });
    }
    if (widget.selectedTab == 3) {
      setState(() {
        _selectedindex = 3;
        loadMember();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint("firstTimeInit:$_selectedindex");
    callApis();
    onBoardeds = getOnboards();
    SharedPreferences.getInstance().then((prefs) {
      final bool isOnboarded = prefs.getBool('isOnboardeds') ?? false;

      if (!isOnboarded) {
        Future.delayed(const Duration(seconds: 2)).then((value) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const ThankyouDialogbox();
            },
          ).then((value) {
            // Dialog closed, update isOnboarded in SharedPreferences
            prefs.setBool('isOnboardeds', true);
          });
        });
      }
    });

    loadMember();
    debugPrint("*****************imageProfile");
    setupInteractedMessage();
    messaging
        .getToken()
        .then((value) => tokens(value ?? '').then((value) => print('test')));
    FirebaseMessaging.instance.getToken().then((value) => tokens(value ?? ''));

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['User'] == 'chat') {
        _handleMessage(message);
      }
    });
  }

  Future<String?> getMessagingToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    String? token = await messaging.getToken();

    return token;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedindex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          if (_selectedindex == 0) {
            Navigator.pop(context);
          }
        } else {
          debugPrint("Pop action was blocked.");
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        body: bottombarwidgets[_selectedindex],
        bottomNavigationBar: NavigationBar(
          surfaceTintColor: clrschm.primary,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedindex = index;
              debugPrint("selectedIndexDash:$_selectedindex");

              loadMember();
            });
          },
          selectedIndex: _selectedindex,
          elevation: 10,
          destinations: <Widget>[
            const NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            const NavigationDestination(
                icon: Icon(Icons.high_quality_rounded), label: 'HQ'),
            NavigationDestination(
              icon: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: const NetworkImage(
                        'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'),
                    foregroundImage:
                        (profileimage != null && profileimage!.isNotEmpty)
                            ? NetworkImage(profileimage!)
                            : null,
                  )),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
