import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

/// Premium dropdown field with custom popup corners, consistent borders,
/// animated shadow glow on focus, and primary arrow icon.
class AppDropdownField<T> extends StatefulWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final bool enabled;

  const AppDropdownField({
    super.key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
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
          child: DropdownButtonFormField<T>(
            value: widget.value,
            items: widget.items,
            onChanged: widget.enabled ? widget.onChanged : null,
            validator: widget.validator,
            focusNode: _focusNode,
            dropdownColor: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(borderRadiusVal),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: widget.enabled ? AppColors.primary : AppColors.textMuted,
              size: 24.sp,
            ),
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
                vertical: 14.h,
              ),
              errorStyle: AppTextStyles.helper.copyWith(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
