import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/global_width.dart';

class LedgerSheetViewModel {
  final BuildContext context;

  LedgerSheetViewModel(this.context);

// Collection reference from Database
  final userCollection = FirebaseFirestore.instance.collection('Users');
  final expenseCollection = FirebaseFirestore.instance.collection('Expense');
  final contributionCollection =
      FirebaseFirestore.instance.collection('Contribution');
  late String userName;
  late String userPic;

  // Method to fetch and combine data from expense and contribution collections
  Future<List<Map<String, dynamic>>> getCombinedData() async {
    final expenseSnapshot =
        await expenseCollection.orderBy('timeStamp', descending: true).get();
    final contributionSnapshot = await contributionCollection
        .orderBy('timeStamp', descending: true)
        .get();
    List<Map<String, dynamic>> combinedData = [];
    combinedData.addAll(expenseSnapshot.docs.map((doc) => doc.data()));
    combinedData.addAll(contributionSnapshot.docs.map((doc) => doc.data()));
    combinedData.sort((a, b) => a['timeStamp'].compareTo(b['timeStamp']));
    if (combinedData.isNotEmpty && combinedData[0].containsKey('uid')) {
      userData(combinedData[0]['uid']);
    }
    // Returning the combined data
    return combinedData;
  }

  // Method to fetch user data based on user ID
  Future<void> userData(String addedUserId) async {
    try {
      // Fetching user snapshot
      final userSnapshot = await userCollection.doc(addedUserId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        userName = userData['u_name'];
        userPic = userData['u_img'];
      } else {
        debugPrint('User does not exist');
      }
    } catch (error) {
      debugPrint('Error fetching user data: $error');
    }
  }

  // Method to build list item widget based on provided data
  Widget listDemoItem({required Map<String, dynamic> data}) {
    Color textColor;
    List<Widget> columnChildren = [];
    if (data.containsKey('exp_name')) {
      textColor = Colors.red;
    } else if (data.containsKey('con_name')) {
      textColor = Colors.green;
    } else {
      textColor = Colors.black;
    }
    if (data['exp_name'] != null && data['e_amt'] != null) {
      columnChildren.add(Text(
        data['exp_name'],
        style: TextStyle(color: textColor),
      ));
      columnChildren.add(
        Text(data['e_amt'], style: TextStyle(color: textColor)),
      );
    }

    if (data['con_name'] != null && data['payment'] != null) {
      columnChildren.add(
        Text(data['con_name'], style: TextStyle(color: textColor)),
      );
      columnChildren.add(
        Text(data['payment'], style: TextStyle(color: textColor)),
      );
    }

    return SizedBox(
      width: GlobalWidthValues.multiplyWidth(.9, context),
      child: Card(
        elevation: 8.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: AppColors.cardColor),
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Row(children: [
              Container(
                height: 90,
                width: 65,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: userPic.isNotEmpty
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                          imageUrl: userPic)
                      : Container(
                          color: AppColors.circleColor,
                          alignment: Alignment.center,
                          child: Text(userName[0].toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: AppColors.circletextColor,
                                  fontWeight: FontWeight.bold)),
                        ),
                ),
              ),
              Column(children: columnChildren),
            ]),
          ]),
        ),
      ),
    );
  }
}
