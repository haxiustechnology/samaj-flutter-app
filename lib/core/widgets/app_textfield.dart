import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

/// Premium text field with saffron focus border, animated glow shadow on focus,
/// floating label, and icon support.
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final String? initialValue;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool showPasswordToggle;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
    this.enabled = true,
    this.initialValue,
    this.readOnly = false,
    this.onTap,
    this.textInputAction,
    this.focusNode,
    this.showPasswordToggle = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isPasswordVisible = false;
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderRadiusVal = 16.r;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusVal),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 12.r,
                      spreadRadius: 2.r,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText && !_isPasswordVisible,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            maxLines: (widget.obscureText && !_isPasswordVisible) ? 1 : widget.maxLines,
            minLines: widget.minLines,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            initialValue: widget.initialValue,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            textInputAction: widget.textInputAction,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? IconTheme(
                      data: const IconThemeData(color: AppColors.primary, size: 20),
                      child: widget.prefixIcon!,
                    )
                  : null,
              suffixIcon: _buildSuffix(),
              filled: true,
              fillColor: widget.enabled
                  ? (_isFocused ? AppColors.backgroundWhite : AppColors.backgroundCream.withValues(alpha: 0.35))
                  : AppColors.backgroundLight,
              // Default border
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusVal),
                borderSide: const BorderSide(color: AppColors.borderLight, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusVal),
                borderSide: const BorderSide(color: AppColors.borderLight, width: 1.5),
              ),
              // Focus — saffron border with glow
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusVal),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusVal),
                borderSide: const BorderSide(color: AppColors.error, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusVal),
                borderSide: const BorderSide(color: AppColors.error, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusVal),
                borderSide: BorderSide(color: AppColors.borderLight.withValues(alpha: 0.5), width: 1),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 15.h,
              ),
              errorStyle: AppTextStyles.helper.copyWith(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix() {
    if (widget.showPasswordToggle || widget.obscureText) {
      return IconButton(
        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        icon: Icon(
          _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.textMuted,
          size: 20.sp,
        ),
      );
    }
    return widget.suffixIcon;
  }
}
