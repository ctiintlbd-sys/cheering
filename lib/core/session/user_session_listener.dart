import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/service_locator.dart';
import '../router/app_router_notifier.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_event.dart';

/// Keeps user-bound blocs in sync with [AppRouterNotifier.isAuthenticated].
class UserSessionListener extends StatefulWidget {
  const UserSessionListener({super.key, required this.child});

  final Widget child;

  @override
  State<UserSessionListener> createState() => _UserSessionListenerState();
}

class _UserSessionListenerState extends State<UserSessionListener> {
  late final AppRouterNotifier _notifier;
  bool? _lastAuthenticated;

  @override
  void initState() {
    super.initState();
    _notifier = getIt<AppRouterNotifier>();
    _notifier.addListener(_onAuthChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onAuthChanged());
  }

  @override
  void dispose() {
    _notifier.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (!mounted || !_notifier.isInitialized) return;

    final authenticated = _notifier.isAuthenticated;
    if (_lastAuthenticated == authenticated) return;
    _lastAuthenticated = authenticated;

    if (authenticated) {
      context.read<ProfileBloc>().add(const LoadProfileRequested());
    } else {
      context.read<ProfileBloc>().add(const ProfileSessionCleared());
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
