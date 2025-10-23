import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:card_loading/card_loading.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/data/models/job.dart';
import 'package:jobhub_jobseeker_ukk/data/services/job_data_service.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/job_card.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/job_card_2.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JobListPage extends StatefulWidget {
  final JobCategory? category;
  final String? categoryTitle;

  const JobListPage({super.key, this.category, this.categoryTitle});

  @override
  State<JobListPage> createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  List<Job> jobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  void _loadJobs() {
    setState(() {
      isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (widget.category != null) {
          jobs = JobDataService.getJobsByCategory(widget.category!);
        } else {
          jobs = JobDataService.getAllJobs();
        }
        isLoading = false;
      });
    });
  }

  void _toggleBookmark(Job job) {
    HapticFeedback.lightImpact();
    JobDataService.toggleBookmark(job);
    setState(() {
      // Always reload job list from JobDataService to sync all components
      if (widget.category != null) {
        jobs = JobDataService.getJobsByCategory(widget.category!);
      } else {
        jobs = JobDataService.getAllJobs();
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: _getAppBarHeight(context),
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "See more recommendation",
              style: TextStyle(
                fontSize: _getAppBarTitleFontSize(context),
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey,
              ),
            ),
            SizedBox(height: 5),
            Text(
              widget.categoryTitle ?? "All Jobs",
              style: TextStyle(
                color: AppColors.mediumGrey,
                fontSize: _getAppBarSubtitleFontSize(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body:
          isLoading
              ? Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 35),
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder:
                      (context, index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: 15,
                          top: index == 0 ? 20 : 0,
                        ),
                        child: CardLoading(
                          height: 130,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                ),
              )
              : jobs.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Icon(
                      LucideIcons.briefcase,
                      size: 64,
                      color: AppColors.mediumGrey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No jobs found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Try searching for different keywords',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.mediumGrey,
                      ),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 35),
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: JobCard(
                            job: job,
                            onTap:
                                () => context.push('/jobs-detail', extra: job),
                            onBookmarkTap: () => _toggleBookmark(job),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
