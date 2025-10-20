import 'package:flutter/material.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/data/models/job.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JobCard2 extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;
  final bool showFullDetails;

  const JobCard2({
    super.key,
    required this.job,
    this.onTap,
    this.onBookmarkTap,
    this.showFullDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding =
        showFullDetails
            ? (screenWidth < 400
                ? 12.0
                : screenWidth < 600
                ? 18.0
                : 25.0)
            : (screenWidth < 400
                ? 8.0
                : screenWidth < 600
                ? 12.0
                : 15.0);
    final logoSize =
        screenWidth < 400
            ? 28.0
            : screenWidth < 600
            ? 34.0
            : 40.0;
    final borderRadius =
        screenWidth < 400
            ? 6.0
            : screenWidth < 600
            ? 8.0
            : 12.0;
    final titleFontSize =
        screenWidth < 400
            ? 12.0
            : screenWidth < 600
            ? 14.0
            : 15.0;
    final companyFontSize =
        screenWidth < 400
            ? 8.0
            : screenWidth < 600
            ? 9.0
            : 10.0;
    final tagFontSize =
        screenWidth < 400
            ? 8.0
            : screenWidth < 600
            ? 9.0
            : 10.0;
    final tagPadding =
        screenWidth < 400
            ? 6.0
            : screenWidth < 600
            ? 8.0
            : 10.0;
    final tagSpacing =
        screenWidth < 400
            ? 6.0
            : screenWidth < 600
            ? 8.0
            : 12.0;
    final bookmarkSize =
        screenWidth < 400
            ? 16.0
            : screenWidth < 600
            ? 18.0
            : 20.0;
    final rowSpacing =
        showFullDetails
            ? (screenWidth < 400
                ? 10.0
                : screenWidth < 600
                ? 13.0
                : 16.0)
            : (screenWidth < 400
                ? 8.0
                : screenWidth < 600
                ? 10.0
                : 12.0);
    final salaryFontSize =
        showFullDetails
            ? (screenWidth < 400
                ? 10.0
                : screenWidth < 600
                ? 11.0
                : 12.0)
            : (screenWidth < 400
                ? 8.0
                : screenWidth < 600
                ? 9.0
                : 10.0);

    return Container(
      padding: EdgeInsets.all(padding),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF5F7394).withOpacity(0.14),
            offset: Offset(0, 6),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header with company info and bookmark
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // Company logo
                      Container(
                        width: logoSize,
                        height: logoSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(
                            color: Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(borderRadius),
                          child: Image.asset(
                            job.company.logoUrl,
                            width: borderRadius,
                            height: borderRadius,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                LucideIcons.building,
                                color: Color(0xFF6B7280),
                                size: bookmarkSize,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: tagSpacing),
                      // Job title and company name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              job.title,
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkGrey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              job.company.name,
                              style: TextStyle(
                                fontSize: companyFontSize,
                                fontWeight: FontWeight.w400,
                                color: AppColors.mediumGrey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Bookmark icon
                AbsorbPointer(
                  child: GestureDetector(
                    onTap: onBookmarkTap,
                    child: Icon(
                      job.isBookmarked ? Icons.bookmark : LucideIcons.bookmark,
                      size: bookmarkSize,
                      color:
                          job.isBookmarked
                              ? AppColors.red
                              : AppColors.mediumGrey,
                    ),
                  ),
                ),
              ],
            ),

            if (showFullDetails) ...[
              SizedBox(height: rowSpacing),
              // Tags/Categories
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: tagPadding,
                      vertical: tagPadding,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Text(
                      job.categoryName,
                      style: TextStyle(
                        fontSize: tagFontSize,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ),
                  SizedBox(width: tagSpacing),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: tagPadding,
                      vertical: tagPadding,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Text(
                      job.typeName,
                      style: TextStyle(
                        fontSize: tagFontSize,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ),
                  SizedBox(width: tagSpacing),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: tagPadding,
                      vertical: tagPadding,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Text(
                      job.daysAgo,
                      style: TextStyle(
                        fontSize: tagFontSize,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: rowSpacing),
            ] else ...[
              SizedBox(height: rowSpacing - 4),
            ],

            // Location and salary
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job.location,
                    style: TextStyle(
                      fontSize: salaryFontSize,
                      fontWeight: FontWeight.w500,
                      color:
                          showFullDetails
                              ? AppColors.darkGrey
                              : AppColors.mediumGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      job.salaryRange,
                      style: TextStyle(
                        fontSize: salaryFontSize,
                        fontWeight: FontWeight.bold,
                        color:
                            showFullDetails
                                ? AppColors.darkGrey
                                : AppColors.mediumGrey,
                      ),
                    ),
                    Text(
                      "/month",
                      style: TextStyle(
                        fontSize: salaryFontSize,
                        fontWeight: FontWeight.w400,
                        color:
                            showFullDetails
                                ? AppColors.darkGrey
                                : AppColors.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
