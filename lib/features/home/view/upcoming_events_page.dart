import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/repositories/guest_repository.dart';
import '../../../data/models/event_model.dart';
import '../bloc/guest_bloc.dart';
import 'package:samaj/generated/l10n.dart';

@RoutePage()
class UpcomingEventsPage extends StatelessWidget {
  const UpcomingEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: AppBar(
        title: Text(
          S.of(context).upcomingEvents,
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
      body: BlocProvider(
        create: (context) => GuestBloc(guestRepository: GuestRepository())
          ..add(UpcomingEventsListEvent()),
        child: BlocBuilder<GuestBloc, GuestState>(
          builder: (context, state) {
            if (state is GuestLoading) {
              return _buildShimmer();
            } else if (state is GuestLoaded) {
              final list = state.data.cast<EventModel>();
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    'No upcoming events found',
                    style: AppTextStyles.heading4.copyWith(color: AppColors.textSecondary),
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final EventModel item = list[index];
                  
                  // Parse date
                  final DateTime date = DateTime.tryParse(item.eventDate) ?? DateTime.now();
                  final String day = DateFormat('dd').format(date);
                  final String month = DateFormat('MMM').format(date).toUpperCase();

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: AppCard(
                      hasLeftBorderAccent: true,
                      leftBorderColor: AppColors.primary,
                      padding: EdgeInsets.zero, // Zero padding to allow full-bleed top image
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event Banner Image (if available)
                          if (item.image != null && item.image!.isNotEmpty) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.r),
                                topRight: Radius.circular(16.r),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: item.image!,
                                height: 160.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(height: 160.h, color: Colors.white),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 160.h,
                                  color: AppColors.primarySurface,
                                  child: Center(
                                    child: Icon(
                                      Icons.image_outlined,
                                      size: 40.sp,
                                      color: AppColors.primary.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          
                          // Event Details (Padded)
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Elegant Saffron Date Badge
                                Container(
                                  width: 68.w,
                                  height: 68.w,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        day,
                                        style: AppTextStyles.heading2White.copyWith(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        month,
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                
                                // Title and Description
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: AppTextStyles.subtitle1.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        item.description,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.textSecondary,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is GuestError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Text(
                    '${S.of(context).error}: ${state.message}',
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mock Image Banner
                Container(
                  height: 160.h,
                  width: double.infinity,
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      // Date Box
                      Container(
                        width: 68.w,
                        height: 68.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Text Skeleton
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 180.w,
                              height: 14.h,
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
                              width: 130.w,
                              height: 12.h,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
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
}
