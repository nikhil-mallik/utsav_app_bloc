import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/data_manager.dart';
import '../../../../helper/widget_string.dart';
import '../../../common_screens/expense/view/view_details_expense.dart';
import '../../../global_screen_ui/fetch_expense_card_ui.dart';
import '../../../global_screen_ui/show_model_buttom_sheet.dart';

class UserFetchExpenseViewModel {
  final BuildContext context;

  UserFetchExpenseViewModel(this.context);

  // Reference to the Expense collection ordered by timestamp
  final dbRef = FirebaseFirestore.instance
      .collection('Expense')
      .orderBy('timeStamp', descending: true)
      .snapshots();
  final DocumentReference documentReference =
      FirebaseFirestore.instance.collection('Expense').doc('id');

  final searchFilter = TextEditingController();

  // Method to build list item widget for expenses
  Widget listItem({required Map expense, required String roomsId}) {
    final String roomId = expense['r_id'];
    final String userId = expense['uid'];
    final String expenseName = expense['exp_name'];
    final String expenseAmount = expense['e_amt'];
    final String expenseDate = expense['cel_dte'];
    final String expenseDesc = expense['e_desc'];
    // Update room details data
    DataManager.updateRoomDetailsData(roomsId);
    // Update current user's amount data
    DataManager.updateCurrentUserAmountData(currentLoginUserId);
    if (userId == currentLoginUserId) {
      return GestureDetector(
        onTap: () async {
          // Show custom bottom sheet with expense details
          CustomBottomSheet.show(context,
              child: ViewExpenseDetails(
                  expenseKey: expense['key'], roomId: roomsId));
        },
        child: Column(children: [
          FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Room')
                  .doc(roomId)
                  .get(),
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
                        if (userSnapshot.connectionState ==
                                ConnectionState.done &&
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
                              expenseDesc: expenseDesc);
                        } else {
                          return Container();
                        }
                      });
                } else {
                  return Container();
                }
              }),
        ]),
      );
    } else {
      // If the expense does not belong to the current logged-in user, return an empty container
      return Container();
    }
  }
}
