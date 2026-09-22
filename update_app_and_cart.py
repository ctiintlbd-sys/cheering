import os
import re

# 1. Update app.dart
app_path = "lib/app.dart"
with open(app_path, 'r') as f:
    app_content = f.read()

if 'getIt<CartBloc>()' not in app_content:
    # Add import
    app_content = app_content.replace(
        "import 'package:cheering/features/address/presentation/bloc/address_bloc.dart';",
        "import 'package:cheering/features/address/presentation/bloc/address_bloc.dart';\nimport 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';\nimport 'package:cheering/features/cart/presentation/blocs/cart/cart_event.dart';"
    )
    # Add provider
    app_content = app_content.replace(
        "BlocProvider(create: (_) => getIt<ProfileBloc>()),",
        "BlocProvider(create: (_) => getIt<ProfileBloc>()),\n        BlocProvider(create: (_) => getIt<CartBloc>()..add(const LoadCart())),"
    )
    with open(app_path, 'w') as f:
        f.write(app_content)
    print("Updated app.dart")


# 2. Update cart_routes.dart
cart_routes_path = "lib/core/router/routes/cart_routes.dart"
with open(cart_routes_path, 'r') as f:
    cart_routes_content = f.read()

# Remove BlocProvider wrapper
new_cart_routes_content = re.sub(
    r'builder: \(context, state\) => BlocProvider\([\s\S]*?child: const CartScreen\(\),\n\s*\),',
    'builder: (context, state) => const CartScreen(),',
    cart_routes_content
)
with open(cart_routes_path, 'w') as f:
    f.write(new_cart_routes_content)
print("Updated cart_routes.dart")


# 3. Update MenuItemWidget
menu_item_path = "lib/features/store/presentation/screens/widgets/menu_item_widget.dart"
with open(menu_item_path, 'r') as f:
    menu_item_content = f.read()

if 'CartBloc' not in menu_item_content:
    # Add imports
    menu_item_content = menu_item_content.replace(
        "import 'package:flutter_screenutil/flutter_screenutil.dart';",
        "import 'package:flutter_screenutil/flutter_screenutil.dart';\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';\nimport 'package:cheering/features/cart/presentation/blocs/cart/cart_event.dart';\nimport 'package:cheering/features/cart/presentation/blocs/cart/cart_state.dart';\nimport 'package:cheering/features/cart/domain/entities/add_cart_item_params.dart';"
    )
    
    # Wrap QuantityButton with BlocBuilder
    quantity_button_code = """QuantityButton(
                      count: null,
                      onIncrement: () {},
                      onDecrement: () {},
                    ),"""
                    
    new_quantity_button_code = """BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        final cartItem = state.cart?.items.where((i) => i.menuItemId == menuItem?.id).firstOrNull;
                        
                        return QuantityButton(
                          count: cartItem?.quantity,
                          onIncrement: () {
                            if (menuItem == null) return;
                            
                            // If item has variants/addons, it's better to show a bottom sheet instead of adding directly.
                            // But for simple functionality, we add 1 to the cart directly here:
                            context.read<CartBloc>().add(AddOrUpdateCartItemEvent(
                              AddCartItemParams(
                                menuItemId: menuItem!.id,
                                quantity: (cartItem?.quantity ?? 0) + 1,
                                // Assuming default variants if empty, in real app show BottomSheet
                              )
                            ));
                          },
                          onDecrement: () {
                            if (menuItem == null || cartItem == null) return;
                            context.read<CartBloc>().add(AddOrUpdateCartItemEvent(
                              AddCartItemParams(
                                menuItemId: menuItem!.id,
                                quantity: cartItem.quantity - 1,
                                variantId: cartItem.variantId, // Keep same variant for decrement
                              )
                            ));
                          },
                        );
                      },
                    ),"""
    menu_item_content = menu_item_content.replace(quantity_button_code, new_quantity_button_code)
    
    # We also need to add firstOrNull capability from collection
    menu_item_content = menu_item_content.replace(
        "import 'package:flutter_screenutil/flutter_screenutil.dart';",
        "import 'package:collection/collection.dart';\nimport 'package:flutter_screenutil/flutter_screenutil.dart';"
    )
    
    with open(menu_item_path, 'w') as f:
        f.write(menu_item_content)
    print("Updated menu_item_widget.dart")

