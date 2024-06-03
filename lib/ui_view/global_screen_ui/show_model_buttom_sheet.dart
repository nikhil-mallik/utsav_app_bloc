import 'package:flutter/material.dart';

class CustomBottomSheet {
  static Future<void> show(
    BuildContext context, {
    required dynamic child,
  }) async {
    await showModalBottomSheet(
      elevation: 10,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * .9,
          height: 550,
          color: Colors.white54,
          alignment: Alignment.center,
          child: child
        ),
      ),
    );
  }
}
