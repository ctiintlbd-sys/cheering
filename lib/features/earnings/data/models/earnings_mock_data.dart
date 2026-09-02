import '../../domain/entities/earnings_entity.dart';

const mockTransactions = [
  TransactionEntity(
    id: 'tx_1',
    orderNumber: '#12454',
    date: '12 Jun , 8:25 Pm',
    amount: 500.0,
  ),
  TransactionEntity(
    id: 'tx_2',
    orderNumber: '#12454',
    date: '13 Jun , 10:15 Am',
    amount: 200.0,
  ),
  TransactionEntity(
    id: 'tx_3',
    orderNumber: '#12455',
    date: '13 Jun , 11:30 Am',
    amount: 150.0,
  ),
  TransactionEntity(
    id: 'tx_4',
    orderNumber: '#12456',
    date: '13 Jun , 12:45 Pm',
    amount: 350.0,
  ),
  TransactionEntity(
    id: 'tx_5',
    orderNumber: '#12457',
    date: '13 Jun , 02:00 Pm',
    amount: 75.0,
  ),
];

const mockPayoutHistory = [
  PayoutHistoryEntity(
    id: 'po_1',
    date: '12 Jun , 10:50 Pm',
    amount: 20000.0,
  ),
  PayoutHistoryEntity(
    id: 'po_2',
    date: '12 Jun , 10:50 Pm',
    amount: 20000.0,
  ),
  PayoutHistoryEntity(
    id: 'po_3',
    date: '14 Jun , 02:30 Pm',
    amount: 22750.0,
  ),
  PayoutHistoryEntity(
    id: 'po_4',
    date: '13 Jun , 09:15 Am',
    amount: 15500.0,
  ),
  PayoutHistoryEntity(
    id: 'po_5',
    date: '15 Jun , 11:45 Am',
    amount: 18200.0,
  ),
];

const mockEarningsSummary = EarningsSummaryEntity(
  totalEarning: 20886.32,
  availableBalance: 20886.32,
  recentTransactions: mockTransactions,
  payoutHistory: mockPayoutHistory,
);
