class ForgotPasswordResponseModel {
  final String message;

  const ForgotPasswordResponseModel({required this.message});

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return ForgotPasswordResponseModel(
      message: data['message']?.toString() ?? '',
    );
  }
}
