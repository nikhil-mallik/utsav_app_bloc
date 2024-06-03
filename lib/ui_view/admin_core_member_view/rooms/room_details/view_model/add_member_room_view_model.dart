import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../helper/custom_flushbar.dart';
import '../../../../../helper/data_manager.dart';
import '../../../../../helper/text_controller_focus_node.dart';
import '../../../../../helper/widget_string.dart';
import '../../../../common_screens/room/view/view_room_details.dart';

class AddMemberRoomViewModel {
  final BuildContext context;

  AddMemberRoomViewModel(this.context);

  late String roomId;
  late String userId;

  // Method to fetch current date
  void getCurrentDateTime() {
    DateTime now = DateTime.now();
    formattedDate = DateFormat('MMMM dd, yyyy').format(now);
  }

  // Firestore reference for members collection
  final CollectionReference<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('Members');

  // Method to fetch Firestore ID for a selected room
  Future<void> fetchFirestoreId(String? selectedVal) async {
    await FirebaseFirestore.instance
        .collection('Room')
        .where('r_name', isEqualTo: selectedVal)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        roomId = snapshot.docs[0].id;
      } else {
        debugPrint('No room found with name $selectedVal');
      }
    }).catchError((error) {
      debugPrint('Error retrieving room id: $error');
    });
  }

  // Method to fetch room names from Firestore
  Future<List<String>> fetchRoomName() async {
    List<String> items = [];
    await FirebaseFirestore.instance
        .collection('Room')
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        items.add(result.data()['r_name']);
      }
    });
    return items;
  }

  // Method to fetch Firestore ID for a selected user email
  Future<void> fetchFirestoreUserId(String? selectedMail) async {
    // Retrieve roomId from Firestore based on selected room name
    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: selectedMail)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        userId = snapshot.docs[0].id;
      } else {
        debugPrint('No email found with email $selectedMail');
      }
    }).catchError((error) {
      debugPrint('Error retrieving user id: $error');
    });
  }

  // Method to fetch user emails from Firestore
  Future<List<String>> fetchUserEmail() async {
    List<String> itemsMail = [];
    await FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        itemsMail.add(result.data()['email']);
      }
    });
    return itemsMail;
  }

  // Method to add user to Firestore
  Future<void> dbAddUser(String employeeKey, String roomKey) async {
    Map<String, dynamic> user = {
      'r_id': employeeKey,
      'cel_dte': formattedDate,
      'uid': userId,
    };
    DataManager.updateRoomMembers(employeeKey);
    // Check if the selected email with the same r_id already exists
    QuerySnapshot querySnapshot = await ref
        .where('uid', isEqualTo: userId)
        .where('r_id', isEqualTo: employeeKey)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      // Show an alert message indicating that the email already exists
      Utils.customFlushBar(
          // ignore: use_build_context_synchronously
          context,
          '$email member already exists in this room');
      return; // Return without adding the user data
    }
    // If the email with the same r_id doesn't exist, proceed to add the user
    ref.doc().set(user).then((value) {}).onError((error, stackTrace) {
      Utils.customFlushBar(context, error.toString());
    });
    Utils.clearTextFields([userNameController, userEmailController]);
    Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => Show_Room_Details(
              employeeKey: employeeKey,
              roomId: roomKey,
              flushBarMessage: '$email \n added to the room'),
        ));
  }
}
