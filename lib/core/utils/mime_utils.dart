import 'package:dio/dio.dart';

DioMediaType? getMediaTypeForFile(String filePath) {
  final ext = filePath.split('.').last.toLowerCase();
  switch (ext) {
    case 'jpg':
    case 'jpeg':
      return DioMediaType('image', 'jpeg');
    case 'png':
      return DioMediaType('image', 'png');
    case 'gif':
      return DioMediaType('image', 'gif');
    case 'webp':
      return DioMediaType('image', 'webp');
    case 'pdf':
      return DioMediaType('application', 'pdf');
    case 'json':
      return DioMediaType('application', 'json');
    case 'mp4':
      return DioMediaType('video', 'mp4');
    default:
      return null;
  }
}
