import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:badges/badges.dart' as badges;
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:mnu_app/view/widgets/custom_progress_indicator.dart';
import 'dart:ui' as ui;

import '../../controllers/form_registration_controller.dart';
import '../../controllers/post_controller.dart';
import '../../main.dart';
import '../../models/campany_model.dart';
import '../../models/race_list_model.dart';
import '../../theme/myfonts.dart';
import '../profile/edit_profile.dart';
import '../widgets/custom-textformfield.dart';
import 'package:http/http.dart' as http;

import 'landing-page.dart';

List<String> Gender = ["Male", "Female", "Others"];
List<String> maritalStatus = ["Single", "Married", "Divorced", "Widow"];
var Others = ['Others'];

bool OtherCheck = false;

String dobCalculate({required String data}) {
  var year = data.substring(0, 2);
  var month = data.substring(2, 4);
  var day = data.substring(4, 6);
  data = "${day}-${month}-19${year}";
  // data = data.substring(0,data.length - 5).split('').toString();
  print(data);
  print(day);
  print(month);
  print(year);
  return data;
}

int calculateAgeFromNRIC(String nric) {
  // Extract birth year from the NRIC
  String yearPrefix = (int.parse(nric.substring(0, 2)) < 22) ? '20' : '19';
  int birthYear = int.parse(yearPrefix + nric.substring(0, 2));
  // Get the current year
  DateTime now = DateTime.now();
  int currentYear = now.year;
  // Calculate the age
  int age = currentYear - birthYear;
  return age;
}

class FormRegistration extends StatefulWidget {
  const FormRegistration({super.key, required this.nric_no});
  final String nric_no;
  @override
  State<FormRegistration> createState() => _FormRegistrationState();
}

class _FormRegistrationState extends State<FormRegistration> {
  final FocusNode fileChooseButtonFocus = FocusNode();

  Future<Companynames> fetchCompany() async {
    final response = await http.get(Uri.parse(
        'http://mnuapi.graspsoftwaresolutions.com/api_company_detail'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Companynames.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Racelist> fetchRace() async {
    final response = await http.get(
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_race_detail'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Racelist.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  final signatureGlobalKey = GlobalKey<SignatureState>();
  ByteData img = ByteData(0);
  final _key = GlobalKey<FormState>();
  Companynames? companynames;
  Racelist? racelists;
  var Imagedata;

  @override
  void initState() {
    Get.put(FormRegistrationController());
    Get.put(PostController());

    super.initState();

    fetchCompany().then((value) {
      setState(() {
        companynames = value;
      });
    });
    fetchRace().then((value) {
      setState(() {
        racelists = value;
      });
    });
  }

  @override
  void dispose() {
    Get.find<FormRegistrationController>().dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  Future<void> _handleSaveButtonPressed() async {
    if (signatureGlobalKey.currentState!.hasPoints == true) {
      final sign = signatureGlobalKey.currentState;
      //retrieve image data, do whatever you want with it (send to server, save locally...)
      final image = await sign!.getData();
      var data = await image.toByteData(format: ui.ImageByteFormat.png);

      final encoded = base64.encode(data!.buffer.asUint8List());

      Imagedata = encoded;

      setState(() {
        Get.find<FormRegistrationController>().signature_img = encoded;
      });

      // debugPrint("onPressed " + encoded);
      // sign.clear();
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter valid  signature')));
    }
    //  int signatureLength = _signature.
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormRegistrationController>();
    final postcontroller = Get.find<PostController>();
    controller.nric_no.text = widget.nric_no;
    controller.dob.text = dobCalculate(data: widget.nric_no);
    controller.age_no.text = calculateAgeFromNRIC(widget.nric_no).toString();
    return Form(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: clrschm.primary,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
          title:   Text(
            //'${widget.nric_no}',
            'New Member Registration',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                        "I wish to enroll as a member of the Malayan Nurses Union and I hereby agree loyally to  abside by its rules and to take an active interest in its work. "),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                        "Saya ingin mendaftar sebagai ahli Kesatuan Jururawat Malaya dan dengan ini saya setia bersetuju untuk mematuhi peraturannya dan mengambil berminat secara aktif dalam kerjanya."),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Full Name / Nama Penuh (According to NRIC)';
                        }
                        return null;
                      },
                      controller: controller.member_name,
                      labelText: 'Full Name / Nama Penuh (According to NRIC)',
                      obscureText: false),
                  CustomFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your user name';
                        }
                        return null;
                      },
                      controller: controller.username,
                      labelText: 'User Name',
                      obscureText: false),
                  CustomFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      controller: controller.password,
                      labelText: 'Password',
                      obscureText: false),
                  CustomFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your IC Number /No Kad Pengenalan';
                        }
                        return null;
                      },
                      controller: controller.nric_no,
                      labelText: 'IC Number /No Kad Pengenalan',
                      obscureText: false),
                  CustomFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Telephone Number/Nombor Telefon';
                        }
                        return null;
                      },
                      controller: controller.telephone_no,
                      labelText: 'Telephone Number/Nombor Telefon',
                      obscureText: false),
                  CustomFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Email/Emel';
                        }
                        return null;
                      },
                      inputType: TextInputType.emailAddress,
                      controller: controller.email,
                      labelText: 'Email/Emel',
                      obscureText: false),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select Gender/Jantina';
                          }
                          return null;
                        },
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Gender/Jantina',
                          labelStyle: getText(context).bodyMedium?.copyWith(
                                fontFamily: 'Outfit',
                                color: const Color(0xFF57636C),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                          hintStyle: getText(context).bodyMedium?.copyWith(
                                fontFamily: 'Outfit',
                                color: const Color(0xFF57636C),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: clrschm.onError,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: clrschm.onError,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20, 24, 16, 24),
                        ),
                        items: Gender.map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem(
                            child: Text(value.substring(0, 1).toUpperCase() +
                                value.substring(1).toLowerCase()),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            controller.gender_name.text = value!;
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select Marital Status/Status perkahwinan';
                          }
                          return null;
                        },
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Marital Status/Status perkahwinan',
                          labelStyle: getText(context).bodyMedium?.copyWith(
                                fontFamily: 'Outfit',
                                color: const Color(0xFF57636C),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                          hintStyle: getText(context).bodyMedium?.copyWith(
                                fontFamily: 'Outfit',
                                color: const Color(0xFF57636C),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: clrschm.onError,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: clrschm.onError,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20, 24, 16, 24),
                        ),
                        items: maritalStatus
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            child: Text(value.substring(0, 1).toUpperCase() +
                                value.substring(1).toLowerCase()),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            controller.marital_status.text = value!;
                          });
                        }),
                  ),
                  CustomFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        return null;
                      },
                      controller: controller.age_no,
                      labelText: 'Age',
                      obscureText: false),
                  // CustomFormField(
                  //   controller: null,
                  //   readOnly: true,

                  //  labelText: 'Dob',

                  // // labelText: controller.nric_no !=null && controller.nric_no.value.text.length >= 5  ? dobCalculate(data: controller.nric_no.text).split('pattern').toString(): '',

                  // obscureText: false),
                  CustomFormField(
                      readOnly: true,
                      suffixIcon: IconButton(
                        onPressed: () {
                          showDate(context, DateTime.now()).then((value) {
                            controller.dob.text =
                                '${value?.day.toString()}-${value?.month.toString()}-${value?.year.toString()}';
                          });
                        },
                        icon: const Icon(Icons.date_range_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your dob';
                        }

                        return null;
                      },
                      inputType: TextInputType.datetime,
                      controller: controller.dob,
                      labelText: 'Date Of Birth',
                      obscureText: false),
                  CustomFormField(
                      readOnly: true,
                      suffixIcon: IconButton(
                        onPressed: () {
                          showDates(context, DateTime.now()).then((value) {
                            controller.doe.text =
                                '${value?.year.toString()}-${value?.month.toString()}-${value?.day.toString()}';
                          });
                        },
                        icon: const Icon(Icons.date_range_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your doe';
                        }

                        return null;
                      },
                      inputType: TextInputType.datetime,
                      controller: controller.doe,
                      labelText: 'Date Of doe',
                      obscureText: false),
                  CustomFormField(
                    maxlines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Address';
                      }

                      return null;
                    },
                    inputType: TextInputType.streetAddress,
                    controller: controller.address,
                    labelText: 'Address/Alamat Rumah',
                    obscureText: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField(
                        menuMaxHeight: 150,
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter your Race/Bangsa';
                          }
                          return null;
                        },
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Race/Bangsa',
                          labelStyle: getText(context).bodyMedium?.copyWith(
                                fontFamily: 'Outfit',
                                color: const Color(0xFF57636C),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                          hintStyle: getText(context).bodyMedium?.copyWith(
                                fontFamily: 'Outfit',
                                color: const Color(0xFF57636C),
                                fontSize: 8,
                                fontWeight: FontWeight.normal,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: clrschm.onError,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: clrschm.onError,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20, 24, 16, 24),
                        ),
                        items: racelists?.data!.race!
                            .map<DropdownMenuItem<Race>>((Race value) {
                          return DropdownMenuItem(
                            child: Text(
                                value.name!.substring(0, 1).toUpperCase() +
                                    value.name!.substring(1).toLowerCase()),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            controller.race_name.text = value!.id.toString();
                          });
                        }),
                  ),
                 
                  CustomFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Postcode/Poskod';
                      }
                      return null;
                    },
                    controller: controller.postal_code,
                    labelText: 'Postcode/Poskod',
                    obscureText: false,
                    inputType: TextInputType.number,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField(
                        menuMaxHeight: 300,
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter your Hospital Name/Nama Hospital';
                          }
                          return null;
                        },
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Hospital Name/Nama Hospital',
                          labelStyle: getText(context).bodyMedium?.copyWith(
                                fontFamily: 'Outfit',
                                color: const Color(0xFF57636C),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                          hintStyle: getText(context).bodyMedium?.copyWith(
                                fontFamily: 'Outfit',
                                color: const Color(0xFF57636C),
                                fontSize: 8,
                                fontWeight: FontWeight.normal,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: clrschm.onError,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: clrschm.onError,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20, 24, 16, 16),
                        ),
                        items: companynames?.data!.company!
                            .map<DropdownMenuItem<Company>>((Company value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                                value.name!.substring(0, 1).toUpperCase() +
                                    value.name!.substring(1).toLowerCase()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            controller.company_name.text = value!.id.toString();
                          
                          });
                        }),
                  ),

                  OtherCheck == false
                      ? Container()
                      : CustomFormField(
                          controller: controller.company_name,
                          labelText: 'Others',
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Hosptial Name';
                            }
                            return null;
                          },
                        ),
                  
                  CustomFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Employee ID/No Pekerja';
                        }
                        return null;
                      },
                      inputType: TextInputType.number,
                      controller: controller.employee_no,
                      labelText: 'Employee ID/No Pekerja',
                      obscureText: false),
                  CustomFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Department/Bahagian';
                        }
                        return null;
                      },
                      controller: controller.department,
                      labelText: 'Department/Bahagian',
                      obscureText: false),
                  CustomFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Position';
                        }
                        return null;
                      },
                      controller: controller.position,
                      labelText: 'Position',
                      obscureText: false),
                  CustomFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Starting Salary/Gaji Permulaan (RM)';
                        }
                        return null;
                      },
                      inputType: TextInputType.number,
                      controller: controller.starting_salary,
                      labelText: 'Starting Salary/Gaji Permulaan (RM)',
                      obscureText: false),
                  CustomFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your  Salary/Gaji  (RM)';
                        }
                        return null;
                      },
                      inputType: TextInputType.number,
                      controller: controller.salary,
                      labelText: ' Salary/Gaji  (RM)',
                      obscureText: false),
                  CustomFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Registration Fees/Bayaran Masuk (RM)';
                        }
                        return null;
                      },
                      inputType: TextInputType.number,
                      controller: controller.entrance_fee,
                      labelText: 'Registration Fees/Bayaran Masuk (RM)',
                      obscureText: false),
                  CustomFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Monthly Fees/Bayaran bagi Bulan (RM)';
                        }
                        return null;
                      },
                      inputType: TextInputType.number,
                      controller: controller.monthly_fee,
                      labelText: 'Monthly Fees/Bayaran bagi Bulan (RM)',
                      obscureText: false),
                  // CustomFormField(
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return 'Please enter your Pf No';
                  //       }
                  //       return null;
                  //     },
                  //     inputType: TextInputType.number,
                  //     controller: controller.pf_no,
                  //     labelText: 'Pf No',
                  //     obscureText: false),

                  Row(
                    children: [
                      FocusScope(
                        child: Checkbox(
                            value: controller.showTerms,
                            onChanged: ((value) {
                              setState(() {
                                controller.showTerms = !controller.showTerms;
                                if (controller.showTerms) {
                                  FocusScope.of(context)
                                      .requestFocus(fileChooseButtonFocus);
                                }
                              });
                            })),
                      ),
                      const Text("To continue....")
                    ],
                  ),
                  
                     
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("(SIGNATURE)"),
                                        TextButton(
                                          onPressed: _handleClearButtonPressed,
                                          child: const Text('Clear'),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                          height: 250,
                                          width: double.infinity,
                                          child: Signature(
                                            key: signatureGlobalKey,
                                            strokeWidth: 3,
                                            color: Colors.black,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey)))),
                                  const SizedBox(height: 10),
                                ]),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("(Payment Receipt)"),
                                      TextButton(
                                          child: const Text('Upload'),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                isDismissible: true,
                                                context: context,
                                                builder: (context) {
                                                  return SizedBox(
                                                    height: Get.height * 0.1,
                                                    width: Get.width,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 100,
                                                          child: Column(
                                                            children: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await postcontroller
                                                                        .addFileFromCamera()
                                                                        .then(
                                                                            (value) {
                                                                      postcontroller
                                                                          .images
                                                                          .forEach(
                                                                              (element) {
                                                                        if (!controller
                                                                            .upload_doc
                                                                            .contains(element)) {
                                                                          controller
                                                                              .upload_doc
                                                                              .add(element);
                                                                        }
                                                                      });
                                                                    });
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .camera_alt,
                                                                    size: 30,
                                                                  )),
                                                              const Text(
                                                                  'Camera')
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 100,
                                                          child: Column(
                                                            children: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await postcontroller
                                                                        .addFiles()
                                                                        .then(
                                                                            (value) {
                                                                      postcontroller
                                                                          .images
                                                                          .forEach(
                                                                              (element) {
                                                                        if (!controller
                                                                            .upload_doc
                                                                            .contains(element)) {
                                                                          controller
                                                                              .upload_doc
                                                                              .add(element);
                                                                        }
                                                                      });
                                                                    });
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  icon:
                                                                      const Icon(
                                                                    Icons.photo,
                                                                    size: 30,
                                                                  )),
                                                              const Text(
                                                                  'Gallery')
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          }),
                                    ],
                                  ),
                                ),
                                controller.upload_doc.isEmpty
                                    ? const Center()
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 160,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: postcontroller
                                                .memoryImage.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: badges.Badge(
                                                    position:
                                                        badges.BadgePosition
                                                            .bottomEnd(),
                                                    badgeContent: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          postcontroller
                                                              .memoryImage
                                                              .removeAt(index);
                                                          postcontroller.images
                                                              .removeAt(index);
                                                          postcontroller.files
                                                              .removeAt(index);
                                                          controller
                                                                  .upload_doc =
                                                              postcontroller
                                                                  .images;

                                                          controller.update();
                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete),
                                                    ),
                                                    child: ClipRRect(
                                                      
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: SizedBox(
                                                          height: 110,
                                                          width: 90,
                                                          child: Image.memory(
                                                            postcontroller
                                                                    .memoryImage[
                                                                index],
                                                             fit: BoxFit.cover,
                                                          ),
                                                        ))),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                const SizedBox(height: 20),
                                Container(
                                  height: Get.height * 0.05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.purple),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return const Center(
                                                child:
                                                    CustomProgressIndicator(),
                                              );
                                            });

                                        await _handleSaveButtonPressed();

                                        if (controller.upload_doc.isEmpty) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text("Please Upload Images"),
                                            ),
                                          );
                                        }

                                        if (_key.currentState!.validate() &&
                                            signatureGlobalKey
                                                    .currentState!.hasPoints ==
                                                true &&
                                            controller.upload_doc.isNotEmpty) {
                                          controller.newregister(context).then(
                                            (value) {
                                              print("*****${value.toString()}");
                                              if (value["data"]["status"] ==
                                                  true) {
                                                final sign = signatureGlobalKey
                                                    .currentState;
                                                sign!.clear();

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        value["message"]
                                                            .toString()),
                                                  ),
                                                );
                                                // Navigator.of(context).pop();
                                                Get.offAll(
                                                    () => const LandingPage());
                                              } else {
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        value["message"]
                                                            .toString()),
                                                  ),
                                                );

                                                // Navigator.of(context).pop();
                                              }
                                            },
                                          );
                                        }
                                      },
                                      style: ButtonStyle(
                                          maximumSize:
                                              MaterialStateProperty.all(Size(
                                                  Get.width * 0.60,
                                                  Get.height * 0.06)),
                                          minimumSize:
                                              MaterialStateProperty.all(Size(
                                                  Get.width * 0.60,
                                                  Get.height * 0.06)),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent)),
                                      child: Text(
                                        "Submit",
                                        style: getText(context)
                                            .titleLarge
                                            ?.copyWith(color: Colors.white),
                                      )),
                                ),
                                const SizedBox(height: 100),
                              ],
                            )
                          ],
                        )
                     
                ],
              )
           
          ),
        ),
      );
    
  }
}
