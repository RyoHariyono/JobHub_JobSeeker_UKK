import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:card_loading/card_loading.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/data/models/job.dart';
import 'package:jobhub_jobseeker_ukk/data/services/job_data_service.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/job_card.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/menu_card.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/custom_search_bar.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomePageContent extends StatefulWidget {
  final Function(int)? onNavigateToSearch;

  const HomePageContent({super.key, this.onNavigateToSearch});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  int _popularJobPage = 0;
  JobCategory? selectedCategory;
  List<Job> popularJobs = [];
  List<Job> recommendationJobs = [];
  bool isLoading = true;

  final List<Map<String, dynamic>> categories = [
    {
      'category': JobCategory.softwareDevelopment,
      'title': 'Software Development',
      'icon': LucideIcons.code,
    },
    {
      'category': JobCategory.frontendDevelopment,
      'title': 'Frontend Development',
    },
    {
      'category': JobCategory.backendDevelopment,
      'title': 'Backend Development',
    },
    {
      'category': JobCategory.devopsCloud,
      'title': 'DevOps & Cloud Engineering',
    },
    {'category': JobCategory.uiuxDesign, 'title': 'UI/UX & Product Design'},
  ];

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
        if (selectedCategory != null) {
          popularJobs = JobDataService.getJobsByCategory(selectedCategory!);
        } else {
          popularJobs = JobDataService.getPopularJobs(limit: 4);
        }
        recommendationJobs = JobDataService.getRandomJobs(5);
        isLoading = false;
      });
    });
  }

  void _onCategorySelected(JobCategory category) {
    setState(() {
      selectedCategory = selectedCategory == category ? null : category;
    });
    _loadJobs();
  }

  void _onSeeMoreTap() {
    context.go(
      '/jobs-popular-list',
      extra:
          selectedCategory != null
              ? {
                'category': selectedCategory,
                'categoryTitle': JobDataService.getCategoryName(
                  selectedCategory!,
                ),
              }
              : 'All Jobs',
    );
  }

  void _toggleBookmark(Job job) {
    HapticFeedback.lightImpact();
    setState(() {
      final updatedJob = JobDataService.toggleBookmark(job);
      final popularIndex = popularJobs.indexWhere((j) => j.id == job.id);
      if (popularIndex != -1) {
        popularJobs[popularIndex] = updatedJob;
      }
      final recommendationIndex = recommendationJobs.indexWhere(
        (j) => j.id == job.id,
      );
      if (recommendationIndex != -1) {
        recommendationJobs[recommendationIndex] = updatedJob;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding =
        screenWidth < 400
            ? 10.0
            : screenWidth < 600
            ? 18.0
            : 35.0;
    final verticalPaddingTop =
        screenWidth < 400
            ? 20.0
            : screenWidth < 600
            ? 35.0
            : 60.0;
    final verticalPaddingBottom =
        screenWidth < 400
            ? 5.0
            : screenWidth < 600
            ? 8.0
            : 10.0;
    final titleFontSize =
        screenWidth < 400
            ? 20.0
            : screenWidth < 600
            ? 26.0
            : 32.0;
    final searchBarSpacing =
        screenWidth < 400
            ? 14.0
            : screenWidth < 600
            ? 22.0
            : 35.0;
    final categorySpacing =
        screenWidth < 400
            ? 12.0
            : screenWidth < 600
            ? 18.0
            : 30.0;
    final popularSpacing =
        screenWidth < 400
            ? 18.0
            : screenWidth < 600
            ? 28.0
            : 45.0;
    final recommendationSpacing =
        screenWidth < 400
            ? 10.0
            : screenWidth < 600
            ? 20.0
            : 40.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 50, 30, 35),
          child: Column(
            children: [
              _buildAppBar(),
              SizedBox(height: 15),
              _buildTitle(fontSize: titleFontSize),
              SizedBox(height: searchBarSpacing),
              CustomSearchBar(
                hintText: "Search your dream job here",
                readOnly: true,
                onTap: () => context.go('/search'),
              ),
              SizedBox(height: categorySpacing),
              _buildCategoryMenu(),
              SizedBox(height: popularSpacing),
              _buildPopularVacancies(),
              SizedBox(height: recommendationSpacing),
              _buildRecommendationJobs(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Profile username
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/profile_picture.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      LucideIcons.user,
                      color: Colors.white,
                      size: 20,
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 5),
                ShaderMask(
                  shaderCallback:
                      (bounds) => LinearGradient(
                        colors: [Color(0xFFAF52DE), Color(0xFFFF2D55)],
                        stops: [0.0, 1.0],
                      ).createShader(bounds),
                  child: Text(
                    "Ryo",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Notification icon
        IconButton(
          onPressed: () => context.go('/notification'),
          icon: Icon(LucideIcons.bell, size: 24, color: AppColors.darkGrey),
        ),
      ],
    );
  }

  Widget _buildTitle({double fontSize = 32}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Find Your",
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 5),
        ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                colors: [
                  Color(0xFF007AFF),
                  Color(0xFFAF52DE),
                  Color(0xFFFF2D55),
                ],
                stops: [0.0, 0.5, 1.0],
              ).createShader(bounds),
          child: Text(
            "Perfect Job",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryMenu() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            categories.map((categoryData) {
              final category = categoryData['category'] as JobCategory;
              final title = categoryData['title'] as String;

              final isSelected = selectedCategory == category;

              return Padding(
                padding: EdgeInsets.only(right: 10),
                child: MenuCard(
                  title: title,
                  isSelected: isSelected,
                  onTap: () => _onCategorySelected(category),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildPopularVacancies() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedCategory != null
                  ? "${JobDataService.getCategoryName(selectedCategory!)} Jobs"
                  : "Popular vacancies",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey,
              ),
            ),
            GestureDetector(
              onTap: _onSeeMoreTap,
              child: Text(
                "See More",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mediumGrey,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        if (isLoading)
          CardLoading(
            height: 200,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            margin: EdgeInsets.only(bottom: 16),
          )
        else if (popularJobs.isEmpty)
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(color: Color(0xFFE5E7EB), width: 1),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.briefcase,
                    size: 48,
                    color: AppColors.mediumGrey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "No jobs found",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              Container(
                height: 200,
                child: PageView.builder(
                  itemCount: popularJobs.length.clamp(0, 3),
                  controller: PageController(viewportFraction: 0.99),
                  pageSnapping: true,
                  onPageChanged: (index) {
                    setState(() {
                      _popularJobPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final job = popularJobs[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: 5,
                        left: 5,
                      ), // Jarak kanan antar container
                      child: JobCard(
                        job: job,
                        onTap: () => context.go('/jobs-detail', extra: job),
                        onBookmarkTap: () => _toggleBookmark(job),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  popularJobs.length.clamp(0, 3),
                  (index) => Container(
                    width: 18,
                    height: 7,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color:
                          _popularJobPage == index
                              ? AppColors.primaryBlue
                              : Color(0xFFE5E7EB),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildRecommendationJobs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recommendation job",
          style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15),
        if (isLoading)
          Column(
            children: [
              CardLoading(
                height: 80,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                margin: EdgeInsets.only(bottom: 12),
              ),
              CardLoading(
                height: 80,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                margin: EdgeInsets.only(bottom: 12),
              ),
              CardLoading(
                height: 80,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                margin: EdgeInsets.only(bottom: 12),
              ),
            ],
          )
        else if (recommendationJobs.isNotEmpty)
          ...recommendationJobs
              .map(
                (job) => Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: JobCard(
                    job: job,
                    showFullDetails: false,
                    onTap: () => context.go('/jobs-detail', extra: job),
                    onBookmarkTap: () => _toggleBookmark(job),
                  ),
                ),
              )
              .toList(),
        SizedBox(height: 20),
      ],
    );
  }
}
