import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_state.dart';

class GlobalCartListener extends StatelessWidget {
  final Widget child;

  const GlobalCartListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) => 
          current.errorMessage != null && 
          current.errorMessage != previous.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ToastMessageHelper.show(state.errorMessage!);
        }
      },
      child: child,
    );
  }
}
