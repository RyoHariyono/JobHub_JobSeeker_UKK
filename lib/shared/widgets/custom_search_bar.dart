import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomSearchBar extends StatelessWidget {
  final String? hintText;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool readOnly;

  const CustomSearchBar({
    super.key,
    this.hintText,
    this.onTap,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding =
        screenWidth < 400
            ? 10.0
            : screenWidth < 600
            ? 16.0
            : 20.0;
    final iconSize =
        screenWidth < 400
            ? 14.0
            : screenWidth < 600
            ? 15.0
            : 17.0;
    final fontSize =
        screenWidth < 400
            ? 12.0
            : screenWidth < 600
            ? 13.0
            : 14.0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.search, color: Color(0xFF6B7280), size: iconSize),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              onTap: readOnly ? onTap : null,
              readOnly: readOnly,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: fontSize,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
