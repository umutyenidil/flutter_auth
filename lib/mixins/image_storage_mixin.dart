import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

mixin ImageStorage {
  Future<Uint8List> getPhotoBytesFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    Uint8List photoBytes = await photo!.readAsBytes();
    return photoBytes;
  }

  Future<Uint8List> getImageBytesFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    Uint8List imageBytes = await image!.readAsBytes();
    return imageBytes;
  }

  Future<Uint8List> getImageBytesFromAssets({required String assetPath}) async {
    ByteData bytes = await rootBundle.load(assetPath);
    Uint8List imageBytes = bytes.buffer.asUint8List();
    return imageBytes;
  }

  Future<File?> getPhotoFileFromCamera() async {
    ImagePicker picker = ImagePicker();
    XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.front,
    );

    if (photo == null) {
      return null;
    }

    File photoFile = File(photo.path);
    return photoFile;
  }

  Future<File?> getPhotoFileFromGallery() async {
    ImagePicker picker = ImagePicker();
    XFile? photo = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (photo == null) {
      return null;
    }

    File photoFile = File(photo.path);
    return photoFile;
  }
}
