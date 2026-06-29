import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
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
              title: '1. Information We Collect',
              content: 'We collect personal information that you voluntarily provide to us when registering in the Samaj App. This includes your first name, middle name, surname, birthdate, age, gender, marital status, job details, and profile images. All information you provide must be true, complete, and accurate.',
            ),
            _buildSection(
              title: '2. How We Use Your Information',
              content: 'We use the collected information to establish a directory of our community members, facilitate member-to-member communication, display local advertisements, send community news and announcements, and manage member profiles. Your data is used exclusively for community administration and connecting family networks.',
            ),
            _buildSection(
              title: '3. Data Sharing & Disclosure',
              content: 'We do not sell, rent, or trade your personal information with third-party advertisers or commercial entities. Your member profile details are only visible to other verified members within the Samaj App directory to foster safe community integration.',
            ),
            _buildSection(
              title: '4. Push Notifications & Local Services',
              content: 'With your consent, we send push notifications via Firebase Cloud Messaging (FCM) to update you about community events, urgent news alerts, and general announcements. You can manage or opt-out of these notifications at any time through your device settings.',
            ),
            _buildSection(
              title: '5. Security of Your Information',
              content: 'We implement administrative, technical, and physical security measures to protect your personal details. However, please remember that no electronic transmission over the internet can be guaranteed 100% secure, so use the services at your own discretion.',
            ),
            _buildSection(
              title: '6. Updates to This Policy',
              content: 'We may update this Privacy Policy from time to time. The updated version will be indicated by an updated date and will be effective as soon as it is accessible. We encourage you to review this policy periodically.',
            ),
            _buildSection(
              title: '7. Contact Us',
              content: 'If you have questions or comments about this policy, or request changes to your registered information, please contact the Samaj Admin team directly via the Admin Portal contact channels.',
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
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.security_rounded,
            size: 48.sp,
            color: AppColors.primary,
          ),
          SizedBox(height: 12.h),
          Text(
            'Your Privacy Matters',
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Please read our Privacy Policy carefully to understand how we secure your community data.',
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
