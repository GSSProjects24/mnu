import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../theme/myfonts.dart';
import '../widgets/custom-button.dart';
import '../widgets/custom-textformfield.dart';
import 'package:http/http.dart' as http;

import 'change_password.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  Future<Map<String, dynamic>> sendOtp(String nric) async {
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_forget_password'),
        body: {"nric_no": Nric.text});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController Nric = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'FORGET PASSWORD',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment:  CrossAxisAlignment.center,

            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: SizedBox(
                  height: 280,
                  child: Image.asset('assets/2.png'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'We will send you an email with a link to reset your password, please enter the NRIC associated with your account below.',
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
                controller: Nric,
                labelText: 'Nric',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(
                          child: LoadingIndicator(
                              indicatorType: Indicator.ballClipRotatePulse,

                              /// Required, The loading type of the widget
                              colors: [
                                Colors.black,
                                Colors.red,
                              ],

                              /// Optional, The color collections
                              strokeWidth: 2,

                              /// Optional, The stroke of the line, only applicable to widget which contains line
                              backgroundColor: Colors.transparent,

                              /// Optional, Background of the widget
                              pathBackgroundColor: Colors.black

                              /// Optional, the stroke backgroundColor
                              ),
                        );
                      });

                  sendOtp(Nric.text).then((value) {
                    print('ok');
                    print('%%%%%%%%%%%%%${value["data"]["status"]}');

                    if (value["data"]["status"]) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(value["message"])));
                      Navigator.of(context).pop();
                      Get.to(() => ChangePassword(
                            userId: value["data"]["user_id"].toString(),
                          ));
                    }
                    if (value["data"]["status"] == false) {
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(value["message"])));
                    }
                  });
                },
                title: 'Send OTP',
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}