import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:samaj/generated/l10n.dart';
import '../../../data/models/member_model.dart';
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
              color: Colors.white.withValues(alpha: 0.25),
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
                  color: Colors.white.withValues(alpha: 0.85),
                ),
                SizedBox(width: 4.w),
                Text(
                  member.villageName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
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

  Widget _infoTile(String title, String? value, {Widget? trailing}) {
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
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value != null && value.isNotEmpty ? value : '—',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: 8.w),
                  trailing,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _educationCard(Member member) {
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
                S.of(context).education,
                style: AppTextStyles.heading4.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ),
            const Divider(color: AppColors.borderLight, thickness: 1),
            _infoTile(S.of(context).sscSchool, member.sscSchool),
            _infoTile(S.of(context).sscPercentage, member.sscPercentage),
            _infoTile(S.of(context).hscSchool, member.hscSchool),
            _infoTile(S.of(context).hscPercentage, member.hscPercentage),
            _infoTile(S.of(context).bachelorDegree, member.bachelorDegree),
            _infoTile(S.of(context).bachelorPercentage, member.bachelorPercentage),
            _infoTile(S.of(context).masterDegree, member.masterDegree),
            _infoTile(S.of(context).masterPercentage, member.masterPercentage),
            if (member.otherEducation?.isNotEmpty == true)
              _infoTile(S.of(context).otherEducation, member.otherEducation),
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
            S.of(context).profile,
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
              return _buildShimmer();
            }
            if (state is MemberDetailLoaded) {
              final member = state.member;
              
              // Localize gender
              final String g = member.gender?.toString().toLowerCase() ?? '';
              final String genderText = g == 'male' ? S.of(context).male : (g == 'female' ? S.of(context).female : '—');

              // Localize marital status
              final String ms = member.maritalStatus.toString().toLowerCase();
              final String maritalStatusText = ms == 'single' ? S.of(context).single :
                  (ms == 'married' ? S.of(context).married :
                  (ms == 'divorced' ? S.of(context).divorced :
                  (ms == 'widow' || ms == 'widowed' ? S.of(context).widow : '—')));

              // Localize working/job type values
              final String workingStatusText = member.isDoingJob == 1 ? S.of(context).yes : S.of(context).no;
              final String jt = member.jobType?.toString().toLowerCase() ?? '';
              final String jobTypeText = jt == 'private' ? S.of(context).privateJob :
                  (jt == 'government' ? S.of(context).governmentJob : (member.jobType ?? '—'));

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
                                S.of(context).personalDetails,
                                style: AppTextStyles.heading4.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const Divider(color: AppColors.borderLight, thickness: 1),
                            _infoTile(S.of(context).gender, genderText),
                            _infoTile(S.of(context).dateOfBirth, member.birthdate),
                            _infoTile(S.of(context).age, member.age != null ? '${member.age} ${S.of(context).years}' : '—'),
                            _infoTile(S.of(context).maritalStatus, maritalStatusText),
                            
                            // Call Action for optional Mobile field
                            if (member.mobile?.isNotEmpty == true)
                              _infoTile(
                                S.of(context).mobile,
                                member.mobile,
                                trailing: IconButton(
                                  icon: const Icon(Icons.phone_rounded, color: AppColors.primary, size: 20),
                                  onPressed: () async {
                                    final Uri url = Uri.parse('tel:${member.mobile}');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    }
                                  },
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                              
                            _infoTile(S.of(context).workingStatus, workingStatusText),
                            if (member.isDoingJob == 1) ...[
                              _infoTile(S.of(context).jobType, jobTypeText),
                              if (member.jobPost?.isNotEmpty == true)
                                _infoTile(S.of(context).designationPost, member.jobPost),
                              if (member.businessDetails?.isNotEmpty == true)
                                _infoTile(S.of(context).businessJobDetails, member.businessDetails),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    _educationCard(member),
                    _familyCard(member),
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

  Widget _buildShimmer() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header skeleton
            Container(
              height: 220.h,
              color: Colors.white,
            ),
            SizedBox(height: 16.h),
            
            // Details Card skeleton
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: AppCard(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120.w,
                      height: 18.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16.h),
                    for (int i = 0; i < 4; i++) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            Container(
                              width: 80.w,
                              height: 14.h,
                              color: Colors.white,
                            ),
                            const Spacer(),
                            Container(
                              width: 140.w,
                              height: 14.h,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  ],
                ),
              ),
            ),
            
            // Professional Details Card skeleton
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: AppCard(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 160.w,
                      height: 18.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Container(
                          width: 100.w,
                          height: 14.h,
                          color: Colors.white,
                        ),
                        const Spacer(),
                        Container(
                          width: 100.w,
                          height: 14.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _familyCard(Member member) {
    if (member.familyMembers == null || member.familyMembers!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: AppCard(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).familyMembers,
              style: AppTextStyles.subtitle1.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const Divider(color: AppColors.borderLight, thickness: 1),
            SizedBox(height: 12.h),
            SizedBox(
              height: 140.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: member.familyMembers!.length,
                itemBuilder: (context, index) {
                  final relative = member.familyMembers![index];
                  String relText = relative.relationship ?? '';
                  if (relText.isNotEmpty) {
                    final lower = relText.toLowerCase();
                    if (lower == 'father') relText = S.of(context).father;
                    else if (lower == 'mother') relText = S.of(context).mother;
                    else if (lower == 'spouse') relText = S.of(context).spouse;
                    else if (lower == 'son') relText = S.of(context).son;
                    else if (lower == 'daughter') relText = S.of(context).daughter;
                    else if (lower == 'brother') relText = S.of(context).brother;
                    else if (lower == 'sister') relText = S.of(context).sister;
                    else if (lower == 'other') relText = S.of(context).other;
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemberDetailPage(memberId: relative.id),
                        ),
                      );
                    },
                    child: Container(
                      width: 120.w,
                      margin: EdgeInsets.only(right: 12.w),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundCream.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 28.r,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                            backgroundImage: relative.profileImage != null && relative.profileImage!.isNotEmpty
                                ? CachedNetworkImageProvider(relative.profileImage!)
                                : null,
                            child: relative.profileImage == null || relative.profileImage!.isEmpty
                                ? Icon(Icons.person, color: AppColors.primary, size: 28.sp)
                                : null,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            relative.firstName,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (relText.isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                relText,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
