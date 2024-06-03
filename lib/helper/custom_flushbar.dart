import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'color.dart';
import 'custom_icons.dart';
import 'text_controller_focus_node.dart';

class Utils {
  // Method to display a custom Flushbar with a success message.
  static Flushbar customFlushBar(BuildContext context, String text) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      message: text,
      messageSize: 16,
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.flushbarBgColor,
      leftBarIndicatorColor: AppColors.whiteColor,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(8),
      forwardAnimationCurve: Curves.easeOutQuart,
      reverseAnimationCurve: Curves.easeInQuart,
      flushbarStyle: FlushbarStyle.GROUNDED,
    )..show(context);
  }

  // Method to display a custom Flushbar with an error message.
  static Flushbar customErrorFlushBar(BuildContext context, String text) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(AppIcons.warningDetailsIcon,
          color: AppColors.flushbarAlertTextColor),
      message: text,
      messageSize: 16,
      duration: const Duration(seconds: 5),
      backgroundColor: AppColors.flushbarAlertBgColor,
      leftBarIndicatorColor: AppColors.whiteColor,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(8),
      forwardAnimationCurve: Curves.easeOutQuart,
      reverseAnimationCurve: Curves.easeInQuart,
      flushbarStyle: FlushbarStyle.FLOATING,
    )..show(context);
  }

  // Method to handle back button pressed event.
  static Future<bool> onBackpressed(BuildContext context) async {
    bool exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text("Are you sure you want to leave this app?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => exit(0),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
    return exitApp;
  }

  // Method to store the current timestamp.
  static DateTime storeCurrentTimestamp() {
    DateTime now = DateTime.now();
    return now;
  }

  // Method to clear text fields specified in the list.
  static void clearTextFields(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      controller.clear();
    }
  }

  // Method to clear all text fields.
  static void clearAllTextFields() {
    confirmPasswordController.clear();
    confirmPasswordController.clear();
    userNameController.clear();
    passwordController.clear();
    emailController.clear();
    userCelDescController.clear();
    userCelNameController.clear();
    dateCtl.clear();
    userTimeInput.clear();
    userEmailController.clear();
    userRoomNameController.clear();
    contributionNameController.clear();
    userDescController.clear();
    userAmountController.clear();
    expenseNameController.clear();
    userRoleController.clear();
    userRoomDescController.clear();
    searchFilter.clear();
  }
}
