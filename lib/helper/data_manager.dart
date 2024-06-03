import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'amount_format.dart';

class DataManager {
  // Function to get total contribution of the current user
  static Future<String> getTotalCurrentUserContribution(
      String currentUserId) async {
    // Reference to the 'Contribution' collection
    final collectionRef = FirebaseFirestore.instance.collection('Contribution');
    // Query to get contributions of the current user
    final query = collectionRef.where('uid', isEqualTo: currentUserId);
    // Get the query snapshot
    final querySnapshot = await query.get();
    // Initialize total contribution
    int totalContribution = 0;
    // Loop through documents in the query snapshot
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      // Parse contribution amount from data
      int contribution = int.parse(data['payment'] as String);
      // Add contribution amount to total
      totalContribution += contribution;
    }
    // Format total contribution amount
    String formattedContribution = AmountFormat.formatAmount(totalContribution);
    // Return formatted total contribution
    return formattedContribution;
  }

// Function to get total expense of the current user
  static Future<String> getTotalCurrentUserExpense(String currentUserId) async {
    // Reference to the 'Expense' collection
    final collectionRef = FirebaseFirestore.instance.collection('Expense');
    // Query to get expenses of the current user
    final query = collectionRef.where('uid', isEqualTo: currentUserId);
    // Get the query snapshot
    final querySnapshot = await query.get();
    // Initialize total expense
    int totalExpense = 0;
    // Loop through documents in the query snapshot
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      // Parse expense amount from data
      int expense = int.parse(data['e_amt'] as String);
      // Add expense amount to total
      totalExpense += expense;
    }
    // Format total expense amount
    String formattedExpenseAmount = AmountFormat.formatAmount(totalExpense);
    // Return formatted total expense
    return formattedExpenseAmount;
  }

// Function to update current user's amount data asynchronously
  static Future<void> updateCurrentUserAmountData(String currentUserId) async {
    // Call functions to get total expense and contribution of the current user
    await getTotalCurrentUserExpense(currentUserId);
    await getTotalCurrentUserContribution(currentUserId);
  }

// Function to update room details data asynchronously
  static Future<void> updateRoomDetailsData(String roomID) async {
    // Update room contribution
    await updateRoomContribution(roomID);
    // Update room balance
    await updateRoomBalance(roomID);
    // Update room expense
    await updateRoomExpense(roomID);
    // Update room members
    await updateRoomMembers(roomID);
    // Get total contribution (no need to await)
    getTotalContribution();
    // Get total expense (no need to await)
    getTotalExpense();
  }

// Function to update room contribution asynchronously
  static Future<void> updateRoomContribution(String roomID) async {
    // Reference to the 'Room' collection
    final ref = FirebaseFirestore.instance.collection('Room');

    // Get current total contribution for the room
    String currentPayment = await getTotalCurrentRoomContribution(roomID);

    // Check if current payment is not empty
    if (currentPayment.isNotEmpty) {
      try {
        // Prepare data to update room contribution
        String totalContribution = currentPayment;
        Map<String, dynamic> totalContributeAmount = {
          'contribution': totalContribution,
        };
        // Update room contribution
        await ref.doc(roomID).update(totalContributeAmount);
      } catch (e) {
        // Handle errors (e.g., parsing fails)
        debugPrint("Error parsing current contribution: $e");
      }
    }
  }

// Function to update room expense asynchronously
  static Future<void> updateRoomExpense(String roomID) async {
    // Reference to the 'Room' collection
    final ref = FirebaseFirestore.instance.collection('Room');
    // Get current total expense for the room
    String currentExpense = await getTotalCurrentRoomExpense(roomID);
    // Check if current expense is not empty
    if (currentExpense.isNotEmpty) {
      try {
        // Prepare data to update room expense
        String totalExpense = currentExpense;
        await ref.doc(roomID).update({'expense': totalExpense});
      } catch (e) {
        // Handle errors (e.g., parsing fails)
        debugPrint("Error parsing current contribution: $e");
      }
    }
  }

// Function to update room members asynchronously
  static Future<void> updateRoomMembers(String roomID) async {
    // Reference to the 'Room' collection
    final ref = FirebaseFirestore.instance.collection('Room');

    // Get current total members for the room
    String currentMembers = await getTotalCurrentRoomMembers(roomID);

    // Check if current members is not empty
    if (currentMembers.isNotEmpty) {
      try {
        // Prepare data to update room members
        String totalMembers = currentMembers;
        await ref.doc(roomID).update({'member': totalMembers});
      } catch (e) {
        // Handle errors (e.g., parsing fails)
        debugPrint("Error parsing current contribution: $e");
      }
    }
  }

// Function to update room balance asynchronously
  static Future<void> updateRoomBalance(String roomID) async {
    // Reference to the 'Room' collection
    final ref = FirebaseFirestore.instance.collection('Room');

    // Get current total difference for the room
    String currentDifference = await getTotalCurrentRoomDifference(roomID);

    // Check if current difference is not empty
    if (currentDifference.isNotEmpty) {
      try {
        // Prepare data to update room balance
        String totalDifference = currentDifference;
        await ref.doc(roomID).update({'balance': totalDifference});
      } catch (e) {
        // Handle errors (e.g., parsing fails)
        debugPrint("Error parsing current difference: $e");
      }
    }
  }

// Function to get total expense for the current room asynchronously
  static Future<String> getTotalCurrentRoomExpense(String roomId) async {
    // Query to get expenses for the current room
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Expense')
        .where('r_id', isEqualTo: roomId)
        .get();

    // Initialize total expense
    int totalExpense = 0;

    // Calculate total expense
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        totalExpense += int.parse(doc.get('e_amt') as String);
      }
    }

    // Convert total expense to string and return
    String expense = totalExpense.toString();
    return expense;
  }

// Function to get total difference for the current room asynchronously
  static Future<String> getTotalCurrentRoomDifference(String roomId) async {
    // Query to get contributions for the current room
    QuerySnapshot contributionSnapshot = await FirebaseFirestore.instance
        .collection('Contribution')
        .where('r_id', isEqualTo: roomId)
        .get();
    // Query to get expenses for the current room
    QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
        .collection('Expense')
        .where('r_id', isEqualTo: roomId)
        .get();
    // Initialize total contribution and total expense
    int totalContribution = 0;
    int totalExpense = 0;
    // Calculate total contribution
    if (contributionSnapshot.docs.isNotEmpty) {
      for (var doc in contributionSnapshot.docs) {
        totalContribution += int.parse(doc.get('payment') as String);
      }
    }
    // Calculate total expense
    if (expenseSnapshot.docs.isNotEmpty) {
      for (var doc in expenseSnapshot.docs) {
        totalExpense += int.parse(doc.get('e_amt') as String);
      }
    }
    // Calculate difference between contribution and expense
    var result = totalContribution - totalExpense;
    // Convert result to string and return
    String balance = result.toString();
    return balance;
  }

// Function to get total contribution for the current room asynchronously
  static Future<String> getTotalCurrentRoomContribution(String roomId) async {
    // Query to get contributions for the current room
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Contribution')
        .where('r_id', isEqualTo: roomId)
        .get();
    // Initialize total contribution
    int totalContribution = 0;
    // Calculate total contribution
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        totalContribution += int.parse(doc.get('payment') as String);
      }
    }
    // Convert total contribution to string and return
    String contribute = totalContribution.toString();
    return contribute;
  }

// Function to get total members for the current room asynchronously
  static Future<String> getTotalCurrentRoomMembers(String roomId) async {
    // Query to get members for the current room
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Members')
        .where('r_id', isEqualTo: roomId)
        .get();
    // Calculate total members
    int totalMembers = snapshot.size;
    // Convert total members to string and return
    String members = totalMembers.toString();
    return members;
  }

// Function to get all details of the current room asynchronously
  static Future<Map<String, String>> getAllCurrentRoomDetails(
      String roomId) async {
    // Initialize a map to store room details
    Map<String, String> data = {};
    // Get and store total expense for the room
    data['expense'] = await getTotalCurrentRoomExpense(roomId);
    // Get and store total contribution for the room
    data['contribution'] = await getTotalCurrentRoomContribution(roomId);
    // Get and store total members for the room
    data['member'] = await getTotalCurrentRoomMembers(roomId);
    // Get and store total balance for the room
    data['balance'] = await getTotalCurrentRoomDifference(roomId);
    // Return the map containing room details
    return data;
  }

// Function to get total contribution from all rooms asynchronously
  static Future<String> getTotalContribution() async {
    // Initialize total contribution
    int totalContribution = 0;
    // Reference to the 'Contribution' collection
    final collectionRef = FirebaseFirestore.instance.collection('Contribution');
    // Get snapshot of all documents in the 'Contribution' collection
    final snapshot = await collectionRef.get();
    // Calculate total contribution
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        int contribution = int.parse(data['payment'] as String);
        totalContribution += contribution;
      }
    }
    // Format total contribution amount
    String formattedContribution = AmountFormat.formatAmount(totalContribution);
    // Return formatted total contribution
    return formattedContribution;
  }

// Function to get total expense from all rooms asynchronously
  static Future<String> getTotalExpense() async {
    // Initialize total expense
    int totalExpense = 0;
    // Get snapshot of all documents in the 'Expense' collection
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Expense').get();
    // Calculate total expense
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        totalExpense += int.parse(doc.get('e_amt') as String);
      }
    }
    // Format total expense amount
    String formattedExpenseAmount = AmountFormat.formatAmount(totalExpense);
    // Return formatted total expense
    return formattedExpenseAmount;
  }
}
