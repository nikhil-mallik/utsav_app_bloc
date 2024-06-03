import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../helper/data_manager.dart';
import '../../../../helper/widget_string.dart';
import '../../../common_screens/contribution/view/view_details_contribution.dart';
import '../../../global_screen_ui/fetch_contribution_card_ui.dart';
import '../../../global_screen_ui/show_model_buttom_sheet.dart';

class UserFetchContributionViewModel {
  final BuildContext context;

  UserFetchContributionViewModel(this.context);

  final searchFilter = TextEditingController();

  // Reference to the Contribution collection ordered by timestamp
  final dbRef = FirebaseFirestore.instance
      .collection('Contribution')
      .orderBy('timeStamp', descending: true)
      .snapshots();

  // Method to build list item widget for contributions
  Widget listItem({required Map contribution, required String roomsId}) {
    final String roomId = contribution['r_id'];
    final String userId = contribution['uid'];
    final String contributionName = contribution['con_name'];
    final String contributionAmount = contribution['payment'];
    final String contributionDate = contribution['cel_dte'];
    final String contributionDesc = contribution['c_desc'];
    DataManager.updateRoomDetailsData(roomsId);
    DataManager.updateCurrentUserAmountData(currentLoginUserId);
    if (userId == currentLoginUserId) {
      // If the contribution belongs to the current logged-in user
      return GestureDetector(
        onTap: () async {
          // Show custom bottom sheet with contribution details
          CustomBottomSheet.show(context,
              child: ViewContributionDetails(
                  contributionKey: contribution['key'], roomId: roomsId));
        },
        child: Column(children: [
          FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance.collection('Room').doc(roomId).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                      final String userPic = userSnapshot.data!['u_img'];
                      return FetchContributionCard(
                          userName: userName,
                          userPic: userPic,
                          contributionName: contributionName,
                          roomName: roomName,
                          contributionAmount: contributionAmount,
                          contributionDate: contributionDate,
                          contributionDesc: contributionDesc);
                    } else {
                      return Container();
                    }
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ]),
      );
    } else {
      // If the contribution does not belong to the current logged-in user, return an empty container
      return Container();
    }
  }
}
