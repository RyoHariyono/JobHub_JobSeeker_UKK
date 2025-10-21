import 'package:flutter/material.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:go_router/go_router.dart'; // Tambahkan import ini jika menggunakan GoRouter

class ConfirmationSendPage extends StatefulWidget {
  const ConfirmationSendPage({super.key});

  @override
  State<ConfirmationSendPage> createState() => _ConfirmationSendPageState();
}

class _ConfirmationSendPageState extends State<ConfirmationSendPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 5),
      () => context.go('/applications'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            spacing: 15,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo.png', width: 65, height: 65),
              Text(
                "You did it!",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
              Text(
                "Stay tuned — we'll notify you once there's an update.",
                style: TextStyle(
                  fontSize: 18,
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
