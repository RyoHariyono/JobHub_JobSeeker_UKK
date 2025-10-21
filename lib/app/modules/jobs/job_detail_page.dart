import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:jobhub_jobseeker_ukk/data/models/job.dart';

class JobDetailPage extends StatelessWidget {
  final Job job;
  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    // If job is not passed, fallback to dummy job (should not happen)
    final Job jobData = job;
    double _getHorizontalPadding(BuildContext context) {
      final width = MediaQuery.of(context).size.width;
      if (width > 1200) return 120;
      if (width > 768) return 50;
      if (width > 600) return 35;
      if (width > 400) return 18;
      return 10;
    }

    double _getAppBarTitleFontSize(BuildContext context) {
      final width = MediaQuery.of(context).size.width;
      if (width > 768) return 18;
      if (width > 600) return 17;
      if (width > 400) return 16;
      return 14;
    }

    double _getAppBarSubtitleFontSize(BuildContext context) {
      final width = MediaQuery.of(context).size.width;
      if (width > 768) return 16;
      if (width > 600) return 15;
      if (width > 400) return 14;
      return 12;
    }

    double _getAppBarHeight(BuildContext context) {
      final width = MediaQuery.of(context).size.width;
      if (width > 768) return 80;
      if (width > 600) return 75;
      return 70;
    }

    double _getCardLoadingHeight(BuildContext context) {
      final width = MediaQuery.of(context).size.width;
      if (width > 768) return 180;
      if (width > 600) return 170;
      return 165;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            LucideIcons.chevronLeft,
            color: AppColors.darkGrey,
            size: 24,
          ),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          "Detail Jobs",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        actions: [
          Icon(LucideIcons.bookmark, color: AppColors.darkGrey, size: 24),
        ],
        actionsPadding: EdgeInsets.fromLTRB(0, 0, 25, 0),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Color(0xFFE5E7EB), width: 1),
                    ),
                    child: Icon(
                      LucideIcons.building,
                      size: 40,
                      color: AppColors.mediumGrey,
                    ),
                    // Image.asset(
                    //   jobData.company.logoUrl,
                    //   width: 80,
                    //   height: 80,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Text(
                        jobData.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "${jobData.company.name}, ${jobData.location}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    jobData.categoryName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    jobData.typeName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    jobData.daysAgo,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 35),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About the job",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGrey,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  jobData.description,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: AppColors.darkGrey.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
            SizedBox(height: 25),
            Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Job Information",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGrey,
                  ),
                ),
                rowInformation(
                  LucideIcons.briefcase,
                  "Company",
                  jobData.company.name,
                ),
                rowInformation(
                  LucideIcons.calendarClock,
                  "Posted Date",
                  "${jobData.postedDate.toLocal().toString().split(' ')[0]}",
                ),
                rowInformation(
                  LucideIcons.calendarCheck,
                  "Deadline",
                  "${jobData.deadlineDate.toLocal().toString().split(' ')[0]}",
                ),
                rowInformation(LucideIcons.rocket, "Experience", "7+ years"),
                // You can add more job fields here if needed
                rowInformation(
                  LucideIcons.circleDollarSign,
                  "Salary",
                  jobData.salaryRange + " /month",
                ),
                rowInformation(
                  LucideIcons.graduationCap,
                  "Tags",
                  jobData.tags.isNotEmpty ? jobData.tags.join(', ') : '-',
                ),
              ],
            ),
            SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Qualifications",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGrey,
                  ),
                ),
                SizedBox(height: 10),
                for (final req in jobData.requirements) qualificationItem(req),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(35, 40, 35, 50),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            padding: EdgeInsets.symmetric(vertical: 17),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder:
                  (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    insetPadding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Container(
                      width: 343,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Double-checking… ready to apply?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGrey,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "You can change your mind later — feel free to cancel anytime.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: AppColors.mediumGrey,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryBlue,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed:
                                      () => context.go(
                                        '/jobs-detail/confirmation-send',
                                      ),
                                  child: Text(
                                    "I’m sure",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: AppColors.primaryBlue,
                                      width: 2,
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: AppColors.primaryBlue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            );
          },
          child: Text(
            "Apply Now",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget rowInformation(IconData icon, String title, String info) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: AppColors.darkGrey),
            SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
        Text(
          info,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.darkGrey,
          ),
        ),
      ],
    );
  }

  Widget qualificationItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 14, color: AppColors.darkGrey)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
