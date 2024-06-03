import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../common_screens/celebration/view/view_details_celebration.dart';
import '../../../global_screen_ui/fetch_celebration_card_ui.dart';
import '../../../global_screen_ui/show_model_buttom_sheet.dart';


class FetchCelebrationViewModel {
  final BuildContext context;

  FetchCelebrationViewModel(this.context);

  final searchFilter = TextEditingController();
  final dbRef =
      FirebaseFirestore.instance.collection('Celebration').snapshots();
  final docRef = FirebaseFirestore.instance
      .collection('Celebration')
      .orderBy('timeStamp', descending: true)
      .snapshots();

  // Method to build list item widget for celebration.
  Widget listItem({required Map celebrate, required String roomsId}) {
    final String roomId = celebrate['r_id'];
    final String userId = celebrate['uid'];
    final String celebrationName = celebrate['cel_name'];
    final String celebrationDesc = celebrate['cel_desc'];
    final String celebrationDate = celebrate['cel_dte'];
    final String celebrationTime = celebrate['cel_tme'];
    return GestureDetector(
      onTap: () async {
        CustomBottomSheet.show(context,
            child: ViewCelebrationDetails(
                celebrationKey: celebrate['key'], roomId: roomsId));
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
                      return FetchCelebrationCardUI(
                          userName: userName,
                          userPic: userPic,
                          roomName: roomName,
                          celebrationName: celebrationName,
                          celebrationDesc: celebrationDesc,
                          celebrationDate: celebrationDate,
                          celebrationTime: celebrationTime);
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
