import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/news_model.dart';
import '../../../data/repositories/guest_repository.dart';
import '../bloc/guest_bloc.dart';
import 'package:samaj/generated/l10n.dart';
import 'package:shimmer/shimmer.dart';

@RoutePage()
class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuestBloc(guestRepository: GuestRepository())
        ..add(NewsListEvent()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundCream,
        appBar: AppBar(
          title: Text(
            S.of(context).news,
            style: AppTextStyles.appBarTitle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
            ),
          ),
        ),
        body: BlocBuilder<GuestBloc, GuestState>(
          builder: (context, state) {
            if (state is GuestLoading) {
              return _buildShimmer();
            } else if (state is GuestLoaded) {
              final List<NewsModel> newsList = state.data.cast<NewsModel>();
              if (newsList.isEmpty) {
                return Center(
                  child: Text(
                    'No news articles found',
                    style: AppTextStyles.heading4.copyWith(color: AppColors.textSecondary),
                  ),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final NewsModel news = newsList[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: AppCard(
                      hasLeftBorderAccent: true,
                      leftBorderColor: AppColors.primary,
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Live Image with network support & placeholder
                          if (news.image != null && news.image!.isNotEmpty) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: CachedNetworkImage(
                                imageUrl: news.image!,
                                height: 180.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.primarySurface,
                                  child: const Center(
                                    child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                                  ),
                                ),
                                errorWidget: (context, url, error) => _buildPlaceholderImage(),
                              ),
                            ),
                          ] else ...[
                            _buildPlaceholderImage(),
                          ],
                          SizedBox(height: 14.h),
                          Text(
                            news.title,
                            style: AppTextStyles.heading4.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            news.description,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (news.createdAt != null) ...[
                            SizedBox(height: 14.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 16.sp,
                                  color: AppColors.textMuted,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  news.createdAt!.split('T').first,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is GuestError) {
              return Center(
                child: Text(
                  '${S.of(context).error}: ${state.message}',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 44.sp,
          color: AppColors.primary.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: AppCard(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  width: 220.w,
                  height: 16.h,
                  color: Colors.white,
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  height: 12.h,
                  color: Colors.white,
                ),
                SizedBox(height: 6.h),
                Container(
                  width: 180.w,
                  height: 12.h,
                  color: Colors.white,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Container(
                      width: 14.w,
                      height: 14.w,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      width: 70.w,
                      height: 10.h,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
