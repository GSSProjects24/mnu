import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/sessioncontroller.dart';
import '../../models/sessionModel.dart';
import '../../terms_conditions.dart';
import 'biometri_check.dart';
import 'login.dart';

Future<void> loadOnboard() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool('isOnboarding', true);
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Future<bool> getOnboard() async {
    final prefs = await SharedPreferences.getInstance();

    var value = prefs.getBool('isOnboarded');

    return value!;
  }

  late Future<bool> onBoarded;
  @override
  void initState() {
    Get.put(SessionController());
    onBoarded = getOnboard();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: onBoarded,
      builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.data == true || false) {
          return Scaffold(
            body: GetX<SessionController>(
                init: SessionController(),
                global: true,
                initState: (value) {
                  Session.loadSession()
                      .then(
                          (data) => value.controller?.session.value.data = data)
                      .then((value) {
                    setState(() {});
                  });
                },
                builder: ((session) {
                  debugPrint(session.session.value.data.toString());
                  debugPrint(session.session.value.data?.userId.toString());
                  debugPrint(session.session.value.toString());

                  if (session.session.value.data?.userId != null &&
                      session.session.value.data?.status == true) {
                    return const BiometricLogin();
                  }
                  if (session.session.value.data?.userId == null) {
                    return const LogIn();
                  }
                  if (session.session.value.data?.userId != null &&
                      session.session.value.data?.status == false) {
                    return const BiometricLogin();
                  }

                  if (kDebugMode) {
                    print(session.session.value.data?.toJson());
                  }
                  return const Center(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                })),
          );
        }
        return const TermsAndCondtion();
      },
    );
  }
}
