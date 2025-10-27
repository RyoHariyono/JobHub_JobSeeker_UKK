import 'package:flutter/material.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:jobhub_jobseeker_ukk/data/services/job_data_service.dart';
import 'package:jobhub_jobseeker_ukk/data/models/job.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/job_card_2.dart';
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Applications",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "result",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.mediumGrey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "1 Apply",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.mediumGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              border: Border.all(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Color(0xFFE5E7EB),
                                                  width: 1,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.asset(
                                                  'assets/images/apple_icon.png',
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return Icon(
                                                      LucideIcons.building,
                                                      color: Color(0xFF6B7280),
                                                      size: 24,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Senior UI/UX Designer",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.darkGrey,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    "Apple",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.mediumGrey,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Icon(
                                          LucideIcons.bookmark,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Jakarta, Indonesia",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.mediumGrey,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "\$1,000 – \$3,000 /month",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.mediumGrey,
                                            ),
                                          ),
                                          Text(
                                            "/month",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.mediumGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  StatefulBuilder(
                                    builder: (context, setState) {
                                      return Column(
                                        children: [
                                          AnimatedCrossFade(
                                            firstChild: SizedBox.shrink(),
                                            secondChild: Column(
                                              children: [
                                                Divider(
                                                  color: Color(0xFFE5E7EB),
                                                  height: 1,
                                                ),
                                                SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          LucideIcons
                                                              .circleCheck,
                                                          color:
                                                              AppColors
                                                                  .lightGreen,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          "Application send",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                AppColors
                                                                    .lightGreen,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "9 September 2025",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColors
                                                                .mediumGrey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          LucideIcons.clock,
                                                          color:
                                                              AppColors.yellow,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          "Panding",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                AppColors
                                                                    .yellow,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "Still being process",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppColors
                                                                .mediumGrey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 15),
                                              ],
                                            ),
                                            crossFadeState:
                                                _isExpanded
                                                    ? CrossFadeState.showSecond
                                                    : CrossFadeState.showFirst,
                                            duration: Duration(
                                              milliseconds: 200,
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF3F4F6),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            child: GestureDetector(
                                              onTap:
                                                  () => setState(
                                                    () =>
                                                        _isExpanded =
                                                            !_isExpanded,
                                                  ),
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                                color: Colors.transparent,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _isExpanded
                                                          ? "Close details"
                                                          : "Open details",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColors
                                                                .mediumGrey,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Icon(
                                                      _isExpanded
                                                          ? LucideIcons
                                                              .chevronUp
                                                          : LucideIcons
                                                              .chevronDown,
                                                      size: 16,
                                                      color:
                                                          AppColors.mediumGrey,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          ValueListenableBuilder<List<Job>>(
                            valueListenable: JobDataService.jobsNotifier,
                            builder: (context, jobs, _) {
                              final favCount =
                                  jobs.where((j) => j.isBookmarked).length;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Favorites",
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
                          // Bookmarked / Favorite jobs list (from JobDataService)
                          ValueListenableBuilder<List<Job>>(
                            valueListenable: JobDataService.jobsNotifier,
                            builder: (context, jobs, _) {
                              final favorites =
                                  jobs.where((j) => j.isBookmarked).toList();
                              return favorites.isEmpty
                                  ? Padding(
                                    padding: EdgeInsets.symmetric(vertical: 0),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 160,
                                          ),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xFFE5E7EB),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                                        ),
                                      ],
                                    ),
                                  )
                                  : Column(
                                    children:
                                        favorites.map((job) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 12,
                                            ),
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
                                          );
                                        }).toList(),
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
