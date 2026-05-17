import 'package:dx/E-Commerce/Cubit/brand_directory_cubit.dart';
import 'package:dx/E-Commerce/Cubit/brand_directory_state.dart';
import 'package:dx/E-Commerce/Models/brand_directory_model.dart';
import 'package:dx/E-Commerce/Screens/home_screen.dart';
import 'package:dx/E-Commerce/Services/brand_directory_service.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandsDirectoryPage extends StatelessWidget {
  const BrandsDirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BrandDirectoryCubit(
        service: getIt<BrandDirectoryService>(),
      )..loadBrands(),
      child: const _BrandsDirectoryView(),
    );
  }
}

class _BrandsDirectoryView extends StatefulWidget {
  const _BrandsDirectoryView();

  @override
  State<_BrandsDirectoryView> createState() => _BrandsDirectoryViewState();
}

class _BrandsDirectoryViewState extends State<_BrandsDirectoryView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pixels = _scrollController.position.pixels;
    final max = _scrollController.position.maxScrollExtent;
    if (pixels >= max - 250) {
      context.read<BrandDirectoryCubit>().loadMoreBrands();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F0F2),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 110.h,
            backgroundColor: const Color(0xFF800020),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  EdgeInsetsDirectional.only(start: 20.w, bottom: 14.h),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'brands.title'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    'brands.subtitle'.tr(),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<BrandDirectoryCubit, BrandDirectoryState>(
            builder: (context, state) {
              if (state.status == BrandDirectoryStatus.loading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF800020),
                    ),
                  ),
                );
              }

              if (state.status == BrandDirectoryStatus.failure) {
                return SliverFillRemaining(
                  child: _ErrorState(
                    message: state.errorMessage ?? 'brands.error'.tr(),
                    onRetry: () =>
                        context.read<BrandDirectoryCubit>().loadBrands(),
                  ),
                );
              }

              if (state.status == BrandDirectoryStatus.success &&
                  state.items.isEmpty) {
                return SliverFillRemaining(
                  child: _EmptyState(onBack: () => Navigator.of(context).pop()),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 8.h),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _BrandCard(brand: state.items[index]),
                    childCount: state.items.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20.h,
                    crossAxisSpacing: 10.w,
                    childAspectRatio: 0.78,
                  ),
                ),
              );
            },
          ),
          BlocBuilder<BrandDirectoryCubit, BrandDirectoryState>(
            builder: (context, state) {
              if (state.status == BrandDirectoryStatus.loadingMore) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF800020),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        ],
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  final BrandDirectoryItem brand;
  const _BrandCard({required this.brand});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreen(brandId: brand.id),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: const Color(0xFF800020).withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 38.r,
              backgroundColor: const Color(0xFFEED6DC),
              child: ClipOval(
                child: brand.profileImageUrl != null
                    ? Image.network(
                        brand.profileImageUrl!,
                        width: 76.r,
                        height: 76.r,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const _FallbackAvatar(),
                      )
                    : const _FallbackAvatar(),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            brand.displayName,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D0A12),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FallbackAvatar extends StatelessWidget {
  const _FallbackAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEED6DC),
      child: Icon(
        Icons.storefront_rounded,
        color: const Color(0xFF800020),
        size: 34.sp,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 56.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text('brands.retry'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF800020),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding:
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onBack;
  const _EmptyState({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.storefront_outlined,
              size: 72.sp,
              // ignore: deprecated_member_use
              color: const Color(0xFF800020).withOpacity(0.3),
            ),
            SizedBox(height: 16.h),
            Text(
              'brands.no_brands'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D0A12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
