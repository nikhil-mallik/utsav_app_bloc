import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/global_sized_box.dart';
import '../../../../helper/color.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/data_manager.dart';

class ParticularExpenseViewModel {
  // Method to fetch expense details for a specific room
  Future<QuerySnapshot<Map<String, dynamic>>> getExpensesDetails(
      String roomKey) async {
    DataManager.updateRoomDetailsData(roomKey);
    return await FirebaseFirestore.instance
        .collection('Expense')
        .where('r_id', isEqualTo: roomKey)
        .get();
  }

  // Widget to display expense details
  Widget listItem({required Map expense, required String roomkey}) {
    final String userId = expense['uid'];
    return Column(children: [
      FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection('Room').doc(roomkey).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
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
                      final String userPic = userSnapshot.data!['u_img'];
                      return Card(
                        elevation: 8.0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: AppColors.cardColor),
                          padding: const EdgeInsets.all(1),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(children: [
                                  Row(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 80,
                                            width: 65,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: userSnapshot.hasData &&
                                                      userPic.isNotEmpty
                                                  ? CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          const Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                      imageUrl: userPic)
                                                  : Container(
                                                      color:
                                                          AppColors.circleColor,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          userName[0]
                                                              .toUpperCase(),
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              color: AppColors
                                                                  .circletextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                            ),
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.all(5.0)),
                                        ]),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${expense['exp_name']}"
                                                          .replaceAll(
                                                              RegExp(r'\s{2,}'),
                                                              ' ')
                                                          .trim()
                                                          .length >
                                                      40
                                                  ? '${"${expense['exp_name']}".replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 40)}...'
                                                  : "${expense['exp_name']}"
                                                      .replaceAll(
                                                          RegExp(r'\s{2,}'),
                                                          ' ')
                                                      .trim(),
                                              overflow: TextOverflow.clip,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400)),
                                          const GlobalSizedBox(height: 5),
                                          Row(children: [
                                            const Icon(AppIcons.userNameIcon,
                                                size: 14),
                                            const Padding(
                                                padding: EdgeInsets.all(3.0)),
                                            Text(
                                                (userName)
                                                            .replaceAll(
                                                                RegExp(
                                                                    r'\s{2,}'),
                                                                ' ')
                                                            .trim()
                                                            .length >
                                                        30
                                                    ? '${(userName).replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 30)}...'
                                                    : userName
                                                        .replaceAll(
                                                            RegExp(r'\s{2,}'),
                                                            ' ')
                                                        .trim(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ]),
                                          const GlobalSizedBox(height: 5),
                                          Row(
                                            children: [
                                              const Icon(
                                                  AppIcons.currencyRupeeIcon,
                                                  size: 14),
                                              const Padding(
                                                  padding: EdgeInsets.all(3.0)),
                                              Text("${expense['e_amt']}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ],
                                          ),
                                          const GlobalSizedBox(height: 5),
                                          Row(children: [
                                            const Icon(AppIcons.calDateIcon,
                                                size: 14),
                                            const Padding(
                                                padding: EdgeInsets.all(3.0)),
                                            Text("${expense['cel_dte']}",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ]),
                                        ]),
                                  ]),
                                  const GlobalSizedBox(height: 5),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${expense['e_desc']}"
                                                  .replaceAll(
                                                      RegExp(r'\s{2,}'), ' ')
                                                  .trim(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400)),
                                        ]),
                                  ),
                                ]),
                              ]),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  });
            } else {
              return Container();
            }
          }),
    ]);
  }
}
