import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/assets.dart';
import '../../../app/app_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/utils/shared_prefs.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/widgets/app_gradient_bg.dart';
import '../../../generated/l10n.dart';
import '../../profile/view/privacy_policy_page.dart';
import '../../profile/view/terms_conditions_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final mobile = _phoneController.text.trim();
      context.read<AuthBloc>().add(LoginEvent(mobile: mobile));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSent) {
          context.router.push(VerifyOtpRoute(mobile: state.mobile));
        } else if (state is AuthError) {
          SnackbarUtils.show(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: AppGradientBg(
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // App Branding/Header Area
                          SizedBox(height: 20.h),
                          Center(
                            child: Hero(
                              tag: 'app_logo',
                              child: Container(
                                height: 100.w,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.r),
                                  child: Image.asset(
                                    Assets.images.logo.path,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            S.of(context).welcomeToApp,
                            style: AppTextStyles.heading1White.copyWith(
                              fontSize: 22.sp,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            S.of(context).loginNow,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 40.h),
                          
                          // Form Card Container
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.backgroundWhite,
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(24.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Country Code Display (Styled)
                                    Container(
                                      height: 54.h,
                                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundCream,
                                        border: Border.all(
                                          color: AppColors.borderLight,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(14.r),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "+91",
                                          style: AppTextStyles.bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: AppTextField(
                                        controller: _phoneController,
                                        hint: S.of(context).pleaseEnterPhoneNumber,
                                        keyboardType: TextInputType.phone,
                                        prefixIcon: const Icon(Icons.phone_iphone_outlined),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return S.of(context).pleaseEnterPhoneNumber;
                                          }
                                          if (value.length < 10) {
                                            return S.of(context).pleaseEnterValidPhoneNumber;
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  S.of(context).weWillTextYouToConfirmYourNumber,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 24.h),
                                AppButton(
                                  text: S.of(context).continueAction,
                                  onPressed: state is AuthLoading ? null : _handleLogin,
                                  isLoading: state is AuthLoading,
                                ),
                                SizedBox(height: 24.h),
                                Row(
                                  children: [
                                    const Expanded(child: Divider(color: AppColors.borderLight)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                                      child: Text(
                                        S.of(context).or,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ),
                                    const Expanded(child: Divider(color: AppColors.borderLight)),
                                  ],
                                ),
                                SizedBox(height: 24.h),
                                
                                // Sign Up Action
                                AppButton.outlined(
                                  text: S.of(context).signUp,
                                  onPressed: () {
                                    context.router.push(const RegisterRoute());
                                  },
                                ),
                                SizedBox(height: 16.h),
                                
                                // Guest Mode Action (Styled)
                                TextButton(
                                  onPressed: () async {
                                    await SharedPrefs.setGuestStatus(true);
                                    await SharedPrefs.setLoginStatus(false);
                                    if (!mounted) return;
                                    context.router.replaceAll([const HomeRoute()]);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Guest Mode',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const PrivacyPolicyPage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Privacy Policy',
                                        style: AppTextStyles.caption.copyWith(
                                          color: Colors.white70,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '  •  ',
                                      style: AppTextStyles.caption.copyWith(
                                        color: Colors.white30,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const TermsConditionsPage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Terms & Conditions',
                                        style: AppTextStyles.caption.copyWith(
                                          color: Colors.white70,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
