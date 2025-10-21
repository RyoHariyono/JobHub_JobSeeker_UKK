import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/data/models/job.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/custom_search_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:jobhub_jobseeker_ukk/data/services/job_data_service.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/job_card_2.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Returns true if any filter is active (other than search text)
  bool _hasActiveFilters() {
    return selectedPosition != null ||
        (selectedCity != null && selectedCity != 'All places') ||
        selectedType != null ||
        minSalaryController.text.isNotEmpty ||
        maxSalaryController.text.isNotEmpty;
  }

  // Returns a string describing active filters
  String _activeFilterText() {
    List<String> filters = [];
    if (selectedPosition != null) filters.add(selectedPosition!);
    return filters.join(', ');
  }

  void _toggleBookmark(Job job) {
    JobDataService.toggleBookmark(job);
    // Re-apply filters to refresh job list and sync bookmark status
    _applyFilters();
  }

  List<String> searchHistory = [];
  // Filter states
  String? selectedPosition;
  String? selectedCity;
  String? selectedType;
  TextEditingController minSalaryController = TextEditingController();
  TextEditingController maxSalaryController = TextEditingController();

  // Search state
  TextEditingController searchController = TextEditingController();
  List<Job> filteredJobs = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadJobs();
    JobDataService.jobsNotifier.addListener(_onJobsChanged);
  }

  @override
  void dispose() {
    JobDataService.jobsNotifier.removeListener(_onJobsChanged);
    minSalaryController.dispose();
    maxSalaryController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onJobsChanged() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      _applyFilters();
    });
  }

  void _loadJobs() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        filteredJobs = JobDataService.getAllJobs();
        isLoading = false;
      });
    });
  }

  void _applyFilters({bool addToHistory = false}) {
    final query = searchController.text.trim();
    if (addToHistory && query.isNotEmpty && !searchHistory.contains(query)) {
      setState(() {
        searchHistory.insert(0, query);
        if (searchHistory.length > 6) searchHistory.removeLast();
      });
    }
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(milliseconds: 300), () {
      List<Job> jobs = JobDataService.getAllJobs();

      // Filter by position
      if (selectedPosition != null) {
        jobs =
            jobs.where((job) => job.categoryName == selectedPosition).toList();
      }

      // Filter by city
      if (selectedCity != null && selectedCity != 'All places') {
        jobs =
            jobs.where((job) => job.location.contains(selectedCity!)).toList();
      }

      // Filter by type
      if (selectedType != null) {
        String typeToMatch = selectedType!;
        if (typeToMatch == 'Half Time') typeToMatch = 'Part Time';
        jobs = jobs.where((job) => job.typeName == typeToMatch).toList();
      }

      // Filter by salary
      if (minSalaryController.text.isNotEmpty) {
        double minSalary = double.tryParse(minSalaryController.text) ?? 0;
        jobs = jobs.where((job) => job.minSalary >= minSalary).toList();
      }
      if (maxSalaryController.text.isNotEmpty) {
        double maxSalary =
            double.tryParse(maxSalaryController.text) ?? double.infinity;
        jobs = jobs.where((job) => job.maxSalary <= maxSalary).toList();
      }

      // Filter by search query
      if (searchController.text.isNotEmpty) {
        jobs = JobDataService.searchJobs(searchController.text);
      }

      setState(() {
        filteredJobs = jobs;
        isLoading = false;
      });
    });
  }

  void _showFilterSheet() {
    // Reset local variables untuk modal
    String? tempPosition = selectedPosition;
    String? tempCity = selectedCity;
    String? tempType = selectedType;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 0,
                right: 0,
                top: 0,
              ),
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  String _getSalaryDisplay() {
                    final min = minSalaryController.text;
                    final max = maxSalaryController.text;
                    if (min.isNotEmpty && max.isNotEmpty) {
                      return '\$$min - \$$max';
                    }
                    return 'min - max salary';
                  }

                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 15),
                        // Handle bar
                        Center(
                          child: Container(
                            width: 40,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        // Header
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: AppColors.darkGrey,
                                  size: 24,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Expanded(
                                child: Text(
                                  'Filter',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: AppColors.darkGrey,
                                  size: 24,
                                ),
                                onPressed: () {
                                  setModalState(() {
                                    tempPosition = null;
                                    tempCity = null;
                                    tempType = null;
                                    minSalaryController.clear();
                                    maxSalaryController.clear();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Content & Button space between
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              // Content
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Job position
                                  _buildFilterRow(
                                    'Job position',
                                    tempPosition ?? 'Choose job',
                                    () {
                                      _showPositionPicker(
                                        context,
                                        setModalState,
                                        (value) {
                                          tempPosition = value;
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  // City & location
                                  _buildFilterRow(
                                    'City & location',
                                    tempCity ?? 'Choose location job',
                                    () {
                                      _showCityPicker(context, setModalState, (
                                        value,
                                      ) {
                                        tempCity = value;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 25),
                                  Divider(
                                    thickness: 1,
                                    color: Color(0xFFE5E7EB),
                                  ),

                                  // Job type
                                  SizedBox(height: 30),
                                  Text(
                                    'Job type',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        children:
                                            [
                                              'Full Time',
                                              'Half Time',
                                              'Freelance',
                                            ].map((type) {
                                              final selected = tempType == type;
                                              return GestureDetector(
                                                onTap:
                                                    () => setModalState(
                                                      () => tempType = type,
                                                    ),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 10,
                                                  ),
                                                  constraints: BoxConstraints(
                                                    minWidth:
                                                        (constraints.maxWidth -
                                                            24) /
                                                        3,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        selected
                                                            ? AppColors
                                                                .primaryBlue
                                                            : AppColors
                                                                .lightGrey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    type,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color:
                                                          selected
                                                              ? Colors.white
                                                              : Color(
                                                                0xFF6B7280,
                                                              ),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 25),
                                  Divider(
                                    thickness: 1,
                                    color: Color(0xFFE5E7EB),
                                  ),
                                  SizedBox(height: 30),

                                  // Job salary
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Job salary',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: AppColors.darkGrey,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          _getSalaryDisplay(),
                                          textAlign: TextAlign.end,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.mediumGrey,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),

                                  // Salary inputs
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildSalaryInput(
                                          'Min salary',
                                          minSalaryController,
                                          setModalState,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: _buildSalaryInput(
                                          'Max salary',
                                          maxSalaryController,
                                          setModalState,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 50),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryBlue,
                                    padding: EdgeInsets.symmetric(vertical: 17),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedPosition = tempPosition;
                                      selectedCity = tempCity;
                                      selectedType = tempType;
                                    });
                                    Navigator.pop(context);
                                    _applyFilters(addToHistory: true);
                                  },
                                  child: Text(
                                    'Search',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterRow(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.darkGrey,
              ),
            ),
          ),
          SizedBox(width: 8),
          Flexible(
            flex: 3,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(color: AppColors.mediumGrey, fontSize: 14),
                  ),
                ),
                SizedBox(width: 3),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.mediumGrey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryInput(
    String label,
    TextEditingController controller,
    StateSetter setModalState,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: label,
          hintStyle: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => setModalState(() {}),
      ),
    );
  }

  void _showPositionPicker(
    BuildContext context,
    StateSetter setModalState,
    Function(String) onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final positions = [
          'UI/UX & Product Design',
          'Software Development',
          'Frontend Development',
          'Backend Development',
          'DevOps & Cloud Engineering',
        ];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Choose Job Position',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(height: 24, thickness: 1, color: Color(0xFFE5E7EB)),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      positions.map((position) {
                        return ListTile(
                          title: Text(position, style: TextStyle(fontSize: 15)),
                          onTap: () {
                            setModalState(() => onSelect(position));
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  void _showCityPicker(
    BuildContext context,
    StateSetter setModalState,
    Function(String) onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final cities = [
          'All places',
          'Jakarta',
          'Surabaya',
          'Bandung',
          'Bali',
          'Yogyakarta',
          'Medan',
        ];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Choose Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(height: 24, thickness: 1, color: Color(0xFFE5E7EB)),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      cities.map((city) {
                        return ListTile(
                          title: Text(city, style: TextStyle(fontSize: 15)),
                          onTap: () {
                            setModalState(() => onSelect(city));
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.fromLTRB(30, 70, 30, 10),
            child: Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                    controller: searchController,
                    hintText: 'Search your dream job here',
                    onChanged: (value) {
                      _applyFilters();
                    },
                    onSubmitted: (value) {
                      _applyFilters(addToHistory: true);
                    },
                  ),
                ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: _showFilterSheet,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE5E7EB), width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      LucideIcons.settings2,
                      color: AppColors.darkGrey,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // History search bubble - RESPONSIVE
          if (searchHistory.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 10,
                    runSpacing: 8,
                    children:
                        searchHistory.map((keyword) {
                          return GestureDetector(
                            onTap: () {
                              searchController.text = keyword;
                              _applyFilters();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 150),
                                    child: Text(
                                      keyword,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6B7280),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        searchHistory.remove(keyword);
                                      });
                                    },
                                    child: Icon(
                                      LucideIcons.circleX,
                                      size: 17,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          SizedBox(height: 10),
          if (!isLoading &&
              (searchController.text.isNotEmpty || _hasActiveFilters()))
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Row(
                      spacing: 2,
                      children: [
                        Flexible(
                          child: Text(
                            (searchController.text.isNotEmpty
                                    ? "${searchController.text}"
                                    : '') +
                                (_activeFilterText().isNotEmpty
                                    ? ' ${_activeFilterText()}'
                                    : ''),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        Text(
                          " Result",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.mediumGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${filteredJobs.length} Found',
                    style: TextStyle(
                      color: AppColors.mediumGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 16),

          // Results
          Expanded(
            child:
                isLoading
                    ? ListView.separated(
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 50),
                      itemCount: 8,
                      separatorBuilder: (_, __) => SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        return CardLoading(
                          height: 70,
                          borderRadius: BorderRadius.circular(16),
                        );
                      },
                    )
                    : filteredJobs.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.searchX,
                            size: 40,
                            color: AppColors.mediumGrey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No jobs found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mediumGrey,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Try adjusting your filters',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.mediumGrey,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.separated(
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 50),
                      itemCount: filteredJobs.length,
                      separatorBuilder: (_, __) => SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        return JobCard2(
                          job: filteredJobs[index],
                          showFullDetails: false,
                          onTap: () async {
                            final job = filteredJobs[index];
                            await context.push('/jobs-detail', extra: job);
                            setState(() {
                              final updatedJob = JobDataService.getAllJobs()
                                  .firstWhere(
                                    (j) => j.id == job.id,
                                    orElse: () => job,
                                  );
                              filteredJobs[index] = updatedJob;
                            });
                          },
                          onBookmarkTap:
                              () => _toggleBookmark(filteredJobs[index]),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
