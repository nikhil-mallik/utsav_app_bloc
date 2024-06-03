import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/amount_format.dart';
import '../../../common_screens/room/view/view_room_details.dart';
import '../../../global_screen_ui/fetch_room_ui.dart';

class FetchRoomViewModel {
  final BuildContext context;

  FetchRoomViewModel(this.context);

  // Firestore document reference for rooms collection
  final dbRef = FirebaseFirestore.instance
      .collection('Room')
      .orderBy('timeStamp', descending: true)
      .snapshots();
  final DocumentReference documentReference =
      FirebaseFirestore.instance.collection('Room').doc('id');

  final searchFilter = TextEditingController();

  // Method to build list item widget for room data
  Widget listItem(
      {required Map<dynamic, dynamic> employee, required String roomId}) {
    final String roomName = employee['r_name'];
    final String roomDesc = employee['r_desc'];
    final String roomDate = employee['cel_dte'];
    final String totalExpense = employee['expense'];
    final String totalContribution = employee['contribution'];
    final String totalMembers = employee['member'];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Show_Room_Details(
                  employeeKey: employee['key'], roomId: roomId),
            ));
      },
      child: FetchRoomCardUI(
        roomName: roomName,
        roomDesc: roomDesc,
        roomDate: roomDate,
        totalExpense: AmountFormat.formatAmount(int.parse(totalExpense)),
        totalContribution:
            AmountFormat.formatAmount(int.parse(totalContribution)),
        totalMembers: AmountFormat.formatAmount(int.parse(totalMembers)),
      ),
    );
  }
}
