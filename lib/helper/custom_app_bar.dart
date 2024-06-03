import 'package:flutter/material.dart';

import 'color.dart';

// Custom AppBar widget

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? leadingOnPressed;
  final VoidCallback? trailingOnPressed;
  final IconData? trailingIcon;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leadingOnPressed,
    this.trailingOnPressed,
    this.trailingIcon,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    double? scrolledUnderElevation;
    return AppBar(
      // Title
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.appbartextColor,
              fontSize: 24,
            ),
          ),
        ],
      ),
      // Background and foreground colors
      surfaceTintColor: AppColors.whiteColor,
      backgroundColor: AppColors.appbarColor,
      foregroundColor: AppColors.appbartextColor,
      // Elevation
      scrolledUnderElevation: scrolledUnderElevation,
      elevation: 2,
      // Leading icon button
      leading: leadingOnPressed != null
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.appbariconColor,
              ),
              onPressed: leadingOnPressed,
            )
          : null,
      // Trailing icon button
      actions: trailingIcon != null && trailingOnPressed != null
          ? [
              IconButton(
                icon: Icon(
                  trailingIcon,
                  color: AppColors.appbariconColor,
                ),
                onPressed: trailingOnPressed,
              ),
            ]
          : null,
    );
  }
}
