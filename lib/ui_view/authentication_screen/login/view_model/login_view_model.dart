import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/widget_string.dart';
import '../../../../services/user_session.dart';
import '../../../common_screens/dashboard/dashboard.dart';
import '../../../error_screen.dart';
import '../../Email_verification/email_verification.dart';

class LoginModel {
  final BuildContext context;
  final VoidCallback updateStateCallback;

  LoginModel(this.context, this.updateStateCallback);

  bool isLoading = false;
  late SharedPreferences logindata, checkdata;
  late bool newUser;

  // Method for user login
  Future<void> userLogin(String email, String password) async {
    try {
      updateStateCallback();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // Set login status to false
      logindata.setBool('login', false);
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        await checkIfAlreadyLogin();
      } else {
        // Redirect to verify email page if email is not verified
        Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const VerifyEmailPage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle login exceptions
      updateStateCallback();
      if (e.code == 'user-not-found') {
        // ignore: use_build_context_synchronously
        Utils.customErrorFlushBar(context, '$noUserFoundText $email.');
      } else if (e.code == 'wrong-password') {
        // ignore: use_build_context_synchronously
        Utils.customErrorFlushBar(context, passwordDidNotMatch);
      }
    }
  }

// Method to check if the user is already logged in
  Future<void> checkIfAlreadyLogin() async {
    final user = FirebaseAuth.instance.currentUser;
    logindata = await SharedPreferences.getInstance();
    newUser = (logindata.getBool('login') ?? true);
    if (newUser == false) {
      if (user != null) {
        final userId = user.uid;
        final userRef =
            FirebaseFirestore.instance.collection('Users').doc(userId);
        final userSnapshot = await userRef.get();

        if (userSnapshot.exists) {
          final roleId = userSnapshot.get('role_id') as String?;
          final roleRef =
              FirebaseFirestore.instance.collection('Role').doc(roleId);
          final roleSnapshot = await roleRef.get();
          if (roleSnapshot.exists) {
            final role = roleSnapshot.data()!;
            final roleName = role['role'];
            final roleID = role['role_id'];
            UserData.saveCurrentUserId(userId);
            currentLoginUserId = userId;
            UserData.saveRoleData(roleID, roleName);
            if (roleName.isNotEmpty) {
              // Redirect to dashboard upon successful login
              Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Dashboard(flushBarMessage: loginSuccessfullyText)));
            } else {
              // Redirect to error screen if role not found
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const ErrorScreen()));
            }
          } else {
            updateStateCallback();
            // ignore: use_build_context_synchronously
            Utils.customErrorFlushBar(context, roleNotFoundText);
          }
        } else {
          updateStateCallback();
          // ignore: use_build_context_synchronously
          Utils.customErrorFlushBar(context, '$noUserFoundText $email');
        }
      }
    }
  }
}
