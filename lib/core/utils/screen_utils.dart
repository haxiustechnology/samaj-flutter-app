import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenUtils {
  static void init(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
    );
  }
  
  // Width helpers
  static double width(double width) => width.w;
  static double screenWidth() => 1.sw;
  
  // Height helpers
  static double height(double height) => height.h;
  static double screenHeight() => 1.sh;
  
  // Font size helpers
  static double fontSize(double size) => size.sp;
  
  // Radius helpers
  static double radius(double radius) => radius.r;
}

