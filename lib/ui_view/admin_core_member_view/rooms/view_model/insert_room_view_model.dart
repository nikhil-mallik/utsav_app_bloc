import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/widget_string.dart';
import '../../../common_screens/dashboard/dashboard.dart';

class InsertRoomViewModel {
  final BuildContext context;

  InsertRoomViewModel(this.context);

  // Method to get the current user's ID
  currentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid.toString();
    return uid;
  }

  // Firestore reference for room collection
  final dbRef = FirebaseFirestore.instance.collection('Room');

  late String formattedDate;

  // Method to get the current date and time
  void getCurrentDateTime() {
    DateTime now = DateTime.now();
    formattedDate = DateFormat('MMMM dd, yyyy').format(now);
  }

  // Method to insert room data into Firestore
  Future<void> insertRoom() async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    dbRef.doc(id).set({
      'r_name': userRoomNameController.text.toString(),
      'r_desc': userRoomDescController.text.toString(),
      'cel_dte': formattedDate,
      'r_id': id,
      'uid': currentUser(),
      'timeStamp': Utils.storeCurrentTimestamp(),
      'expense': '0',
      'member': '0',
      'contribution': '0',
      'balance': '0',
      'updatedAt': ''
    }).then((value) async {
      Utils.clearTextFields(
          [userRoomNameController, userRoomDescController, dateCtl]);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard(
                flushBarMessage: '$room data added in record successfully')),
      );
    }).onError((error, stackTrace) {
      Utils.customFlushBar(
          context, 'Failed to add room: \n${error.toString()}');
    });
  }
}
