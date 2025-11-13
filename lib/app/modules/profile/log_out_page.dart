import 'package:flutter/material.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/data/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class LogOutPage extends StatefulWidget {
  const LogOutPage({super.key});

  @override
  State<LogOutPage> createState() => _LogOutPageState();
}

class _LogOutPageState extends State<LogOutPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _handleLogout();
  }

  Future<void> _handleLogout() async {
    try {
      await _authService.signOut();
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        context.go('/');
      }
    }
  }

  // Responsive font size untuk title
  double _getTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 50;
    if (width > 600) return 45;
    if (width > 400) return 40;
    return 35;
  }

  // Responsive font size untuk subtitle
  double _getSubtitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 20;
    if (width > 600) return 19;
    if (width > 400) return 18;
    return 16;
  }

  // Responsive logo size
  double _getLogoSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 80;
    if (width > 600) return 75;
    if (width > 400) return 65;
    return 55;
  }

  // Responsive spacing
  double _getSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 20;
    if (width > 600) return 18;
    if (width > 400) return 15;
    return 12;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Column(
                  spacing: 15,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: _getLogoSize(context),
                      height: _getLogoSize(context),
                    ),
                    Text(
                      "You've been signed out. \nSee you again soon!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Text(
                  "JobHub",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
