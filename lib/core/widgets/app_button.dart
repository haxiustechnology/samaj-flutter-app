import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

/// Premium gradient button with shadow, loading state, optional icon,
/// and interactive spring bounce (scale-down) animation on touch feedback.
class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final IconData? icon;
  final bool outlined;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = 14,
    this.icon,
    this.outlined = false,
  });

  /// Secondary outlined variant
  const AppButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.borderRadius = 14,
    this.icon,
  })  : outlined = true,
        gradient = null,
        backgroundColor = null,
        textColor = AppColors.primary;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _scale = 0.96);
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _scale = 1.0);
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _scale = 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = widget.onPressed == null || widget.isLoading;

    Widget buttonBody = widget.outlined ? _buildOutlined(disabled) : _buildGradient(disabled);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: disabled ? null : widget.onPressed,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: buttonBody,
      ),
    );
  }

  Widget _buildGradient(bool disabled) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 56.h,
      decoration: BoxDecoration(
        gradient: disabled
            ? const LinearGradient(colors: [Color(0xFFD4B8A8), Color(0xFFD4B8A8)])
            : (widget.gradient ?? AppColors.primaryGradient),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: disabled
            ? []
            : [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: _buildContent(AppColors.textWhite),
    );
  }

  Widget _buildOutlined(bool disabled) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 56.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: _buildContent(widget.textColor ?? AppColors.primary),
    );
  }

  Widget _buildContent(Color fgColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 20.w,
            height: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(fgColor),
            ),
          ),
        ] else ...[
          if (widget.icon != null) ...[
            Icon(widget.icon, color: fgColor, size: 20.sp),
            SizedBox(width: 8.w),
          ],
          Text(
            widget.text,
            style: AppTextStyles.buttonText.copyWith(color: fgColor),
          ),
        ],
      ],
    );
  }
}
