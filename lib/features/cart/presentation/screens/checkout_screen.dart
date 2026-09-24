import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/address/domain/entities/address_entity.dart';
import 'package:cheering/features/address/presentation/bloc/address_bloc.dart';
import 'package:cheering/features/address/presentation/bloc/address_form_cubit.dart';
import 'package:cheering/features/address/presentation/bloc/address_state.dart';
import 'package:cheering/features/address/presentation/screens/widgets/add_address_location_card.dart';
import 'package:cheering/features/cart/domain/entities/checkout_summary_params.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/cart/cart_state.dart';
import 'package:cheering/features/cart/presentation/blocs/checkout_summary/checkout_summary_bloc.dart';
import 'package:cheering/features/cart/presentation/blocs/checkout_summary/checkout_summary_event.dart';
import 'package:cheering/features/cart/presentation/blocs/checkout_summary/checkout_summary_state.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/bill_details_card.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/cart_botton_bar_widget.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/delivery_mode_toggle_widget.dart';
import 'package:cheering/features/cart/presentation/screens/widgets/payment_methods_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int deliveryTypeIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSummary();
    });
  }

  void _loadSummary() {
    final addressState = context.read<AddressBloc>().state;
    final addressId = addressState.activeDefaultId;
    if (addressId != null) {
      context.read<CheckoutSummaryBloc>().add(
        LoadCheckoutSummary(
          CheckoutSummaryParams(addressId: addressId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listenWhen: (prev, curr) => prev.activeDefaultId != curr.activeDefaultId,
      listener: (context, state) {
        if (state.activeDefaultId != null) {
          context.read<CheckoutSummaryBloc>().add(
            LoadCheckoutSummary(
              CheckoutSummaryParams(addressId: state.activeDefaultId!),
            ),
          );
        }
      },
      child: BlocBuilder<CheckoutSummaryBloc, CheckoutSummaryState>(
        builder: (context, checkoutState) {
          return SliverScaffold(
            isNavWrap: false,
            backgroundColor: context.colors.bgSecondary,
            appBar: CustomSliverAppBar(
              backgroundColor: context.colors.bgSecondary,
              title: 'Checkout',
            ),
            bottomNavigationBar: checkoutState.summary != null
                ? CartBottomBarWidget(
                    totalPrice: checkoutState.summary!.grandTotal,
                    buttonText: 'Place order',
                    onPressed: () {
                      // Place order action
                    },
                  )
                : const SizedBox.shrink(),
            bodyList: [
              SizedBox(height: 16.w),

              BlocBuilder<AddressBloc, AddressState>(
                builder: (context, state) {
                  final address = state.activeAddress;
                  return AddAddressLocationCard(
                    address: address,
                    onChangeTap: (){
                      context.push(RoutePaths.address);
                    },
                  );
                },
              ),
              SizedBox(height: 24.w),
              CustomText(
                left: 16.w,
                text: 'Payment method',
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 12.w),
              PaymentMethodsCard(
                selectedValue: checkoutState.paymentMethod,
                onChanged: (value) => context.read<CheckoutSummaryBloc>().add(UpdatePaymentMethodEvent(value)),
              ),
              SizedBox(height: 24.w),
              CustomContainer(
                horizontalMargin: 16.w,
                child: DeliveryModeToggleWidget(
                  selectedIndex: deliveryTypeIndex,
                  options: const ['Delivery', 'Tip'],
                  showIcons: false,
                  onChanged: (index) {
                    setState(() => deliveryTypeIndex = index);
                  },
                ),
              ),
              if (deliveryTypeIndex == 0) ...[
                SizedBox(height: 16.w),
                _buildDeliveryOptions(),
              ],
              SizedBox(height: 24.w),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, cartState) {
                    return BillDetailsCard(
                      itemTotal: checkoutState.summary?.itemTotal ?? 0,
                      itemCount: cartState.cart?.itemCount ?? 0,
                      minOrderAmount: cartState.cart?.minOrderAmount ?? 0,
                      deliveryFee: checkoutState.summary?.deliveryFee ?? 0,
                      discount: checkoutState.summary?.discount ?? 0,
                      grandTotal: checkoutState.summary?.grandTotal ?? 0,
                    );
                  },
                ),
              SizedBox(height: 100.w),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDeliveryOptions() {
    return CustomContainer(
      radiusAll: 16.r,
      horizontalMargin: 16.w,
      color: context.colors.background,
      child: Column(
        children: [
          _buildDeliveryOptionRow('Standard', '30-40 min', true),
          _buildDeliveryOptionRow('Priority', '20-30 min', false, extra: '+20'),
        ],
      ),
    );
  }

  Widget _buildDeliveryOptionRow(String title, String time, bool isSelected, {String? extra}) {
    return CustomContainer(
      paddingAll: 16.w,
      border: isSelected
          ? Border(bottom: BorderSide(color: context.colors.borderTertiary))
          : null,
      child: Row(
        children: [
          CustomContainer(
            height: 20.r,
            width: 20.r,
            shape: BoxShape.circle,
            borderWidth: isSelected ? 6.r : 1.r,
            bordersColor: isSelected ? context.colors.primary : context.colors.borderSecondary,
            child: isSelected 
                ? Center(
                    child: CustomContainer(
                      height: 10.r,
                      width: 10.r,
                      shape: BoxShape.circle,
                      color: context.colors.primary,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 12.w),
          CustomText(
            text: title,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(width: 8.w),
          CustomText(
            text: time,
            color: context.colors.textSecondary,
          ),
          if (extra != null) ...[
            const Spacer(),
            CustomContainer(
              paddingHorizontal: 12.w,
              paddingVertical: 4.w,
              radiusAll: 16.r,
              color: context.colors.bgTertiary,
              child: CustomText(
                text: extra,
                color: context.colors.textPrimary,
                fontSize: 12.r,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
