import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/widget_button.dart';
import '../../../../helper/widget_string.dart';
import '../../../services/user_session.dart';
import '../login/View/login_page.dart';

class VerifyEmailPage extends StatefulWidget {
  final String? flushBarMessage;
  const VerifyEmailPage({super.key, this.flushBarMessage});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResentEmail = false;
  final _isLoading = false;
  Timer? timer;

  @override
  void initState() {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
    // Check if flushBarMessage is not null, then display FlushBar
    if (widget.flushBarMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Utils.customFlushBar(context, widget.flushBarMessage!);
      });
    }
    super.initState();
  }

  // Check if the email has been verified
  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // Send verification email
  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResentEmail = false);
      await Future.delayed(const Duration(seconds: 10));
      setState(() => canResentEmail = true);
    } catch (error) {
      Utils.customFlushBar(
        // ignore: use_build_context_synchronously
        context, error.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const LoginPage()
      : PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            Utils.onBackpressed(context);
          },
          child: Scaffold(
            appBar: CustomAppBar(title: verifyEmailText),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        'A verification email has been sent to your email',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center),
                    const GlobalSizedBox(),
                    CustomButton(
                        minWidth: double.infinity,
                        height: 52,
                        Onpressed:
                            canResentEmail ? sendVerificationEmail : null,
                        Display_Name: resentEmailButtonText,
                        Loading: _isLoading),
                    const GlobalSizedBox(height: 8),
                    CustomButton(
                        minWidth: double.infinity,
                        height: 52,
                        Onpressed: () async {
                          UserData.clearUserData();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginPage()));
                        },
                        Display_Name: cancelButtonText,
                        Loading: _isLoading),
                  ]),
            ),
          ),
        );
}
