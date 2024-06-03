import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/widget_string.dart';
import '../View/fetch_celebration_data.dart';

class InsertCelebrationViewModel {
  final BuildContext context;

  InsertCelebrationViewModel(this.context);

  late String roomId;
  final dbRef = FirebaseFirestore.instance.collection('Celebration');

  // Method to fetch room names from Firestore.
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

  // Method to fetch roomId based on selected room name.
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

  // Method to get current user's UID.
  currentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid.toString();
    return uid;
  }

  // Method to insert celebration data into Firestore.
  Future<void> insertCelebration() async {
    Map<String, dynamic> celebrate = {
      'cel_name': userCelNameController.text,
      'cel_desc': userCelDescController.text,
      'cel_dte': dateCtl.text,
      'cel_tme': userTimeInput.text,
      'r_id': roomId,
      'uid': currentUser(),
      'timeStamp': Utils.storeCurrentTimestamp()
    };

    dbRef.doc().set(celebrate).then((_) async {
      Utils.clearTextFields([
        userCelNameController,
        userCelDescController,
        dateCtl,
        userTimeInput
      ]);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FetchCeleData(flushBarMessage: '$celRoom $dataAddedSuccessfully'),
        ),
      );
    }).catchError((error) {
      Utils.customErrorFlushBar(
          context, "Failed to add celebration: \n${error.toString()}");
    });
  }
}
