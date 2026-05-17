import 'package:dx/E-Commerce/Cubit/checkout_cubit.dart';
import 'package:dx/E-Commerce/Cubit/checkout_state.dart';
import 'package:dx/E-Commerce/Screens/add_card_screen.dart';
import 'package:dx/E-Commerce/Screens/edit_card_info.dart';
import 'package:dx/E-Commerce/Screens/track_order_screen.dart';
import 'package:dx/Widgets/card_payment_ui.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/core/validators/text_validator.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutScreen extends StatelessWidget {
  final bool? data;
  final String brandId;
  final String cartId;
  final num totalPrice;
  final String? cardHolder;
  final String? cardNumber;
  final String? cardExpiry;

  const CheckoutScreen({
    super.key,
    this.data,
    required this.brandId,
    required this.cartId,
    this.totalPrice = 0,
    this.cardHolder,
    this.cardNumber,
    this.cardExpiry,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckoutCubit(
        repository: getIt<UserRepository>(),
        brandId: brandId,
      ),
      child: _CheckoutView(
        data: data,
        brandId: brandId,
        cartId: cartId,
        totalPrice: totalPrice,
        cardHolder: cardHolder,
        cardNumber: cardNumber,
        cardExpiry: cardExpiry,
      ),
    );
  }
}

class _CheckoutView extends StatefulWidget {
  final bool? data;
  final String brandId;
  final String cartId;
  final num totalPrice;
  final String? cardHolder;
  final String? cardNumber;
  final String? cardExpiry;

  const _CheckoutView({
    this.data,
    required this.brandId,
    required this.cartId,
    required this.totalPrice,
    this.cardHolder,
    this.cardNumber,
    this.cardExpiry,
  });

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  final GlobalKey<FormState> _shippingFormKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final TextEditingController _streetEn = TextEditingController();
  final TextEditingController _streetAr = TextEditingController();
  final TextEditingController _cityEn = TextEditingController();
  final TextEditingController _cityAr = TextEditingController();
  final TextEditingController _buildingNumber = TextEditingController();

  late bool _hasCard;
  late String _cardHolder;
  late String _cardNumber;
  late String _cardExpiry;
  String? shippingOption;

  bool get _isThereAcard => _hasCard;

  bool get _shippingFilled =>
      _streetEn.text.isNotEmpty &&
      _streetAr.text.isNotEmpty &&
      _cityEn.text.isNotEmpty &&
      _cityAr.text.isNotEmpty &&
      _buildingNumber.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _hasCard = widget.data ?? false;
    _cardHolder = widget.cardHolder ?? '';
    _cardNumber = widget.cardNumber ?? '';
    _cardExpiry = widget.cardExpiry ?? '';
  }

  @override
  void dispose() {
    _streetEn.dispose();
    _streetAr.dispose();
    _cityEn.dispose();
    _cityAr.dispose();
    _buildingNumber.dispose();
    super.dispose();
  }

  void _showShippingSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text("checkout.shipping_address".tr(),
                    style: AppStyles.subTitleStyle),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: Color(0xFF800020), size: 18),
                    SizedBox(width: 4.w),
                    Text("checkout.egypt".tr(),
                        style: AppStyles.labelTextStyle),
                  ],
                ),
                SizedBox(height: 20.h),
                Form(
                  key: _shippingFormKey,
                  child: Column(
                    children: [
                      _buildField(_streetEn, "checkout.street_en",
                          TextInputType.text, Icons.signpost_outlined),
                      SizedBox(height: 14.h),
                      _buildField(_streetAr, "checkout.street_ar",
                          TextInputType.text, Icons.signpost_outlined),
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(_cityEn, "checkout.city_en",
                                TextInputType.text, Icons.location_city_outlined),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildField(_cityAr, "checkout.city_ar",
                                TextInputType.text, Icons.location_city_outlined),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      _buildField(
                          _buildingNumber,
                          "checkout.building_number",
                          TextInputType.number,
                          Icons.apartment_outlined),
                      SizedBox(height: 24.h),
                      ElevatedButton(
                        style: AppStyles.commerceButton,
                        onPressed: () {
                          if (_shippingFormKey.currentState!.validate()) {
                            setState(() {});
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text("checkout.save_changes".tr(),
                            style: AppStyles.whiteTextButtonStyle),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String labelKey,
    TextInputType keyboardType,
    IconData icon,
  ) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelKey.tr(),
        labelStyle: AppStyles.labelTextStyle,
        prefixIcon: Icon(icon, color: const Color(0xFF800020), size: 20),
        enabledBorder: AppStyles.outlineInputBorderstyle,
        focusedBorder: AppStyles.foucasedoutlineInputBorder,
        focusedErrorBorder: AppStyles.errorBorder,
        errorBorder: AppStyles.errorBorder,
      ),
      validator: (value) => TextValidation.textValidation(value!),
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state.status == CheckoutStatus.success) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => TrackOrderScreen(brandId: widget.brandId),
            ),
          );
        } else if (state.status == CheckoutStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF800020),
              content: Text(
                state.errorMessage?.tr() ?? 'checkout.order_failed'.tr(),
                style: AppStyles.normalTextStyle.copyWith(color: Colors.white),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF800020),
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          title: Text(
            "checkout.title".tr(),
            style: AppStyles.mainTitleStyle.copyWith(
              color: Colors.white,
              fontSize: 22.sp,
            ),
          ),
        ),
        body: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            final isLoading = state.status == CheckoutStatus.loading;
            return Stack(
              children: [
                ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 120.h),
                  children: [
                    // ── Shipping Address ──────────────────────────────
                    _sectionCard(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.dg),
                            decoration: BoxDecoration(
                              color: const Color(0xFF800020).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: const Icon(Icons.location_on_outlined,
                                color: Color(0xFF800020)),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("checkout.shipping_address".tr(),
                                    style: AppStyles.subTitleStyle
                                        .copyWith(fontSize: 16.sp)),
                                SizedBox(height: 2.h),
                                Text(
                                  _shippingFilled
                                      ? "${_streetEn.text}, ${_cityEn.text}"
                                      : "checkout.tap_to_add".tr(),
                                  style: AppStyles.labelTextStyle
                                      .copyWith(fontSize: 13.sp),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _showShippingSheet,
                            icon: Icon(
                              _shippingFilled
                                  ? Icons.check_circle_outline
                                  : Icons.edit_outlined,
                              color: _shippingFilled
                                  ? Colors.green
                                  : const Color(0xFF800020),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 14.h),

                    // ── Shipping Options ──────────────────────────────
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.dg),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF800020).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: const Icon(Icons.local_shipping_outlined,
                                    color: Color(0xFF800020)),
                              ),
                              SizedBox(width: 12.w),
                              Text("checkout.shipping_options".tr(),
                                  style: AppStyles.subTitleStyle
                                      .copyWith(fontSize: 16.sp)),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          _ShippingOptionTile(
                            value: "Standard",
                            groupValue: shippingOption,
                            title: "checkout.standard".tr(),
                            subtitle: "checkout.standard_subtitle".tr(),
                            trailing: "checkout.free".tr(),
                            onTap: () =>
                                setState(() => shippingOption = "Standard"),
                          ),
                          Divider(height: 1, color: Colors.grey[200]),
                          _ShippingOptionTile(
                            value: "Express",
                            groupValue: shippingOption,
                            title: "checkout.express".tr(),
                            subtitle: "checkout.express_subtitle".tr(),
                            trailing: "\$12.00",
                            onTap: () =>
                                setState(() => shippingOption = "Express"),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 14.h),

                    // ── Payment Method ────────────────────────────────
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.dg),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF800020).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: const Icon(Icons.credit_card_outlined,
                                    color: Color(0xFF800020)),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text("checkout.payment_method".tr(),
                                    style: AppStyles.subTitleStyle
                                        .copyWith(fontSize: 16.sp)),
                              ),
                              TextButton.icon(
                                onPressed: () async {
                                  final result = await Navigator.of(context).push<Map<String, String>>(
                                    MaterialPageRoute(
                                      builder: (_) => EditCardInfoScreen(
                                          brandId: widget.brandId,
                                          cartId: widget.cartId),
                                    ),
                                  );
                                  if (result != null && mounted) {
                                    setState(() {
                                      _hasCard = true;
                                      _cardHolder = result['holder'] ?? '';
                                      _cardNumber = result['number'] ?? '';
                                      _cardExpiry = result['expiry'] ?? '';
                                    });
                                  }
                                },
                                icon: const Icon(Icons.edit_outlined,
                                    size: 16, color: Color(0xFF800020)),
                                label: Text(
                                  "checkout.edit".tr(),
                                  style: TextStyle(
                                      color: const Color(0xFF800020),
                                      fontSize: 13.sp),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.h),
                                    side: const BorderSide(
                                        color: Color(0xFF800020)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  icon: const Icon(Icons.credit_card,
                                      color: Color(0xFF800020)),
                                  label: Text(
                                    "checkout.card".tr(),
                                    style: TextStyle(
                                      color: const Color(0xFF800020),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_isThereAcard) {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(24.r)),
                                        ),
                                        builder: (_) => Padding(
                                          padding: EdgeInsets.all(20.dg),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Center(
                                                child: Container(
                                                  width: 40.w,
                                                  height: 4.h,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.r),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 16.h),
                                              buildCard(
                                                holder: _cardHolder,
                                                number: _cardNumber,
                                                expiry: _cardExpiry,
                                              ),
                                              SizedBox(height: 16.h),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      final result = await Navigator.of(context).push<Map<String, String>>(
                                        MaterialPageRoute(
                                          builder: (_) => AddCardScreen(
                                              brandId: widget.brandId,
                                              cartId: widget.cartId),
                                        ),
                                      );
                                      if (result != null && mounted) {
                                        setState(() {
                                          _hasCard = true;
                                          _cardHolder = result['holder'] ?? '';
                                          _cardNumber = result['number'] ?? '';
                                          _cardExpiry = result['expiry'] ?? '';
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 12.w),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.all(12.dg),
                                  side: const BorderSide(
                                      color: Color(0xFF800020)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                onPressed: () async {
                                  final result = await Navigator.of(context).push<Map<String, String>>(
                                    MaterialPageRoute(
                                      builder: (_) => AddCardScreen(
                                          brandId: widget.brandId,
                                          cartId: widget.cartId),
                                    ),
                                  );
                                  if (result != null && mounted) {
                                    setState(() {
                                      _hasCard = true;
                                      _cardHolder = result['holder'] ?? '';
                                      _cardNumber = result['number'] ?? '';
                                      _cardExpiry = result['expiry'] ?? '';
                                    });
                                  }
                                },
                                child: const Icon(Icons.add,
                                    color: Color(0xFF800020)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // ── Fixed bottom PAY bar ──────────────────────────
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24.r)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "checkout.total".tr(),
                                style: AppStyles.labelTextStyle
                                    .copyWith(fontSize: 12.sp),
                              ),
                              Text(
                                "\$${widget.totalPrice.toStringAsFixed(2)}",
                                style: AppStyles.subTitleStyle.copyWith(
                                  fontSize: 20.sp,
                                  color: const Color(0xFF800020),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(0, 54.h),
                                backgroundColor: _shippingFilled && !isLoading
                                    ? const Color(0xFF800020)
                                    : Colors.grey[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                elevation: 0,
                              ),
                              onPressed: isLoading || !_shippingFilled
                                  ? null
                                  : () {
                                      context.read<CheckoutCubit>().placeOrder(
                                            cartId: widget.cartId,
                                            streetEn: _streetEn.text,
                                            streetAr: _streetAr.text,
                                            cityEn: _cityEn.text,
                                            cityAr: _cityAr.text,
                                            buildingNumber:
                                                _buildingNumber.text,
                                          );
                                    },
                              child: isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5),
                                    )
                                  : Text(
                                      "checkout.pay".tr(),
                                      style: AppStyles.whiteTextButtonStyle
                                          .copyWith(fontSize: 18.sp),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ShippingOptionTile extends StatelessWidget {
  final String value;
  final String? groupValue;
  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback onTap;

  const _ShippingOptionTile({
    required this.value,
    required this.groupValue,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = groupValue == value;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            RadioGroup(
              groupValue: groupValue,
              onChanged: (_) => onTap(),
              child: Radio<String>(
                value: value,
                activeColor: const Color(0xFF800020),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppStyles.normalTextStyle.copyWith(
                          fontSize: 14.sp,
                          color: selected ? const Color(0xFF800020) : Colors.black)),
                  Text(subtitle,
                      style: AppStyles.labelTextStyle
                          .copyWith(fontSize: 12.sp)),
                ],
              ),
            ),
            Text(trailing,
                style: AppStyles.normalTextStyle.copyWith(
                    fontSize: 14.sp,
                    color: selected
                        ? const Color(0xFF800020)
                        : Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}
