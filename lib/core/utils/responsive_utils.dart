import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Responsive layout utilities using breakpoints.
class ResponsiveUtils {
  ResponsiveUtils._();

  /// Returns true if screen width >= breakpointSm.
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < AppTheme.breakpointSm;

  /// Returns true if screen width >= breakpointSm and < breakpointMd.
  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= AppTheme.breakpointSm && w < AppTheme.breakpointMd;
  }

  /// Returns true if screen width >= breakpointMd.
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppTheme.breakpointMd;

  /// Returns responsive padding based on screen size.
  static EdgeInsets screenPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= AppTheme.breakpointLg) {
      return const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
    }
    if (w >= AppTheme.breakpointMd) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    }
    if (w >= AppTheme.breakpointSm) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  }

  /// Returns number of columns for a grid based on screen width.
  static int gridCrossAxisCount(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= AppTheme.breakpointLg) return 4;
    if (w >= AppTheme.breakpointMd) return 3;
    if (w >= AppTheme.breakpointSm) return 2;
    return 1;
  }

  /// Returns max content width for centered layouts.
  static double maxContentWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= AppTheme.breakpointLg) return 1200;
    if (w >= AppTheme.breakpointMd) return 900;
    return w;
  }
}
