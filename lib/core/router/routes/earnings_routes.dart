import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../features/earnings/presentation/screens/cashout_methods_screen.dart';
import '../../../features/earnings/presentation/screens/mobile_wallet_selection_screen.dart';
import '../../../features/earnings/presentation/screens/payout_history_screen.dart';
import '../../../features/earnings/presentation/screens/payout_review_screen.dart';
import '../../../features/earnings/presentation/screens/payout_success_screen.dart';
import '../../../features/earnings/presentation/screens/withdraw_form_screen.dart';
import '../route_args.dart';
import '../route_paths.dart';

List<RouteBase> earningsRoutes(GlobalKey<NavigatorState> rootNavigatorKey) => [
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.payoutHistory,
        builder: (context, state) => const PayoutHistoryScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.cashoutMethods,
        builder: (context, state) => const CashoutMethodsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.mobileWalletSelection,
        builder: (context, state) => MobileWalletSelectionScreen(
          prefillAmount: state.extra as double? ??
              double.tryParse(state.uri.queryParameters['amount'] ?? ''),
        ),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.withdrawForm,
        builder: (context, state) {
          final args = state.extra as WithdrawFormArgs? ??
              WithdrawFormArgs.fromQuery(state.uri.queryParameters);
          return WithdrawFormScreen(
            methodType: args.methodType,
            methodName: args.methodName,
            methodColor: args.methodColor,
            prefillAmount: args.prefillAmount,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.payoutReview,
        builder: (context, state) {
          final args = state.extra as PayoutReviewArgs? ??
              PayoutReviewArgs.fromQuery(state.uri.queryParameters);
          return PayoutReviewScreen(
            amount: args.amount,
            methodType: args.methodType,
            methodName: args.methodName,
            methodColor: args.methodColor,
            accountNumber: args.accountNumber,
            beneficiaryName: args.beneficiaryName,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.payoutSuccess,
        builder: (context, state) {
          final args = state.extra as PayoutSuccessArgs? ??
              PayoutSuccessArgs.fromQuery(state.uri.queryParameters);
          return PayoutSuccessScreen(
            amount: args.amount,
            methodName: args.methodName,
            accountNumber: args.accountNumber,
            transactionId: args.transactionId,
            dateTime: args.dateTime,
          );
        },
      ),
    ];
