import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/widget_string.dart';
import '../../../common_screens/dashboard/dashboard.dart';

class UpdateRoomViewModel {
  final BuildContext context;
  UpdateRoomViewModel(this.context);

  late String formattedDate;

  // Firestore reference for room collection
  CollectionReference dbRef = FirebaseFirestore.instance.collection('Room');

  // Method to get the current date and time
  void getCurrentDateTime() {
    DateTime now = DateTime.now();
    formattedDate = DateFormat('MMMM dd, yyyy').format(now);
  }

  // Method to fetch room data by key
  void getRoomData(String employeeKey) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("Room").doc(employeeKey);
    DocumentSnapshot snapshot = await docRef.get();
    Map<String, dynamic> employee = snapshot.data() as Map<String, dynamic>;
    userRoomNameController.text = employee['r_name'];
    userRoomDescController.text = employee['r_desc'];
    dateCtl.text = employee['cel_dte'];
  }

  // Method to update room data
  Future<void> dbUpdateRoom(String employeeKey) async {
    Map<String, dynamic> employee = {
      'r_name': userRoomNameController.text,
      'r_desc': userRoomDescController.text,
      'updatedAt': formattedDate,
      'timeStamp': Utils.storeCurrentTimestamp(),
    };
    dbRef.doc(employeeKey).update(employee).then(
      (_) async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(
                    flushBarMessage:
                        "${employee['r_name']} $dataAddedSuccessfully")));
        Utils.clearTextFields(
            [userRoomNameController, userRoomDescController, dateCtl]);
      },
    ).catchError((error) {
      Utils.customErrorFlushBar(
          context, "Failed to update $room: \n${error.toString()}");
    });
  }
}
