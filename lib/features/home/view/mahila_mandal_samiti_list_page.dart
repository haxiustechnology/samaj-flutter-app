import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:samaj/data/repositories/guest_repository.dart';
import 'package:samaj/generated/l10n.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/mahila_mandal_samiti_model.dart';
import '../bloc/guest_bloc.dart';

class MahilaMandalSamitiListPage extends StatelessWidget {
  const MahilaMandalSamitiListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: AppBar(
        title: Text(
          S.of(context).mahilaMandalSamitiList,
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
          ..add(MahilaMandalListEvent()),
        child: BlocBuilder<GuestBloc, GuestState>(
          builder: (context, state) {
            if (state is GuestLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (state is GuestLoaded) {
              final list = state.data;
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    'No committee members found',
                    style: AppTextStyles.heading4.copyWith(color: AppColors.textSecondary),
                  ),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final MahilaMandalSamitiModel item = list[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: AppCard(
                      hasLeftBorderAccent: true,
                      leftBorderColor: AppColors.primary,
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySurface,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  item.fullName,
                                  style: AppTextStyles.subtitle1.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (item.mobile != null && item.mobile!.isNotEmpty)
                                const Icon(
                                  Icons.verified_rounded,
                                  color: AppColors.success,
                                  size: 20,
                                ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            item.designation,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 16.sp, color: AppColors.textMuted),
                              SizedBox(width: 4.w),
                              Text(
                                item.village,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const Spacer(),
                              if (item.mobile != null && item.mobile!.isNotEmpty)
                                Row(
                                  children: [
                                    Icon(Icons.phone_outlined, size: 16.sp, color: AppColors.textMuted),
                                    SizedBox(width: 4.w),
                                    Text(
                                      item.mobile!,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
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
}
