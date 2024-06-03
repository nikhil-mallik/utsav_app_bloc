import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/validation.dart';
import '../../../../helper/color.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/widget_string.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Utils.customFlushBar(
      // ignore: use_build_context_synchronously
          context, 'Reset password link has been sent in $email');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // ignore: use_build_context_synchronously
        Utils.customErrorFlushBar(context, '$noUserFoundText $email');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Utils.clearAllTextFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
          title: resetPasswordText,
          leadingOnPressed: () => Navigator.pop(context)),
      body: Container(
        color: AppColors.bgColor,
        alignment: Alignment.center,
        child: SizedBox(
          width: GlobalWidthValues.multiplyWidth(.98, context),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Padding(padding: EdgeInsets.all(10)),
            Text(resetPasswordLinkSent,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold)),
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: ListView(children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                          autofocus: false,
                          decoration: InputDecoration(
                              labelText: emailLabelText,
                              labelStyle: const TextStyle(fontSize: 20.0),
                              border: const OutlineInputBorder(),
                              errorStyle: const TextStyle(
                                  color: Colors.redAccent, fontSize: 15)),
                          controller: emailController,
                          validator: validateEmail),
                    ),
                    const GlobalSizedBox(height: 10),
                    Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, otherwise false.
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    email = emailController.text;
                                  });
                                  resetPassword();
                                  Utils.clearTextFields([emailController]);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: AppColors.textColor,
                                backgroundColor: AppColors.submitbuttonColor,
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              child: Text(sendEmailText),
                            ),
                            const GlobalSizedBox(height: 0, width: 10),
                            // Row(
                            //   children: [
                            //     ElevatedButton(
                            //       onPressed: () => {
                            //         Navigator.pushAndRemoveUntil(
                            //             context,
                            //             PageRouteBuilder(
                            //               pageBuilder: (context, a, b) =>
                            //               const LoginPage(),
                            //               transitionDuration: const Duration(
                            //                 seconds: 0,
                            //               ),
                            //             ),
                            //                 (route) => false)
                            //       },
                            //       style: ElevatedButton.styleFrom(
                            //         foregroundColor: AppColors.textColor,
                            //         backgroundColor:
                            //         AppColors.submitbuttonColor,
                            //         textStyle: const TextStyle(
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //       child: const Text(
                            //         "Login",
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ]),
                    ]),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
