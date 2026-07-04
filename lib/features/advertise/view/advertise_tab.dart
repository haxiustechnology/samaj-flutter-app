import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/advertise_model.dart';
import '../../../data/repositories/guest_repository.dart';
import '../../home/bloc/guest_bloc.dart';
import 'package:samaj/generated/l10n.dart';

class AdvertiseTab extends StatelessWidget {
  const AdvertiseTab({super.key});

  void _showContactDialog(BuildContext context, AdvertiseModel ad) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          ad.companyName ?? 'Sponsor Contact',
          style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Listing: ${ad.title}',
              style: AppTextStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                const Icon(Icons.phone_rounded, color: AppColors.secondary),
                SizedBox(width: 8.w),
                Text(
                  ad.contactMobile ?? 'N/A',
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonSmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
          if (ad.contactMobile != null)
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await Clipboard.setData(ClipboardData(text: ad.contactMobile!));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Copied contact number: ${ad.contactMobile}'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.primary,
                    ),
                  );
                }
              },
              child: Text(
                'Copy Number',
                style: AppTextStyles.buttonSmall.copyWith(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuestBloc(guestRepository: GuestRepository())
        ..add(AdvertiseListEvent()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundCream,
        appBar: AppBar(
          title: Text(
            S.of(context).advertise,
            style: AppTextStyles.appBarTitle,
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
            ),
          ),
        ),
        body: BlocBuilder<GuestBloc, GuestState>(
          builder: (context, state) {
            if (state is GuestLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (state is GuestLoaded) {
              final List<AdvertiseModel> ads = state.data.cast<AdvertiseModel>();
              if (ads.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.campaign_rounded,
                            size: 80.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Text(
                          'No Advertisements',
                          style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Advertise your business here to reach thousands of community members.',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: ads.length,
                itemBuilder: (context, index) {
                  final ad = ads[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: AppCard(
                      hasLeftBorderAccent: true,
                      leftBorderColor: AppColors.accent,
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: AppColors.accentSurface,
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(color: AppColors.accentLight, width: 1),
                                ),
                                child: Text(
                                  'SPONSOR',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ),
                              if (ad.companyName != null) ...[
                                SizedBox(width: 8.w),
                                Text(
                                  ad.companyName!,
                                  style: AppTextStyles.subtitle2.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 12.h),
                          if (ad.image != null && ad.image!.isNotEmpty) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: CachedNetworkImage(
                                imageUrl: ad.image!,
                                height: 160.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.primarySurface,
                                  child: const Center(
                                    child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                                  ),
                                ),
                                errorWidget: (context, url, error) => _buildPlaceholderAdIcon(),
                              ),
                            ),
                            SizedBox(height: 12.h),
                          ],
                          Text(
                            ad.title,
                            style: AppTextStyles.heading4.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            ad.description,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          AppButton(
                            text: 'Contact Business',
                            icon: Icons.phone_rounded,
                            height: 44.h,
                            onPressed: () => _showContactDialog(context, ad),
                          ),
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

  Widget _buildPlaceholderAdIcon() {
    return Container(
      height: 160.h,
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
          Icons.campaign_rounded,
          size: 44.sp,
          color: AppColors.primary.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
