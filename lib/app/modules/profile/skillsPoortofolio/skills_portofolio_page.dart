import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/bottom_button.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SkillsPortofolioPage extends StatelessWidget {
  const SkillsPortofolioPage({super.key});

  // Responsive methods (follow pattern from profile_edit_page)
  double _getTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 18;
    if (width > 600) return 16;
    return 16;
  }

  double _getLabelFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 15;
    if (width > 600) return 14.5;
    return 14;
  }

  double _getBodyFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 14.5;
    if (width > 600) return 13.5;
    return 12;
  }

  double _getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 120;
    if (width > 768) return 80;
    if (width > 600) return 50;
    return 30;
  }

  double _getButtonFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 16;
    if (width > 600) return 15.5;
    return 16;
  }

  Widget _skillChip(String Skills, context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.primaryBlue,
      ),
      child: Text(
        Skills,
        style: TextStyle(
          fontSize: _getBodyFontSize(context),
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
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
        title: Text(
          "Portofolio & skills",
          style: TextStyle(
            fontSize: _getTitleFontSize(context),
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          30,
          _getHorizontalPadding(context),
          30,
          _getHorizontalPadding(context),
        ),
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
                          LucideIcons.satellite,
                          color: AppColors.primaryBlue,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 3,
                          children: [
                            Text(
                              "JobHub",
                              style: TextStyle(
                                fontSize: _getLabelFontSize(context),
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            Text(
                              "A platform help us to find a perfect job for you based on your skills and preferences.",
                              style: TextStyle(
                                fontSize: _getBodyFontSize(context),
                                fontWeight: FontWeight.w400,
                                color: AppColors.mediumGrey,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _skillChip("UI/UX Design", context),
                      _skillChip("Flutter Dev", context),
                      _skillChip("Web Dev", context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomButton(
        label: 'Add Portofolio',
        onPressed: () => context.go('/skills-portofolio/add-skills-portofolio'),
      ),
    );
  }
}
