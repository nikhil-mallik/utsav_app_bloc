import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/global_sized_box.dart';
import '../../../../helper/color.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/widget_string.dart';

class DetailsContributionViewModel {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> stream;

  // Fetch contribution data
  void contributionData(String contributionKey) {
    stream = FirebaseFirestore.instance
        .collection('Contribution')
        .doc(contributionKey)
        .snapshots();
  }

  // Build list item widget
  Widget listItem({required Map contribution, required String roomsId}) {
    final String roomId = contribution['r_id'];
    final String userId = contribution['uid'];

    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Room').doc(roomId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final String roomName = snapshot.data!['r_name'];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(userId)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.done &&
                    userSnapshot.hasData) {
                  final String userName = userSnapshot.data!['u_name'];
                  final String userEmail = userSnapshot.data!['email'];
                  final String userPic = userSnapshot.data!['u_img'];
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(children: [
                          Row(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 70,
                                    width: 65,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: userSnapshot.hasData &&
                                              userPic.isNotEmpty
                                          ? CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              imageUrl: userPic)
                                          : Container(
                                              color: AppColors.circleColor,
                                              alignment: Alignment.center,
                                              child: Text(
                                                  userName[0].toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: AppColors
                                                          .circletextColor,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.all(5.0)),
                                ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      roomName
                                                  .replaceAll(
                                                      RegExp(r'\s{2,}'), ' ')
                                                  .trim()
                                                  .length >
                                              30
                                          ? '${roomName.replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 30)}...'
                                          : roomName
                                              .replaceAll(
                                                  RegExp(r'\s{2,}'), ' ')
                                              .trim(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  const GlobalSizedBox(height: 5),
                                  Text(" ${contribution['cel_dte']}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                  const GlobalSizedBox(height: 5),
                                  Row(children: [
                                    const Icon(AppIcons.currencyRupeeIcon,
                                        size: 16),
                                    const Padding(padding: EdgeInsets.all(3.0)),
                                    Text("${contribution['payment']}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                                ]),
                          ]),
                          const GlobalSizedBox(height: 15),
                          Column(children: [
                            Row(children: [
                              const Icon(AppIcons.userNameIcon),
                              const Padding(padding: EdgeInsets.all(3.0)),
                              Text(
                                  userName
                                              .replaceAll(
                                                  RegExp(r'\s{2,}'), ' ')
                                              .trim()
                                              .length >
                                          30
                                      ? '${userName.replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 30)}...'
                                      : userName
                                          .replaceAll(RegExp(r'\s{2,}'), ' ')
                                          .trim(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ]),
                            const GlobalSizedBox(height: 15),
                            Row(children: [
                              const Icon(
                                AppIcons.userMailIcon,
                              ),
                              const Padding(padding: EdgeInsets.all(3.0)),
                              Text(
                                  userEmail.length > 25
                                      ? '${userEmail.substring(0, 25)}...'
                                      : userEmail,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.textColor)),
                            ]),
                          ]),
                          const GlobalSizedBox(height: 15),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contributionTitleText,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.appbariconColor,
                                        fontWeight: FontWeight.w200),
                                  ),
                                  const GlobalSizedBox(height: 1),
                                  Text(
                                    "${contribution['con_name']}"
                                        .replaceAll(RegExp(r'\s{2,}'), ' ')
                                        .trim(),
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: AppColors.appbariconColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                          ),
                          const GlobalSizedBox(height: 15),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(descriptionText,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.appbariconColor,
                                          fontWeight: FontWeight.w200)),
                                  const GlobalSizedBox(height: 2),
                                  Text(
                                      "${contribution['c_desc']}"
                                          .replaceAll(RegExp(r'\s{2,}'), ' ')
                                          .trim(),
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.appbariconColor,
                                          fontWeight: FontWeight.w400)),
                                ]),
                          ),
                        ]),
                      ]);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
