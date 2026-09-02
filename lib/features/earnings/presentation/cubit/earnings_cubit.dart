import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/earnings_mock_data.dart';
import '../../domain/entities/earnings_entity.dart';

class EarningsState {
  final bool isLoading;
  final String? errorMessage;
  final double totalEarning;
  final double availableBalance;
  final List<TransactionEntity> recentTransactions;
  final List<PayoutHistoryEntity> payoutHistory;

  const EarningsState({
    this.isLoading = false,
    this.errorMessage,
    this.totalEarning = 20886.32,
    this.availableBalance = 20886.32,
    this.recentTransactions = const [],
    this.payoutHistory = const [],
  });

  EarningsState copyWith({
    bool? isLoading,
    String? errorMessage,
    double? totalEarning,
    double? availableBalance,
    List<TransactionEntity>? recentTransactions,
    List<PayoutHistoryEntity>? payoutHistory,
  }) {
    return EarningsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      totalEarning: totalEarning ?? this.totalEarning,
      availableBalance: availableBalance ?? this.availableBalance,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      payoutHistory: payoutHistory ?? this.payoutHistory,
    );
  }
}

class EarningsCubit extends Cubit<EarningsState> {
  EarningsCubit()
      : super(
          const EarningsState(
            totalEarning: 20886.32,
            availableBalance: 20886.32,
            recentTransactions: mockTransactions,
            payoutHistory: mockPayoutHistory,
          ),
        );

  void processPayout({
    required double amount,
    required String method,
    required String accountOrPhone,
    String? beneficiaryName,
  }) {
    final newPayout = PayoutHistoryEntity(
      id: 'po_${DateTime.now().millisecondsSinceEpoch}',
      date: 'Just now',
      amount: amount,
    );

    final updatedBalance =
        (state.availableBalance - amount).clamp(0.0, double.infinity);

    emit(
      state.copyWith(
        availableBalance: updatedBalance,
        payoutHistory: [newPayout, ...state.payoutHistory],
      ),
    );
  }

  void refresh() {
    emit(
      const EarningsState(
        totalEarning: 20886.32,
        availableBalance: 20886.32,
        recentTransactions: mockTransactions,
        payoutHistory: mockPayoutHistory,
      ),
    );
  }
}
