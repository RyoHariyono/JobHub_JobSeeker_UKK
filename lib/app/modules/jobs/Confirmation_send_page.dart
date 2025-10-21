import 'package:flutter/material.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:go_router/go_router.dart';

class ConfirmationSendPage extends StatefulWidget {
  const ConfirmationSendPage({super.key});

  @override
  State<ConfirmationSendPage> createState() => _ConfirmationSendPageState();
}

class _ConfirmationSendPageState extends State<ConfirmationSendPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        context.go('/applications');
      }
    });
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
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            spacing: _getSpacing(context),
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: _getLogoSize(context),
                height: _getLogoSize(context),
              ),
              Text(
                "You did it!",
                style: TextStyle(
                  fontSize: _getTitleFontSize(context),
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
              Text(
                "Stay tuned — we'll notify you once there's an update.",
                style: TextStyle(
                  fontSize: _getSubtitleFontSize(context),
                  fontWeight: FontWeight.normal,
                  color: AppColors.mediumGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
