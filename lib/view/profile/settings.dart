// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nuteaiw/theme/myfonts.dart';
// import 'package:nuteaiw/view/auth/landing-page.dart';
// import 'package:nuteaiw/view/admin/adminpostlist_page.dart';
// import 'package:nuteaiw/view/chat/suggestionlist.dart';
// import 'package:nuteaiw/view/profile/edit_profile.dart';
// import 'package:nuteaiw/view/profile/friend_requestlist.dart';
//
// import '../../controllers/sessioncontroller.dart';
// import '../../models/sessionModel.dart';
//
//
//
// class SettingsPage extends StatefulWidget {
//   const SettingsPage({Key? key}) : super(key: key);
//
//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }
//
// class _SettingsPageState extends State<SettingsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//
//       body: Column(
//         children: [
//
//           Image.network('https://img.freepik.com/free-vector/teamwork-tiny-people-with-gears-cogwheels-team-partners-working-upgrade-repair-improving-skills-client-service-flat-vector-illustration-business-organization-cooperation-concept_74855-20950.jpg?w=1800&t=st=1673332284~exp=1673332884~hmac=c9e1c536b29e34e36e536cf063d50519021540f1474e5d15396aaf99255f8fbd'),
//
//           CustomListButton(
//             onTap: (){
//               Get.to(()=>EditProfile());
//             },
//             icon: Icon(Icons.person),
//             titile: 'Edit profile',
//
//           ),
//           CustomListButton(
//             onTap: (){
//
//               Get.to(()=>AdminPostListPage(title: 'Admin Timeline'));
//
//             },
//             icon: Icon(Icons.group),
//             titile: 'HQ post',
//
//           ),
//           CustomListButton(
//             onTap: (){
//               Get.to(()=>FriendRequests());
//
//             },
//             icon: Icon(Icons.group_add),
//             titile: 'Followers request',
//
//           ),
//           CustomListButton(
//             onTap: (){
//
//               Get.to(()=>SuggestionList());
//
//             },
//             icon: Icon(Icons.description),
//             titile: 'Suggestions',
//
//           ),
//
//           Padding(
//             padding:  EdgeInsets.only(top: Get.height*0.10),
//             child: ElevatedButton(
//
//               onPressed: () async {
//                 Get.find<SessionController>().session.value.logOut();
//                 Get.find<SessionController>().session.value = Session();
//                 Get.to(()=>LandingPage());
//
//               },
//
//
//
//
//              child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: Get.width*0.25,vertical: 15),
//               child: Text('Logout', style: getText(context).button, ),
//             ),
//
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(Colors.red)
//             ),
//             ),
//           )
//
//
//         ],
//       ),
//
//
//     );
//   }
// }
//
// class CustomListButton extends StatelessWidget {
//   const CustomListButton({
//     Key? key, this.onTap, required this.titile, required this.icon,
//   }) : super(key: key);
//   final void Function()? onTap;
//   final String titile;
//   final Widget icon;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         child: ListTile(
//           onTap:onTap ,
//           leading:icon,
//           title: Text(titile),
//           trailing: Icon(Icons.navigate_next),
//
//         ),
//       ),
//     );
//   }
// }
