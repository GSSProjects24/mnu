import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../auth/landing-page.dart';
import 'custom-button.dart';

class ThankyouDialogbox extends StatefulWidget {
  const ThankyouDialogbox({super.key});

  @override
  State<ThankyouDialogbox> createState() => _ThankyouDialogboxState();
}

class _ThankyouDialogboxState extends State<ThankyouDialogbox> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 470,
        width: 400,
        child: AlertDialog(
          content: Container(
              child: Column(
            children: [
              SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/thank-you.png')),
              Padding(
                  padding:
                      EdgeInsets.only(top: 28, left: 8, right: 8, bottom: 20),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: const <TextSpan>[
                        TextSpan(
                          text:
                              'Thank you for using our app.\n MALAYAN NURSES UNION, \non your mobile device! ',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 5,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: const <TextSpan>[
                    TextSpan(
                      text:
                          'Your support and engagement \nmean a lot to us, We hope that\nour app has enhanced your\nexperience and provided you with\nvaluable information and services.',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),

              //  style: TextStyle(
              //             color: Colors.black, fontWeight: FontWeight.w700)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SizedBox(
                  width: 130,
                  child: ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();

                      await prefs.setBool('isOnboarded', true).then((value) {
                        print(value);
                        //  Get.offAll(const LandingPage());
                         Navigator.of(context).pop();
                      });
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: clrschm.primary),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
