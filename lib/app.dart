import 'package:flutter/material.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/application/application_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/home/home_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/profile/profile_page.dart';
import 'package:jobhub_jobseeker_ukk/app/modules/search/search_page.dart';
import 'package:jobhub_jobseeker_ukk/core/config/constans.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JobHub extends StatelessWidget {
  const JobHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomePageContent(),
    SearchPage(),
    ApplicationPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
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
              onTap: (value) => setState(() => currentIndex = value),
              currentIndex: currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Icon(
                      LucideIcons.house,
                      color:
                          currentIndex == 0
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
                          currentIndex == 1
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
                          currentIndex == 2
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
                          currentIndex == 3
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
