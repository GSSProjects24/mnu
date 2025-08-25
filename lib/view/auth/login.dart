import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mnu_app/view/widgets/custom_progress_indicator.dart';
import '../../controllers/sessioncontroller.dart';
import '../../models/sessionModel.dart';
import '../admin/admin-post-view.dart';
import '../widgets/custoemFormField2.dart';
import '../widgets/custom-button.dart';
import 'forget-password.dart';
import 'package:http/http.dart' as http;
import 'landing-page.dart';
import 'nric-check.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  Future<Map<String, dynamic>> logIn() async {
    final response = await http.post(
        Uri.parse('https://api.malayannursesunion.xyz/api_login'),
        body: {"username": userName.text, "password": passWord.text});
    print("$userName ,$passWord");
    print("https://api.malayannursesunion.xyz/api_login");
    if (kDebugMode) {
      debugPrint('**********+${response.body}');
    }
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  TextEditingController userName = TextEditingController();
  TextEditingController passWord = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: SizedBox(
                  height: 280,
                  child: Image.asset('assets/MNU-Logo.png'),
                ),
              ),
              CustomFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Email or User Name';
                  }
                  return null;
                },
                inputType: TextInputType.emailAddress,
                controller: userName,
                labelText: 'Email or User Name',
                obscureText: false,
              ),
              CustomFormField2(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
                controller: passWord,
                labelText: 'Password',
                obscureText: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: CustomElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                                child: CustomProgressIndicator());
                          });

                      logIn().then((value) async {
                        if (value["data"]["status"] == true) {
                          Get.off(() => const LandingPage());

                          Navigator.of(context).pop();
                          Get.find<SessionController>().session.value =
                              Session.fromJson(value);
                          await Get.find<SessionController>()
                              .session
                              .value
                              .login(value);
                          // await Get.find<SessionController>().session.value.loadSession();
                        } else if (value["data"]["status"] == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(value["message"])));
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                  title: 'Login',
                ),
              ),
              TextButton(
                  onPressed: () {
                    Get.to(() => const ForgetPassword());
                  },
                  child: const Text('Forget Password?')),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text(
                              'CONTACT : Administrator',
                              style: TextStyle(fontSize: 16),
                            ),
                            content:
                                SelectableText('Email : mnucliks@gmail.com'),
                          );
                        });
                  },
                  child: const Text('Forget MemberID?')),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already a Member?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const NricCheck());
                      },
                      child: const Text('Register here')),
                  SizedBox(
                    height: Get.height * 0.07,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Not a Member yet?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const NricCheck());
                      },
                      child: const Text('Join Now')),
                  SizedBox(
                    height: Get.height * 0.05,
                  )
                ],
              ),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
