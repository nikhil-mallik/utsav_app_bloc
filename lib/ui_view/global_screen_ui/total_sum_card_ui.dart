import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/widget_string.dart';

class TotalSumCardUI extends StatelessWidget {
  // Future containing the data for the total sum
  final Future<dynamic> future;

  const TotalSumCardUI({super.key, required this.future});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(120.0)),
          color: AppColors.cardColor),
      padding: const EdgeInsets.all(10),
      child: FutureBuilder<dynamic>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Extracting amount from snapshot data
              String amount = (snapshot.data ?? 0) as String;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(totalAmountText,
                        style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.amountColor,
                            fontWeight: FontWeight.w400)),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(AppIcons.currencyRupeeIcon),
                      Text(
                          amount, // Assuming data is a String, modify as needed
                          style: const TextStyle(
                              fontSize: 28,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.bold)),
                    ]),
                  ]);
            }
          }),
    );
  }
}
