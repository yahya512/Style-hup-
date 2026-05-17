// ignore_for_file: deprecated_member_use

import 'package:dx/E-Commerce/Cubit/cart_cubit.dart';
import 'package:dx/E-Commerce/Cubit/cart_state.dart';
import 'package:dx/E-Commerce/Models/get_cart_model.dart';
import 'package:dx/E-Commerce/Screens/checkout_screen.dart';
import 'package:dx/E-Commerce/Screens/favourite_screen.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatelessWidget {
  final String brandId;
  const CartScreen({super.key, required this.brandId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(
        repository: getIt<UserRepository>(),
        brandId: brandId,
      )..loadCart(),
      child: _CartView(brandId: brandId),
    );
  }
}

class _CartView extends StatelessWidget {
  final String brandId;
  const _CartView({required this.brandId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            pinned: false,
            floating: true,
            snap: true,
            expandedHeight: 50.h,
            backgroundColor: const Color(0xFF800020),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "cart.title".tr(),
                style: AppStyles.mainTitleStyle.copyWith(color: Colors.white),
              ),
              titlePadding:
                  EdgeInsetsDirectional.only(bottom: 10.h, start: 80.w),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FavouriteScreen(brandId: brandId),
                    ),
                  );
                },
                icon: const Icon(Icons.favorite_border),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
            ],
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
          ),

          // Cart items list
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.status == CartStatus.loading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF800020),
                    ),
                  ),
                );
              }

              if (state.status == CartStatus.failure) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48.sp, color: Colors.grey[400]),
                        SizedBox(height: 12.h),
                        Text(
                          state.errorMessage ?? 'Something went wrong.',
                          style: AppStyles.normalTextStyle
                              .copyWith(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF800020),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () =>
                              context.read<CartCubit>().loadCart(),
                          child: Text(
                            'Retry',
                            style: AppStyles.mainTitleStyle.copyWith(
                                color: Colors.white, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state.status == CartStatus.success && state.items.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 72.sp, color: Colors.grey[300]),
                        SizedBox(height: 16.h),
                        Text(
                          'cart.empty'.tr(),
                          style: AppStyles.mainTitleStyle.copyWith(
                            color: Colors.grey[600],
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'cart.empty_subtitle'.tr(),
                          style: AppStyles.normalTextStyle.copyWith(
                            color: Colors.grey[400],
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF800020),
                            padding: EdgeInsets.symmetric(
                                horizontal: 32.w, vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'cart.continue_shopping'.tr(),
                            style: AppStyles.mainTitleStyle.copyWith(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsetsDirectional.all(16.dg),
                sliver: SliverList.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    return _CartItemCard(item: state.items[index]);
                  },
                ),
              );
            },
          ),

          // Total price + checkout button
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.status != CartStatus.success || state.items.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              return SliverPadding(
                padding: EdgeInsetsDirectional.all(16.dg),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    margin:
                        EdgeInsetsDirectional.only(bottom: 20.h, top: 10.h),
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "cart.total".tr(),
                              style: AppStyles.normalTextStyle.copyWith(
                                color: Colors.grey[600],
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              "\$${state.totalPrice.toStringAsFixed(2)}",
                              style: AppStyles.mainTitleStyle.copyWith(
                                fontSize: 20.sp,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF800020),
                            padding: EdgeInsets.symmetric(
                                horizontal: 32.w, vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          onPressed: state.items.isEmpty
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => CheckoutScreen(
                                        brandId: brandId,
                                        cartId: state.items.first.cartId,
                                        totalPrice: state.totalPrice,
                                      ),
                                    ),
                                  );
                                },
                          child: Text(
                            "cart.checkout".tr(),
                            style: AppStyles.mainTitleStyle.copyWith(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final ProductModel item;
  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final name = isArabic ? item.productNameAr : item.productNameEn;

    return Dismissible(
      key: Key(item.cartItemId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsetsDirectional.only(end: 20.w),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 28.sp),
      ),
      onDismissed: (_) => context.read<CartCubit>().removeItem(item),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.dg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product image
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: item.thumbnail.isNotEmpty
                      ? Image.network(
                          item.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey[400],
                            size: 32.sp,
                          ),
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF800020),
                                strokeWidth: 2,
                              ),
                            );
                          },
                        )
                      : Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey[400],
                          size: 32.sp,
                        ),
                ),
              ),
              SizedBox(width: 16.w),
              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            name.isNotEmpty ? name : 'Product',
                            style: AppStyles.mainTitleStyle
                                .copyWith(fontSize: 16.sp),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              context.read<CartCubit>().removeItem(item),
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.red[400],
                            size: 20.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "${"cart.size".tr()} ${item.size}",
                      style: AppStyles.normalTextStyle.copyWith(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "\$${item.totalPrice.toStringAsFixed(2)}",
                      style: AppStyles.mainTitleStyle.copyWith(
                        fontSize: 16.sp,
                        color: const Color(0xFF32DBE6),
                      ),
                    ),
                  ],
                ),
              ),
              // Quantity controls
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.all(8.dg),
                      onPressed: () =>
                          context.read<CartCubit>().incrementQuantity(item),
                      icon: Icon(Icons.add,
                          color: Colors.black87, size: 18.sp),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        "${item.qantity.toInt()}",
                        style: AppStyles.subTitleStyle
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.all(8.dg),
                      onPressed: () =>
                          context.read<CartCubit>().decrementQuantity(item),
                      icon: Icon(Icons.remove,
                          color: Colors.black87, size: 18.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
