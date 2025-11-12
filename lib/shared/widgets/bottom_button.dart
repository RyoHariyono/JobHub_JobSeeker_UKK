import 'package:flutter/material.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';

class BottomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final bool isDisabled;
  final EdgeInsets? padding;

  const BottomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.isDisabled = false,
    this.padding,
  }) : super(key: key);

  double _getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 40;
    if (width > 600) return 30;
    return 15;
  }

  double _getButtonFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 18;
    if (width > 600) return 16;
    return 16;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.fromLTRB(35, 20, 35, 40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDisabled
                  ? Color(0xFFF3F4F6)
                  : (backgroundColor ?? AppColors.primaryBlue),
          padding: EdgeInsets.symmetric(vertical: 17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: isDisabled ? null : onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize ?? _getButtonFontSize(context),
            fontWeight: FontWeight.w600,
            color: isDisabled ? Color(0xFF6B7280) : (textColor ?? Colors.white),
          ),
        ),
      ),
    );
  }
}
