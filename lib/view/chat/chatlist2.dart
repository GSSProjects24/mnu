import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../controllers/sessioncontroller.dart';
import '../../models/chat_member_list_model.dart';
import '../admin/admin-post-view.dart';
import '../widgets/custom_progress_indicator.dart';
import 'chat_screen.dart';

class ChatList2 extends StatefulWidget {
  const ChatList2({super.key});

  @override
  State<ChatList2> createState() => _ChatList2State();
}

class _ChatList2State extends State<ChatList2> {
  ScrollController scrollcontroller = ScrollController();

  double height = 0;
  double appbarheight = 50;

  Future<ChatMemberListModel> loadMembers({String? search}) async {
    debugPrint("welcome:Search:$search");
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data!.userId.toString()!,
      "search": search ?? ""
    };
    final response = await http.post(
        Uri.parse('https://api.malayannursesunion.xyz/api_chat_mem_list'),
        body: body);

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return ChatMemberListModel.fromJson(jsonDecode(response.body));
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
    }
  }

  TextEditingController search = TextEditingController();

  late Future<ChatMemberListModel> list = loadMembers();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Friends',
              style: TextStyle(color: Colors.white),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CustomFormField(
                    controller: search,
                    labelText: '',
                    suffixIcon: const Icon(Icons.search),
                    obscureText: false,
                    onChanged: (value) {
                      setState(() {
                        list = loadMembers(search: value ?? '');
                      });
                    },
                  ),
                ),
              ),
            )),
        body: FutureBuilder<ChatMemberListModel>(
            future: list,
            builder: (BuildContext context,
                AsyncSnapshot<ChatMemberListModel> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.data?.memberDetails?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                        ),
                        child: ListTile(
                          dense: true,
                          onTap: () {
                            Get.to(() => ChatScreen(
                                  receiverId: snapshot.data?.data
                                          ?.memberDetails![index]?.userId
                                          .toString() ??
                                      '',
                                  receiverImageUrl: snapshot.data?.data
                                          ?.memberDetails![index]?.profileImage
                                          .toString() ??
                                      '',
                                  Name: snapshot.data?.data
                                          ?.memberDetails![index]?.memberName ??
                                      '',
                                ));
                          },
                          title: Text(snapshot.data?.data?.memberDetails![index]
                                  ?.memberName ??
                              ''),
                          subtitle: Text(snapshot.data?.data
                                  ?.memberDetails![index]?.companyName ??
                              'Company Name'),
                          leading: CircleAvatar(
                            backgroundImage:
                                const AssetImage('assets/profile.png'),
                            foregroundImage: NetworkImage(snapshot.data?.data
                                    ?.memberDetails![index]?.profileImage ??
                                'http://upcwapi.graspsoftwaresolutions.com/public/images/user.png'),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Icon(Icons.error_outline));
              } else {
                return Center(child: CustomProgressIndicator());
              }
            }));
  }
}
