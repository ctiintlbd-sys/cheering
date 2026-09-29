import 'package:cheering/features/orders/presentation/screens/rate_order_screen.dart';
import 'package:cheering/features/orders/domain/entities/order_entity.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('RateOrderScreen renders all design elements correctly',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/rate-order',
      routes: [
        GoRoute(
          path: '/rate-order',
          builder: (context, state) => RateOrderScreen(
            order: OrderEntity(
              id: '12345',
              orderNumber: 1,
              status: 'DELIVERED',
              restaurantId: 'rest-1',
              restaurantName: 'KFC - Badda',
              itemCount: 1,
              grandTotal: 10,
              paymentMethod: 'COD',
              paymentStatus: 'PAID',
              rider: const TrackingRiderEntity(
                id: 'rider1',
                name: 'Jayed Khan',
                ratingAvg: 4.9,
              ),
              placedAt: DateTime.now().subtract(const Duration(minutes: 24)),
              deliveredAt: DateTime.now(),
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title
    expect(find.text('Rate Your Order'), findsOneWidget);

    // Verify Restaurant Card elements
    expect(find.text('How was KFC - Badda?'), findsOneWidget);
    expect(
      find.text('Your feedback helps other customers and the restaurant'),
      findsOneWidget,
    );
    expect(find.text('What went well?'), findsOneWidget);

    // Verify feedback tags
    expect(find.text('Great taste'), findsOneWidget);
    expect(find.text('Fast delivery'), findsOneWidget);
    expect(find.text('Good packaging'), findsOneWidget);
    expect(find.text('Accurate order'), findsOneWidget);
    expect(find.text('Friendly rider'), findsOneWidget);

    // Verify Rate restaurant label
    expect(find.text('Rate restaurant'), findsOneWidget);

    // Verify Comment label and TextField placeholder
    expect(find.text('Leave a comment (optional)'), findsOneWidget);
    expect(find.text('Placeholder'), findsOneWidget);

    // Verify Rider card elements
    expect(find.text('Rate your rider'), findsOneWidget);
    expect(find.text('Jayed Khan'), findsOneWidget);

    // Verify Submit Review button
    expect(find.text('Submit Review'), findsOneWidget);

    // Test tag toggle
    await tester.tap(find.text('Good packaging'));
    await tester.pumpAndSettle();

    // Test entering text in comment field
    await tester.enterText(find.byType(TextField), 'Great food and service!');
    await tester.pumpAndSettle();
    expect(find.text('Great food and service!'), findsOneWidget);
  });
}
