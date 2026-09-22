import os
import re

# 1. Revert app.dart
app_path = "lib/app.dart"
with open(app_path, 'r') as f:
    app_content = f.read()

app_content = app_content.replace("import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';\n", "")
app_content = app_content.replace("import 'package:cheering/features/cart/presentation/blocs/cart/cart_event.dart';\n", "")
app_content = app_content.replace("        BlocProvider(create: (_) => getIt<CartBloc>()..add(const LoadCart())),\n", "")

with open(app_path, 'w') as f:
    f.write(app_content)
print("Reverted app.dart")

# 2. Revert cart_routes.dart
cart_routes_path = "lib/core/router/routes/cart_routes.dart"
with open(cart_routes_path, 'w') as f:
    f.write('''import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_event.dart';
import 'package:cheering/features/cart/presentation/screens/cart_screen.dart';
import '../route_paths.dart';

final List<RouteBase> cartRoutes = [
  GoRoute(
    path: RoutePaths.cart,
    builder: (context, state) => BlocProvider(
      create: (context) => getIt<CartBloc>()..add(const LoadCart()),
      child: const CartScreen(),
    ),
  ),
];
''')
print("Reverted cart_routes.dart")


# 3. Revert menu_item_widget.dart
menu_item_path = "lib/features/store/presentation/screens/widgets/menu_item_widget.dart"
with open(menu_item_path, 'w') as f:
    f.write('''import 'package:cheering/core/common_widgets/quantity_button.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItemWidget extends StatelessWidget {
  final MenuItemEntity? menuItem;

  const MenuItemWidget({super.key,  this.menuItem,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            width: 66.r,
            height: 66.r,
            borderRadius: 12.r,
            imageUrl: menuItem?.imageUrl ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: menuItem?.name ?? '',
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  bottom: 2.w,
                ),
                if (menuItem?.description != null && menuItem!.description!.isNotEmpty)
                  CustomText(
                    text: menuItem!.description!,
                    color: context.colors.textTertiary,
                    fontSize: 12.r,
                    maxLines: 1,
                  ),
                SizedBox(height: 8.w),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: '৳${menuItem?.basePrice.toStringAsFixed(0) ?? '0'}',
                      color: context.colors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.r,
                    ),

                    QuantityButton(
                      count: null,
                      onIncrement: () {},
                      onDecrement: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
''')
print("Reverted menu_item_widget.dart")

