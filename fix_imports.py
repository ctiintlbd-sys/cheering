import os

cart_routes_path = "lib/core/router/routes/cart_routes.dart"
with open(cart_routes_path, 'r') as f:
    content = f.read()

content = content.replace("import 'package:flutter_bloc/flutter_bloc.dart';", "")
content = content.replace("import 'package:cheering/core/di/service_locator.dart';", "")
content = content.replace("import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';", "")
content = content.replace("import 'package:cheering/features/cart/presentation/blocs/cart/cart_event.dart';", "")

with open(cart_routes_path, 'w') as f:
    f.write(content)

menu_item_path = "lib/features/store/presentation/screens/widgets/menu_item_widget.dart"
with open(menu_item_path, 'r') as f:
    content = f.read()

content = content.replace("import 'package:collection/collection.dart';", "")

# If firstOrNull is not available natively in this dart version, I'll use a safer fallback:
content = content.replace(
    "final cartItem = state.cart?.items.where((i) => i.menuItemId == menuItem?.id).firstOrNull;",
    "final items = state.cart?.items.where((i) => i.menuItemId == menuItem?.id) ?? [];\n                        final cartItem = items.isNotEmpty ? items.first : null;"
)

with open(menu_item_path, 'w') as f:
    f.write(content)

