import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/utils/shared_prefs.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../features/auth/bloc/auth_bloc.dart';
import '../../../app/app_router.dart';
import '../../../app/app.dart';
import 'package:samaj/generated/l10n.dart';
import '../../../core/utils/auth_guard.dart';
import '../../../core/widgets/app_card.dart';

import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../member/view/my_members_page.dart';
import '../../member/view/add_edit_member_page.dart';
import 'edit_profile_page.dart';
import 'privacy_policy_page.dart';
import 'terms_conditions_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ValueNotifier<String?> _userNameNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<String> _appVersionNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _buildNumberNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadAppInfo();
  }

  @override
  void dispose() {
    _userNameNotifier.dispose();
    _appVersionNotifier.dispose();
    _buildNumberNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = await SharedPrefs.getUserModel();
    if (user == null) return;
    _userNameNotifier.value = user.name;
  }

  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _appVersionNotifier.value = packageInfo.version;
      _buildNumberNotifier.value = packageInfo.buildNumber;
    } catch (_) {
      _appVersionNotifier.value = '1.0.0';
      _buildNumberNotifier.value = '1';
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          S.of(context).logout,
          style: AppTextStyles.heading3,
        ),
        content: Text(
          S.of(context).areYouSureYouWantToLogout,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              S.of(context).cancel,
              style: AppTextStyles.buttonSmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(const LogoutEvent());
            },
            child: Text(
              S.of(context).logout,
              style: AppTextStyles.buttonSmall.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          'Delete Account',
          style: AppTextStyles.heading3.copyWith(color: AppColors.error),
        ),
        content: const Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone, and your registered member profile will be deactivated.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              S.of(context).cancel,
              style: AppTextStyles.buttonSmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(const DeleteAccountEvent());
            },
            child: Text(
              'Delete',
              style: AppTextStyles.buttonSmall.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          SnackbarUtils.show(context, state.message);
          context.router.replaceAll([const LoginRoute()]);
        } else if (state is AuthError) {
          SnackbarUtils.show(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundCream,
        body: Column(
          children: [
            // Hero Profile Header Card
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.headerGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: EdgeInsets.fromLTRB(24.w, MediaQuery.of(context).padding.top + 20.h, 24.w, 32.h),
              child: Column(
                children: [
                  Text(
                    S.of(context).profile,
                    style: AppTextStyles.appBarTitle.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundColor: AppColors.primarySurface,
                        child: Icon(
                          Icons.person_rounded,
                          size: 54.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ValueListenableBuilder<String?>(
                    valueListenable: _userNameNotifier,
                    builder: (context, userName, _) {
                      return Text(
                        S.of(context).hey(userName ?? 'User'),
                        style: AppTextStyles.heading2White,
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Menu Items List
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: S.of(context).editProfile,
                      onTap: () async {
                        final allowed = await ensureLoggedIn(context);
                        if (!allowed) return;
                        final changed = await Navigator.push<bool?>(
                          context,
                          MaterialPageRoute(builder: (_) => const EditProfilePage()),
                        );
                        if (changed == true) {
                          await _loadUserData();
                        }
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.group_add_outlined,
                      title: S.of(context).addMember,
                      onTap: () async {
                        final allowed = await ensureLoggedIn(context);
                        if (!allowed) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddEditMemberPage()),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.contacts_outlined,
                      title: S.of(context).myMembers,
                      onTap: () async {
                        final allowed = await ensureLoggedIn(context);
                        if (!allowed) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MyMembersPage()),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.translate_rounded,
                      title: S.of(context).changeLanguage,
                      onTap: () {
                        _showLanguageBottomSheet(context);
                      },
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionCard(
                            icon: Icons.share_rounded,
                            title: S.of(context).shareApp,
                            gradient: AppColors.primaryGradient,
                            onTap: () async {
                              await Share.share(
                                'Join our community! Download the official Samaj App to connect with family members, view local news updates, and directories.\nDownload now: https://play.google.com/store/apps/details?id=com.valiyasamaj.app.samaj',
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildActionCard(
                            icon: Icons.star_rate_rounded,
                            title: S.of(context).rateApp,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7B1F3A), Color(0xFFA52B50)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            onTap: () async {
                              final Uri storeUrl = Uri.parse(
                                'https://play.google.com/store/apps/details?id=com.valiyasamaj.app.samaj',
                              );
                              if (await canLaunchUrl(storeUrl)) {
                                await launchUrl(storeUrl, mode: LaunchMode.externalApplication);
                              } else {
                                if (context.mounted) {
                                  SnackbarUtils.show(context, 'Could not open store to rate app');
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _buildMenuItem(
                      icon: Icons.privacy_tip_outlined,
                      title: S.of(context).privacyPolicy,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.gavel_outlined,
                      title: S.of(context).termsConditions,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TermsConditionsPage()),
                        );
                      },
                    ),
                    
                    const Divider(color: AppColors.borderLight, height: 24),
                    
                    // Delete Account tile with dynamic spinner state
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is DeleteAccountLoading;
                        return _buildMenuItem(
                          icon: Icons.delete_forever_rounded,
                          title: 'Delete Account',
                          iconColor: AppColors.error,
                          titleColor: AppColors.error,
                          isLoading: isLoading,
                          onTap: isLoading
                              ? null
                              : () {
                                  _showDeleteAccountConfirmationDialog(context);
                                },
                        );
                      },
                    ),

                    // Logout tile with dynamic spinner state
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is LogoutLoading;
                        return _buildMenuItem(
                          icon: Icons.logout_rounded,
                          title: S.of(context).logout,
                          iconColor: AppColors.error,
                          titleColor: AppColors.error,
                          isLoading: isLoading,
                          onTap: isLoading
                              ? null
                              : () {
                                  _showLogoutConfirmationDialog(context);
                                },
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                    Center(
                      child: Column(
                        children: [
                          ValueListenableBuilder<String>(
                            valueListenable: _appVersionNotifier,
                            builder: (context, version, _) {
                              return ValueListenableBuilder<String>(
                                valueListenable: _buildNumberNotifier,
                                builder: (context, build, _) {
                                  return Text(
                                    S.of(context).versionText(version, build),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            S.of(context).copyrightText,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textMuted.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback? onTap,
    Color iconColor = AppColors.primary,
    Color titleColor = AppColors.textPrimary,
    bool isLoading = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: AppCard(
        onTap: onTap,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                      ),
                    )
                  : Icon(icon, color: iconColor, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.subtitle2.copyWith(
                  color: titleColor,
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
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyles.subtitle2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        final currentLocale = Localizations.localeOf(context);
        return Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  S.of(context).changeLanguage,
                  style: AppTextStyles.heading4.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Divider(),
              _buildLanguageOption(
                context: context,
                locale: const Locale('en'),
                title: S.of(context).english,
                isSelected: currentLocale.languageCode == 'en',
                sheetContext: sheetContext,
              ),
              _buildLanguageOption(
                context: context,
                locale: const Locale('gu'),
                title: S.of(context).gujarati,
                isSelected: currentLocale.languageCode == 'gu',
                sheetContext: sheetContext,
              ),
              _buildLanguageOption(
                context: context,
                locale: const Locale('hi'),
                title: S.of(context).hindi,
                isSelected: currentLocale.languageCode == 'hi',
                sheetContext: sheetContext,
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required Locale locale,
    required String title,
    required bool isSelected,
    required BuildContext sheetContext,
  }) {
    return InkWell(
      onTap: () {
        App.setLocale(context, locale);
        Navigator.pop(sheetContext);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.subtitle1.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
