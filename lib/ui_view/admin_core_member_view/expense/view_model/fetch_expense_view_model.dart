import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/data_manager.dart';
import '../../../common_screens/expense/view/view_details_expense.dart';
import '../../../global_screen_ui/fetch_expense_card_ui.dart';
import '../../../global_screen_ui/show_model_buttom_sheet.dart';

class FetchExpenseViewModel {
  final BuildContext context;

  FetchExpenseViewModel(this.context);

  // Database reference for expenses collection
  final dbRef = FirebaseFirestore.instance
      .collection('Expense')
      .orderBy('timeStamp', descending: true)
      .snapshots();

  // Document reference for expenses collection
  final DocumentReference documentReference =
      FirebaseFirestore.instance.collection('Expense').doc('id');

  // Controller for search filter
  final searchFilter = TextEditingController();

  // Method to build list item for expense
  Widget listItem({required Map expense, required String roomsId}) {
    final String roomId = expense['r_id'];
    final String userId = expense['uid'];
    final String expenseName = expense['exp_name'];
    final String expenseAmount = expense['e_amt'];
    final String expenseDate = expense['cel_dte'];
    final String expenseDesc = expense['e_desc'];
    DataManager.updateRoomDetailsData(roomId);
    return GestureDetector(
      onTap: () async {
        CustomBottomSheet.show(context,
            child:
                ViewExpenseDetails(expenseKey: expense['key'], roomId: roomId));
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
                      return FetchExpenseCard(
                        userName: userName,
                        userPic: userPic,
                        expenseName: expenseName,
                        roomName: roomName,
                        expenseAmount: expenseAmount,
                        expenseDate: expenseDate,
                        expenseDesc: expenseDesc,
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              } else {
                return Container();
              }
            }),
      ]),
    );
  }
}
