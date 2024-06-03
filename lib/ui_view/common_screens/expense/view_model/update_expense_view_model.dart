import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/widget_string.dart';
import '../../Dashboard/dashboard.dart';

class UpdateExpenseModel {
  final BuildContext context;
  UpdateExpenseModel(
    this.context,
  );

  // Collection reference for expenses
  CollectionReference dbRef = FirebaseFirestore.instance.collection('Expense');

  // Method to get the current date and time
  void getCurrentDateTime() {
    DateTime now = DateTime.now();
    formattedDate = DateFormat('MMMM dd, yyyy - hh:mm a').format(now);
  }

  // Method to fetch expense data based on expense key
  void getExpenseData(String expenseKey) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("Expense").doc(expenseKey);
    DocumentSnapshot snapshot = await docRef.get();
    Map<String, dynamic> expense = snapshot.data() as Map<String, dynamic>;
    expenseNameController.text = expense['exp_name'];
    userDescController.text = expense['e_desc'];
    userAmountController.text = expense['e_amt'];
    dateCtl.text = expense['cel_dte'];
  }

  // Method to update expense in Firestore
  Future<void> updateExpense(String expenseKey) async {
    // Expense data to be updated
    Map<String, dynamic> expense = {
      'e_amt': userAmountController.text,
      'exp_name': expenseNameController.text,
      'e_desc': userDescController.text,
      'cel_dte': formattedDate,
      'updatedAt': formattedDate,
      'timeStamp': Utils.storeCurrentTimestamp(),
    };

    // Update expense document in Firestore
    dbRef.doc(expenseKey).update(expense).then((_) async {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(
                initialSelectedIndex: 2,
                flushBarMessage: '$expenseName $dataUpdatedSuccessfully'),
          ));
      // Clear text fields after updating expense
      Utils.clearTextFields([
        userDescController,
        userAmountController,
        expenseNameController,
        dateCtl
      ]);
    }).catchError((error) {
      // Show error flushbar if update fails
      Utils.customErrorFlushBar(
          context, "Failed to update $expenseName: \n${error.toString()}");
    });
    userAmountController.addListener(() {
      if (userAmountController.text.length > 6) {
        userAmountController.text = userAmountController.text.substring(0, 6);
        userAmountController.selection = TextSelection.fromPosition(
          TextPosition(offset: userAmountController.text.length),
        );
      }
    });
  }
}
