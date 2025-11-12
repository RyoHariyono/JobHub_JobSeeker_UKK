import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/data/services/job_data_service.dart';
import 'package:jobhub_jobseeker_ukk/data/models/job.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:card_loading/card_loading.dart';

class ApplicationHistoryPage extends StatefulWidget {
  const ApplicationHistoryPage({super.key});

  @override
  State<ApplicationHistoryPage> createState() => _ApplicationHistoryPageState();
}

class _ApplicationHistoryPageState extends State<ApplicationHistoryPage> {
  late TextEditingController _searchController;
  String _selectedCategory = 'this_week'; // 'this_week' or 'last_month'
  String _searchQuery = '';
  bool isLoading = true;
  bool _isSearching = false; // NEW: Track if search mode is active
  List<Job> filteredApplications = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    // simulate loading
    await Future.delayed(Duration(milliseconds: 500));
    if (!mounted) return;
    _filterApplications();
    setState(() => isLoading = false);
  }

  void _filterApplications() {
    final allJobs = JobDataService.jobsNotifier.value;
    final appliedJobs = allJobs.where((job) => job.isApplied).toList();

    List<Job> filtered = appliedJobs;

    // Filter by category (date range)
    if (_selectedCategory == 'this_week') {
      final oneWeekAgo = DateTime.now().subtract(Duration(days: 7));
      filtered =
          filtered
              .where(
                (job) =>
                    job.appliedDate != null &&
                    job.appliedDate!.isAfter(oneWeekAgo),
              )
              .toList();
    } else if (_selectedCategory == 'last_month') {
      final oneMonthAgo = DateTime.now().subtract(Duration(days: 30));
      final oneWeekAgo = DateTime.now().subtract(Duration(days: 7));
      filtered =
          filtered
              .where(
                (job) =>
                    job.appliedDate != null &&
                    job.appliedDate!.isAfter(oneMonthAgo) &&
                    job.appliedDate!.isBefore(oneWeekAgo),
              )
              .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (job) =>
                    job.title.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    job.company.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    job.location.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    setState(() {
      filteredApplications = filtered;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _filterApplications();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterApplications();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Responsive methods
  double _getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 120;
    if (width > 768) return 80;
    if (width > 600) return 50;
    return 30;
  }

  double _getLabelFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 15;
    if (width > 600) return 14.5;
    return 14;
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
          onPressed: () => context.go('/profile'),
        ),
        title:
            !_isSearching
                ? Text(
                  "Application history",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGrey,
                  ),
                )
                : TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search applications...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: AppColors.mediumGrey,
                      fontSize: 16,
                    ),
                  ),
                  style: TextStyle(color: AppColors.darkGrey, fontSize: 16),
                  autofocus: true,
                ),
        actions: [
          if (!_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
              icon: Icon(
                LucideIcons.search,
                color: AppColors.darkGrey,
                size: 24,
              ),
            )
          else
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                });
                _filterApplications();
              },
              icon: Icon(LucideIcons.x, color: AppColors.darkGrey, size: 24),
            ),
        ],
        centerTitle: !_isSearching,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primaryBlue,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            _getHorizontalPadding(context),
            35,
            _getHorizontalPadding(context),
            35,
          ),
          child:
              isLoading
                  ? Column(
                    children: [
                      for (int i = 0; i < 3; i++)
                        Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: CardLoading(
                            height: 160,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                    ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Filter
                      Row(
                        spacing: 15,
                        children: [
                          _buildCategoryButton(
                            label: 'This week',
                            value: 'this_week',
                            isActive: _selectedCategory == 'this_week',
                          ),
                          _buildCategoryButton(
                            label: 'Last month',
                            value: 'last_month',
                            isActive: _selectedCategory == 'last_month',
                          ),
                        ],
                      ),
                      SizedBox(height: 25),

                      // Applications List
                      if (filteredApplications.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 100),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.inbox,
                                  size: 64,
                                  color: AppColors.mediumGrey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No applications found',
                                  style: TextStyle(
                                    fontSize: _getLabelFontSize(context),
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
                          spacing: 12,
                          children: [
                            for (final job in filteredApplications)
                              _buildApplicationCard(job),
                          ],
                        ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton({
    required String label,
    required String value,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => _onCategoryChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isActive ? AppColors.primaryBlue : Color(0xFFF3F4F6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Color(0xFF6B7280),
            fontSize: _getLabelFontSize(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationCard(Job job) {
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF5F7394).withOpacity(0.10),
            offset: Offset(2, 2),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          // Header: Logo, Title, Company
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFE5E7EB), width: 1),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      job.title,
                      style: TextStyle(
                        fontSize: _getLabelFontSize(context),
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
                        fontSize: 12,
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

          // Location and Salary
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                job.location,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mediumGrey,
                ),
              ),
              Text(
                job.salaryRange + '/month',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mediumGrey,
                ),
              ),
            ],
          ),

          // Applied Date
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Applied on",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mediumGrey,
                ),
              ),
              Text(
                job.appliedDate != null
                    ? _formatDate(job.appliedDate!)
                    : "Unknown",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mediumGrey,
                ),
              ),
            ],
          ),

          // Status Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Applied",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
