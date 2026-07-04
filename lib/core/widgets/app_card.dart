import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool hasLeftBorderAccent;
  final Color leftBorderColor;
  final List<BoxShadow>? shadow;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.borderRadius,
    this.padding,
    this.hasLeftBorderAccent = false,
    this.leftBorderColor = AppColors.primary,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final cardDecoration = BoxDecoration(
      color: color ?? AppColors.surfaceCard,
      borderRadius: BorderRadius.circular(borderRadius ?? 16),
      boxShadow: shadow ?? [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );

    final cardChild = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: cardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (hasLeftBorderAccent) ...[
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: leftBorderColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(child: child),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          child: cardChild,
        ),
      );
    }

    return cardChild;
  }
}
