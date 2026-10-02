class FaqModel {
  final String question;
  final String answer;

  const FaqModel({
    required this.question,
    required this.answer,
  });
}

final List<FaqModel> faqs = [
  const FaqModel(
    question: 'How do I update my menu?',
    answer: 'You can add or edit items directly in the Menu tab from the bottom navigation.',
  ),
  const FaqModel(
    question: 'How do refunds work?',
    answer: 'You can reach our support team via the “Contact Us” option available in the app.',
  ),
  const FaqModel(
    question: 'When do payouts arrive?',
    answer: 'Payouts are processed instantly to your mobile wallet or within 1–2 business days to your bank.',
  ),
  const FaqModel(
    question: 'How is my rating calculated?',
    answer: 'Your rating is an average of customer reviews submitted over the last 90 days.',
  ),
  const FaqModel(
    question: 'How do I pause my store?',
    answer: 'You can toggle store status from your store settings or dashboard.',
  ),
];
