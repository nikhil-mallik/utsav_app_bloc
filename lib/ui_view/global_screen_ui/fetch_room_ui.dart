import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/global_sized_box.dart';

class FetchRoomCardUI extends StatelessWidget {
  final String roomName;
  final String roomDesc;
  final String roomDate;
  final String totalExpense;
  final String totalContribution;
  final String totalMembers;

  const FetchRoomCardUI({
    super.key,
    required this.roomName,
    required this.roomDesc,
    required this.roomDate,
    required this.totalExpense,
    required this.totalContribution,
    required this.totalMembers,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: AppColors.cardColor),
        padding: const EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                Row(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          maxRadius: 15,
                          backgroundColor: AppColors.circleColor,
                          child: Text(roomName[0].toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.circletextColor)),
                        ),
                        const Padding(padding: EdgeInsets.all(15.0)),
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                                (roomName)
                                            .replaceAll(RegExp(r'\s{2,}'), ' ')
                                            .trim()
                                            .length >
                                        40
                                    ? '${(roomName).replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 40)}...'
                                    : roomName
                                        .replaceAll(RegExp(r'\s{2,}'), ' ')
                                        .trim(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const GlobalSizedBox(height: 5),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(roomDate,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                            ]),
                      ]),
                ]),
                const GlobalSizedBox(height: 5),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(roomDesc.replaceAll(RegExp(r'\s{2,}'), ' ').trim(),
                            overflow: TextOverflow.clip,
                            style: const TextStyle(color: AppColors.textColor)),
                      ]),
                ),
                const GlobalSizedBox(height: 8),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Icon(AppIcons.currencyRupeeIcon),
                          Text(totalExpense)
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(AppIcons.contributionname),
                          Text(totalContribution)
                        ],
                      ),
                      Row(children: [
                        const Icon(AppIcons.userNameIcon),
                        Text(totalMembers)
                      ]),
                    ]),
              ]),
            ]),
      ),
    );
  }
}
