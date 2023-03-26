import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

mixin ImageStorage {
  Future<Uint8List> getPhotoBytesFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    Uint8List photoBytes = await photo!.readAsBytes();
    return photoBytes;
  }

  Future<Uint8List> getImageBytesFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    Uint8List imageBytes = await image!.readAsBytes();
    return imageBytes;
  }

  Future<Uint8List> getImageBytesFromAssets({required String assetPath}) async {
    ByteData bytes = await rootBundle.load(assetPath);
    Uint8List imageBytes = bytes.buffer.asUint8List();
    return imageBytes;
  }
}
