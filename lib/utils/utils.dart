import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource src) async {
  final ImagePicker _imagepicker = ImagePicker();

  XFile _file = await _imagepicker.pickImage(source: src);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No image selected');
}

showSnackbar(BuildContext cntxt, String content) {
  ScaffoldMessenger.of(cntxt).showSnackBar(SnackBar(content: Text(content)));
}
