import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:jobhub_jobseeker_ukk/data/models/job.dart';
import 'package:jobhub_jobseeker_ukk/data/services/job_data_service.dart';
import 'package:intl/intl.dart';

class JobDetailPage extends StatefulWidget {
  final Job job;
  final void Function(Job)? onBookmarkToggle;
  const JobDetailPage({super.key, required this.job, this.onBookmarkToggle});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  late Job jobData;

  @override
  void initState() {
    super.initState();
    jobData = widget.job;
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  void _toggleBookmark() {
    JobDataService.toggleBookmark(jobData);
    setState(() {
      // Always reload jobData from JobDataService to sync all components
      jobData = JobDataService.getAllJobs().firstWhere(
        (j) => j.id == jobData.id,
        orElse: () => jobData,
      );
    });
    if (widget.onBookmarkToggle != null) {
      widget.onBookmarkToggle!(jobData);
    }
  }

  // Responsive methods
  double _getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 120;
    if (width > 768) return 80;
    if (width > 600) return 50;
    return 30;
  }

  double _getTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 24;
    if (width > 600) return 22;
    return 20;
  }

  double _getSubtitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 16;
    if (width > 600) return 15;
    return 14;
  }

  double _getSectionTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 18;
    if (width > 600) return 17;
    return 16;
  }

  double _getBodyFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 15;
    if (width > 600) return 14.5;
    return 14;
  }

  double _getTagFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 14;
    if (width > 600) return 13.5;
    return 13;
  }

  double _getLogoSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 120;
    if (width > 600) return 110;
    return 100;
  }

  double _getIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 50;
    if (width > 600) return 45;
    return 40;
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () async {
            // Try to pop first (go back to the page that pushed this detail).
            // If there's nothing to pop, fallback to going home.
            if (await Navigator.maybePop(context)) return;
            context.go('/');
          },
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
          IconButton(
            icon: Icon(
              jobData.isBookmarked ? Icons.bookmark : LucideIcons.bookmark,
              color: jobData.isBookmarked ? Colors.red : AppColors.mediumGrey,
              size: 24,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: _getHorizontalPadding(context),
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Company Logo and Job Title Section
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: _getLogoSize(context),
                    height: _getLogoSize(context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Color(0xFFE5E7EB), width: 1),
                    ),
                    child: Icon(
                      LucideIcons.building,
                      size: _getIconSize(context),
                      color: AppColors.mediumGrey,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        jobData.title,
                        style: TextStyle(
                          fontSize: _getTitleFontSize(context),
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "${jobData.company.name}, ${jobData.location}",
                        style: TextStyle(
                          fontSize: _getSubtitleFontSize(context),
                          fontWeight: FontWeight.w500,
                          color: AppColors.mediumGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Tags Section
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildTag(jobData.categoryName.split(' ')[0], context),
                  _buildTag(jobData.typeName, context),
                  _buildTag(jobData.daysAgo, context),
                ],
              ),
            ),
            SizedBox(height: 35),

            // About the job Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About the job",
                  style: TextStyle(
                    fontSize: _getSectionTitleFontSize(context),
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGrey,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  jobData.description,
                  style: TextStyle(
                    fontSize: _getBodyFontSize(context),
                    fontWeight: FontWeight.normal,
                    color: AppColors.darkGrey.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
            SizedBox(height: 25),

            // Job Information Section
            Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Job Information",
                  style: TextStyle(
                    fontSize: _getSectionTitleFontSize(context),
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGrey,
                  ),
                ),
                _rowInformation(
                  LucideIcons.users,
                  "Capacity",
                  jobData.capacityText,
                  context,
                ),
                _rowInformation(
                  LucideIcons.calendarClock,
                  "Start Date",
                  _formatDate(jobData.startDate),
                  context,
                ),
                _rowInformation(
                  LucideIcons.calendarX,
                  "End Date",
                  _formatDate(jobData.deadlineDate),
                  context,
                ),
                _rowInformation(
                  LucideIcons.rocket,
                  "Experience",
                  jobData.experience,
                  context,
                ),
                _rowInformation(
                  LucideIcons.circleDollarSign,
                  "Salary",
                  jobData.salaryRange + " /month",
                  context,
                ),
                _rowInformation(
                  LucideIcons.briefcase,
                  "Job Level",
                  jobData.jobLevel,
                  context,
                ),
              ],
            ),
            SizedBox(height: 25),

            // Qualifications Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Qualifications",
                  style: TextStyle(
                    fontSize: _getSectionTitleFontSize(context),
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGrey,
                  ),
                ),
                SizedBox(height: 10),
                for (final req in jobData.requirements)
                  _qualificationItem(req, context),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(35, 40, 35, 50),
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
                                    "I'm sure",
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

  Widget _buildTag(String text, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: _getTagFontSize(context),
          fontWeight: FontWeight.w500,
          color: AppColors.darkGrey,
        ),
      ),
    );
  }

  Widget _rowInformation(
    IconData icon,
    String title,
    String info,
    BuildContext context,
  ) {
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
                fontSize: _getBodyFontSize(context),
                fontWeight: FontWeight.w500,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
        Flexible(
          child: Text(
            info,
            style: TextStyle(
              fontSize: _getBodyFontSize(context),
              fontWeight: FontWeight.w500,
              color: AppColors.darkGrey,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _qualificationItem(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(
              fontSize: _getBodyFontSize(context),
              color: AppColors.darkGrey,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: _getBodyFontSize(context),
                color: AppColors.darkGrey.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
