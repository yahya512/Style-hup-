import 'package:dx/core/api/endpoints.dart';
import 'package:image_picker/image_picker.dart';

class ImageuploadModel {
  final XFile? brandPhoto;

  ImageuploadModel({required this.brandPhoto});

  factory ImageuploadModel.fromJson(Map<String, dynamic> jsonData) {
    return ImageuploadModel(brandPhoto: jsonData[ApiKey.brandProfile]);
  }
}
