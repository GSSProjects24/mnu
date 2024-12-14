import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart' as badges;
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mnu_app/view/widgets/custom_progress_indicator.dart';
import 'package:path_provider/path_provider.dart';

import '../../controllers/post_controller.dart';
import '../../controllers/sessioncontroller.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import '../../theme/myfonts.dart';
import '../admin/admin-post-view.dart';
import '../auth/landing-page.dart';
import '../widgets/custom_loading.dart';
import 'dart:typed_data';

class PostCreatePage extends StatefulWidget {
  const PostCreatePage(
      {super.key,
      required this.isEdit,
      this.urls,
      this.video,
      this.title,
      this.content,
      this.postId});

  final bool isEdit;
  final List<dynamic>? urls;
  final List<dynamic>? video;
  final String? title;
  final String? content;
  final String? postId;

  @override
  State<PostCreatePage> createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  TextEditingController content = TextEditingController();
  TextEditingController title = TextEditingController();

  Future<Map<String, dynamic>> createPost(
      {required List<String?> images,
      required List<String?> videos,
      String? Title,
      String? Content}) async {
    var body = {
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "image": images,
      "video": videos,
      "content": Content ?? '',
      "title": Title ?? ''
    };
    print(Get.find<SessionController>().session.value.data?.userId);
    final response = await http.put(
        headers: {"Content-Type": "application/json"},
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_post'),
        body: jsonEncode(body));
    print(response.body);

    debugPrint(jsonEncode(body));

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> editPost(
      {required List<String?> images,
      required List<String?> videos,
      String? Title,
      String? Content,
      String? postId}) async {
    var body = {
      "post_id": postId,
      "user_id":
          Get.find<SessionController>().session.value.data?.userId.toString(),
      "image": images,
      "video": videos,
      "content": Content ?? '',
      "title": Title ?? ''
    };
    print(Get.find<SessionController>().session.value.data?.userId);
    final response = await http.put(
        headers: {"Content-Type": "application/json"},
        Uri.parse('http://mnuapi.graspsoftwaresolutions.com/api_post_edit'),
        body: jsonEncode(body));
    print('**********+${response.body}');
    if (response.statusCode == 200) {
      print(jsonEncode(body));
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // PostController postcotroller = PostController();
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    title.text = widget.title ?? '';
    content.text = widget.content ?? '';
    Get.put(PostController());
    if (widget.isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint("postId:${widget.postId}");
        loadEdit();
      });
      print(widget.urls?.length);
      print(widget.video?.length);
    }

    super.initState();
  }

  @override
  dispose() {
    Get.find<PostController>().dispose();
    super.dispose();
  }

  late VideoPlayerController _controller;

  // loadEdit() async {
  //   if (widget.isEdit && widget.urls != null) {
  //     List<String?> data = [];
  //
  //     print(data);
  //
  //     for (var dynamic in widget.urls!) {
  //       data.add(dynamic.toString());
  //     }
  //
  //     print("mydata ${data}");
  //
  //     await Get.find<PostController>().LoadNetworkImage(data);
  //   }
  //   if (widget.isEdit && widget.video != null) {
  //     List<String?> data = [];
  //     print(data);
  //     for (var dynamic in widget.video!) {
  //       data.add(dynamic.toString());
  //     }
  //     print("vidata ${data}");
  //     print("vidataNav ${widget.video}");
  //     await Get.find<PostController>().LoadNetworkVideo(data);
  //   }
  //   setState(() {});
  // }
  bool isLoading = true;

  Future<void> loadEdit() async {
    setState(() {
      isLoading = true; // Show loader
    });
    if (widget.isEdit && widget.urls != null) {
      List<String?> data = widget.urls!.map((e) {
        if (widget.urls!.contains(e)) {
          return e.toString();
        }
      }).toList();
      Get.find<PostController>().memoryImage.clear();
      debugPrint("Image URLs: $data");
      await Get.find<PostController>().LoadNetworkImage(data);
    }

    if (widget.isEdit && widget.video != null) {
      List<String?> videoData = widget.video!.map((e) {
        if (widget.video!.contains(e)) {
          return e.toString();
        }
      }).toList();
      Get.find<PostController>().memoryVideo.clear();
      debugPrint("Video URLs: $videoData");
      await Get.find<PostController>().LoadNetworkVideo(videoData);
    }
    setState(() {
      isLoading = false; // Hide loader
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetX<PostController>(
        init: PostController(),
        initState: (value) async {
          // Get.find<PostController>().images=[];
          // Get.find<PostController>().memoryImage=[];
          // Get.find<PostController>().videos=[];
          // Get.find<PostController>().videoFiles=[];
          // Get.find<PostController>().files=[];
          // Get.find<PostController>().memoryVideo=[];
          widget.isEdit ? null : value.controller = PostController();
        },
        builder: (postcontroller) => Form(
              key: _formkey,
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  debugPrint("Pop action ************.");
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      widget.isEdit ? 'Edit Your Post' : '',
                      style: const TextStyle(color: Colors.white),
                    ),
                    leading: IconButton(
                        onPressed: () {
                          if (widget.isEdit) {
                            Navigator.pop(context, true);
                            Navigator.pop(context, true);
                            Navigator.pop(context, true);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.arrow_back)),
                    actions: [
                      // widget.isEdit
                      //     ? IconButton(
                      //         onPressed: () {},
                      //         icon: Icon(
                      //           Icons.delete,
                      //           color: Colors.red,
                      //         ))
                      //     : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  isDismissible: true,
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: Get.height * 0.13,
                                      width: Get.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 100,
                                            child: Column(
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      await postcontroller
                                                          .addFileFromCamera();
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
                                                    onPressed: () async {
                                                      await postcontroller
                                                          .addFiles();
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
                                          SizedBox(
                                            height: 100,
                                            child: Column(
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      await postcontroller
                                                          .addVideoFromCamera();
                                                    },
                                                    icon: const Icon(
                                                      Icons.video_call_rounded,
                                                      size: 30,
                                                    )),
                                                const Text('Video')
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 100,
                                            child: Column(
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      await postcontroller
                                                          .addVideoFromGallery();
                                                    },
                                                    icon: const Icon(
                                                      Icons.file_copy,
                                                      size: 30,
                                                    )),
                                                const Text('Video Gallery')
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: const SizedBox(
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(child: Text('Add')),
                                  Icon(Icons.camera)
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }

                              return null;
                            },
                            controller: title,
                            labelText: 'Title',
                            obscureText: false,
                            maxlines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }

                              return null;
                            },
                            controller: content,
                            labelText: 'Type your thoughts here',
                            obscureText: false,
                            maxlines: 4,
                          ),
                        ),
                        postcontroller.memoryImage.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 170,
                                  child: isLoading && widget.isEdit
                                      ? const Center(
                                          child: CustomProgressIndicator(),
                                        )
                                      : ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              postcontroller.memoryImage.length,
                                          itemBuilder: (context, index) {
                                            final memoryImage = postcontroller
                                                .memoryImage[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: badges.Badge(
                                                position: badges.BadgePosition
                                                    .bottomEnd(),
                                                badgeStyle: badges.BadgeStyle(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                badgeContent: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      debugPrint(
                                                          'Before removal: memoryImage: ${postcontroller.memoryImage.length}, images: ${postcontroller.images.length}, files: ${postcontroller.files.length}');
                                                      if (index <
                                                          postcontroller
                                                              .memoryImage
                                                              .length) {
                                                        postcontroller
                                                            .memoryImage
                                                            .removeAt(index);
                                                      }
                                                      if (index <
                                                          postcontroller
                                                              .images.length) {
                                                        postcontroller.images
                                                            .removeAt(index);
                                                      }
                                                      if (index <
                                                          postcontroller
                                                              .files.length) {
                                                        postcontroller.files
                                                            .removeAt(index);
                                                      }
                                                      debugPrint(
                                                          'After removal: memoryImage: ${postcontroller.memoryImage.length}, images: ${postcontroller.images.length}, files: ${postcontroller.files.length}');
                                                    });
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete),
                                                ),
                                                child: SizedBox(
                                                  height: 170,
                                                  width: 150,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: memoryImage != null
                                                        ? Image.memory(
                                                            memoryImage,
                                                            fit: BoxFit.fill,
                                                          )
                                                        : const SizedBox(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ),
                        postcontroller.memoryVideo.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 170,
                                  child: isLoading && widget.isEdit
                                      ? const Center(
                                          child: CustomProgressIndicator(),
                                        )
                                      : Obx(() => ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: postcontroller
                                                .memoryVideo.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              debugPrint(
                                                  "memeoryVideo:${postcontroller.memoryVideo}");
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: badges.Badge(
                                                    position:
                                                        badges.BadgePosition
                                                            .bottomEnd(),
                                                    badgeStyle: const badges
                                                        .BadgeStyle(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    2))),
                                                    badgeContent: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          debugPrint(
                                                              'Before removal: memoryVideo: ${postcontroller.memoryVideo.length}, videos: ${postcontroller.videos.length}, files: ${postcontroller.videoFiles.length}');
                                                          if (index <
                                                              postcontroller
                                                                  .memoryVideo
                                                                  .length) {
                                                            postcontroller
                                                                .memoryVideo
                                                                .removeAt(
                                                                    index);
                                                          }
                                                          if (index <
                                                              postcontroller
                                                                  .videos
                                                                  .length) {
                                                            postcontroller
                                                                .videos
                                                                .removeAt(
                                                                    index);
                                                          }
                                                          if (index <
                                                              postcontroller
                                                                  .videoFiles
                                                                  .length) {
                                                            postcontroller
                                                                .videoFiles
                                                                .removeAt(
                                                                    index);
                                                          }
                                                          debugPrint(
                                                              'After removal: memoryVideo: ${postcontroller.memoryVideo.length}, videos: ${postcontroller.videos.length}, files: ${postcontroller.videoFiles.length}');
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                      ),
                                                    ),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: SizedBox(
                                                          height: 150,
                                                          width: 150,
                                                          child: VideoAppUrl(
                                                            memoryVideo:
                                                                postcontroller
                                                                        .memoryVideo[
                                                                    index],
                                                          ),
                                                        ))),
                                              );
                                            },
                                          )),
                                ),
                              ),
                        Text(
                          'Please upload the video  with less than 15 mb',
                          style: getText(context)
                              .bodySmall
                              ?.copyWith(color: Colors.grey.withOpacity(0.5)),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: CustomFormField(
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return 'Please enter some text';
                        //       }

                        //       return null;
                        //     },
                        //     controller: title,
                        //     labelText: 'Title',
                        //     obscureText: false,
                        //     maxlines: 1,
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: CustomFormField(
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return 'Please enter some text';
                        //       }

                        //       return null;
                        //     },
                        //     controller: content,
                        //     labelText: 'Type your thoughts here',
                        //     obscureText: false,
                        //     maxlines: 4,
                        //   ),
                        // ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              print("is calling");
                              if (_formkey.currentState!.validate()) {
                                List<String> images = postcontroller.images;
                                List<String> videos = postcontroller.videos;
                                // memoryVideo

                                if (widget.isEdit != true) {
                                  showLoading(context);
                                  await createPost(
                                          Content: content.text,
                                          images: images.toList(),
                                          Title: title.text,
                                          videos: videos)
                                      .then((data) {
                                    if (data["data"]["status"] == true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(data["message"])));
                                      Navigator.pop(context);
                                      //Get.off(() => const LandingPage());
                                    }
                                    if (data["data"]["status"] == false) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(data["message"])));

                                      Get.off(() => const LandingPage());
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  });
                                }
                                if (widget.isEdit) {
                                  print("is calling");
                                  showLoading(context);
                                  print("img list");
                                  print(images.toList());
                                  print("debug img list");
                                  debugPrint(images.toList().toString());
                                  print(
                                      "postcontroller : ${postcontroller.images}");
                                  print(
                                      "memoryImage length : ${postcontroller.memoryImage.length}");
                                  print(
                                      "img length : ${postcontroller.images.length}");
                                  print("length : ${images.length}");
                                  print(postcontroller.images.toList());
                                  List<String> base64ImageList = postcontroller
                                      .memoryImage
                                      .map((imageData) {
                                    return base64Encode(imageData);
                                  }).toList();

                                  print(
                                      "memoryVideo len : ${postcontroller.memoryVideo.length}");
                                  print("video len : ${videos.length}");

                                  print("base64ImageList : ${base64ImageList}");
                                  print(
                                      "base64ImageList length : ${base64ImageList.length}");
                                  try {
                                    final data = await editPost(
                                      Content: content.text,
                                      postId: widget.postId,
                                      images: base64ImageList,
                                      Title: title.text,
                                      videos: videos,
                                    );
                                    print(
                                        "my_status : ${data["data"]["status"] == true}");
                                    if (data["data"]["status"] == true) {
                                      Get.snackbar("Post Updated Successfully",
                                           "",
                                          snackPosition: SnackPosition.BOTTOM);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("An error occurred: $e")),
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  }
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                              ),
                              child: Text(widget.isEdit ? 'Update Post' : 'Post'),
                            )),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}

Future<void> showMyDialog2(
    {required BuildContext context,
    void Function()? camera,
    void Function()? gallery}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          width: Get.width * 0.40,
          height: Get.height * 0.10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                  onTap: camera,
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/3249/3249935.png',
                    height: 100,
                  )),
              GestureDetector(
                  onTap: gallery,
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/7224/7224509.png',
                    height: 100,
                  )),
            ],
          ),
        ),
      );
    },
  );
}

class VideoApp extends StatefulWidget {
  const VideoApp({Key? key, required this.closedbodySmallFile})
      : super(key: key);

  final File closedbodySmallFile;

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.closedbodySmallFile,
        videoPlayerOptions: VideoPlayerOptions(
            // allowBackgroundPlayback: true,
            // mixWithOthers: true
            ))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Center(
            child: IconButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class VideoAppUrl extends StatefulWidget {
  final Uint8List memoryVideo;

  const VideoAppUrl({Key? key, required this.memoryVideo}) : super(key: key);

  @override
  _VideoAppUrlState createState() => _VideoAppUrlState();
}

class _VideoAppUrlState extends State<VideoAppUrl> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  String? _currentMemoryVideoPath;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer(widget.memoryVideo);
  }

  // Function to initialize the video player with a given memory video (Uint8List)
  Future<void> _initializeVideoPlayer(Uint8List videoData) async {
    try {
      // Dispose of previous controllers before creating a new one
      await _controller?.dispose();
      _chewieController?.dispose();

      // Save the Uint8List data to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/video.mp4');

      // Explicitly cast Uint8List to List<int> before writing
      await tempFile.writeAsBytes(videoData as List<int>); // Cast to List<int>

      // Initialize the VideoPlayerController with the temporary file
      _controller = VideoPlayerController.file(tempFile);

      // Wait for initialization
      await _controller?.initialize();

      // Set up the Chewie controller after the VideoPlayerController is initialized
      final videoWidth = _controller?.value.size.width ?? 0;
      final videoHeight = _controller?.value.size.height ?? 0;
      double aspectRatio = videoWidth / videoHeight;

      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        aspectRatio: aspectRatio,
        autoPlay: true,
        looping: false,
      );

      setState(() {
        _currentMemoryVideoPath = tempFile.path;
        _isInitialized = true;
      });
    } catch (e) {
      // Handle any errors here (e.g., file read/write issues or video initialization failure)
      print("Error initializing video player: $e");
      setState(() {
        _isInitialized = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant VideoAppUrl oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the memory video data has changed, reload the video
    if (widget.memoryVideo != oldWidget.memoryVideo) {
      _initializeVideoPlayer(widget.memoryVideo);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _controller!.value.isInitialized
                ? VideoPlayer(_controller!)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Center(
            child: IconButton(
              onPressed: () {
                setState(() {
                  _controller!.value.isPlaying
                      ? _controller?.pause()
                      : _controller?.play();
                });
              },
              icon: Icon(
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          )
        ],
      ),
    );
  }
}
