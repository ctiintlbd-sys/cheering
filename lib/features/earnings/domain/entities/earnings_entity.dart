class TransactionEntity {
  final String id;
  final String orderNumber;
  final String date;
  final double amount;
  final bool isPositive;

  const TransactionEntity({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.amount,
    this.isPositive = true,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'orderNumber': orderNumber,
        'date': date,
        'amount': amount,
        'isPositive': isPositive,
      };

  factory TransactionEntity.fromMap(Map<String, dynamic> map) =>
      TransactionEntity(
        id: map['id']?.toString() ?? '',
        orderNumber: map['orderNumber']?.toString() ?? '',
        date: map['date']?.toString() ?? '',
        amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
        isPositive: map['isPositive'] != false,
      );
}

class PayoutHistoryEntity {
  final String id;
  final String date;
  final double amount;

  const PayoutHistoryEntity({
    required this.id,
    required this.date,
    required this.amount,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'amount': amount,
      };

  factory PayoutHistoryEntity.fromMap(Map<String, dynamic> map) =>
      PayoutHistoryEntity(
        id: map['id']?.toString() ?? '',
        date: map['date']?.toString() ?? '',
        amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      );
}

class EarningsSummaryEntity {
  final double totalEarning;
  final double availableBalance;
  final List<TransactionEntity> recentTransactions;
  final List<PayoutHistoryEntity> payoutHistory;

  const EarningsSummaryEntity({
    required this.totalEarning,
    required this.availableBalance,
    required this.recentTransactions,
    required this.payoutHistory,
  });
}
