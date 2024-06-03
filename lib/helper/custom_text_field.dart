import 'package:flutter/material.dart';

import 'color.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final int maxLines;
  final int? maxLength;
  final bool readOnly;
  final String? Function(String?) validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    required this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofocus: false,
      autocorrect: false,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: Icon(widget.prefixIcon),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        focusColor: AppColors.focusedColor,
        labelStyle: const TextStyle(
          fontSize: 17.0,
        ),
        errorStyle: const TextStyle(
          color: AppColors.alertColor,
          fontSize: 15,
        ),
      ),
      validator: widget.validator,
      onTap: widget.onTap,
    );
  }
}

class CustomPasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final Widget suffixIcon;
  final TextInputType keyboardType;
  final String obscuringCharacter;
  final ValueNotifier<bool> obscureTextNotifier;
  final void Function() onSuffixIconPressed;
  final String? Function(String?) validator;
  final ValueChanged<bool> onToggleObscureText;

  const CustomPasswordTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.keyboardType,
    required this.obscuringCharacter,
    required this.obscureTextNotifier,
    required this.onToggleObscureText,
    required this.onSuffixIconPressed,
    required this.validator,
  });

  @override
  State<CustomPasswordTextField> createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      obscureText: widget.obscureTextNotifier.value,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      obscuringCharacter: widget.obscuringCharacter,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: GestureDetector(
          onTap: () {
            widget.obscureTextNotifier.value =
                !widget.obscureTextNotifier.value;
            widget.onToggleObscureText(widget.obscureTextNotifier.value);
            widget.onSuffixIconPressed();
          },
          child: widget.suffixIcon,
        ),
        border: const OutlineInputBorder(),
        focusColor: AppColors.focusedColor,
        errorStyle: const TextStyle(
          color: AppColors.alertColor,
          fontSize: 15,
        ),
      ),
      validator: widget.validator,
    );
  }
}
