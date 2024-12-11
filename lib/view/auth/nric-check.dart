import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mnu_app/view/auth/register.dart';

import '../../main.dart';
import '../../theme/myfonts.dart';

import '../widgets/custom-button.dart';
import '../widgets/custom-textformfield.dart';
import 'package:http/http.dart' as http;

import '../widgets/myformatter.dart';
import 'new_registration_form.dart';

class NricCheck extends StatefulWidget {
  const NricCheck({Key? key}) : super(key: key);

  @override
  State<NricCheck> createState() => _NricCheckState();
}

class _NricCheckState extends State<NricCheck> {
  TextEditingController nricController = TextEditingController();

  Future<Map<String, dynamic>> checkNric(String nric) async {
    var body = {"nric_no": nric};

    final response = await http.post(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/member_nric_check'),
        body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: clrschm.primary,
          title: const Text(
            'NRIC VERIFICATION',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: SizedBox(
              height: Get.height * 0.90,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, left: Get.width * 0.12),
                      child: SizedBox(
                        width: Get.width * 0.70,
                        child: Center(
                          child: ListTile(
                            leading: Image.asset('assets/MNU-Logo.png'),
                            title: Text(
                              'MNU',
                              style: getText(context).titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900, fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Image.asset('assets/5.png'),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Please verify your NRIC',
                        style: getText(context).titleLarge,
                      ),
                    ),
                    CustomFormField(
                      formatters: [
                        LengthLimitingTextInputFormatter(14),
                        NricFormatter(separator: '-')
                      ],
                      inputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: nricController,
                      labelText: 'NRIC',
                      obscureText: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child:  isLoading
                          ? Center(child: CircularProgressIndicator())
                          : CustomElevatedButton(
                        onPressed: checkNricAndNavigate,
                        title: 'Check NRIC',
                      ),
                      // child: CustomElevatedButton(
                      //   onPressed: () {
                      //     var response;
                      //
                      //     if (_formKey.currentState!.validate()) {
                      //       showDialog(
                      //           context: context,
                      //           builder: (context) {
                      //             return Center(
                      //               child: LoadingIndicator(
                      //                   indicatorType:
                      //                       Indicator.ballClipRotatePulse,
                      //
                      //                   /// Required, The loading type of the widget
                      //                   colors: const [
                      //                     Colors.black,
                      //                     Colors.red,
                      //                   ],
                      //
                      //                   /// Optional, The color collections
                      //                   strokeWidth: 2,
                      //
                      //                   /// Optional, The stroke of the line, only applicable to widget which contains line
                      //                   backgroundColor: Colors.transparent,
                      //
                      //                   /// Optional, Background of the widget
                      //                   pathBackgroundColor: Colors.black
                      //
                      //                   /// Optional, the stroke backgroundColor
                      //                   ),
                      //             );
                      //           });
                      //       checkNric(nricController.text).then((value) {
                      //         print("********* ${value['data']['status']}");
                      //         print("********* RESPONSE $value");
                      //
                      //         if (value["data"]["status"] == true) {
                      //           ScaffoldMessenger.of(context).showSnackBar(
                      //               SnackBar(
                      //                   content:
                      //                       Text(value["message"].toString())));
                      //           Navigator.of(context).pop();
                      //
                      //           Get.to(() => RegisterPage(
                      //               nric: value["data"]["icno"],
                      //               name: value["data"]["name"]));
                      //
                      //           // RegisterPage(
                      //           //       name: value["data"]["name"],
                      //           //       nric: value["data"]["icno"],
                      //           //     ));
                      //         }
                      //         if (value["data"]["status"] == false &&
                      //             value["message"].toString() ==
                      //                 "This nric member already registered.") {
                      //           ScaffoldMessenger.of(context).showSnackBar(
                      //               SnackBar(
                      //                   content:
                      //                       Text(value["message"].toString())));
                      //           Navigator.of(context).pop();
                      //         }
                      //         if (value["data"]["status"] == false &&
                      //             value["message"].toString() !=
                      //                 "This nric member already registered.") {
                      //           ScaffoldMessenger.of(context).showSnackBar(
                      //               SnackBar(
                      //                   content:
                      //                       Text(value["message"].toString())));
                      //           Navigator.of(context).pop();
                      //           Get.to(() => FormRegistration(
                      //               nric_no: nricController.text));
                      //         }
                      //       }).catchError((e) {
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //             SnackBar(
                      //                 content:
                      //                     Text('Unknown Error try again')));
                      //       });
                      //     }
                      //   },
                      //   title: 'Verify',
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  bool isLoading = false;
  void checkNricAndNavigate() {
    setState(() {
      isLoading = true; // Start showing the loader
    });

    checkNric(nricController.text).then((value) {
      if (!mounted) return; // Ensure widget is still mounted

      setState(() {
        isLoading = false; // Stop showing the loader
      });

      print("********* ${value['data']['status']}");
      print("********* RESPONSE $value");

      String message = value["message"].toString();

      // Check if the NRIC is already registered
      if (value["data"]["status"] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message),
          ));
        }
        Navigator.of(context).pop();

        Get.to(() => RegisterPage(
          nric: value["data"]["icno"],
          name: value["data"]["name"],
        ));
      } else {
        // Handle the case where NRIC is already registered
        if (message == "This nric member already registered.") {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message), // Show this specific message
            ));
          }
          Navigator.of(context).pop();
        } else {
          // If the NRIC is not registered
          Get.to(() => FormRegistration(nric_no: nricController.text));
        }
      }
    }).catchError((e) {
      if (!mounted) return; // Ensure widget is still mounted

      setState(() {
        isLoading = false; // Stop loader on error
      });

      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unknown Error: ${e.toString()}'),
      ));
    });
  }

}
