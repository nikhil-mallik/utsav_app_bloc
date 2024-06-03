import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/widget_string.dart';
import '../../Email_verification/email_verification.dart';

class SignUpModel {
  final BuildContext context;
  final VoidCallback updateStateCallback;
  SignUpModel(this.context, this.updateStateCallback);

  final dbRef = FirebaseFirestore.instance.collection('Users');
  final roleId = "wEXDVTBPg0Fe9Hh4Oywu";
  bool isLoading = false;

  // Method for user sign up
  Future<void> userSignUp(String email, String password) async {
    // Check if user with provided email already exists
    final signInMethods =
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    if (signInMethods.isNotEmpty) {
      // User already exists
      updateStateCallback();
      // User already exists
      // ignore: use_build_context_synchronously
      Utils.customErrorFlushBar(context, 'Email already exists');

      return;
    }
    try {
      updateStateCallback();
      // Create user account with email and password
      final authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String userId = authResult.user!.uid.toString();

      // Add user data to Firestore
      dbRef.doc(userId).set({
        'uid': userId,
        'u_name': name.toString(),
        'email': authResult.user!.email.toString(),
        'role_id': roleId,
        'u_img': '',
        'age': '',
        'number': '',
        'gender': 'Male',
        // Default gender for new users
      }).then((_) {
        // Redirect to verify email page
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const VerifyEmailPage(flushBarMessage: 'Verify your email'),
            ));
      }).onError((error, stackTrace) {
        updateStateCallback();
        Utils.customErrorFlushBar(context, error.toString());
      });
    } catch (error) {
      // Handle sign up errors
      updateStateCallback();
      // ignore: use_build_context_synchronously
      Utils.customErrorFlushBar(context, error.toString());
    }
  }
}
