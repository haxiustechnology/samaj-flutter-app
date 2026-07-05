import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/constants/assets.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/widgets/app_gradient_bg.dart';
import '../../../core/utils/snackbar_utils.dart';
import 'package:samaj/generated/l10n.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../app/app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../data/repositories/member_repository.dart';

@RoutePage()
class VerifyOtpPage extends StatefulWidget {
  final String mobile;

  const VerifyOtpPage({
    super.key,
    required this.mobile,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _saveFcmTokenSilently() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await MemberRepository().saveFcmToken(fcmToken);
      }
    } catch (_) {
      // FCM token save should never block or crash the app
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpVerified) {
          _saveFcmTokenSilently();
          if (state.user == null) {
            context.router.push(const RegisterRoute());
          } else {
            context.router.replaceAll([const HomeRoute()]);
          }
        } else if (state is AuthError) {
          SnackbarUtils.show(context, state.message);
        } else if (state is OtpSent) {
          SnackbarUtils.show(context, 'OTP resent successfully');
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: AppGradientBg(
            child: SafeArea(
              child: Column(
                children: [
                  // Custom AppBar (Transparent with back button)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: Colors.white,
                          onPressed: () => context.router.maybePop(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Header Icon
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
                                  S.of(context).verifyOtp,
                                  style: AppTextStyles.heading1White,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Enter the OTP sent to +91 ${widget.mobile}',
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
                                AppTextField(
                                  controller: _otpController,
                                  label: S.of(context).enterOtp,
                                  hint: '123456',
                                  keyboardType: TextInputType.number,
                                  prefixIcon: const Icon(Icons.security_outlined),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return S.of(context).pleaseEnterOtp;
                                    }
                                    if (value.length != 6) {
                                      return 'OTP must be 6 digits';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 24.h),
                                AppButton(
                                  text: S.of(context).verifyOtp,
                                  onPressed: state is AuthLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!.validate()) {
                                            final otp = _otpController.text.trim();
                                            context.read<AuthBloc>().add(
                                                  VerifyOtpEvent(
                                                    mobile: widget.mobile,
                                                    otp: otp,
                                                  ),
                                                );
                                          }
                                        },
                                  isLoading: state is AuthLoading,
                                ),
                                SizedBox(height: 16.h),
                                TextButton(
                                  onPressed: state is AuthLoading
                                      ? null
                                      : () {
                                          context.read<AuthBloc>().add(
                                                ResendOtpEvent(mobile: widget.mobile),
                                              );
                                        },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                  ),
                                  child: Text(
                                    S.of(context).resendOtp,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
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
          ],
        ),
      ),
    ),
  );
      },
    );
  }
}
