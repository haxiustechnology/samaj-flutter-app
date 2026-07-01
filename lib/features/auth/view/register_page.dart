import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/widgets/app_gradient_bg.dart';
import 'package:samaj/generated/l10n.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../profile/view/terms_conditions_page.dart';
import '../../profile/view/privacy_policy_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../app/app_router.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    if (state is OtpSent) {
      _mobileController.text = state.mobile;
    } else if (state is OtpVerified) {
      _mobileController.text = state.user?.mobile ?? '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      if (!_agreedToTerms) {
        SnackbarUtils.show(context, S.of(context).pleaseAgreeToTermsAndConditions);
        return;
      }

      context.read<AuthBloc>().add(
            CompleteRegistrationEvent(
              firstName: _fullNameController.text.trim(),
              email: _emailController.text.trim(),
              mobile: _mobileController.text.trim(),
            ),
          );
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
                        Text(
                          S.of(context).signUp,
                          style: AppTextStyles.appBarTitle,
                        ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 20.h),
                              Text(
                                S.of(context).finishSigningUp,
                                style: AppTextStyles.heading1White,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 30.h),
                              
                              // Form Container Card
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundWhite,
                                  borderRadius: BorderRadius.circular(24.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
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
                                      controller: _fullNameController,
                                      label: 'Full Name',
                                      hint: 'Kamlesh Prajapati',
                                      prefixIcon: const Icon(Icons.person_outline_rounded),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return S.of(context).pleaseEnterFullName;
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 16.h),
                                    
                                    // Mobile with +91 block
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
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
                                            controller: _mobileController,
                                            hint: '1234567890',
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
                                    
                                    AppTextField(
                                      controller: _emailController,
                                      label: '${S.of(context).email} (optional)',
                                      hint: 'samaj@gmail.com',
                                      prefixIcon: const Icon(Icons.email_outlined),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return null;
                                        }
                                        if (!value.contains('@')) {
                                          return S.of(context).pleaseEnterValidEmail;
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 24.h),
                                    
                                    // Terms & Conditions Checkbox
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 24.w,
                                          width: 24.w,
                                          child: Checkbox(
                                            value: _agreedToTerms,
                                            onChanged: (value) {
                                              setState(() {
                                                _agreedToTerms = value ?? false;
                                              });
                                            },
                                            activeColor: AppColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'I read and agreed to ',
                                              style: AppTextStyles.bodyMediumSecondary.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textSecondary,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'Terms & Conditions',
                                                  style: AppTextStyles.bodyMediumSecondary.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.primary,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => const TermsConditionsPage(),
                                                        ),
                                                      );
                                                    },
                                                ),
                                                TextSpan(
                                                  text: ' and ',
                                                  style: AppTextStyles.bodyMediumSecondary.copyWith(
                                                    color: AppColors.textSecondary,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'Privacy Policy',
                                                  style: AppTextStyles.bodyMediumSecondary.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.primary,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => const PrivacyPolicyPage(),
                                                        ),
                                                      );
                                                    },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 24.h),
                                    
                                    AppButton(
                                      text: S.of(context).signUp,
                                      onPressed: state is AuthLoading ? null : _handleSignUp,
                                      isLoading: state is AuthLoading,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                            ],
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
