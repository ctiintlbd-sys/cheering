class PresignedUpload {
  final String presignedUrl;
  final String publicUrl;
  final String contentType;

  const PresignedUpload({
    required this.presignedUrl,
    required this.publicUrl,
    required this.contentType,
  });
}
