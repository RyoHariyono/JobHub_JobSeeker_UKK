import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:card_loading/card_loading.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/data/models/job.dart';
import 'package:jobhub_jobseeker_ukk/data/models/company.dart';
import 'package:jobhub_jobseeker_ukk/data/services/job_data_service.dart';
import 'package:jobhub_jobseeker_ukk/data/services/job_service.dart'
    hide JobCategory, JobType;
import 'package:jobhub_jobseeker_ukk/data/services/profile_service.dart';
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
  final JobService _jobService = JobService();
  final ProfileService _profileService = ProfileService();

  int _popularJobPage = 0;
  JobCategory? selectedCategory;
  List<Job> popularJobs = [];
  List<Job> recommendationJobs = [];
  bool isLoading = true;
  String _userName = 'User';
  String? _profilePhotoUrl;

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
    JobDataService.jobsNotifier.addListener(_onJobsChanged);
  }

  @override
  void dispose() {
    JobDataService.jobsNotifier.removeListener(_onJobsChanged);
    super.dispose();
  }

  void _onJobsChanged() {
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load profile (optional, continue if fails)
      Map<String, dynamic>? profile;
      try {
        profile = await _profileService.getProfile();
        print('Profile loaded: ${profile?['full_name']}');
      } catch (e) {
        print('Could not load profile: $e');
      }

      // Load jobs from Supabase
      final jobs = await _jobService.getJobs(activeOnly: true);
      print('Jobs loaded: ${jobs.length} jobs');

      // Load favorites (only if user is logged in)
      Set<String> favoriteIds = {};
      try {
        final favorites = await _jobService.getFavoriteJobs();
        print('Favorites loaded: ${favorites.length} favorites');
        favoriteIds =
            favorites
                .where((fav) => fav['jobs'] != null)
                .map((fav) => fav['jobs']['id'] as String)
                .toSet();
      } catch (e) {
        print('Could not load favorites (user might not be logged in): $e');
        // Continue without favorites
      }

      // Convert to Job models
      final allJobs = _convertToJobModels(jobs, favoriteIds);

      if (mounted) {
        setState(() {
          _userName = profile?['full_name']?.split(' ')[0] ?? 'User';
          _profilePhotoUrl = profile?['profile_photo_url'];

          // Filter by category if selected
          if (selectedCategory != null) {
            // Popular jobs dari category yang dipilih
            popularJobs =
                allJobs
                    .where((job) => job.category == selectedCategory)
                    .take(4)
                    .toList();
            // Recommendation jobs dari semua category (random/shuffle)
            final shuffledJobs = List<Job>.from(allJobs)..shuffle();
            recommendationJobs = shuffledJobs.take(5).toList();
          } else {
            popularJobs = allJobs.take(4).toList();
            recommendationJobs = allJobs.skip(4).take(5).toList();
          }

          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Error loading jobs: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading jobs: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Job> _convertToJobModels(
    List<Map<String, dynamic>> supabaseJobs,
    Set<String> favoriteIds,
  ) {
    return supabaseJobs.map((jobData) {
      print('Converting job: ${jobData['title']}');
      print('Job data keys: ${jobData.keys.toList()}');
      final company = jobData['companies'];
      print('Company: ${company?['name']}');
      return Job(
        id: jobData['id'],
        title: jobData['title'] ?? 'Unknown',
        company: Company(
          id: company['id'],
          name: company['name'] ?? 'Unknown Company',
          logoUrl: company['logo_url'] ?? '',
          location: company['location'] ?? '',
          description: company['description'] ?? company['industry'] ?? '',
        ),
        category: _parseCategory(jobData['category']),
        type: _parseJobType(jobData['type']),
        location: jobData['location'] ?? '',
        minSalary: (jobData['min_salary'] ?? 0).toDouble(),
        maxSalary: (jobData['max_salary'] ?? 0).toDouble(),
        description: jobData['description'] ?? '',
        requirements: [],
        postedDate: DateTime.parse(jobData['posted_date']),
        deadlineDate: DateTime.parse(jobData['deadline_date']),
        isBookmarked: favoriteIds.contains(jobData['id']),
        tags: [],
        capacity: jobData['capacity'] ?? 1,
        startDate:
            jobData['start_date'] != null
                ? DateTime.parse(jobData['start_date'])
                : DateTime.now(),
        experience: jobData['experience_required'] ?? '',
        jobLevel: jobData['job_level'] ?? '',
      );
    }).toList();
  }

  JobCategory _parseCategory(String? category) {
    switch (category?.toLowerCase()) {
      case 'frontend':
        return JobCategory.frontendDevelopment;
      case 'backend':
        return JobCategory.backendDevelopment;
      case 'fullstack':
      case 'mobile':
        return JobCategory.softwareDevelopment;
      case 'ui_ux':
        return JobCategory.uiuxDesign;
      case 'devops':
        return JobCategory.devopsCloud;
      default:
        return JobCategory.softwareDevelopment;
    }
  }

  JobType _parseJobType(String? type) {
    switch (type?.toLowerCase()) {
      case 'full_time':
        return JobType.fullTime;
      case 'part_time':
        return JobType.partTime;
      case 'contract':
        return JobType.contract;
      case 'freelance':
        return JobType.freelance;
      case 'internship':
        return JobType.internship;
      default:
        return JobType.fullTime;
    }
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

  Future<void> _toggleBookmark(Job job) async {
    HapticFeedback.lightImpact();

    try {
      final isFavorited = await _jobService.isFavorited(job.id);

      if (isFavorited) {
        await _jobService.removeFromFavorites(job.id);
      } else {
        await _jobService.addToFavorites(job.id);
      }

      // Reload jobs to update bookmark status
      await _loadJobs();
    } catch (e) {
      print('Error toggling bookmark: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update favorite')));
      }
    }
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
      body: RefreshIndicator(
        onRefresh: _loadJobs,
        color: AppColors.primaryBlue,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
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
                child:
                    _profilePhotoUrl != null
                        ? Image.network(
                          _profilePhotoUrl!,
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
                        )
                        : Icon(LucideIcons.user, color: Colors.white, size: 20),
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
                    _userName,
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
                        onTap: () => context.push('/jobs-detail', extra: job),
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
        else if (recommendationJobs.isEmpty)
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
        else if (recommendationJobs.isNotEmpty)
          ...recommendationJobs
              .map(
                (job) => Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: JobCard(
                    job: job,
                    showFullDetails: false,
                    onTap: () => context.push('/jobs-detail', extra: job),
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
