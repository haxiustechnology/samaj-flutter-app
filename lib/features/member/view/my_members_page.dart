import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/repositories/member_repository.dart';
import '../../member/bloc/member_bloc.dart';
import '../../../data/models/member_model.dart';
import 'add_edit_member_page.dart';

class MyMembersPage extends StatelessWidget {
  const MyMembersPage({Key? key}) : super(key: key);

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: ListTile(
                  leading: CircleAvatar(radius: 24.r, backgroundColor: Colors.white),
                  title: Container(height: 12.h, color: Colors.white, margin: EdgeInsets.only(right: 60.w)),
                  subtitle: Container(height: 10.h, color: Colors.white, margin: EdgeInsets.only(top: 6.h, right: 100.w)),
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
      create: (_) => MemberBloc(repository: MemberRepository())..add(FetchMyMembers()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundCream,
        appBar: AppBar(
          title: Text(
            'My Family Members',
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
            if (state is MyMembersLoaded) {
              final list = state.members;
              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 64.sp,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No family members added yet.',
                        style: AppTextStyles.heading4.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final Member m = list[index];
                  final bool isFemale = m.gender?.toLowerCase() == 'female';
                  final Color borderAccentColor = isFemale ? AppColors.secondary : AppColors.primary;
                  
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: AppCard(
                      hasLeftBorderAccent: true,
                      leftBorderColor: borderAccentColor,
                      padding: EdgeInsets.all(12.w),
                      child: Row(
                        children: [
                          // Avatar Frame
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: borderAccentColor.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24.r),
                              child: m.profileImage != null && m.profileImage!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: m.profileImage!,
                                      width: 48.w,
                                      height: 48.w,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => _avatarPlaceholder(borderAccentColor),
                                      errorWidget: (_, __, ___) => _avatarPlaceholder(borderAccentColor),
                                    )
                                  : _avatarPlaceholder(borderAccentColor),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${m.firstName} ${m.surname}',
                                  style: AppTextStyles.subtitle1.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                if (m.villageName != null)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_rounded,
                                        size: 14.sp,
                                        color: AppColors.textMuted,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        m.villageName!,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          
                          // Action Button (Edit)
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
                              onPressed: () async {
                                final updated = await Navigator.push<bool?>(
                                  context,
                                  MaterialPageRoute(builder: (_) => AddEditMemberPage(member: m)),
                                );
                                if (updated == true && context.mounted) {
                                  context.read<MemberBloc>().add(FetchMyMembers());
                                }
                              },
                            ),
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

  Widget _avatarPlaceholder(Color baseColor) {
    return Container(
      width: 48.w,
      height: 48.w,
      color: baseColor.withValues(alpha: 0.1),
      child: Icon(
        Icons.person_rounded,
        size: 24.sp,
        color: baseColor,
      ),
    );
  }
}
