import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/global_width.dart';
import '../View/update_role_data.dart';

class FetchRoleViewModel {
  final BuildContext context;

  FetchRoleViewModel(this.context);

  final searchFilter = TextEditingController();

  // Method to build list item for each user
  Widget listItem({required Map user}) {
    final String roleID = user['role_id'];
    final String userPic = user['u_img'];
    final String username = user['u_name'];
    final String userEmail = user['email'];

    return Column(
      children: [
        FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance.collection('Role').doc(roleID).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final String roleName = snapshot.data!['role'];
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
                                      child: userPic.isNotEmpty
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
                                                  username[0].toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: AppColors
                                                          .circletextColor,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.all(5.0))
                                ],
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: GlobalWidthValues.multiplyWidth(
                                          .65, context),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                roleName
                                                    .replaceAll(
                                                        RegExp(r'\s{2,}'), ' ')
                                                    .trim(),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            UpdateRoleData(
                                                                userKey: user[
                                                                    'key']),
                                                      ));
                                                },
                                                child: const Icon(Icons.edit,
                                                    color: AppColors
                                                        .editbuttonColor)),
                                          ]),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(children: [
                                      const Icon(AppIcons.userNameIcon,
                                          size: 14),
                                      const Padding(
                                          padding: EdgeInsets.all(3.0)),
                                      Text(
                                          "${user['u_name']}"
                                                      .replaceAll(
                                                          RegExp(r'\s{2,}'),
                                                          ' ')
                                                      .trim()
                                                      .length >
                                                  40
                                              ? '${"${user['u_name']}".replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 40)}...'
                                              : "${user['u_name']}"
                                                  .replaceAll(
                                                      RegExp(r'\s{2,}'), ' ')
                                                  .trim(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                    ]),
                                    const SizedBox(height: 5),
                                    Row(children: [
                                      const Icon(AppIcons.userMailIcon,
                                          size: 14),
                                      const Padding(
                                          padding: EdgeInsets.all(3.0)),
                                      Text(
                                          userEmail.length > 23
                                              ? '${userEmail.substring(0, 23)}...'
                                              : userEmail,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                    ]),
                                  ]),
                            ]),
                          ]),
                        ]),
                  ),
                );
              } else {
                return Container();
              }
            })
      ],
    );
  }
}
