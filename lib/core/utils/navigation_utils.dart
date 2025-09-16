// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class NavigationUtils {
//   /// Safely pops the current route if possible, otherwise navigates to home
//   static void safePopOrGoHome(BuildContext context) {
//     if (GoRouter.of(context).canPop()) {
//       context.pop();
//     } else {
//       context.goNamed('home');
//     }
//   }

//   /// Safely pops the current route if possible, otherwise navigates to specified fallback
//   static void safePopOrGoTo(BuildContext context, String fallbackRoute) {
//     if (GoRouter.of(context).canPop()) {
//       context.pop();
//     } else {
//       context.goNamed(fallbackRoute);
//     }
//   }

//   /// Check if navigation can pop
//   static bool canPop(BuildContext context) {
//     return GoRouter.of(context).canPop();
//   }
// }
