import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/data_manager.dart';
import '../../../../helper/widget_string.dart';
import '../../../../services/role_service.dart';
import '../../Dashboard/dashboard.dart';

class InsertExpenseModel {
  final BuildContext context;

  InsertExpenseModel(this.context);

// Expense collection reference
  final dbRef = FirebaseFirestore.instance.collection('Expense');
  late String roomId;
  late FirebaseFirestore membersRef;
  late FirebaseFirestore db;
  late String currentUserId;
  List<String> roomNames = [];
  late String formattedDate;

  // Method to get current date and time
  Future<void> getCurrentDateTime() async {
    DateTime now = DateTime.now();
    formattedDate = DateFormat('MMMM dd, yyyy - hh:mm a').format(now);
  }

  // Method to fetch room data list
  Future<List<String>> fetchRoomDataList() async {
    if (RoleUtils.isAdmin) {
      return fetchData();
    } else {
      return fetchRoomNames();
    }
  }

  // Method to fetch room names
  Future<List<String>> fetchRoomNames() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return []; // Return an empty list if user is not authenticated
    }
    String currentUserId = user.uid;
    // Fetch data from Firestore instead of Realtime Database
    QuerySnapshot membersQuery = await FirebaseFirestore.instance
        .collection('Members')
        .where('uid', isEqualTo: currentUserId)
        .get();
    List<String> roomIds = [];
    if (membersQuery.docs.isNotEmpty) {
      for (var doc in membersQuery.docs) {
        String roomId = doc['r_id'];
        roomIds.add(roomId);
      }
    }

    List<Future<DocumentSnapshot>> futures = roomIds
        .map(
            (id) => FirebaseFirestore.instance.collection("Room").doc(id).get())
        .toList();
    List<DocumentSnapshot> snapshots = await Future.wait(futures);
    // Extract room names from snapshots and return as a list
    return snapshots
        .map((snapshot) => snapshot.get("r_name").toString())
        .toList();
  }

  // Method to fetch room data
  Future<List<String>> fetchData() async {
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

  // Method to fetch Firestore ID for the selected room
  Future<void> fetchFirestoreId(String? selectedVal) async {
    // Retrieve roomId from Firestore based on selected room name
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

  // Method to insert expense into Firestore
  Future<void> insertExpense() async {
    Map<String, dynamic> expense = {
      'r_id': roomId,
      'e_amt': userAmountController.text,
      'exp_name': expenseNameController.text,
      'e_desc': userDescController.text,
      'cel_dte': formattedDate,
      'uid': currentLoginUserId,
      'timeStamp': Utils.storeCurrentTimestamp(),
    };
    // Update room details data
    DataManager.updateRoomDetailsData(roomId);
    dbRef.doc().set(expense).then((_) async {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(
                initialSelectedIndex: 2,
                flushBarMessage: '$expenseName $dataAddedSuccessfully'),
          ));
    }).catchError((error) {
      Utils.customErrorFlushBar(
          context, "Failed to add expense: \n${error.toString()}");
    });
    userAmountController.addListener(() {
      if (userAmountController.text.length > 6) {
        userAmountController.text = userAmountController.text.substring(0, 6);
        userAmountController.selection = TextSelection.fromPosition(
            TextPosition(offset: userAmountController.text.length));
      }
    });
  }
}
