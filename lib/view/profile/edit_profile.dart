import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/post_controller.dart';
import '../../controllers/sessioncontroller.dart';
import '../../main.dart';
import '../../models/edit_profile.dart';
import '../../models/member-model.dart';
import '../../models/sessionModel.dart';
import '../../theme/myfonts.dart';
import '../auth/login.dart';
import '../widgets/custom-button.dart';
import '../widgets/custom-textformfield.dart';
import 'package:http/http.dart' as http;

import '../widgets/custom_loading.dart';
import '../widgets/custom_progress_indicator.dart';
import '../widgets/myformatter.dart';

List<String> Gender = ["male", "female", "others"];
String? imageurl = '';

class EditProfile extends StatefulWidget {
  const EditProfile({
    Key? key,
    required this.imageurl,
  }) : super(key: key);
  final String imageurl;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Future<Map<String, dynamic>> updateMember() async {
    debugPrint('username start');
    Map<String, dynamic> body = {
      // "username":'deepa',
      "mem_prof_id":
          Get.find<SessionController>().session.value.data?.userId.toString() ??
              '',
      "member_name": membername.text,
      "new_icno": newicno.text,
      "old_icno": oldicno.text,
      "gender": dropDownValue,
      "dob": dob.text,
      "doj": doj.text,
      "address": address.text,
      "postal_code": postalcode.text,
      "position": position.text,
      "employee_no": employee_no.text,
      "member_no": member_no.text,
      "telephone_no": telephoneno.text,
      "telephone_no_office": telephoneoffice.text,
      "telephone_no_hp": telephonenohp.text,
      "salary": salary.text,
      "entrance_fee": entrancefee.text,
      "monthly_fee": montlyfee.text,
      "pf_no": pf_no.text,
      "doe": doe.text,
    };
    if (kDebugMode) {
      print(body);
    }

    final response = await http.post(
        Uri.parse(
            'https://api.malayannursesunion.xyz/api_update_member_profile'),
        body: body);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  final data = Get.put(PostController());

  Future<EditProfileModel> LoadMember() async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString()
    };
    if (kDebugMode) {
      print(Get.find<SessionController>().session.value.data?.userId);
    }
    final response = await http.post(
        Uri.parse(
            'https://api.malayannursesunion.xyz/api_edit_member_profile'),
        body: body);

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return EditProfileModel.fromJson(jsonDecode(response.body));
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future deleteUser() async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString()
    };
    final response = await http.post(
        Uri.parse('https://api.malayannursesunion.xyz/api_delete_user'),
        body: body);

    if (response.statusCode == 200) {
      debugPrint('userDelete');
    } else {
      debugPrint(response.body);
      throw Exception('Failed to Delete your account');
    }
  }

  Future<Map<String, dynamic>> upload(String data) async {
    // Map<String,dynamic>
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "image": data
    };
    if (kDebugMode) {
      print(Get.find<SessionController>().session.value.data?.userId);
    }
    final response = await http.put(
        Uri.parse(
            'https://api.malayannursesunion.xyz/api_profile_image_upload'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body));
    if (kDebugMode) {
      print(body);
    }
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return jsonDecode(response.body);
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
    }
  }

  TextEditingController membername = TextEditingController();
  TextEditingController newicno = TextEditingController();
  TextEditingController oldicno = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController doj = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController postalcode = TextEditingController();
  TextEditingController position = TextEditingController();
  TextEditingController employee_no = TextEditingController();
  TextEditingController member_no = TextEditingController();

  TextEditingController telephoneno = TextEditingController();
  TextEditingController telephoneoffice = TextEditingController();
  TextEditingController telephonenohp = TextEditingController();
  TextEditingController salary = TextEditingController();
  TextEditingController entrancefee = TextEditingController();
  TextEditingController montlyfee = TextEditingController();
  TextEditingController pf_no = TextEditingController();
  TextEditingController doe = TextEditingController();
  List<String> readOnly = [];

  late String? dropDownValue = 'male';

  late Future<EditProfileModel> member;

  bool isLoaded = false;

  Future<MemberModel> loadMember() async {
    var body = {
      "mem_prof_id":
          Get.find<SessionController>().session.value.data?.userId.toString()
    };
    // log("Req_body:${Get.find<SessionController>().session.value.data?.userId}");

    if (kDebugMode) {
      print(Get.find<SessionController>().session.value.data?.userId);
    }
    final response = await http.post(
        Uri.parse('https://api.malayannursesunion.xyz/api_getuser'),
        body: {
          "user_id": Get.find<SessionController>()
              .session
              .value
              .data
              ?.userId
              .toString()
        });

    if (response.statusCode == 200) {
      debugPrint(response.body);
      // log("body:${jsonDecode(response.body)}");
      return MemberModel.fromJson(jsonDecode(response.body));
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load data');
    }
    return MemberModel();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    Get.find<PostController>().dispose();
  }

  @override
  void initState() {
    LoadMember().then((value) {
      // log("value:${jsonEncode(value)}");
      loadData(value);
    });

    // TODO: implement initState
    super.initState();
    if (kDebugMode) {
      print(
          'profile update id ${Get.find<SessionController>().session.value.data?.userId.toString()}');
    }
  }

  String formatDateString(String? inputDate) {
    List<String> dateParts = inputDate!.split('/');

    if (dateParts.length == 3) {
      String day = dateParts[0];
      String month = dateParts[1];
      String year = dateParts[2];

      return '$day/$month/$year';
    } else {
      return "Invalid date format";
    }
  }

  loadData(EditProfileModel value) {
    membername.text = value.data?.memberName.toString() ?? '';
    newicno.text = value.data?.newIcno.toString() ?? '';
    oldicno.text = value.data?.oldIcno.toString() ?? '';
    dropDownValue = value.data?.gender.toString() ?? '';
    dob.text = formatDateString(value.data?.dob);
    doj.text = formatDateString(value.data?.doj);
    pf_no.text = value.data?.pf_no.toString() ?? "";
    salary.text = value.data?.Salary.toString() ?? '';
    address.text = value.data?.address.toString() ?? '';
    postalcode.text = value.data?.postalCode.toString() ?? '';
    position.text = value.data?.position.toString() ?? '';
    employee_no.text = value.data?.employeeNo.toString() ?? '';
    member_no.text = value.data?.memberNo.toString() ?? '';
    telephoneno.text = value.data?.telephoneNo.toString() ?? '';
    telephoneoffice.text = value.data?.telephoneNoOffice.toString() ?? '';
    telephonenohp.text = value.data?.telephoneNoHp.toString() ?? '';
    salary.text = value.data?.Salary.toString() ?? '';
    entrancefee.text = value.data?.entranceFee.toString() ?? '';
    montlyfee.text = value.data?.monthlyFee.toString() ?? '';
    readOnly = value.data?.readOnly ?? [];
    // log("readOnly:${readOnly}");
    setState(() {});
  }

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetX<PostController>(builder: (data) {
      return Form(
        key: _formkey,
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
              title: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: FutureBuilder(
                future: LoadMember(),
                builder: (BuildContext context,
                    AsyncSnapshot<EditProfileModel> value) {
                  if (value.hasData && value.data!.data!.status == true) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: badges.Badge(
                                position: badges.BadgePosition.bottomEnd(),
                                badgeContent: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          isDismissible: true,
                                          context: context,
                                          builder: (context) {
                                            return SizedBox(
                                              width: Get.width * 0.40,
                                              height: Get.height * 0.12,
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
                                                              await data
                                                                ..addprofileFromCamera()
                                                                    .then(
                                                                        (value) {
                                                                  setState(() {
                                                                    isLoaded =
                                                                        true;
                                                                  });
                                                                });
                                                            },
                                                            icon: const Icon(
                                                              Icons.camera_alt,
                                                              size: 30,
                                                            )),
                                                        const Text('Camera')
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
                                                              await data
                                                                  .addFile()
                                                                  .then((value) =>
                                                                      isLoaded =
                                                                          true);
                                                              setState(() {});
                                                            },
                                                            icon: const Icon(
                                                              Icons.photo,
                                                              size: 30,
                                                            )),
                                                        const Text('Gallery')
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: const Icon(Icons.edit)),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(200)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 50,
                                      child: ClipOval(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(48),
                                          child: data.memoryImage.isEmpty
                                              ? (Get.find<SessionController>()
                                                          .session
                                                          .value
                                                          .data
                                                          ?.profile_image
                                                          ?.isNotEmpty ??
                                                      false
                                                  ? Image.network(
                                                      Get.find<SessionController>()
                                                              .session
                                                              .value
                                                              .data
                                                              ?.profile_image ??
                                                          '',
                                                      height: 100,
                                                      width: 100,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : (widget.imageurl.isNotEmpty
                                                      ? Image.network(
                                                          widget.imageurl,
                                                          height: 100,
                                                          width: 100,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          'assets/profile.png',
                                                          height: 100,
                                                          width: 100,
                                                          fit: BoxFit.cover,
                                                        )))
                                              : Image.memory(
                                                  data.memoryImage.first,
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // child: Padding(
                                  //   padding: const EdgeInsets.all(5.0),
                                  //   child: CircleAvatar(
                                  //     backgroundColor: Colors.white,
                                  //     radius: 50,
                                  //     child: ClipOval(
                                  //       child: SizedBox.fromSize(
                                  //         size: const Size.fromRadius(48),
                                  //         child: data.memoryImage.isEmpty
                                  //             ? Image.network(
                                  //                 Get.find<SessionController>()
                                  //                             .session
                                  //                             .value
                                  //                             .data
                                  //                             ?.profile_image ==
                                  //                         ''
                                  //                     ? widget.imageurl
                                  //                     : Get.find<SessionController>()
                                  //                             .session
                                  //                             .value
                                  //                             .data
                                  //                             ?.profile_image ??
                                  //                         widget.imageurl,
                                  //                 height: 100,
                                  //                 width: 100,
                                  //                 fit: BoxFit.cover,
                                  //               )
                                  //             : Image.memory(
                                  //                 data.memoryImage.first,
                                  //                 height: 100,
                                  //                 width: 100,
                                  //                 fit: BoxFit.cover,
                                  //               ),
                                  //       ),
                                  //     ),
                                  //     // backgroundImage:  data.memoryImage.isEmpty? NetworkImage(Get.find<
                                  //     //     SessionController>()
                                  //     //     .session
                                  //     //     .value
                                  //     //     .data
                                  //     //     ?.profile_image ??
                                  //     //     'https://api.malayannursesunion.xyz/public/images/user.png'):MemoryImage(data.memoryImage.first),
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                          ),

                          // isLoaded? ElevatedButton( child: Text('Upload')):Text(''),

                          CustomFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your UserName';
                                }
                                return null;
                              },
                              controller: membername,
                              labelText: 'User Name',
                              obscureText: false),
                          CustomFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your MemberName';
                                }

                                return null;
                              },
                              inputType: TextInputType.emailAddress,
                              controller: membername,
                              labelText: 'Member Name',
                              obscureText: false),
                          CustomFormField(
                              readOnly: isReadOnly("new_icno"),
                              formatters: [
                                LengthLimitingTextInputFormatter(14),
                                NricFormatter(separator: '-')
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your NRIC';
                                }
                                return null;
                              },
                              inputType: TextInputType.number,
                              controller: newicno,
                              labelText: 'NRIC',
                              obscureText: false),

                          // CustomFormField(
                          //     // formatters: [
                          //     //   LengthLimitingTextInputFormatter(14),
                          //     //   NricFormatter(separator: '-')
                          //     // ],
                          //     validator: (value) {
                          //       if (value == null || value.isEmpty) {
                          //         return 'Please enter your pf.No';
                          //       }
                          //       return null;
                          //     },
                          //     inputType: TextInputType.number,
                          //     controller: pf_no,
                          //     labelText: 'Pf.No',
                          //     obscureText: false),
                          CustomFormField(
                              readOnly: isReadOnly("member_no"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Member Number';
                                }
                                return null;
                              },
                              inputType: TextInputType.number,
                              controller: member_no,
                              labelText: 'Member Number',
                              obscureText: false),
                          //  CustomFormField(
                          // // formatters: [
                          // //   LengthLimitingTextInputFormatter(14),
                          // //   NricFormatter(separator: '-')
                          // // ],
                          // // validator: (value) {
                          // //   if (value == null || value.isEmpty) {
                          // //     return 'Please enter your Employee Number';
                          // //   }
                          // //   return null;
                          // // },
                          // inputType: TextInputType.number,
                          // controller: employee_no,
                          // labelText: 'Employee Number',
                          // obscureText: false),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 16),
                            child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  labelText: 'Gender',
                                  labelStyle:
                                      getText(context).bodyMedium?.copyWith(
                                            fontFamily: 'Outfit',
                                            color: const Color(0xFF57636C),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                  hintStyle:
                                      getText(context).bodyMedium?.copyWith(
                                            fontFamily: 'Outfit',
                                            color: const Color(0xFF57636C),
                                            fontSize: 14,
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
                                  contentPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          20, 24, 0, 24),
                                ),
                                value: dropDownValue,

                                // value: dropDownValue
                                // !.isEmpty
                                //     ? 'others'
                                //     : dropDownValue,
                                items: Gender.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem(
                                    child: Text(
                                        value.substring(0, 1).toUpperCase() +
                                            value.substring(1).toLowerCase()),
                                    value: value,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropDownValue = value!;
                                  });
                                }),
                          ),

                          CustomFormField(
                            readOnly: true,
                            suffixIcon: IconButton(
                              onPressed: () {
                                showDate(context, DateTime.now()).then((value) {
                                  dob.text = DateFormat('yyyy/MM/dd')
                                      .format(value!)
                                      .toString();
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
                            inputType: TextInputType.number,
                            controller: dob,
                            labelText: 'Date Of Birth',
                            obscureText: false,
                          ),

                          CustomFormField(
                            readOnly: true,
                            controller: doj,
                            labelText: 'Date Of Joining',
                            obscureText: false,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  if (!isReadOnly("doj")) {
                                    showDates(context, DateTime.now())
                                        .then((value) {
                                      doj.text = DateFormat('yyyy/MM/dd')
                                          .format(value!)
                                          .toString();
                                    });
                                  }
                                },
                                icon: const Icon(Icons.date_range_outlined)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your doj';
                              }
                              debugPrint("${value}asaallll");

                              return null;
                            },
                          ),
                          CustomFormField(
                              maxlines: 3,
                              inputType: TextInputType.emailAddress,
                              controller: address,
                              labelText: 'Address',
                              obscureText: false),
                          CustomFormField(
                              inputType: TextInputType.number,
                              controller: postalcode,
                              labelText: 'Postal Code',
                              obscureText: false),
                          CustomFormField(
                              readOnly: isReadOnly("position"),
                              inputType: TextInputType.emailAddress,
                              controller: position,
                              labelText: 'Position',
                              obscureText: false),
                          CustomFormField(
                              readOnly: isReadOnly("employee_no"),
                              inputType: TextInputType.number,
                              controller: employee_no,
                              labelText: 'Employee No',
                              obscureText: false),
                          // CustomFormField(
                          //     inputType: TextInputType.number,
                          //     controller: telephoneno,
                          //     labelText: 'Telephone Number',
                          //     obscureText: false),
                          CustomFormField(
                              readOnly: isReadOnly("telephone_no_office"),
                              inputType: TextInputType.number,
                              controller: telephoneoffice,
                              labelText: 'No.Tel(O)',
                              obscureText: false),
                          CustomFormField(
                              inputType: TextInputType.number,
                              controller: telephonenohp,
                              labelText: 'No.H/P',
                              obscureText: false),

                          CustomFormField(
                              readOnly: isReadOnly("entrance_fee"),
                              inputType: TextInputType.number,
                              controller: entrancefee,
                              labelText: 'Entrance Fee',
                              obscureText: false),
                          CustomFormField(
                              readOnly: isReadOnly("monthly_fee"),
                              inputType: TextInputType.number,
                              controller: montlyfee,
                              labelText: 'Monthly Fee ',
                              obscureText: false),
                          CustomElevatedButton(
                            title: 'Submit',
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                showLoading(context);

                                if (data.memoryImage.isNotEmpty &&
                                    data.images.isNotEmpty) {
                                  List<String> images = data.images;
                                  await upload(images.first)
                                      .then((value) async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(value["message"])));

                                    data.memoryImage = [];
                                    data.images = [];
                                    data.files = [];
                                  });
                                }

                                await updateMember().then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              value["message"].toString())));

                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              }
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: 300,
                            child: Card(
                              color: const Color.fromARGB(255, 173, 145, 238),
                              child: ListTile(
                                trailing: const Icon(
                                  Icons.arrow_right_outlined,
                                  size: 30,
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              deleteUser();
                                              Get.find<SessionController>()
                                                  .session
                                                  .value
                                                  .logOut();
                                              setState(() {
                                                Get.find<SessionController>()
                                                    .session
                                                    .value = Session();
                                                Get.to(() => const LogIn());
                                              });
                                            },
                                            child: const Text('Yes')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: const Text('No'))
                                      ],
                                      title: const Text('Delete Account'),
                                      content: const Text(
                                          'Are you sure Delete your account?'),
                                    ),
                                  );
                                },
                                leading: const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                                title: const Text(
                                  'If you want to delete your Account',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    );
                  } else if (value.hasError) {
                    if (kDebugMode) {
                      print(value.error);
                    }
                    return const Center(child: Icon(Icons.error_outline));
                  } else if (value.hasData &&
                      value.data!.data!.status == false) {
                    return const Center(
                      child: Text('No user Found'),
                    );
                  } else {
                    return const CustomProgressIndicator();
                  }
                })),
      );
    });
  }

  isReadOnly(String keyValue) {
    // log("isReadOnly:${readOnly}");
    // log("keyValue:${keyValue}");

    if (readOnly.isNotEmpty && readOnly.contains(keyValue)) {
      return true;
    } else {
      return false;
    }
  }
}

Future<DateTime?> showDate(BuildContext context, DateTime dateTime) {
  DateTime myDate;

  return showDatePicker(
          context: context,
          initialDate: DateTime.now().subtract(const Duration(days: 60 * 365)),
          firstDate: DateTime(1900),
          lastDate: DateTime.now().subtract(const Duration(days: 18 * 365)))
      .then((value) => myDate = value ?? DateTime.now());
}

Future<DateTime?> showDates(BuildContext context, DateTime dateTime) {
  DateTime myDates;

  return showDatePicker(
          context: context,
          initialDate: DateTime.now().subtract(const Duration(days: 0)),
          firstDate: DateTime(1900),
          lastDate: DateTime.now())
      .then((value) => myDates = value ?? DateTime.now());
}
