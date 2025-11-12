import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/bottom_button.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/textfield.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// List of all available skills
final List<String> allSkills = [
  'Flutter Dev',
  'UI/UX Design',
  'Web Dev',
  'React',
  'Vue.js',
  'Angular',
  'Node.js',
  'Python',
  'Java',
  'C++',
  'JavaScript',
  'TypeScript',
  'CSS',
  'HTML',
  'SQL',
  'MongoDB',
  'Firebase',
  'AWS',
  'Docker',
  'Git',
  'Figma',
  'Adobe XD',
  'Photoshop',
  'Illustrator',
  'Mobile Development',
  'Backend Development',
  'Frontend Development',
  'Full Stack',
  'API Development',
  'Database Design',
];

class AddPortofolioSkillsPage extends StatefulWidget {
  const AddPortofolioSkillsPage({super.key});

  @override
  State<AddPortofolioSkillsPage> createState() =>
      _AddPortofolioSkillsPageState();
}

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
  return 15;
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

class _AddPortofolioSkillsPageState extends State<AddPortofolioSkillsPage> {
  late TextEditingController projectNameController;
  late TextEditingController skillsController;
  List<String> selectedSkills = [];
  List<String> suggestedSkills = [];

  @override
  void initState() {
    super.initState();
    projectNameController = TextEditingController();
    skillsController = TextEditingController();
    skillsController.addListener(_onSkillsChanged);
  }

  @override
  void dispose() {
    projectNameController.dispose();
    skillsController.dispose();
    super.dispose();
  }

  void _onSkillsChanged() {
    final query = skillsController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        suggestedSkills = [];
      } else {
        suggestedSkills =
            allSkills
                .where(
                  (skill) =>
                      skill.toLowerCase().contains(query) &&
                      !selectedSkills.contains(skill),
                )
                .take(5)
                .toList();
      }
    });
  }

  void _addSkill(String skill) {
    setState(() {
      if (!selectedSkills.contains(skill)) {
        selectedSkills.add(skill);
        skillsController.clear();
        suggestedSkills = [];
      }
    });
  }

  void _removeSkill(String skill) {
    setState(() {
      selectedSkills.remove(skill);
    });
  }

  void _showSuccessDialog() {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 400 ? 343.0 : screenWidth * 0.85;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Container(
              width: dialogWidth,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure to add ${projectNameController.text}?",
                    style: TextStyle(
                      fontSize: screenWidth > 360 ? 16 : 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGrey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your portfolio will be updated and visible to employers.",
                    style: TextStyle(
                      fontSize: screenWidth > 360 ? 14 : 12,
                      fontWeight: FontWeight.normal,
                      color: AppColors.mediumGrey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () => context.go('/skills-portofolio'),
                          child: Text(
                            "I'm sure",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth > 360 ? 14 : 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.primaryBlue,
                              width: 2,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: screenWidth > 360 ? 14 : 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
          onPressed: () => context.go('/skills-portofolio'),
        ),
        title: Text(
          "Add portofolio & skills",
          style: TextStyle(
            fontSize: _getLabelFontSize(context) + 2,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          _getHorizontalPadding(context),
          30,
          _getHorizontalPadding(context),
          35,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                spacing: 25,
                children: [
                  CustomTextField(
                    label: "Project name",
                    hintText: "e.g. JobHub Mobile App",
                    controller: projectNameController,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        label: "Skills",
                        hintText: "Add skills here",
                        controller: skillsController,
                      ),

                      // Suggestions list di bawahnya
                      if (suggestedSkills.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children:
                                suggestedSkills.map((skill) {
                                  return GestureDetector(
                                    onTap: () => _addSkill(skill),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Color(0xFFE5E7EB),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              skill,
                                              style: TextStyle(
                                                fontSize: _getBodyFontSize(
                                                  context,
                                                ),
                                                color: AppColors.darkGrey,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      if (selectedSkills.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Wrap(
                            spacing: 15,
                            runSpacing: 8,
                            children:
                                selectedSkills.map((skill) {
                                  return Chip(
                                    label: Text(
                                      skill,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: AppColors.primaryBlue,
                                    deleteIcon: Icon(
                                      LucideIcons.circleX,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    onDeleted: () => _removeSkill(skill),
                                  );
                                }).toList(),
                          ),
                        ),
                    ],
                  ),
                  CustomTextField(
                    label: "Description",
                    hintText: "Add description",
                    maxLines: 4,
                  ),
                  Divider(height: 0, color: Color(0xFFE5E7EB)),
                  Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 6,
                        children: [
                          Text(
                            "Links",
                            style: TextStyle(
                              fontSize: _getLabelFontSize(context),
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          Text(
                            "right now",
                            style: TextStyle(
                              fontSize: _getBodyFontSize(context),
                              fontWeight: FontWeight.w500,
                              color: AppColors.mediumGrey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
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
                        child: TextField(
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkGrey,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: "https://",
                            hintStyle: TextStyle(
                              fontSize: _getBodyFontSize(context),
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF666666),
                            ),
                            prefixIcon: Icon(
                              LucideIcons.link,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomButton(
        label: 'Add portofolio & skills',
        onPressed: () {
          _showSuccessDialog();
        },
      ),
    );
  }
}
