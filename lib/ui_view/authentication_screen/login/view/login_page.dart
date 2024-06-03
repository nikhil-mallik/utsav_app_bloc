import 'package:flutter/material.dart';
import '../../../../helper/color.dart';
import '../../../../helper/custom_flushbar.dart';
import 'login_page_left_side.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        Utils.onBackpressed(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              height: 640,
              width: 640,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: AppColors.whiteColor),
              child: const Row(children: [LoginPageLeftSide()]),
            ),
          ),
        ),
      ),
    );
  }
}
