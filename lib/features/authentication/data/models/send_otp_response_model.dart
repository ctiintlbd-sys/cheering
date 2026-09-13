class SendOtpResponseModel {
  final String message;

  const SendOtpResponseModel({required this.message});

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return SendOtpResponseModel(
      message: data['message']?.toString() ?? 'OTP sent',
    );
  }
}
