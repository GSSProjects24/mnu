import 'package:loading_indicator/loading_indicator.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custoemFormField2.dart';
import '../widgets/custom-button.dart';
import '../widgets/custom-textformfield.dart';
import 'package:http/http.dart' as http;
import 'landing-page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  Future<Map<String, dynamic>> changePassword() async {
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_change_password'),
        body: {
          "password": password.text,
          "confirm_password": confirmPassword.text,
          "otp": otp.text,
          "user_id": widget.userId.toString()
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController otp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change password'),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: SizedBox(
                  height: 280,
                  child: Image.network(
                      'https://img.freepik.com/free-vector/security-concept-illustration_114360-1518.jpg?w=1380&t=st=1672141941~exp=1672142541~hmac=fe076cb7df163944a7eb9fa7458adf55005590889e3e8acbfaf795349a87466c'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'We have sent you an email with OTP to reset your password.',
                  textAlign: TextAlign.center,
                ),
              ),
              CustomFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid nric';
                  }
                  return null;
                },
                controller: otp,
                labelText: 'Enter your OTP',
                obscureText: false,
              ),
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
              SizedBox(
                height: Get.height * 0.06,
                child: CustomElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      changePassword().then((value) {
                        debugPrint(value["data"]["status"]);

                        if (value["data"]["status"] == true) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const Center(
                                  child: LoadingIndicator(
                                      indicatorType:
                                          Indicator.ballClipRotatePulse,
                                      colors: [
                                        Colors.black,
                                        Colors.red,
                                      ],
                                      strokeWidth: 2,
                                      backgroundColor: Colors.transparent,
                                      pathBackgroundColor: Colors.black),
                                );
                              });
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(value["message"])));
                          Navigator.of(context).pop();
                          Get.to(() => const LandingPage());
                        }
                        if (value["data"]["status"] == false) {
                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(value["message"])));
                        }
                      });
                    }
                  },
                  title: 'Change Password',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
