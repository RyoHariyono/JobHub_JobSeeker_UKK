import 'package:flutter/material.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:jobhub_jobseeker_ukk/data/services/job_data_service.dart';
import 'package:jobhub_jobseeker_ukk/data/models/job.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/job_card_2.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/application/application_item.dart';
import 'package:go_router/go_router.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/services.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  bool _isExpanded = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    // simulate loading
    await Future.delayed(Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => isLoading = false);
  }

  void _toggleBookmark(Job job) {
    HapticFeedback.lightImpact();
    JobDataService.toggleBookmark(job);
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild UI cleanly to ensure balanced widgets and responsive layout
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Applications & Favorites",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primaryBlue,
        backgroundColor: Colors.white,
        child:
            isLoading
                ? Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder:
                        (context, index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: 12,
                            top: index == 0 ? 10 : 0,
                          ),
                          child: CardLoading(
                            height: 140,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                  ),
                )
                : ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                  children: [
                    SizedBox(height: 10),

                    // Applications header + items (max 2)
                    ValueListenableBuilder<List<Job>>(
                      valueListenable: JobDataService.jobsNotifier,
                      builder: (context, jobs, _) {
                        final appliedJobs =
                            jobs.where((j) => j.isApplied).toList();
                        final applications = appliedJobs.take(2).toList();
                        final List<Widget> sectionChildren = [];

                        sectionChildren.add(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Applications',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'result',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.mediumGrey,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${appliedJobs.length} Applied',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.mediumGrey,
                                ),
                              ),
                            ],
                          ),
                        );

                        sectionChildren.add(SizedBox(height: 12));

                        if (applications.isEmpty) {
                          sectionChildren.add(
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 160),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFE5E7EB),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    LucideIcons.send,
                                    size: 48,
                                    color: AppColors.mediumGrey,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'No applications yet',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.mediumGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          for (var job in applications) {
                            sectionChildren.add(
                              Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: ApplicationItem(
                                  job: job,
                                  onTap:
                                      () => context.push(
                                        '/jobs-detail',
                                        extra: job,
                                      ),
                                  onBookmarkTap: () => _toggleBookmark(job),
                                ),
                              ),
                            );
                          }
                        }

                        sectionChildren.add(SizedBox(height: 40));

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: sectionChildren,
                        );
                      },
                    ),

                    // Favorites header
                    ValueListenableBuilder<List<Job>>(
                      valueListenable: JobDataService.jobsNotifier,
                      builder: (context, jobs, _) {
                        final favCount =
                            jobs.where((j) => j.isBookmarked).length;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Favorites',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            Text(
                              '$favCount Favorites',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.mediumGrey,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20),

                    // Favorites list
                    ValueListenableBuilder<List<Job>>(
                      valueListenable: JobDataService.jobsNotifier,
                      builder: (context, jobs, _) {
                        final favorites =
                            jobs.where((j) => j.isBookmarked).toList();
                        if (favorites.isEmpty) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 160),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  LucideIcons.bookmark,
                                  size: 48,
                                  color: AppColors.mediumGrey,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'No favorites yet',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.mediumGrey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          children:
                              favorites
                                  .map(
                                    (job) => Padding(
                                      padding: EdgeInsets.only(bottom: 12),
                                      child: JobCard2(
                                        job: job,
                                        showFullDetails: false,
                                        onTap:
                                            () => context.push(
                                              '/jobs-detail',
                                              extra: job,
                                            ),
                                        onBookmarkTap:
                                            () => _toggleBookmark(job),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        );
                      },
                    ),
                  ],
                ),
      ),
    );
  }
}
