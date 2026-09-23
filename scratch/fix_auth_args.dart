import 'dart:io';

void main() {
  var file = File('lib/features/authentication/presentation/screen/otp_screen.dart');
  var content = file.readAsStringSync();
  content = content.replaceAll(
    "extra: {\n        'email': widget.email,\n        'otp': otp,\n        'isForgotPassword': widget.isForgotPassword,\n      }",
    "extra: SetPasswordScreenArgs(email: widget.email, otp: otp, isForgotPassword: widget.isForgotPassword)"
  );
  if (!content.contains('route_args.dart')) {
    content = "import 'package:cheering/core/router/route_args.dart';\n" + content;
  }
  file.writeAsStringSync(content);
}
