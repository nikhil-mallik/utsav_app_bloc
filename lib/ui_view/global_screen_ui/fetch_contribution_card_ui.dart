import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_icons.dart';

class FetchContributionCard extends StatelessWidget {
  final String userName;
  final String userPic;
  final String roomName;
  final String contributionName;
  final String contributionAmount;
  final String contributionDate;
  final String contributionDesc;

  const FetchContributionCard({
    super.key,
    required this.userName,
    required this.userPic,
    required this.contributionName,
    required this.roomName,
    required this.contributionAmount,
    required this.contributionDate,
    required this.contributionDesc,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
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
                        Container(
                          height: 70,
                          width: 65,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: userPic.isNotEmpty
                                ? CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    imageUrl: userPic)
                                : Container(
                                    color: AppColors.circleColor,
                                    alignment: Alignment.center,
                                    child: Text(userName[0].toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: AppColors.circletextColor,
                                            fontWeight: FontWeight.bold)),
                                  ),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.all(
                          5.0,
                        )),
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contributionName
                                      .replaceAll(RegExp(r'\s{2,}'), ' ')
                                      .trim()
                                      .length >
                                  20
                              ? '${contributionName.replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 20)}...'
                              : contributionName
                                  .replaceAll(RegExp(r'\s{2,}'), ' ')
                                  .trim(),
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 5),
                        Row(children: [
                          const Icon(AppIcons.headTitleIcon, size: 14),
                          const Padding(padding: EdgeInsets.all(3.0)),
                          Text(
                              roomName
                                          .replaceAll(RegExp(r'\s{2,}'), ' ')
                                          .trim()
                                          .length >
                                      25
                                  ? '${roomName.replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 25)}...'
                                  : roomName
                                      .replaceAll(RegExp(r'\s{2,}'), ' ')
                                      .trim(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ]),
                        const SizedBox(height: 5),
                        Row(children: [
                          const Icon(AppIcons.userNameIcon, size: 14),
                          const Padding(padding: EdgeInsets.all(3.0)),
                          Text(
                            userName
                                        .replaceAll(RegExp(r'\s{2,}'), ' ')
                                        .trim()
                                        .length >
                                    25
                                ? '${userName.replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 25)}...'
                                : userName
                                    .replaceAll(RegExp(r'\s{2,}'), ' ')
                                    .trim(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ]),
                      ]),
                ]),
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            contributionDesc
                                        .replaceAll(RegExp(r'\s{2,}'), ' ')
                                        .trim()
                                        .length >
                                    35
                                ? '${contributionDesc.replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 35)}...'
                                : contributionDesc
                                    .replaceAll(RegExp(r'\s{2,}'), ' ')
                                    .trim(),
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400)),
                      ]),
                ),
                const SizedBox(height: 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const Icon(AppIcons.currencyRupeeIcon, size: 14),
                        const Padding(padding: EdgeInsets.all(3.0)),
                        Text(contributionAmount,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400)),
                      ]),
                      Row(children: [
                        const Icon(AppIcons.calDateIcon, size: 14),
                        const Padding(padding: EdgeInsets.all(3.0)),
                        Text(contributionDate,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400)),
                      ]),
                    ]),
              ]),
            ]),
      ),
    );
  }
}
