import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../helper/amount_format.dart';
import '../../../../helper/data_manager.dart';
import '../../../../helper/widget_string.dart';
import '../../../common_screens/room/view/view_room_details.dart';
import '../../../global_screen_ui/fetch_room_ui.dart';

class UserFetchRoomViewModel {
  final BuildContext context;

  UserFetchRoomViewModel(this.context);

  // Database reference for Members collection
  final dbRef = FirebaseFirestore.instance.collection('Members').snapshots();

  final searchFilter = TextEditingController();

  // Method to build list item widget for rooms
  Widget listItem({required Map user, required Map employee}) {
    final String roomId = user['r_id'];
    final String userId = user['uid'];

    // Update room details data
    DataManager.updateRoomDetailsData(roomId);

    if (userId == currentLoginUserId) {
      // If the user ID matches the current logged-in user ID
      return Column(children: [
        FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance.collection('Room').doc(roomId).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final String roomName = snapshot.data!['r_name'];
                final String roomDesc = snapshot.data!['r_desc'];
                final String roomDate = snapshot.data!['cel_dte'];
                final String totalExpense = snapshot.data!['expense'];
                final String totalContribution = snapshot.data!['contribution'];
                final String totalMembers = snapshot.data!['member'];
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
                    totalExpense:
                        AmountFormat.formatAmount(int.parse(totalExpense)),
                    totalContribution:
                        AmountFormat.formatAmount(int.parse(totalContribution)),
                    totalMembers:
                        AmountFormat.formatAmount(int.parse(totalMembers)),
                  ),
                );
              } else {
                return Container();
              }
            }),
      ]);
    } else {
      // If the user ID does not match the current logged-in user ID, return an empty container
      return Container();
    }
  }
}
