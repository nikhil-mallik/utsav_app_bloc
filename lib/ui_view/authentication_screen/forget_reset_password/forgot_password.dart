import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/custom_text_field.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/validation.dart';
import '../../../../helper/color.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/widget_button.dart';
import '../../../../helper/widget_string.dart';
import '../login/View/login_page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  var email = '';
  final _isLoading = false;

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.appbarColor,
          content: Text('Reset password link has been sent in email',
              style:
                  TextStyle(fontSize: 18.0, color: AppColors.appbartextColor)),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        Utils.onBackpressed(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: const CustomAppBar(title: 'Reset Profile'),
        body: Container(
          alignment: Alignment.center,
          child: SizedBox(
            width: GlobalWidthValues.multiplyWidth(.98, context),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.all(10)),
                  const Text('Reset password link will be sent to your email!',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  const GlobalSizedBox(height: 10),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 30),
                        child: ListView(children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: CustomTextField(
                                controller: emailController,
                                focusNode: emailFocusNode,
                                labelText: 'Email',
                                hintText: 'Enter your mail',
                                prefixIcon: AppIcons.userMailIcon,
                                validator: validateEmail),
                          ),
                          const GlobalSizedBox(height: 10),
                          SizedBox(
                            width: GlobalWidthValues.getWidth(context),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                      width: GlobalWidthValues.multiplyWidth(
                                          .4, context),
                                      child: CustomButton(
                                          minWidth: double.infinity,
                                          height: 52,
                                          Onpressed: () {
                                            // Validate returns true if the form is valid, otherwise false.
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                email = emailController.text;
                                              });
                                              resetPassword();
                                              Utils.clearTextFields(
                                                  [emailController]);
                                            }
                                          },
                                          Display_Name: "Send Email",
                                          Loading: _isLoading)),
                                  const Padding(
                                      padding: EdgeInsets.only(
                                          left: 1.0, right: 1.0)),
                                  SizedBox(
                                    width: GlobalWidthValues.multiplyWidth(
                                        .4, context),
                                    child: CustomButton(
                                        minWidth: double.infinity,
                                        height: 52,
                                        Onpressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage(),
                                            ),
                                          );
                                        },
                                        Display_Name: "Login",
                                        Loading: _isLoading),
                                  ),
                                ]),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
