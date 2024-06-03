// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:material_dialogs/dialogs.dart';

import 'color.dart';
import 'global_width.dart';
import 'widget_string.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.Onpressed,
    required this.Display_Name,
    required this.Loading,
    this.minWidth = 55.0,
    this.height = 35.0,
    this.textStyle = const TextStyle(fontWeight: FontWeight.w500),
  });

  double height;
  double minWidth;
  TextStyle textStyle;
  var Onpressed;
  var Display_Name;
  bool Loading;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: Onpressed,
      minWidth: minWidth,
      height: height,
      color: AppColors.submitbuttonColor,
      textColor: AppColors.textColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      child: Loading
          ? Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2.0),
              child: const CircularProgressIndicator(
                  color: AppColors.appbartextColor, strokeWidth: 3),
            )
          : Text(
              Display_Name,
              style: textStyle,
            ),
    );
  }
}

class LoginSignUpButton extends StatelessWidget {
  double height;
  double minWidth;
  TextStyle textStyle;
  var Onpressed;
  var Display_Name;
  bool Loading;
  final VoidCallback updateStateCallback;

  LoginSignUpButton({
    super.key,
    required this.Onpressed,
    required this.Display_Name,
    required this.Loading,
    this.minWidth = 55.0,
    this.height = 35.0,
    this.textStyle = const TextStyle(fontWeight: FontWeight.w500),
    required this.updateStateCallback,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Onpressed();
        updateStateCallback();
      },
      minWidth: minWidth,
      height: height,
      color: AppColors.submitbuttonColor,
      textColor: AppColors.textColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      child: Loading
          ? Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2.0),
              child: const CircularProgressIndicator(
                  color: AppColors.appbartextColor, strokeWidth: 3),
            )
          : Text(
              Display_Name,
              style: textStyle,
            ),
    );
  }
}

class EditButton extends StatelessWidget {
  EditButton({
    super.key,
    required this.Onpressed,
  });

  var Onpressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: GlobalWidthValues.multiplyWidth(.4, context),
      child: MaterialButton(
        onPressed: Onpressed,
        minWidth: double.infinity,
        height: 38,
        elevation: 16,
        color: AppColors.editbuttonColor,
        textColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.edit_outlined, color: AppColors.whiteColor),
            const Padding(
              padding: EdgeInsets.only(left: 1.0, right: 2.0),
            ),
            Text(
              editButtonText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const DeleteButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: GlobalWidthValues.multiplyWidth(.4, context),
      child: DailogueBox(
        onPressed: onPressed,
        title: title,
        buttonText: deleteButtonText,
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignOutButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: GlobalWidthValues.multiplyWidth(.4, context),
      height: 35,
      child: DailogueBox(
        onPressed: onPressed,
        title: sureWantToLogout,
        buttonText: signOutButtonText,
      ),
    );
  }
}

class DailogueBox extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String buttonText;

  const DailogueBox(
      {super.key,
      required this.onPressed,
      required this.title,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Dialogs.materialDialog(
          title: title,
          color: AppColors.bgColor,
          context: context,
          actions: [
            MaterialButton(
              onPressed: onPressed,
              color: AppColors.submitbuttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Text(
                yesButtonText,
                style: const TextStyle(color: AppColors.textColor),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  32,
                ),
              ),
              color: AppColors.submitbuttonColor,
              child: Text(
                noButtonText,
                style: const TextStyle(color: AppColors.textColor),
              ),
            ),
          ],
        );
      },
      minWidth: double.infinity,
      height: 38,
      elevation: 16,
      color: AppColors.deletebuttonColor,
      textColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.delete_forever_outlined,
              color: AppColors.whiteColor),
          const Padding(
            padding: EdgeInsets.only(left: 1.0, right: 1.0),
          ),
          Text(
            buttonText,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.whiteColor),
          ),
        ],
      ),
    );
  }
}
