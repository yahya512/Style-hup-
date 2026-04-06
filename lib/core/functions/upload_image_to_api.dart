import 'package:dio/dio.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future uploadimageToApi(XFile image) async {
  return MultipartFile.fromFile(
    image.path,
    filename: image.path.split("/").last,
  );
}

// for PickImage in Brand Info
Future<XFile?> pickImage(BuildContext context) async {
  final XFile? image = await ImagePicker().pickImage(
    source: ImageSource.gallery,
  );
  if (image == null) {
    if (!context.mounted) {
      // means that user close the widget (Dipose)
      return null;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.up,
        content: Text(
          "You Must Choose a Photo to Complete Info",
          style: AppStyles.snackBarStyle,
        ),
      ),
    );
  }
  return image;
}
