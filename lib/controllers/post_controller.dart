import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PostController extends GetxController {
  List<Uint8List> memoryImage = <Uint8List>[].obs;
  List<Uint8List> memoryVideo = <Uint8List>[].obs;
  List<String> images = <String>[].obs;
  List<String> videos = <String>[].obs;
  List<File> files = <File>[].obs;
  List<File> videoFiles = <File>[].obs;
  List<String?> urls = <String?>[].obs;

  Future<void> addFileFromCamera() async {
    PickedFile? result =
        (await ImagePicker.platform.pickImage(source: ImageSource.camera));
    if (result != null) {
      files.add(File(result.path));
      images = await convertFilesToBase64();

      await File(result.path)
          .readAsBytes()
          .then((value) => memoryImage.add(value));
    }
  }

  Future<void> addImageFromGalley() async {
    PickedFile? result =
        (await ImagePicker.platform.pickImage(source: ImageSource.gallery));
    if (result != null) {
      files.add(File(result.path));
      images = await convertFilesToBase64();

      await File(result.path)
          .readAsBytes()
          .then((value) => memoryImage.add(value));
    }
  }

  Future<void> addVideoFromCamera() async {
    PickedFile? result =
        (await ImagePicker.platform.pickVideo(source: ImageSource.camera));
    if (result != null) {
      videoFiles.add(File(result.path));
      videos = await convertVideosToBase64().whenComplete(() => print(
          '*****************************done**************************************'));

      await File(result.path)
          .readAsBytes()
          .then((value) => memoryVideo.add(value));
    }
  }

  Future<void> addVideoFromGallery() async {
    PickedFile? result =
        (await ImagePicker.platform.pickVideo(source: ImageSource.gallery));
    if (result != null) {
      videoFiles.add(File(result.path));
      videos = await convertVideosToBase64().whenComplete(() => print(
          '*****************************done**************************************'));

      await File(result.path)
          .readAsBytes()
          .then((value) => memoryVideo.add(value));
    }
  }

  Future<void> addprofileFromCamera() async {
    files = [];
    memoryImage = [];

    PickedFile? result =
        (await ImagePicker.platform.pickImage(source: ImageSource.camera));
    if (result != null) {
      files.add(File(result.path));
      images = await convertFilesToBase64();

      await File(result.path)
          .readAsBytes()
          .then((value) => memoryImage.add(value));
    }
  }

  Future<void> addFiles() async {
    List<PickedFile> result =
        (await ImagePicker.platform.pickMultiImage()) ?? [];
    debugPrint("resultGallery:$result");
    if (result != null) {
      files.addAll(result.map((e) => File(e.path)));
      images = await convertFilesToBase64();

      for (var file in result) {
        await File(file.path)
            .readAsBytes()
            .then((value) => memoryImage.add(value));
      }
    }
  }

  Future<void> addFile() async {
    files = [];
    memoryImage = [];
    PickedFile? result =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (result != null) {
      files.add(File(result.path));
      images = await convertFilesToBase64();

      await File(files[0].path)
          .readAsBytes()
          .then((value) => memoryImage.add(value));
    }
  }

  removeFile(File e) {
    files.remove(e);
  }

  Future<List<String>> convertFilesToBase64() {
    List<Future<String>> futures = [];
    for (var file in files) {
      futures.add(convertFiletoBase64(file));
    }

    return Future.wait(futures);
  }

  Future<List<String>> convertVideosToBase64() {
    List<Future<String>> futures = [];
    for (var file in videoFiles) {
      futures.add(convertFiletoBase64(file));
    }

    return Future.wait(futures);
  }

  Future<String> convertFiletoBase64(File file) {
    return file.readAsBytes().then((Uint8List uint8list) {
      return base64Encode(uint8list);
    });
  }

  Future<void> LoadNetworkImage(List<String?> urls) async {
    for (var url in urls) {
      if (url != null) {
        try {
          var data = await networkImageToBase64(url);
          var data2 = await networkImageTouint(url);

          print("LoadNetworkImageData");
          print(data2);
          print(data);

          // Avoid duplicates
          if (data != null && !images.contains(data)) {
            images.add(data);
          }
          if (data2 != null && !memoryImage.contains(data2)) {
            memoryImage.add(data2);
          }
        } catch (e) {
          debugPrint('Error loading image: $e');
        }
      }
    }
  }

  Future<void> LoadNetworkVideo(List<String?> videosList) async {
    for (var url in videosList) {
      if (url != null) {
        try {
          var data = await networkImageToBase64(url);
          var data2 = await networkImageTouint(url);

          if (data != null && !videos.contains(data)) {
            videos.add(url);
          }
          if (data2 != null && !memoryVideo.contains(data2)) {
            memoryVideo.add(data2);
          }
        } catch (e) {
          debugPrint('Error loading video: $e');
        }
      }
    }
  }

  Future<String?> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    print(response.statusCode);
    print(response.body);

    print('test');
    final bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  Future<Uint8List?> networkImageTouint(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));

    print('test');
    return response.bodyBytes;
  }
}
