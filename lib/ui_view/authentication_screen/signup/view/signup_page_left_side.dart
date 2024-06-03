import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/custom_text_field.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/validation.dart';
import '../../../../helper/widget_button.dart';
import '../../../../helper/widget_string.dart';
import '../../login/View/login_page.dart';
import '../view_model/sign_up_view_model.dart';

class SignUpPageLeftSide extends StatefulWidget {
  const SignUpPageLeftSide({super.key});

  @override
  State<SignUpPageLeftSide> createState() => _SignUpPageLeftSideState();
}

class _SignUpPageLeftSideState extends State<SignUpPageLeftSide> {
  final _formKey = GlobalKey<FormState>();
  late SignUpModel signUpModel;

  final ValueNotifier<bool> obsecurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> obsecurePassword2 = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    Utils.clearAllTextFields();
    signUpModel = SignUpModel(context, () {
      signUpModel.isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/gateway.png', width: 70),
                    const GlobalSizedBox(width: 10),
                    Text(signUpTitleText,
                        style: const TextStyle(
                            fontSize: 28,
                            color: AppColors.loginBtnColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(10)),
                const Text("Please Sign Up to create your account!",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                const Padding(padding: EdgeInsets.all(10)),
                CustomTextField(
                    controller: userNameController,
                    focusNode: userNameFocusNode,
                    labelText: nameLabelText,
                    hintText: enterNameText,
                    prefixIcon: AppIcons.userNameIcon,
                    validator: validateName),
                const SizedBox(height: 10),
                CustomTextField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    labelText: emailLabelText,
                    hintText: enterEmailText,
                    prefixIcon: AppIcons.userMailIcon,
                    validator: validateEmail),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                    valueListenable: obsecurePassword,
                    builder: (context, value, child) {
                      return CustomPasswordTextField(
                          controller: passwordController,
                          focusNode: passwordFocusNode,
                          labelText: passwordLabelText,
                          hintText: enterPasswordText,
                          prefixIcon: Icons.lock_open_outlined,
                          obscureTextNotifier: obsecurePassword,
                          obscuringCharacter: '*',
                          suffixIcon: obsecurePassword.value
                              ? const Icon(Icons.visibility_off_outlined)
                              : const Icon(Icons.visibility),
                          onSuffixIconPressed: () {
                            obsecurePassword.value = !obsecurePassword.value;
                          },
                          keyboardType: TextInputType.text,
                          onToggleObscureText: (value) {
                            obsecurePassword.value = !obsecurePassword.value;
                          },
                          validator: validatePassword);
                    }),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                    valueListenable: obsecurePassword2,
                    builder: (context, value, child) {
                      return CustomPasswordTextField(
                          controller: confirmPasswordController,
                          focusNode: confirmPasswordFocusNode,
                          labelText: confirmPasswordLabelText,
                          hintText: enterConfirmPasswordText,
                          prefixIcon: Icons.lock_open_outlined,
                          obscureTextNotifier: obsecurePassword2,
                          obscuringCharacter: '*',
                          suffixIcon: obsecurePassword2.value
                              ? const Icon(Icons.visibility_off_outlined)
                              : const Icon(Icons.visibility),
                          onSuffixIconPressed: () {
                            obsecurePassword2.value = !obsecurePassword2.value;
                          },
                          keyboardType: TextInputType.text,
                          onToggleObscureText: (value) {
                            obsecurePassword2.value = !obsecurePassword2.value;
                          },
                          validator: (value) => validateConfirmPassword(
                              value, passwordController));
                    }),
                const SizedBox(height: 15),
                LoginSignUpButton(
                    minWidth: double.infinity,
                    height: 52,
                    Onpressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          email = emailController.text;
                          password = passwordController.text;
                          confirmPassword = confirmPasswordController.text;
                          name = userNameController.text;
                        });
                        signUpModel.userSignUp(email, password);
                      }
                    },
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                    Display_Name: signUpButtonText,
                    Loading: signUpModel.isLoading,
                    updateStateCallback: () {
                      setState(() {
                        signUpModel.isLoading = true;
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            signUpModel.isLoading = false;
                          });
                        });
                      });
                    }),
                const SizedBox(height: 10),
                Row(children: [
                  const Text('Already have account ?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text("Login",
                          style: TextStyle(
                              color: AppColors.loginBtnColor,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic))),
                ]),
              ]),
        ),
      ),
    );
  }
}
