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
import 'package:cheering/features/cart/presentation/screens/widgets/tip_widget.dart';
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
        LoadCheckoutSummary(CheckoutSummaryParams(addressId: addressId)),
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
                    color: context.colors.white,
                    address: address,
                    onChangeTap: () {
                      context.push(RoutePaths.address);
                    },
                  ).horizontal(16.w);
                },
              ),
              SizedBox(height: 20.w),
              CustomText(
                left: 16.w,
                text: 'Payment method',
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 12.w),
              PaymentMethodsCard(
                selectedValue: checkoutState.paymentMethod,
                onChanged: (value) => context.read<CheckoutSummaryBloc>().add(
                  UpdatePaymentMethodEvent(value),
                ),
              ),
              SizedBox(height: 20.w),
              CustomContainer(
                radiusAll: 16.r,
                color: context.colors.white,
                horizontalMargin: 16.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:  EdgeInsets.all(12.r),
                      child: DeliveryModeToggleWidget(
                        selectedIndex: deliveryTypeIndex,
                        options: const ['Delivery', 'Tip'],
                        showIcons: false,
                        onChanged: (index) {
                          setState(() => deliveryTypeIndex = index);
                        },
                      ),
                    ),
                    SizedBox(height: 4.w),

                    if (deliveryTypeIndex == 0)
                      CustomContainer(
                        horizontalMargin: 12.w,
                        paddingVertical: 12.w,
                        paddingHorizontal: 16.w,
                        child: Row(
                          children: [
                            CustomContainer(
                              width: 20.r,
                              height: 20.r,
                              shape: BoxShape.circle,
                              color: context.colors.white,
                              borderWidth:  6,
                              bordersColor: context.colors.primary
                            ),
                            SizedBox(width: 12.w),
                            CustomText(
                              text: 'Standard',
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(width: 8.w),
                            CustomText(
                              text: (checkoutState.summary?.estimatedDeliveryMinutes != null && checkoutState.summary!.estimatedDeliveryMinutes > 0)
                                  ? '${checkoutState.summary!.estimatedDeliveryMinutes}-${checkoutState.summary!.estimatedDeliveryMinutes + 5} min'
                                  : '30-40 min',
                              color: context.colors.textSecondary,
                            ),
                          ],
                        ),
                      )
                    else
                      TipWidget(
                        selectedTip: checkoutState.currentParams?.tip ?? 0.0,
                        onTipSelected: (tip) {
                          context.read<CheckoutSummaryBloc>().add(
                            UpdateTipEvent(tip),
                          );
                        },
                      ),

                    SizedBox(height: 12.w),
                  ],
                ),
              ),

              SizedBox(height: 20.w),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  return BillDetailsCard(
                    itemTotal: checkoutState.summary?.itemTotal ?? 0,
                    itemCount: cartState.cart?.itemCount ?? 0,
                    minOrderAmount: cartState.cart?.minOrderAmount ?? 0,
                    deliveryFee: checkoutState.summary?.deliveryFee ?? 0,
                    packagingFee: checkoutState.summary?.packagingFee ?? 0,
                    taxAmount: checkoutState.summary?.taxAmount ?? 0,
                    platformFee: checkoutState.summary?.platformFee ?? 0,
                    discount: checkoutState.summary?.discount ?? 0,
                    tip: checkoutState.summary?.tip ?? 0,
                    grandTotal: checkoutState.summary?.grandTotal ?? 0,
                  );
                },
              ),
              SizedBox(height: 204.w),
            ],
          );
        },
      ),
    );
  }
}
