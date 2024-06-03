// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../helper/global_sized_box.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/amount_format.dart';
import '../../../../helper/color.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/data_manager.dart';
import '../../../../helper/settings_tile.dart';
import '../../../../helper/widget_button.dart';
import '../../../../helper/widget_string.dart';
import '../../../../services/role_service.dart';
import '../../../admin_core_member_view/rooms/room_details/view/add_members_room.dart';
import '../../../admin_core_member_view/rooms/view/update_room_data.dart';
import '../../Dashboard/dashboard.dart';
import 'view_particular_contribution.dart';
import 'view_particular_expense.dart';
import 'view_particular_member.dart';

class Show_Room_Details extends StatefulWidget {
  final String employeeKey;
  final String roomId;
  final String? flushBarMessage;

  const Show_Room_Details(
      {required this.employeeKey,
      required this.roomId,
      super.key,
      this.flushBarMessage});

  @override
  _Show_Room_DetailsState createState() => _Show_Room_DetailsState();
}

class _Show_Room_DetailsState extends State<Show_Room_Details> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _stream;
  final DocumentReference documentReference =
      FirebaseFirestore.instance.collection('Room').doc('id');
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    _stream = FirebaseFirestore.instance
        .collection('Room')
        .doc(widget.roomId)
        .snapshots();
    if (widget.flushBarMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Utils.customFlushBar(context, widget.flushBarMessage!);
      });
    }
    DataManager.updateRoomDetailsData(widget.roomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          roomDetailsText,
          style:
              const TextStyle(color: AppColors.appbartextColor, fontSize: 24),
        ),
        backgroundColor: AppColors.appbarColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon:
                const Icon(Icons.arrow_back, color: AppColors.appbariconColor),
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const Dashboard(initialSelectedIndex: 0)),
                )),
        actions: [
          const Padding(padding: EdgeInsets.only(right: 5.0)),
          RoleUtils.isAdmin
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMemberData(
                            employeeKey: widget.employeeKey,
                            // pass the employee key value
                            roomKey: widget.roomId),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add_alt_outlined),
                )
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _stream,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text(someErrorOccurred);
              }
              Map<String, dynamic> employee = snapshot.data!.data()!;
              employee['key'] = widget.employeeKey;
              Map<String, dynamic> roomId = snapshot.data!.data()!;
              roomId['key'] = widget.roomId;
              final String userId = roomId['uid'];
              final String roomName = snapshot.data!['r_name'];
              final String updatedAt = snapshot.data?['updatedAt'];
              String totalExpense = snapshot.data?['expense'];
              String totalContribution = snapshot.data?['contribution'];
              String totalMembers = snapshot.data?['member'];
              String totalBalance = snapshot.data?['balance'];
              return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userId)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.done &&
                        userSnapshot.hasData) {
                      _userName = userSnapshot.data!['u_name'];
                      _userEmail = userSnapshot.data!['email'];
                      final String userPic = userSnapshot.data!['u_img'];
                      final isCurrentUserRoom = userId == currentLoginUserId;
                      return Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
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
                                            height: 100,
                                            width: 65,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color:
                                                        AppColors.circleColor)),
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
                                                          roomName[0]
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
                                              padding: EdgeInsets.all(5.0))
                                        ]),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${employee['r_name']}"
                                                        .replaceAll(
                                                            RegExp(r'\s{2,}'),
                                                            ' ')
                                                        .trim()
                                                        .length >
                                                    40
                                                ? '${"${employee['r_name']}".replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 40)}...'
                                                : "${employee['r_name']}"
                                                    .replaceAll(
                                                        RegExp(r'\s{2,}'), ' ')
                                                    .trim(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const GlobalSizedBox(height: 5),
                                          Text(
                                              "Created at: ${employee['cel_dte']}",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400)),
                                          if (updatedAt.isNotEmpty) ...[
                                            const GlobalSizedBox(height: 5),
                                            Text("Updated at: $updatedAt",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ]
                                        ]),
                                  ]),
                                ]),
                                const GlobalSizedBox(height: 15),
                                Column(children: [
                                  Row(children: [
                                    const Icon(AppIcons.userNameIcon),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 6)),
                                    Text(
                                        (_userName ?? '')
                                                    .replaceAll(
                                                        RegExp(r'\s{2,}'), ' ')
                                                    .trim()
                                                    .length >
                                                40
                                            ? '${(_userName ?? '').replaceAll(RegExp(r'\s{2,}'), ' ').trim().substring(0, 40)}...'
                                            : _userName!
                                                .replaceAll(
                                                    RegExp(r'\s{2,}'), ' ')
                                                .trim(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                                  const GlobalSizedBox(height: 15),
                                  Row(children: [
                                    const Icon(AppIcons.userMailIcon),
                                    const GlobalSizedBox(width: 15),
                                    Text(_userEmail ?? someErrorOccurred,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            color: AppColors.textColor)),
                                  ]),
                                ]),
                                const GlobalSizedBox(height: 15),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Column(children: [
                                    Text(
                                      "${employee['r_desc']}"
                                          .replaceAll(RegExp(r'\s{2,}'), ' ')
                                          .trim(),
                                      maxLines: 4,
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: AppColors.textColor),
                                    ),
                                  ]),
                                ),
                                const GlobalSizedBox(height: 20),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                  color:
                                                      AppColors.appbartextColor,
                                                  width: 1.0),
                                            ),
                                          ),
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(expenseLabelText,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .amountColor)),
                                                const GlobalSizedBox(height: 2),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(AppIcons
                                                          .currencyRupeeIcon),
                                                      Text(
                                                          AmountFormat.formatAmount(
                                                              int.parse(
                                                                  totalExpense)),
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              color: AppColors
                                                                  .textColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ]),
                                              ]),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                  color:
                                                      AppColors.appbartextColor,
                                                  width: 1.0),
                                            ),
                                          ),
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  contributionLabelText,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: AppColors
                                                          .amountColor),
                                                ),
                                                const GlobalSizedBox(height: 2),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(AppIcons
                                                          .currencyRupeeIcon),
                                                      Text(
                                                        AmountFormat.formatAmount(
                                                            int.parse(
                                                                totalContribution)),
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            color: AppColors
                                                                .textColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ]),
                                              ]),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                  color:
                                                      AppColors.appbartextColor,
                                                  width: 1.0),
                                            ),
                                          ),
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  memberLabelText,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: AppColors
                                                          .amountColor),
                                                ),
                                                const GlobalSizedBox(height: 2),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                          AppIcons.userNameIcon),
                                                      Text(
                                                          AmountFormat.formatAmount(
                                                              int.parse(
                                                                  totalMembers)),
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              color: AppColors
                                                                  .textColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ]),
                                              ]),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(balanceText,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .amountColor)),
                                                const GlobalSizedBox(height: 2),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(AppIcons
                                                          .currencyRupeeIcon),
                                                      Text(
                                                          AmountFormat.formatAmount(
                                                              int.parse(
                                                                  totalBalance)),
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              color: AppColors
                                                                  .textColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ]),
                                              ]),
                                        ),
                                      ),
                                    ]),
                                const GlobalSizedBox(height: 15),
                                Column(children: [
                                  const Divider(height: 12, thickness: 2),
                                  const GlobalSizedBox(height: 15),
                                  SettingsTile(
                                      color: AppColors.settingiconColor,
                                      title: expenseListText,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ShowExpenseDetails(
                                                      employeeKey:
                                                          employee['key'],
                                                      // pass the employee key value
                                                      roomKey: roomId[
                                                          'key'] // pass the room key value
                                                      ),
                                            ));
                                      },
                                      icon: AppIcons.roomDetailsIcon),
                                  const GlobalSizedBox(height: 15),
                                  const Divider(height: 12, thickness: 2),
                                  const GlobalSizedBox(height: 15),
                                  SettingsTile(
                                      color: AppColors.settingiconColor,
                                      title: contributionListText,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Show_Contribution_Details(
                                                employeeKey: employee['key'],
                                                // pass the employee key value
                                                roomKey: roomId['key'],
                                              ),
                                            ));
                                      },
                                      icon: AppIcons.roomDetailsIcon),
                                  const GlobalSizedBox(height: 15),
                                  const Divider(height: 12, thickness: 2),
                                  const GlobalSizedBox(height: 15),
                                  SettingsTile(
                                      color: AppColors.settingiconColor,
                                      title: memberListText,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Show_Member_Details(
                                                employeeKey: employee['key'],
                                                // pass the employee key value
                                                roomKey: roomId['key'],
                                              ),
                                            ));
                                      },
                                      icon: Ionicons.person_circle_outline),
                                  const GlobalSizedBox(),
                                  if (isCurrentUserRoom)
                                    SizedBox(
                                      width:
                                          GlobalWidthValues.getWidth(context),
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
                                                          UpdateRoomData(
                                                        employeeKey:
                                                            employee['key'],
                                                      ),
                                                    ));
                                              },
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 1.0, right: 1.0)),
                                            DeleteButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              const Dashboard()));
                                                  FirebaseFirestore.instance
                                                      .collection('Room')
                                                      .doc(employee['key'])
                                                      .delete();
                                                  documentReference
                                                      .delete()
                                                      .then(
                                                    (value) {
                                                      FirebaseFirestore.instance
                                                          .collection('Expense')
                                                          .where('r_id',
                                                              isEqualTo:
                                                                  employee[
                                                                      'key'])
                                                          .get()
                                                          .then(
                                                              (expenseSnapshot) {
                                                        for (var expenseDoc
                                                            in expenseSnapshot
                                                                .docs) {
                                                          expenseDoc.reference
                                                              .delete();
                                                        }
                                                      }).catchError((error) {
                                                        // Handle error if any
                                                      });
                                                      FirebaseFirestore.instance
                                                          .collection('Members')
                                                          .where('r_id',
                                                              isEqualTo:
                                                                  employee[
                                                                      'key'])
                                                          .get()
                                                          .then(
                                                              (membersSnapshot) {
                                                        for (var memberDoc
                                                            in membersSnapshot
                                                                .docs) {
                                                          memberDoc.reference
                                                              .delete();
                                                        }
                                                      }).catchError((error) {
                                                        // Handle error if any
                                                      });

                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'Celebration')
                                                          .where('r_id',
                                                              isEqualTo:
                                                                  employee[
                                                                      'key'])
                                                          .get()
                                                          .then(
                                                              (celebrationSnapshot) {
                                                        for (var celebrationDoc
                                                            in celebrationSnapshot
                                                                .docs) {
                                                          celebrationDoc
                                                              .reference
                                                              .delete();
                                                        }
                                                      }).catchError((error) {
                                                        // Handle error if any
                                                      });

                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'Contribution')
                                                          .where('r_id',
                                                              isEqualTo:
                                                                  employee[
                                                                      'key'])
                                                          .get()
                                                          .then(
                                                              (contributionSnapshot) {
                                                        for (var contributionDoc
                                                            in contributionSnapshot
                                                                .docs) {
                                                          contributionDoc
                                                              .reference
                                                              .delete();
                                                        }
                                                      }).catchError((error) {
                                                        // Handle error if any
                                                      });
                                                      Utils.customFlushBar(
                                                        context,
                                                        '${employee['r_name']} $deletedSuccessfully',
                                                      );
                                                    },
                                                  ).catchError(
                                                    (error) {
                                                      Utils.customErrorFlushBar(
                                                          context,
                                                          "$errorDeleteText ${employee['r_name']}: \n${error.toString()}");
                                                    },
                                                  );
                                                },
                                                title:
                                                    '$sureWantToDelete \n ${employee['r_name']} ?'),
                                          ]),
                                    ),
                                ]),
                              ]),
                        ),
                      );
                    } else {
                      return const Column(children: [
                        Center(child: CircularProgressIndicator()),
                      ]);
                    }
                  });
            }),
      ),
    );
  }
}
