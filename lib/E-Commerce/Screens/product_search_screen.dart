import 'package:dx/E-Commerce/Cubit/product_search_cubit.dart';
import 'package:dx/E-Commerce/Cubit/product_search_state.dart';
import 'package:dx/E-Commerce/Models/all_products_list_model.dart';
import 'package:dx/E-Commerce/Screens/view_selected_item.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductSearchScreen extends StatelessWidget {
  const ProductSearchScreen({super.key, required this.brandId});

  final String brandId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductSearchCubit(
        repository: getIt<UserRepository>(),
        brandId: brandId,
      ),
      child: _ProductSearchBody(brandId: brandId),
    );
  }
}

class _ProductSearchBody extends StatefulWidget {
  const _ProductSearchBody({required this.brandId});

  final String brandId;

  @override
  State<_ProductSearchBody> createState() => _ProductSearchBodyState();
}

class _ProductSearchBodyState extends State<_ProductSearchBody> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _navigateToProduct(BuildContext context, ProductModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ViewSelectedItem(
          brandid: widget.brandId,
          productid: product.productId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'home.search'.tr(),
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: BlocBuilder<ProductSearchCubit, ProductSearchState>(
              buildWhen: (prev, curr) =>
                  (prev.status == ProductSearchStatus.initial) !=
                  (curr.status == ProductSearchStatus.initial),
              builder: (context, state) => TextField(
                controller: _ctrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'home.search'.tr(),
                  hintStyle:
                      TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.grey[400], size: 22.r),
                  suffixIcon: state.status != ProductSearchStatus.initial
                      ? IconButton(
                          icon: Icon(Icons.clear,
                              color: Colors.grey[400], size: 20.r),
                          onPressed: () {
                            _ctrl.clear();
                            context.read<ProductSearchCubit>().clearSearch();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (q) =>
                    context.read<ProductSearchCubit>().onQueryChanged(q),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductSearchCubit, ProductSearchState>(
              builder: (context, state) {
                return switch (state.status) {
                  ProductSearchStatus.initial => const _EmptyPrompt(),
                  ProductSearchStatus.loading => const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF800020)),
                    ),
                  ProductSearchStatus.failure => Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.r),
                        child: Text(
                          state.errorMessage ?? 'Search failed.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.sp, color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  ProductSearchStatus.success when state.results.isEmpty =>
                    _NoResults(query: state.query),
                  ProductSearchStatus.success => ListView.separated(
                      itemCount: state.results.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: Colors.grey[100]),
                      itemBuilder: (context, index) {
                        final product = state.results[index];
                        final name = isArabic
                            ? product.productNameEn
                            : product.productNameAr;
                        return ListTile(
                          onTap: () => _navigateToProduct(context, product),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              product.thumbnail,
                              width: 52.w,
                              height: 52.h,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 52.w,
                                height: 52.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(Icons.image_not_supported,
                                    color: Colors.grey[400], size: 24.r),
                              ),
                            ),
                          ),
                          title: Text(
                            name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Icon(Icons.chevron_right,
                              color: Colors.grey[400], size: 20.r),
                        );
                      },
                    ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPrompt extends StatelessWidget {
  const _EmptyPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 56.r, color: Colors.grey[300]),
          SizedBox(height: 12.h),
          Text(
            'Search for products',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 56.r, color: Colors.grey[300]),
          SizedBox(height: 12.h),
          Text(
            'No results for "$query"',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
