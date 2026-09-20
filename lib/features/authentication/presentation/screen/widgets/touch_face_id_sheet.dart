import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../data/services/biometric_service.dart';
import '../../utils/biometric_ui_kind_assets.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class TouchFaceIdSheet extends StatefulWidget {
  const TouchFaceIdSheet({super.key});

  @override
  State<TouchFaceIdSheet> createState() => _TouchFaceIdSheetState();
}

class _TouchFaceIdSheetState extends State<TouchFaceIdSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(const BiometricLoginRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    final biometricUi = getIt<BiometricService>().biometricUiKind;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          curr.action == AuthAction.biometricLogin &&
          prev.status != curr.status,
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.success:
            Navigator.of(context).pop();
          case AuthStatus.failure:
            final message = state.errorMessage ?? 'Biometric login failed.';
            ToastMessageHelper.show(message);
            final isCancel = message.toLowerCase().contains('cancel');
            if (!isCancel) {
              Navigator.of(context).pop();
            }
          default:
            break;
        }
      },
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 12.w),
          child: CustomContainer(
            paddingAll: 24.w,
            radiusAll: 16.r,
            color: context.colors.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  top: 22.w,
                  text: biometricUi.promptTitle,
                  fontSize: 16.r,
                  fontWeight: FontWeight.w600,
                ),
                CustomText(
                  top: 4.w,
                  text: 'Log in to your Cheering account',
                  color: context.colors.textSecondary,
                ),
                SizedBox(height: 20.w),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (prev, curr) =>
                      prev.isBiometricLoginLoading !=
                      curr.isBiometricLoginLoading,
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: state.isBiometricLoginLoading
                          ? null
                          : () => context.read<AuthBloc>().add(
                              const BiometricLoginRequested(),
                            ),
                      child: CustomContainer(
                        width: 64.r,
                        height: 64.r,
                        color: context.colors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        child: Center(
                          child: biometricUi.icon.svg(
                            width: 54.r,
                            height: 54.r,
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.w),
                CustomButton(
                  backgroundColor: context.colors.background,
                  foregroundColor: context.colors.textPrimary,
                  bordersColor: context.colors.borderPrimary,
                  onPressed: () => Navigator.of(context).pop(),
                  label: 'Cancel',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
