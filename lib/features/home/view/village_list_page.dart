import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../member/bloc/member_bloc.dart';
import '../../../data/models/village_model.dart';
import '../../../data/repositories/member_repository.dart';

class VillageListPage extends StatelessWidget {
  const VillageListPage({Key? key}) : super(key: key);

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Shimmer.fromColors(
            baseColor: AppColors.backgroundCream,
            highlightColor: AppColors.backgroundWhite,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: ListTile(
                  leading: CircleAvatar(radius: 20.r, backgroundColor: Colors.white),
                  title: Container(height: 12.h, color: Colors.white, margin: EdgeInsets.only(right: 80.w)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MemberBloc(repository: MemberRepository())..add(FetchVillages()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundCream,
        appBar: AppBar(
          title: Text(
            'Villages List',
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
        body: BlocBuilder<MemberBloc, MemberState>(
          builder: (context, state) {
            if (state is MemberLoading) return _buildShimmer();
            if (state is VillagesLoaded) {
              final List<Village> list = state.villages;
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    'No villages found',
                    style: AppTextStyles.heading4.copyWith(color: AppColors.textSecondary),
                  ),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final Village v = list[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: AppCard(
                      hasLeftBorderAccent: true,
                      leftBorderColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Text(
                              v.villageName,
                              style: AppTextStyles.subtitle1.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textMuted,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            if (state is MemberError) {
              return Center(
                child: Text(
                  state.message,
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