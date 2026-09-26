import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/core/router/app_router_notifier.dart';
import 'package:cheering/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:cheering/features/profile/presentation/bloc/profile_event.dart';
import 'package:cheering/features/address/presentation/bloc/address_bloc.dart';
import 'package:cheering/features/address/presentation/bloc/address_event.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_event.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSessionSync extends StatefulWidget {
  const ProfileSessionSync({super.key, required this.child});

  final Widget child;

  @override
  State<ProfileSessionSync> createState() => _ProfileSessionSyncState();
}

class _ProfileSessionSyncState extends State<ProfileSessionSync> {
  AppRouterNotifier get _router => getIt<AppRouterNotifier>();
  late bool _wasAuthenticated;

  @override
  void initState() {
    super.initState();
    _wasAuthenticated = _router.isAuthenticated;
    _router.addListener(_onSessionChanged);
  }

  @override
  void dispose() {
    _router.removeListener(_onSessionChanged);
    super.dispose();
  }

  void _onSessionChanged() {
    if (!_router.isInitialized) return;

    final isAuthenticated = _router.isAuthenticated;
    if (isAuthenticated == _wasAuthenticated) return;

    final profileBloc = context.read<ProfileBloc>();
    final cartBloc = context.read<CartBloc>();
    final addressBloc = context.read<AddressBloc>();

    if (_wasAuthenticated && !isAuthenticated) {
      profileBloc.add(const ProfileSessionCleared());
      cartBloc.add(const ClearCart());
    } else if (!_wasAuthenticated && isAuthenticated) {
      _requestProfileIfNeeded(profileBloc);
      cartBloc.add(const LoadCart());
      addressBloc.add(const LoadAddressesRequested());
    }

    _wasAuthenticated = isAuthenticated;
  }

  void _requestProfileIfNeeded(ProfileBloc bloc) {
    final profile = bloc.state;
    if (profile.hasUser) return;
    if (profile.isLoadProfileLoading) return;
    bloc.add(const LoadProfileRequested());
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
