import 'package:flutter/material.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
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
                      "Are you sure you want to log out?",
                      style: TextStyle(
                        fontSize: screenWidth > 360 ? 16 : 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGrey,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "We'll be here whenever you're ready to come back!",
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
                            onPressed: () => context.go('/log-out'),
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 50),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      _ProfileAvatar(width: width),
                      SizedBox(height: 8),
                      _ProfileNameEmail(
                        name: 'Ryo',
                        email: 'ryo@gmail.com',
                        width: width,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                _StatsCard(width: width),

                SizedBox(height: 40),

                GestureDetector(
                  onTap: () => context.go('/upload-cv'),
                  child: _UploadCvRow(
                    filename: 'Ryo_Hariyono_Angwyn.pdf',
                    width: width,
                  ),
                ),

                SizedBox(height: 15),

                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF5F7394).withOpacity(0.10),
                        offset: Offset(2, 2),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => context.go('/profile-edit'),
                        child: _MenuItem(
                          icon: LucideIcons.user,
                          title: 'Profile',
                          width: width,
                          borderBottom: true,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/applications'),
                        child: _MenuItem(
                          icon: LucideIcons.bookmark,
                          title: 'Favorite jobs',
                          width: width,
                          borderBottom: true,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/application-history'),
                        child: _MenuItem(
                          icon: LucideIcons.history,
                          title: 'Application history',
                          width: width,
                          borderBottom: true,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/education'),
                        child: _MenuItem(
                          icon: LucideIcons.school,
                          title: 'Education',
                          width: width,
                          borderBottom: true,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/skills-portofolio'),
                        child: _MenuItem(
                          icon: LucideIcons.rocket,
                          title: 'Portofolio & skills',
                          width: width,
                          borderBottom: true,
                        ),
                      ),
                      _MenuItem(
                        icon: LucideIcons.settings,
                        title: 'Settings',
                        width: width,
                        borderBottom: true,
                      ),
                      GestureDetector(
                        onTap: () {
                          _showSuccessDialog();
                        },
                        child: _MenuItem(
                          icon: LucideIcons.logOut,
                          title: 'Log Out',
                          width: width,
                          borderBottom: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final double width;
  const _ProfileAvatar({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = width < 350 ? 70.0 : 90.0;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/profile_picture.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => Container(
                width: size,
                height: size,
                color: AppColors.mediumGrey,
                alignment: Alignment.center,
                child: Icon(
                  Icons.person,
                  size: size * 0.53,
                  color: AppColors.darkGrey,
                ),
              ),
        ),
      ),
    );
  }
}

class _ProfileNameEmail extends StatelessWidget {
  final String name;
  final String email;
  final double width;

  const _ProfileNameEmail({
    Key? key,
    required this.name,
    required this.email,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameFontSize = width < 350 ? 18.0 : 20.0;
    final emailFontSize = width < 350 ? 12.0 : 14.0;

    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: nameFontSize,
            fontWeight: FontWeight.w700,
            color: AppColors.darkGrey,
          ),
        ),
        SizedBox(height: 5),
        Text(
          email,
          style: TextStyle(
            fontSize: emailFontSize,
            fontWeight: FontWeight.normal,
            color: AppColors.mediumGrey,
          ),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  final double width;
  const _StatsCard({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labelFontSize = width < 350 ? 12.0 : 14.0;
    final valueFontSize = width < 350 ? 12.0 : 14.0;
    final cardHeight = width < 350 ? 70.0 : 78.0;
    final horizontalPadding = width < 350 ? 8.0 : 15.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      height: cardHeight,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Applied',
                  style: TextStyle(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGrey,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '1 Jobs',
                  style: TextStyle(
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1.5, height: cardHeight, color: Color(0xFFF7F7F9)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGrey,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '3 Jobs',
                  style: TextStyle(
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1.5, height: cardHeight, color: Color(0xFFF7F7F9)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Last applied',
                  style: TextStyle(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Sep 9, 2025',
                    style: TextStyle(
                      fontSize: valueFontSize,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadCvRow extends StatelessWidget {
  final String filename;
  final double width;

  const _UploadCvRow({Key? key, required this.filename, required this.width})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filenameFontSize = width < 350 ? 12.0 : 14.0;
    final buttonFontSize = width < 350 ? 10.0 : 12.0;
    final buttonPaddingH = width < 350 ? 6.0 : 10.0;
    final buttonPaddingV = width < 350 ? 5.0 : 7.0;
    final iconSize = width < 350 ? 13.0 : 15.0;
    final containerPaddingH = width < 350 ? 12.0 : 19.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: containerPaddingH,
        vertical: 12,
      ),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              filename,
              style: TextStyle(
                fontSize: filenameFontSize,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGrey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: buttonPaddingH,
              vertical: buttonPaddingV,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryBlue),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                  'Upload new CV',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: buttonFontSize,
                  ),
                ),
                SizedBox(width: 6),
                Icon(
                  LucideIcons.upload,
                  size: iconSize,
                  color: AppColors.primaryBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final double width;
  final bool borderBottom;

  const _MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.width,
    required this.borderBottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconSize = width < 350 ? 18.0 : 20.0;
    final fontSize = width < 350 ? 14.0 : 16.0;
    final chevronSize = width < 350 ? 20.0 : 24.0;
    final horizontalPadding = width < 350 ? 12.0 : 19.0;
    final verticalPadding = width < 350 ? 13.0 : 16.0;
    final spacing = width < 350 ? 12.0 : 16.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom:
              borderBottom
                  ? BorderSide(color: Color(0xFFE5E7EB), width: 1)
                  : BorderSide.none,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(icon, size: iconSize, color: AppColors.primaryBlue),
                SizedBox(width: spacing),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            LucideIcons.chevronRight,
            size: chevronSize,
            color: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }
}
