import 'package:flutter/material.dart';

class GlobalSizedBox extends StatelessWidget {
  final double width;
  final double height;
  const GlobalSizedBox({super.key, this.height = 30, this.width = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
