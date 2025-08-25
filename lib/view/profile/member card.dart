import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:screenshot/screenshot.dart';
import '../../controllers/sessioncontroller.dart';
import '../../models/edit_profile.dart';
import '../../models/member-model.dart';
import '../../theme/myfonts.dart';
import '../widgets/custom_progress_indicator.dart';
import 'package:pdf/widgets.dart' as pw;

class Membercard extends StatefulWidget {
  const Membercard({super.key});

  @override
  State<Membercard> createState() => _MembercardState();
}

class _MembercardState extends State<Membercard> {
  ScreenshotController screenshotController = ScreenshotController();
  Future<MemberModel> loadMember() async {
    final response = await http.post(
      Uri.parse('https://api.malayannursesunion.xyz/api_getuser'),
      body: {
        "user_id":
            Get.find<SessionController>().session.value.data?.userId.toString(),
        "logged_user_id":
            Get.find<SessionController>().session.value.data?.userId.toString()
      },
    );

    if (response.statusCode == 200) {
      return MemberModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<EditProfileModel> LoadMember(String? newicno) async {
    var body = {
      "new_icno": newicno,
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString()
    };
    final response = await http.post(
        Uri.parse(
            'https://api.malayannursesunion.xyz/api_edit_member_profile'),
        body: body);

    if (response.statusCode == 200) {
      return EditProfileModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  late Future<MemberModel> member;
  final pdf = pw.Document();
  @override
  void initState() {
    member = loadMember();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MemberModel>(
      future: member,
      builder: (BuildContext context, AsyncSnapshot<MemberModel> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'MALAYAN NURSES UNION',
                    style: TextStyle(color: Colors.white),
                  )),
              actions: [
                IconButton(
                  icon: const Icon(Icons.download_rounded),
                  onPressed: () async {
                    await screenshotController.capture(pixelRatio: 1.5).then(
                        (value) => {saveAndLaunchFile(value!, 'example.jpg')});
                  },
                ),
              ],
            ),
            body: Builder(builder: (context) {
              return Center(
                child: Screenshot(
                  controller: screenshotController,
                  child: Card(
                    elevation: 0,
                    color: const Color.fromARGB(255, 49, 21, 163),
                    margin: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 60,
                            child: Card(
                              color: Color.fromARGB(255, 49, 21, 163),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor:
                                        Color.fromARGB(255, 49, 21, 163),
                                    foregroundImage:
                                        AssetImage('assets/memberlogo.png'),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'MALAYAN NURSES UNION',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          buildCardRow(
                              "Name:", snapshot.data?.data?.memberName ?? ''),
                          buildCardRow(
                              "Nric:", snapshot.data?.data?.newIcno ?? ''),
                          buildCardRow("Member No:",
                              snapshot.data?.data?.memberNo ?? ''),
                          buildCardRow("Dob:", snapshot.data?.data?.dob ?? ''),
                          buildCardRow("Doj:", snapshot.data?.data?.doj ?? ''),
                          buildCardRow("Mob No:",
                              snapshot.data?.data?.telephoneNo ?? ''),
                          buildCardRow(
                              "Address:", "${snapshot.data?.data?.address}"),
                          const SizedBox(
                            height: 8,
                          )

                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     top: 6,
                          //     left: 8,
                          //   ),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text('Name       ',
                          //           style: (getText(context).bodySmall)!
                          //               .copyWith(
                          //                   color: Colors.white,
                          //                   fontWeight: FontWeight.bold)),
                          //       Expanded(
                          //         child: RichText(
                          //           text: TextSpan(
                          //             text:
                          //                 snapshot.data?.data?.memberName ?? '',
                          //           ),
                          //           maxLines: 3,
                          //           overflow: TextOverflow.ellipsis,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     top: 6,
                          //     left: 8,
                          //   ),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text(
                          //         'Nric          ',
                          //         style: (getText(context).bodySmall)!.copyWith(
                          //             color: Colors.white,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //       Text(
                          //         snapshot.data?.data?.newIcno ?? '',
                          //         style: (getText(context).bodySmall)!
                          //             .copyWith(color: Colors.white),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     top: 6,
                          //     left: 8,
                          //   ),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text(
                          //         'Member No          ',
                          //         style: (getText(context).bodySmall)!.copyWith(
                          //             color: Colors.white,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //       Text(
                          //         snapshot.data?.data?.memberNo ?? '',
                          //         style: (getText(context).bodySmall)!
                          //             .copyWith(color: Colors.white),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     top: 6,
                          //     left: 8,
                          //   ),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text(
                          //         'Dob          ',
                          //         style: (getText(context).bodySmall)!.copyWith(
                          //             color: Colors.white,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //       Text(
                          //         snapshot.data?.data?.dob ?? '',
                          //         style: (getText(context).bodySmall)!
                          //             .copyWith(color: Colors.white),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     top: 6,
                          //     left: 8,
                          //   ),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text(
                          //         'Doj           ',
                          //         style: (getText(context).bodySmall)!.copyWith(
                          //             color: Colors.white,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //       Text(
                          //         snapshot.data?.data?.doj ?? '',
                          //         style: (getText(context).bodySmall)!
                          //             .copyWith(color: Colors.white),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     top: 6,
                          //     left: 8,
                          //   ),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text(
                          //         'Mob No    ',
                          //         style: (getText(context).bodySmall)!.copyWith(
                          //             color: Colors.white,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //       Text(
                          //         snapshot.data?.data?.telephoneNo ?? '',
                          //         style: (getText(context).bodySmall)!
                          //             .copyWith(color: Colors.white),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       top: 6, left: 8, right: 3),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text(
                          //         'Address ',
                          //         style: (getText(context).bodySmall)!.copyWith(
                          //             color: Colors.white,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //       SizedBox(
                          //         width: 10,
                          //       ),
                          //       Expanded(
                          //         child: RichText(
                          //           text: TextSpan(
                          //             text: snapshot.data?.data?.address ?? '',
                          //           ),
                          //           maxLines: 3,
                          //           overflow: TextOverflow.ellipsis,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        } else if (snapshot.hasError) {
          if (kDebugMode) {
            print(snapshot.error);
          }
          return const Scaffold(body: Center(child: Icon(Icons.error_outline)));
        } else {
          return const Scaffold(body: CustomProgressIndicator());
        }
      },
    );
  }

  buildCardRow(lable, value) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 6,
        left: 8,
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              lable,
              style: (getText(context).bodySmall)!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              maxLines: 7,
              overflow: TextOverflow.ellipsis,
              value,
              style:
                  (getText(context).bodySmall)!.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> generatePdf(Uint8List image) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.landscape,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Image(pw.MemoryImage(image)),
                ),
              ),
            ],
          );
        },
      ),
    );
    final file = File("example.pdf");
    await file.writeAsBytes(await pdf.save());
    // final pdfBytes = await pdf.save();
    // final anchor = html.document.createElement('a') as html.AnchorElement
    //   ..href = html.Url.createObjectUrlFromBlob(html.Blob([pdfBytes], 'image/pdf'))
    //   ..download = 'file.pdf'
    //   ..style.display = 'none';
    // html.document.body?.children.add(anchor);
    // anchor.click();

    // html.document.body?.children.remove(anchor);
    // html.Url.revokeObjectUrl(anchor.href!);
    return pdf.save();
  }
}

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  //Get the storage folder location using path_provider package.
  String? path;
  if (Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isLinux ||
      Platform.isWindows) {
    final Directory directory =
        await path_provider.getApplicationSupportDirectory();
    path = directory.path;
  } else {
    path = await PathProviderPlatform.instance.getApplicationSupportPath();
  }
  final File file =
      File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  if (Platform.isAndroid || Platform.isIOS) {
    //Launch the file (used open_file package)
    await open_file.OpenFile.open('$path/$fileName');
  } else if (Platform.isWindows) {
    await Process.run('start', <String>['$path\\$fileName'], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', <String>['$path/$fileName'], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', <String>['$path/$fileName'],
        runInShell: true);
  }
}
