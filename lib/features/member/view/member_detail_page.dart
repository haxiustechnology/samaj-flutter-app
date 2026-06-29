import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/repositories/member_repository.dart';
import '../../member/bloc/member_bloc.dart';

class MemberDetailPage extends StatefulWidget {
  final int memberId;
  const MemberDetailPage({Key? key, required this.memberId}) : super(key: key);

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  late MemberBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MemberBloc(repository: MemberRepository());
    _bloc.add(FetchMemberDetail(id: widget.memberId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Widget _buildHeader(dynamic member) {
    final bool isFemale = member.gender?.toLowerCase() == 'female';
    final Color borderAccentColor = isFemale ? AppColors.secondary : AppColors.primary;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
      child: Column(
        children: [
          // Elegant Profile Avatar with dual rings
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.25),
            ),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: member.profileImage != null && member.profileImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: member.profileImage,
                        width: 96.w,
                        height: 96.w,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _avatarPlaceholder(),
                        errorWidget: (_, __, ___) => _avatarPlaceholder(),
                      )
                    : _avatarPlaceholder(),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            '${member.firstName} ${member.middleName ?? ''} ${member.surname}',
            style: AppTextStyles.heading2White,
            textAlign: TextAlign.center,
          ),
          if (member.villageName != null && member.villageName.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 16.sp,
                  color: Colors.white.withOpacity(0.85),
                ),
                SizedBox(width: 4.w),
                Text(
                  member.villageName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      width: 96.w,
      height: 96.w,
      color: AppColors.backgroundCream,
      child: const Icon(
        Icons.person_rounded,
        size: 48,
        color: AppColors.primary,
      ),
    );
  }

  Widget _infoTile(String title, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: AppTextStyles.bodyMediumSecondary.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value != null && value.isNotEmpty ? value : '—',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _educationCard(dynamic member) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: AppCard(
        hasLeftBorderAccent: true,
        leftBorderColor: AppColors.secondary,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text(
                'Educational Details',
                style: AppTextStyles.heading4.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ),
            const Divider(color: AppColors.borderLight, thickness: 1),
            _infoTile('SSC School', member.sscSchool),
            _infoTile('SSC Percentage', member.sscPercentage),
            _infoTile('HSC School', member.hscSchool),
            _infoTile('HSC Percentage', member.hscPercentage),
            _infoTile('Bachelor Degree', member.bachelorDegree),
            _infoTile('Bachelor Percentage', member.bachelorPercentage),
            _infoTile('Master Degree', member.masterDegree),
            _infoTile('Master Percentage', member.masterPercentage),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: AppColors.backgroundCream,
        appBar: AppBar(
          title: Text(
            'Member Profile',
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
            if (state is MemberDetailLoading || state is MemberLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is MemberDetailLoaded) {
              final member = state.member;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(member),
                    SizedBox(height: 16.h),
                    
                    // Basic Details Card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: AppCard(
                        hasLeftBorderAccent: true,
                        leftBorderColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              child: Text(
                                'Personal Profile',
                                style: AppTextStyles.heading4.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const Divider(color: AppColors.borderLight, thickness: 1),
                            _infoTile('Gender', member.gender?.toString().toUpperCase()),
                            _infoTile('Birthdate', member.birthdate),
                            _infoTile('Age', member.age?.toString()),
                            _infoTile('Marital Status', member.maritalStatus),
                            _infoTile('Working Status', member.isDoingJob == 1 ? 'Yes' : 'No'),
                            if (member.isDoingJob == 1) _infoTile('Job Type', member.jobType),
                          ],
                        ),
                      ),
                    ),
                    
                    _educationCard(member),
                    SizedBox(height: 32.h),
                  ],
                ),
              );
            }
            if (state is MemberError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
                    SizedBox(height: 12.h),
                    Text(
                      state.message,
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
                    ),
                  ],
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
