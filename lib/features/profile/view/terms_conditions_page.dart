import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
          style: AppTextStyles.appBarTitle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.headerGradient,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            SizedBox(height: 24.h),
            _buildSection(
              title: '1. Acceptance of Terms',
              content: 'By accessing and registering in the Samaj App, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions. If you do not agree, you are prohibited from using the application.',
            ),
            _buildSection(
              title: '2. User Registration & Eligibility',
              content: 'To register as a member, you must belong to our community and provide true, complete, and accurate personal information. Multiple registrations or impersonation of other community members is strictly prohibited and will lead to immediate account termination.',
            ),
            _buildSection(
              title: '3. Member Code of Conduct',
              content: 'You agree to use the Samaj App directory solely for building networking connections. You must not use other members\' contact details for spamming, harassment, advertisement, commercial sales, or promotional campaigns without explicit community admin consent.',
            ),
            _buildSection(
              title: '4. Admin Moderation Powers',
              content: 'The Samaj Admin reserves the right to review, edit, suspend, or permanently delete any member profile, news submission, or advertisement that violates community rules or contains inappropriate, false, or offensive content.',
            ),
            _buildSection(
              title: '5. Advertisements and News',
              content: 'News, events, and advertisements shown in the app are for community informational purposes. The app administrators are not responsible for the accuracy of external commercial advertisements, though we actively verify community news alerts.',
            ),
            _buildSection(
              title: '6. Limitation of Liability',
              content: 'The Samaj App is provided on an "as-is" and "as-available" basis. We make no guarantees that the app will always be secure, error-free, or function without disruptions. In no event shall the administrators be liable for any direct or indirect damages.',
            ),
            _buildSection(
              title: '7. Termination of Access',
              content: 'We reserve the right, without notice and at our sole discretion, to terminate or restrict your access to the Samaj App for any conduct that we determine violates these Terms or is harmful to the community integration.',
            ),
            _buildSection(
              title: '8. Governing Law',
              content: 'These terms are governed by and construed in accordance with the laws of the jurisdiction in which our community administration office is located.',
            ),
            SizedBox(height: 24.h),
            Center(
              child: Text(
                'Last updated: June 2026',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.gavel_rounded,
            size: 48.sp,
            color: AppColors.primary,
          ),
          SizedBox(height: 12.h),
          Text(
            'Terms of Service',
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Please review our terms of service to understand the rules and guidelines of our Samaj community directory.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.subtitle1.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
