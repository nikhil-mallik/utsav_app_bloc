import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/widget_button.dart';
import '../../../../helper/widget_string.dart';
import '../services/user_session.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  late SharedPreferences logindata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: errorScreenTitleText,
      ),
      body: SizedBox(
        width: GlobalWidthValues.getWidth(context),
        child: Padding(
          padding: const EdgeInsets.only(top: 25, left: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Something went wrong!.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const GlobalSizedBox(height: 5),
              const Text(
                "Got some error while login",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const GlobalSizedBox(height: 5),
              const Text(
                "Kindly logout and try again to Login",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const GlobalSizedBox(height: 25),
              SignOutButton(
                onPressed: () async {
                  logindata = await SharedPreferences.getInstance();
                  logindata.clear();
                  UserData.clearUserData();
                  // ignore: use_build_context_synchronously
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => const LoginPage(),
                  //   ),
                  // );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
