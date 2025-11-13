import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/data/services/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Delay untuk splash screen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check auth status
    if (_authService.isLoggedIn) {
      context.go('/');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo atau Icon
            Image.asset('assets/images/logo.png', width: 65, height: 65),
            const SizedBox(height: 15),
            const Text(
              'JobHub',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
