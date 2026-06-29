import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'dart:math' as math;

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../app/app_router.dart';
import '../../../core/utils/shared_prefs.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotate;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToNext();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900),
    );
    _textController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700),
    );
    _pulseController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoRotate = Tween<double>(begin: -0.3, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic));
    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _logoController.forward().then((_) => _textController.forward());
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;
    final isLogin = await SharedPrefs.getLoginStatus();
    final isGuest = await SharedPrefs.getGuestStatus();
    if (!mounted) return;
    if (isGuest || isLogin) {
      context.router.replaceAll([const HomeRoute()]);
    } else {
      context.router.replaceAll([const LoginRoute()]);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Stack(
          children: [
            // ── Decorative circles ─────────────────────────────────────────
            Positioned(
              top: -80.h, right: -60.w,
              child: Container(
                width: 240.w, height: 240.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -100.h, left: -80.w,
              child: Container(
                width: 300.w, height: 300.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              top: 200.h, left: -40.w,
              child: Container(
                width: 120.w, height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            // ── Main content ──────────────────────────────────────────────
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  AnimatedBuilder(
                    animation: Listenable.merge([_logoController, _pulseController]),
                    builder: (context, _) {
                      return Transform.scale(
                        scale: _logoScale.value * _pulse.value,
                        child: Transform.rotate(
                          angle: _logoRotate.value,
                          child: Container(
                            width: 110.w, height: 110.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 30, offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'ॐ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 46.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 32.h),
                  // App name + tagline
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: Column(
                        children: [
                          Text(
                            'Samaj',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 44.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              'Prajapati Samaj — Ek Parivaar',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 13.sp,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── Loading dots at bottom ─────────────────────────────────────
            Positioned(
              bottom: 60.h, left: 0, right: 0,
              child: FadeTransition(
                opacity: _textOpacity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, __) {
                        final delay = i * 0.3;
                        final value = math.sin((_pulseController.value * math.pi * 2) + delay);
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          width: 8.w,
                          height: 8.w + (value * 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6 + value * 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
