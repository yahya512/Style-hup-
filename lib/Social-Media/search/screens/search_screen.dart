import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/Social-Media/search/cubit/search_cubit.dart';
import 'package:dx/Social-Media/search/cubit/search_state.dart';
import 'package:dx/Social-Media/search/services/search_service.dart';
import 'package:dx/Social-Media/search/models/search_result_model.dart';
import 'package:dx/Social-Media/brand/screens/other_brand_profile_screen.dart';
import 'package:dx/Social-Media/search/widgets/search_result_tile.dart';
import 'package:dx/Social-Media/user/screens/other_user_profile_screen.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(service: getIt<SearchService>()),
      child: const SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onTap(BuildContext context, SearchResultModel result) {
    final page = result.type == AccountType.brand
        ? OtherBrandProfilePage(userId: result.id)
        : OtherUserProfilePage(userId: result.id);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Search',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: BlocBuilder<SearchCubit, SearchState>(
              buildWhen: (prev, curr) =>
                  (prev.status == SearchStatus.initial) !=
                  (curr.status == SearchStatus.initial),
              builder: (context, state) => TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search users and brands...',
                  hintStyle:
                      TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.grey[400], size: 22.r),
                  suffixIcon: state.status != SearchStatus.initial
                      ? IconButton(
                          icon: Icon(Icons.clear,
                              color: Colors.grey[400], size: 20.r),
                          onPressed: () {
                            _searchCtrl.clear();
                            context.read<SearchCubit>().clearSearch();
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
                onChanged: (q) => context.read<SearchCubit>().onQueryChanged(q),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) => switch (state.status) {
                SearchStatus.initial => const _EmptyPrompt(),
                SearchStatus.loading => const Center(
                    child: CircularProgressIndicator(color: Color(0xFF32DBE6)),
                  ),
                SearchStatus.failure => Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.r),
                      child: Text(
                        state.errorMessage ?? 'Search failed.',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                SearchStatus.success when state.results.isEmpty =>
                  _NoResults(query: state.query),
                SearchStatus.success => ListView.separated(
                    itemCount: state.results.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey[100]),
                    itemBuilder: (context, index) => SearchResultTile(
                      result: state.results[index],
                      onTap: () => _onTap(context, state.results[index]),
                    ),
                  ),
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
            'Search for users or brands',
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
          Icon(Icons.person_search, size: 56.r, color: Colors.grey[300]),
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
