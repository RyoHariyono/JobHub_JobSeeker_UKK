import 'package:flutter/material.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const MenuCard({
    super.key,
    required this.title,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding =
        screenWidth < 400
            ? 6.0
            : screenWidth < 600
            ? 8.0
            : 10.0;
    final verticalPadding =
        screenWidth < 400
            ? 6.0
            : screenWidth < 600
            ? 8.0
            : 10.0;
    final borderRadius =
        screenWidth < 400
            ? 8.0
            : screenWidth < 600
            ? 10.0
            : 12.0;
    final fontSize =
        screenWidth < 400
            ? 11.0
            : screenWidth < 600
            ? 13.0
            : 14.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
