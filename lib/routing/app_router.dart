import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/application/application_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/home/home_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/jobs/Confirmation_send_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/jobs/job_detail_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/jobs/job_list_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/notification/notification_paga.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/profile/application_history_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/profile/education/add_education_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/profile/education/education_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/profile/profile_edit_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/profile/profile_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/profile/skillsPoortofolio/skills_portofolio_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/profile/upload_cv_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/search/search_page.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/data/models/job.dart';
import 'package:jobhub_jobseeker_ukk/data/models/company.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Bottom Navigation Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomePageContent(),
              ),
            ],
          ),
          // Search Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),
          // Saved Plans Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/applications',
                name: 'applications',
                builder: (context, state) => const ApplicationPage(),
              ),
            ],
          ),
          // Profile Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      // Routes without navbar - outside StatefulShellRoute
      GoRoute(
        path: '/jobs-popular-list',
        name: 'jobs-popular-list',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map) {
            return JobListPage(
              category: extra['category'] as JobCategory?,
              categoryTitle: extra['categoryTitle'] as String?,
            );
          }
          return const JobListPage();
        },
      ),
      GoRoute(
        path: '/jobs-detail',
        name: 'jobs-detail',
        builder: (context, state) {
          final job = state.extra as Job?;
          void _toggleBookmark(Job job) {
            // You can implement a global bookmark handler here if needed
          }
          if (job != null) {
            return JobDetailPage(job: job, onBookmarkToggle: _toggleBookmark);
          }
          // fallback dummy job if needed
          return JobDetailPage(
            job: Job(
              id: 'dummy',
              title: 'Unknown',
              company: Company(
                id: 'dummy_company',
                name: 'Unknown',
                logoUrl: 'assets/images/apple_icon.png',
                location: 'Unknown',
                description: 'No company description.',
              ),
              category: JobCategory.softwareDevelopment,
              type: JobType.fullTime,
              location: 'Unknown',
              minSalary: 0,
              maxSalary: 0,
              description: 'No description available.',
              requirements: [],
              postedDate: DateTime.now(),
              deadlineDate: DateTime.now(),
            ),
            onBookmarkToggle: _toggleBookmark,
          );
        },
        routes: [
          GoRoute(
            path: '/confirmation-send',
            name: 'confirmation-send',
            builder: (context, state) => const ConfirmationSendPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/notification',
        name: 'notification',
        builder: (context, state) => const NotificationPaga(),
      ),
      GoRoute(
        path: '/upload-cv',
        name: 'upload-cv',
        builder: (context, state) => const UploadCvPage(),
      ),
      GoRoute(
        path: '/profile-edit',
        name: 'profile-edit',
        builder: (context, state) => ProfileEditPage(),
      ),
      GoRoute(
        path: '/application-history',
        name: 'application-history',
        builder: (context, state) => ApplicationHistoryPage(),
      ),
      GoRoute(
        path: '/education',
        name: 'education',
        builder: (context, state) => EducationPage(),
        routes: [
          GoRoute(
            path: '/add-education',
            name: 'add-education',
            builder: (context, state) => AddEducationPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/skills-portofolio',
        name: 'skills-portofolio',
        builder: (context, state) => SkillsPortofolioPage(),
        // routes: [
        //   GoRoute(
        //     path: '/add-skills-portofolio',
        //     name: 'add-skills-portofolio',
        //     builder: (context, state) => AddEducationPage(),
        //   ),
        // ],
      ),
    ],
  );
}

// Bottom Navigation Bar Widget
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        height: 100,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.primaryBlue,
              unselectedItemColor: const Color(0xFF6B7280),
              selectedLabelStyle: const TextStyle(
                fontSize: 11,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 11,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
              onTap: (index) => navigationShell.goBranch(index),
              currentIndex: navigationShell.currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Icon(
                      LucideIcons.house,
                      color:
                          navigationShell.currentIndex == 0
                              ? AppColors.primaryBlue
                              : const Color(0xFF6B7280),
                      size: 24,
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Icon(
                      LucideIcons.search,
                      color:
                          navigationShell.currentIndex == 1
                              ? AppColors.primaryBlue
                              : const Color(0xFF6B7280),
                      size: 24,
                    ),
                  ),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Icon(
                      LucideIcons.bookmark,
                      color:
                          navigationShell.currentIndex == 2
                              ? AppColors.primaryBlue
                              : const Color(0xFF6B7280),
                      size: 24,
                    ),
                  ),
                  label: 'Applications',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Icon(
                      LucideIcons.user,
                      color:
                          navigationShell.currentIndex == 3
                              ? AppColors.primaryBlue
                              : const Color(0xFF6B7280),
                      size: 24,
                    ),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
