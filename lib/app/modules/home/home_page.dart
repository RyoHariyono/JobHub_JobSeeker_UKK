import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/data/models/job.dart';
import 'package:jobhub_jobseeker_ukk/data/services/job_data_service.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/job_card.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/menu_card.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/custom_search_bar.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/jobs/job_list_page.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomePageContent extends StatefulWidget {
  final Function(int)? onNavigateToSearch;

  const HomePageContent({super.key, this.onNavigateToSearch});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
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
          popularJobs = JobDataService.getPopularJobs(limit: 3);
        }
        recommendationJobs = JobDataService.getRandomJobs(3);
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

  void _onSearchTap() {
    if (widget.onNavigateToSearch != null) {
      widget.onNavigateToSearch!(1); // Navigate to search page (navbar index 1)
    }
  }

  void _onSeeMoreTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => JobListPage(
              category: selectedCategory,
              categoryTitle:
                  selectedCategory != null
                      ? JobDataService.getCategoryName(selectedCategory!)
                      : 'All Jobs',
            ),
      ),
    );
  }

  void _toggleBookmark(Job job) {
    HapticFeedback.lightImpact();
    setState(() {
      final updatedJob = JobDataService.toggleBookmark(job);

      // Update in popular jobs
      final popularIndex = popularJobs.indexWhere((j) => j.id == job.id);
      if (popularIndex != -1) {
        popularJobs[popularIndex] = updatedJob;
      }

      // Update in recommendation jobs
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(35, 60, 35, 10),
          child: Column(
            children: [
              // AppBar
              _buildAppBar(),

              // Title
              SizedBox(height: 15),
              _buildTitle(),

              // Search Bar
              SizedBox(height: 35),
              CustomSearchBar(readOnly: true, onTap: _onSearchTap),

              // Category Menu
              SizedBox(height: 30),
              _buildCategoryMenu(),

              // Popular Vacancies
              SizedBox(height: 45),
              _buildPopularVacancies(),

              // Recommendation Jobs
              SizedBox(height: 40),
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
          onPressed: () {
            // Add your notification action here
          },
          icon: Icon(LucideIcons.bell, size: 24, color: AppColors.darkGrey),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Find Your",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
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
              fontSize: 32,
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
          Container(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryBlue,
                ),
              ),
            ),
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
          Container(
            height: 200,
            child: JobCard(
              job: popularJobs.first,
              onTap: () {
                // Navigate to job detail
                HapticFeedback.lightImpact();
              },
              onBookmarkTap: () => _toggleBookmark(popularJobs.first),
            ),
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
          Container(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryBlue,
                ),
              ),
            ),
          )
        else if (recommendationJobs.isNotEmpty)
          ...recommendationJobs
              .map(
                (job) => Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: JobCard(
                    job: job,
                    showFullDetails: false,
                    onTap: () {
                      // Navigate to job detail
                      HapticFeedback.lightImpact();
                    },
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
