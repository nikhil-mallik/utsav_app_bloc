// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/widget_string.dart';
import '../../../services/user_session.dart';
import '../../authentication_screen/login/View/login_page.dart';
import '../../common_screens/dashboard/dashboard.dart';
import '../../error_screen.dart';

class SplashViewModel {
  final user = FirebaseAuth.instance.currentUser;
  late SharedPreferences logindata, checkdata;
  late bool newUser;

  // Method to check if the user is already logged in
  Future<void> check_if_already_login(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    final logindata = await SharedPreferences.getInstance();
    final newUser = (logindata.getBool('login') ?? true);
    currentLoginUserId = await UserData.getCurrentUserId();
    Map<String, String> roleData = await UserData.getRoleData();
    String roleName = roleData['roleName'] ?? '';
    if (newUser == false) {
      if (user != null) {
        if (roleName.isNotEmpty) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Dashboard()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ErrorScreen()));
        }
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }
}
