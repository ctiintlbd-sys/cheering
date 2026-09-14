import '../../domain/entities/presigned_upload.dart';

class PresignedUploadModel extends PresignedUpload {
  const PresignedUploadModel({
    required super.presignedUrl,
    required super.publicUrl,
    required super.contentType,
  });

  factory PresignedUploadModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final headers = data['headers'] is Map<String, dynamic>
        ? data['headers'] as Map<String, dynamic>
        : null;
    final contentType = headers?['Content-Type']?.toString() ?? '';

    return PresignedUploadModel(
      presignedUrl: data['upload_url']?.toString() ?? '',
      publicUrl: data['public_url']?.toString() ?? '',
      contentType: contentType,
    );
  }
}
