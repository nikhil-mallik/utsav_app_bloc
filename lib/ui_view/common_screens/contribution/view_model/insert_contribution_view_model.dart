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

class InsertContributionViewModel {
  final BuildContext context;

  InsertContributionViewModel(this.context);

  final dbRef = FirebaseFirestore.instance.collection('Contribution');

  late FirebaseFirestore membersRef;
  late FirebaseFirestore db;
  late String currentUserId;
  List<String> roomNames = [];

  // Get current date and time
  void getCurrentDateTime() {
    DateTime now = DateTime.now();
    formattedDate = DateFormat('MMMM dd, yyyy - hh:mm a').format(now);
  }

  // Fetch room data list based on user role
  Future<List<String>> fetchRoomDataList() async {
    if (RoleUtils.isAdmin) {
      return fetchData();
    } else {
      return fetchRoomNames();
    }
  }

  // Fetch room names from Firestore
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

  // Fetch room data for admin
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

  // Fetch Firestore id based on selected room name
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

  // Insert contribution data into Firestore
  Future<void> insertContribution() async {
    Map<String, dynamic> contribution = {
      'r_id': roomId,
      'con_name': contributionNameController.text,
      'c_desc': userDescController.text,
      'payment': userAmountController.text,
      'cel_dte': formattedDate,
      'uid': currentLoginUserId,
      'timeStamp': Utils.storeCurrentTimestamp(),
    };
    DataManager.updateRoomDetailsData(roomId);
    dbRef.doc().set(contribution).then((_) async {
      Utils.clearTextFields([
        userNameController,
        userDescController,
        contributionNameController,
        userAmountController,
        userTimeInput
      ]);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(
                initialSelectedIndex: 1,
                flushBarMessage: '$contributionName $dataAddedSuccessfully'),
          ));
    }).catchError((error) {
      Utils.customErrorFlushBar(
          context, "Failed to add contribution: \n${error.toString()}");
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
