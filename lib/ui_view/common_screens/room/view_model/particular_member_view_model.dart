import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/data_manager.dart';

class ParticularMemberViewModel {
  // Stream to handle real-time database updates
  late Stream<DocumentSnapshot<Map<String, dynamic>>> stream;

  // Method to fetch database and update room details
  void database(String roomKey) {
    stream =
        FirebaseFirestore.instance.collection('Room').doc(roomKey).snapshots();
    DataManager.updateRoomDetailsData(roomKey);
  }

  // Widget to display list item for a particular member
  Widget listItem({required Map user}) {
    final String userId = user['uid'];
    return Column(children: [
      FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection('Users').doc(userId).get(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.done &&
                userSnapshot.hasData) {
              final String userName = userSnapshot.data!['u_name'];
              final String userEmail = userSnapshot.data!['email'];
              final String userRoleId = userSnapshot.data!['role_id'];
              final String userPic = userSnapshot.data!['u_img'];
              return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Role')
                      .doc(userRoleId)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      final String roleName = snapshot.data!['role'];
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
                          padding: const EdgeInsets.all(10),
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
                                            width: 55,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
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
                                                        25
                                                    ? '${(userName).replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 25)}...'
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
                                          const SizedBox(height: 5),
                                          Row(children: [
                                            const Icon(AppIcons.roleIcon,
                                                size: 14),
                                            const Padding(
                                                padding: EdgeInsets.all(3.0)),
                                            Text(
                                                roleName
                                                    .replaceAll(
                                                        RegExp(r'\s{2,}'), ' ')
                                                    .trim(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ]),
                                          const SizedBox(height: 5),
                                          Row(children: [
                                            const Icon(AppIcons.userMailIcon,
                                                size: 14),
                                            const Padding(
                                                padding: EdgeInsets.all(3.0)),
                                            Text(
                                                (userEmail).length > 23
                                                    ? '${(userEmail).substring(0, 23)}...'
                                                    : userEmail,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ]),
                                          const SizedBox(height: 5),
                                        ]),
                                  ]),
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
