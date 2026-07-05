import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../data/repositories/guest_repository.dart';
import '../../../data/models/gallery_model.dart';
import '../bloc/guest_bloc.dart';
import 'package:samaj/generated/l10n.dart';
import 'gallery_detail_page.dart';

@RoutePage()
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: AppBar(
        title: Text(
          S.of(context).gallery,
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
          ..add(GalleryListEvent()),
        child: BlocBuilder<GuestBloc, GuestState>(
          builder: (context, state) {
            if (state is GuestLoading) {
              return _buildShimmer();
            } else if (state is GuestLoaded) {
              final list = state.data.cast<GalleryModel>();
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    'No photos found in gallery',
                    style: AppTextStyles.heading4.copyWith(color: AppColors.textSecondary),
                  ),
                );
              }

              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.0,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final GalleryModel item = list[index];
                  final isVideo = item.mediaType == 'video';
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.borderLight,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GalleryDetailPage(
                                  mediaUrl: item.image,
                                  mediaType: item.mediaType,
                                ),
                              ),
                            );
                          },
                          child: isVideo
                              ? Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.play_circle_fill_rounded,
                                        size: 44.sp,
                                        color: AppColors.primary,
                                      ),
                                      Positioned(
                                        bottom: 12.h,
                                        child: Text(
                                          "VIDEO",
                                          style: AppTextStyles.labelSmall.copyWith(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: item.image,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(color: Colors.white),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      size: 28.sp,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ),
                        ),
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
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.0,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      },
    );
  }
}
