import 'dart:io';

void main() {
  final file = File('lib/features/profile/presentation/screens/widgets/profile_empty_widget.dart');
  var content = file.readAsStringSync();
  content = content.replaceAll(
    'context.go(AuthRedirect.loginPath(returnTo: RoutePaths.profileTab));', 
    '{\n              getIt<AppRouterNotifier>().setPendingRedirect(RoutePaths.profileTab);\n              context.go(RoutePaths.login);\n            }'
  );
  file.writeAsStringSync(content);
}
