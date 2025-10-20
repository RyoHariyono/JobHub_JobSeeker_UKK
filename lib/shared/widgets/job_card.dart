import 'package:flutter/material.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/data/models/job.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;
  final bool showFullDetails;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
    this.onBookmarkTap,
    this.showFullDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(showFullDetails ? 25 : 15),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
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
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            job.company.logoUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                LucideIcons.building,
                                color: Color(0xFF6B7280),
                                size: 20,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Job title and company name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              job.title,
                              style: TextStyle(
                                fontSize: 15,
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
                                fontSize: 10,
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
                GestureDetector(
                  onTap: onBookmarkTap,
                  child: Icon(
                    job.isBookmarked ? Icons.bookmark : LucideIcons.bookmark,
                    size: 20,
                    color:
                        job.isBookmarked ? AppColors.red : AppColors.mediumGrey,
                  ),
                ),
              ],
            ),

            if (showFullDetails) ...[
              SizedBox(height: 16),
              // Tags/Categories
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      job.categoryName,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      job.typeName,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      job.daysAgo,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ] else ...[
              SizedBox(height: 12),
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
                      fontSize: showFullDetails ? 12 : 10,
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
                        fontSize: showFullDetails ? 12 : 10,
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
                        fontSize: showFullDetails ? 12 : 10,
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
