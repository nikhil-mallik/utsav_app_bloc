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
import '../../../../utils/routes/routes_name.dart';
import '../../signup/View/signup_view.dart';
import '../view_model/login_view_model.dart';

class LoginPageLeftSide extends StatefulWidget {
  const LoginPageLeftSide({super.key});

  @override
  State<LoginPageLeftSide> createState() => _LoginPageLeftSideState();
}

class _LoginPageLeftSideState extends State<LoginPageLeftSide> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> obsecurePassword = ValueNotifier<bool>(true);

// ignore: prefer_typing_uninitialized_variables
  var currentUserId;
  late LoginModel loginModel;

  @override
  void initState() {
    super.initState();
    loginModel = LoginModel(context, () {
      loginModel.isLoading;
    });
    loginModel.checkIfAlreadyLogin();
    Utils.clearAllTextFields();
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
                    Image.asset('assets/images/gateway.png', width: 80),
                    const GlobalSizedBox(width: 10, height: 0),
                    Text(loginLabelText,
                        style: const TextStyle(
                            fontSize: 28,
                            color: AppColors.loginBtnColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(24)),
                CustomTextField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    labelText: emailLabelText,
                    hintText: enterEmailText,
                    prefixIcon: AppIcons.userMailIcon,
                    validator: validateEmail),
                const Padding(
                  padding: EdgeInsets.all(17),
                ),
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
                          validator: validateEmptyPassword,
                          keyboardType: TextInputType.text,
                          onToggleObscureText: (value) {
                            obsecurePassword.value = !obsecurePassword.value;
                          });
                    }),
                const Padding(padding: EdgeInsets.all(8)),
                const GlobalSizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: MaterialButton(
                            child: Text(
                              signUpButtonText,
                              style: const TextStyle(
                                color: AppColors.loginBtnColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUp(),
                                ),
                              );
                            },
                          )),
                      Align(
                        alignment: Alignment.topRight,
                        child: MaterialButton(
                          child: Text(
                            forgetPasswordText,
                            style: const TextStyle(
                              color: AppColors.loginBtnColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RoutesName.forgotPassword);
                          },
                        ),
                      ),
                    ]),
                const Padding(padding: EdgeInsets.all(15)),
                LoginSignUpButton(
                    minWidth: double.infinity,
                    height: 52,
                    Onpressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          email = emailController.text;
                          password = passwordController.text;
                          loginModel.isLoading = true;
                        });
                        loginModel.isLoading = true;
                        loginModel.userLogin(email, password);
                      }
                    },
                    Display_Name: loginButtonText,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                    Loading: loginModel.isLoading,
                    updateStateCallback: () {
                      setState(() {
                        loginModel.isLoading = true;
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            loginModel.isLoading = false;
                          });
                        });
                      });
                    }),
              ]),
        ),
      ),
    );
  }
}
