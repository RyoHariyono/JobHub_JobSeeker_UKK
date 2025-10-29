import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';

class AppToast {
  // Success Toast
  static void showSuccess(
    BuildContext context, {
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: duration,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGrey,
        ),
      ),
      description:
          description != null
              ? Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.mediumGrey,
                ),
              )
              : null,
      alignment: Alignment.topCenter,
      primaryColor: Colors.green,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.darkGrey,
      icon: Icon(LucideIcons.circleCheck, color: Colors.green, size: 24),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      showIcon: true,
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: Colors.green.withOpacity(0.5),
      ),
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  // Error Toast
  static void showError(
    BuildContext context, {
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: duration,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      description:
          description != null
              ? Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                ),
              )
              : null,
      alignment: Alignment.topCenter,
      primaryColor: Colors.red,
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      icon: Icon(Icons.error, color: Colors.white, size: 24),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: Colors.white.withOpacity(0.3),
      ),
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  // Warning Toast
  static void showWarning(
    BuildContext context, {
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: duration,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      description:
          description != null
              ? Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                ),
              )
              : null,
      alignment: Alignment.topCenter,
      primaryColor: Colors.orange,
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      icon: Icon(Icons.warning, color: Colors.white, size: 24),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: Colors.white.withOpacity(0.3),
      ),
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  // Info Toast
  static void showInfo(
    BuildContext context, {
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: duration,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      description:
          description != null
              ? Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                ),
              )
              : null,
      alignment: Alignment.topCenter,
      primaryColor: AppColors.primaryBlue,
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      icon: Icon(Icons.info, color: Colors.white, size: 24),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: Colors.white.withOpacity(0.3),
      ),
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  // Custom Toast with custom color
  static void showCustom(
    BuildContext context, {
    required String title,
    String? description,
    required Color color,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: duration,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      description:
          description != null
              ? Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                ),
              )
              : null,
      alignment: Alignment.topCenter,
      primaryColor: color,
      backgroundColor: color,
      foregroundColor: Colors.white,
      icon: Icon(icon, color: Colors.white, size: 24),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: Colors.white.withOpacity(0.3),
      ),
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }
}

// ============================================
// EXAMPLE USAGE IN YOUR UPLOAD CV PAGE:
// ============================================

/*
// Import the toast component
import 'path/to/app_toast.dart';

// In your _onEditPressed() method, replace the SnackBar with:
onPressed: () {
  Navigator.of(context).pop();
  
  // Show success toast
  AppToast.showSuccess(
    context,
    title: 'CV Uploaded Successfully!',
    description: 'Your CV has been saved and ready to use.',
  );
  
  // TODO: Save CV to backend/storage
},

// Or for error handling:
catch (e) {
  AppToast.showError(
    context,
    title: 'Upload Failed',
    description: 'Failed to upload CV. Please try again.',
  );
}

// Or for info:
AppToast.showInfo(
  context,
  title: 'Processing',
  description: 'Your CV is being processed...',
);

// Or for warning:
AppToast.showWarning(
  context,
  title: 'File Size Warning',
  description: 'Your CV file is larger than recommended.',
);

// Or custom:
AppToast.showCustom(
  context,
  title: 'Custom Message',
  description: 'This is a custom toast notification.',
  color: Colors.purple,
  icon: Icons.star,
);
*/
