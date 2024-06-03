// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../view_model/splash_services.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashViewModel splashServices = SplashViewModel();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () async {
      await splashServices.check_if_already_login(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFFccad33),
                Color(0xFF8cb0ad),
              ]),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [
                Image.asset("assets/images/gateway.png",
                    height: 300.0, width: 300.0),
                const Text("Welcome To Gateway Utsav\n Gateway Group",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0)),
              ]),
            ]),
      ),
    );
  }
}
