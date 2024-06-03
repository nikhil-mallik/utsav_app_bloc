import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../helper/data_manager.dart';
import '../../../common_screens/contribution/view/view_details_contribution.dart';
import '../../../global_screen_ui/fetch_contribution_card_ui.dart';
import '../../../global_screen_ui/show_model_buttom_sheet.dart';

class FetchContributionViewModel {
  final BuildContext context;

  FetchContributionViewModel(this.context);

  final dbRef = FirebaseFirestore.instance
      .collection('Contribution')
      .orderBy('timeStamp', descending: true)
      .snapshots();
  final DocumentReference documentReference =
      FirebaseFirestore.instance.collection('Contribution').doc('id');

  // Method to build list item widget for contribution.
  Widget listItem({required Map contribution, required String roomsId}) {
    final String roomId = contribution['r_id'];
    final String userId = contribution['uid'];
    final String contributionName = contribution['con_name'];
    final String contributionAmount = contribution['payment'];
    final String contributionDate = contribution['cel_dte'];
    final String contributionDesc = contribution['c_desc'];
    DataManager.updateRoomDetailsData(roomId);
    return GestureDetector(
      onTap: () async {
        CustomBottomSheet.show(context,
            child: ViewContributionDetails(
                contributionKey: contribution['key'], roomId: roomsId));
      },
      child: Column(
        children: [
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
                        contributionDesc: contributionDesc,
                      );
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
        ],
      ),
    );
  }
}
