import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/global_sized_box.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/color.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/data_manager.dart';
import '../../../../helper/widget_button.dart';
import '../../../../helper/widget_string.dart';
import '../../../../services/user_session.dart';
import '../../Dashboard/dashboard.dart';
import '../View/update_expense_data.dart';

class ViewDetailsExpenseModel {
  var currentUserId = '';

  // Method to get the current user ID
  void currentUser() async => currentUserId = await UserData.getCurrentUserId();

  // Reference to the Firestore document for expenses
  final DocumentReference documentReference =
      FirebaseFirestore.instance.collection('Expense').doc('id');

  // Widget to display expense details
  Widget listItem({required Map expense, required String roomsId}) {
    final String roomId = expense['r_id'];
    final String userId = expense['uid'];
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
                    final isCurrentUserExpense = userId == currentUserId;
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
                                      height: 90,
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
                                        (roomName)
                                                    .replaceAll(
                                                        RegExp(r'\s{2,}'), ' ')
                                                    .trim()
                                                    .length >
                                                30
                                            ? '${(roomName).replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 30)}...'
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
                                    Text("Added: ${expense['cel_dte']}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    const GlobalSizedBox(height: 5),
                                    Row(children: [
                                      const Icon(AppIcons.currencyRupeeIcon,
                                          size: 16),
                                      const Padding(
                                          padding: EdgeInsets.all(3.0)),
                                      Text("${expense['e_amt']}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                                  ]),
                            ]),
                            const GlobalSizedBox(height: 15),
                            Column(children: [
                              Row(
                                children: [
                                  const Icon(AppIcons.userNameIcon),
                                  const Padding(padding: EdgeInsets.all(3.0)),
                                  Text(
                                      (userName)
                                                  .replaceAll(
                                                      RegExp(r'\s{2,}'), ' ')
                                                  .trim()
                                                  .length >
                                              30
                                          ? '${(userName).replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 30)}...'
                                          : userName
                                              .replaceAll(
                                                  RegExp(r'\s{2,}'), ' ')
                                              .trim(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const GlobalSizedBox(height: 15),
                              Row(children: [
                                const Icon(AppIcons.userMailIcon),
                                const Padding(padding: EdgeInsets.all(3.0)),
                                Text(
                                    (userEmail).length > 25
                                        ? '${(userEmail).substring(0, 25)}...'
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
                                    Text(expenseTitleText,
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: AppColors.appbariconColor,
                                            fontWeight: FontWeight.w300)),
                                    const GlobalSizedBox(height: 1),
                                    Text(
                                        "${expense['exp_name']}"
                                            .replaceAll(RegExp(r'\s{2,}'), ' ')
                                            .trim(),
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
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
                                            fontWeight: FontWeight.w300)),
                                    const GlobalSizedBox(height: 2),
                                    Text(
                                        "${expense['e_desc']}"
                                            .replaceAll(RegExp(r'\s{2,}'), ' ')
                                            .trim(),
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                  ]),
                            ),
                            const GlobalSizedBox(height: 15),
                            if (isCurrentUserExpense)
                              SizedBox(
                                width: GlobalWidthValues.getWidth(context),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      EditButton(
                                        Onpressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    UpdateExpenseData(
                                                        expenseKey:
                                                            expense['key']),
                                              ));
                                        },
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              left: 1.0, right: 1.0)),
                                      DeleteButton(
                                        title:
                                            '$sureWantToDelete \n ${expense['exp_name']} ?',
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('Expense')
                                              .doc(expense['key'])
                                              .delete();
                                          documentReference
                                              .delete()
                                              .then((_) {})
                                              .catchError(
                                            (error) {
                                              Utils.customErrorFlushBar(context,
                                                  '$errorDeleteText \n${error.toString()}');
                                            },
                                          );
                                          DataManager.updateRoomDetailsData(
                                              roomsId);
                                          DataManager
                                              .updateCurrentUserAmountData(
                                                  currentLoginUserId);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Dashboard(
                                                    initialSelectedIndex: 2,
                                                    flushBarMessage:
                                                        '${expense['exp_name']} $deletedSuccessfully'),
                                              ));
                                        },
                                      ),
                                    ]),
                              )
                          ]),
                        ]);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
