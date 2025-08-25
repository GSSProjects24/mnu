import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mnu_app/view/widgets/custom-textformfield.dart';
import '../../theme/myfonts.dart';
import '../widgets/custoemFormField2.dart';
import '../widgets/custom-button.dart';
import 'package:http/http.dart' as http;

import 'landing-page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.nric, required this.name});

  final String nric;
  final String name;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController Nric = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  Future<Map<String, dynamic>> register() async {
    var body = {
      "username": username.text,
      "email": email.text,
      "password": password.text,
      "nric_no": Nric.text
    };

    final response = await http.put(
      Uri.parse('https://api.malayannursesunion.xyz/api_member_register'),
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  bool isLoading = false;
  void handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true); // Start loading indicator

      try {
        final value = await register();
        if (value["data"]["status"] == true ||
            value["data"]["user_id"].isNotEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value["message"])));
          Get.offAll(() => LandingPage());
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value["message"])));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed. Please try again.')));
      } finally {
        setState(() => isLoading = false); // Stop loading indicator
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    username.text = widget.name;
    Nric.text = widget.nric;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                child: SizedBox(
                  width: Get.width * 0.70,
                  child: ListTile(
                    leading: Image.asset('assets/MNU-Logo.png'),
                    title: Text(
                      'mnu_app',
                      style: getText(context)
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w900, fontSize: 25),
                    ),
                    // subtitle: Text('Share Your Thoughts',style: getText(context).titleMedium,),
                  ),
                ),
              ),

              Center(
                  child: Padding(
                padding: const EdgeInsets.only(left: 70, right: 20),
                child: Text(
                  widget.name ?? '',
                  style: getText(context).titleLarge,
                ),
              )),
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(widget.nric ?? ''),
              )),

              // CustomFormField(
              //   readOnly: true,
              //
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter your UserName';
              //       }
              //       return null;
              //     },
              //     controller: username,
              //     labelText: 'User Name',
              //     obscureText: false),
              CustomFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (email.text.isEmail == false) {
                      return ' Please enter valid email';
                    }
                    return null;
                  },
                  inputType: TextInputType.emailAddress,
                  controller: email,
                  labelText: 'Email',
                  obscureText: false),
              // CustomFormField(
              //   readOnly: true,
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter your NRIC';
              //       }
              //       return null;
              //     },
              //
              //     inputType: TextInputType.number,
              //     controller: Nric, labelText: 'NRIC', obscureText: false),
              CustomFormField2(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Some Text';
                    }

                    if (password.text != confirmPassword.text) {
                      return ' Password Not Matched';
                    }

                    return null;
                  },
                  controller: password,
                  labelText: 'Password',
                  obscureText: true),
              CustomFormField2(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Some Text';
                    }

                    if (password.text != confirmPassword.text) {
                      return ' Password Not Matched';
                    }

                    return null;
                  },
                  controller: confirmPassword,
                  labelText: 'Confirm Password',
                  obscureText: true),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomElevatedButton(
                        onPressed: handleRegister,
                        title: 'Register',
                      ),
                // child: CustomElevatedButton(
                //   onPressed: () async {
                //     if (_formKey.currentState!.validate()) {
                //       await showDialog(
                //           context: context,
                //           builder: (context) {
                //             return const Center(
                //               child: CustomProgressIndicator(),
                //             );
                //           });
                //       register(context).then((value) async {
                //         if (value["data"]["status"] == true ||
                //             value["data"]["user_id"].isBlank == false) {
                //           ScaffoldMessenger.of(context).showSnackBar(
                //               SnackBar(content: Text(value["message"])));
                //           // Get.offAll(() => LandingPage());
                //
                //           Get.offAll(() => LandingPage());
                //
                //           // Navigator.of(context).pop();
                //           // Get.find<SessionController>().session.value =
                //           //     Session.fromJson(value);
                //           // await Get.find<SessionController>()
                //           //     .session
                //           //     .value
                //           //     .login(value);
                //           // Get.find<SessionController>().session.value.data =
                //           //     await Session.loadSession();
                //         } else {
                //           ScaffoldMessenger.of(context).showSnackBar(
                //               SnackBar(content: Text(value["message"])));
                //         }
                //       });
                //       Navigator.of(context).pop();
                //     }
                //   },
                //   title: 'Register',
                // ),
              ),
              SizedBox(
                height: Get.height * 0.10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
