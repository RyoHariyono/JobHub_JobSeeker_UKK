import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

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
        title: Text(
          "Education",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 35),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
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
                spacing: 15,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          LucideIcons.school,
                          color: AppColors.primaryBlue,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 3,
                        children: [
                          Text(
                            "SMK Telkom Malang",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkGrey,
                            ),
                          ),
                          Text(
                            "Computer and Network Engineering",
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
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primaryBlue,
                        ),
                        child: Text(
                          "2017 - 2021",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primaryBlue,
                        ),
                        child: Text(
                          "GPA 9.4",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 50),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            padding: EdgeInsets.symmetric(vertical: 17),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed: () {},
          child: Text(
            "Add education",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
