import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/widget_string.dart';
import '../../../../services/role_service.dart';
import '../View/fetch_role_data.dart';

class UpdateRoleViewModel {
  final BuildContext context;

  late String roleId;

  // Role lists for admin and core member
  final adminRoleList = ["Participant", "Core Member", "Admin"];
  final coreMemberRoleList = ["Participant", "Core Member"];
  late final List<String> roleList;
  CollectionReference ref = FirebaseFirestore.instance.collection('Users');

  UpdateRoleViewModel(this.context) {
    // Initialize roleList based on the condition whether the user is an admin or core member
    roleList = RoleUtils.isAdmin ? adminRoleList : coreMemberRoleList;
  }

  // Fetch role ID from Firestore based on selected role name
  Future<void> fetchRoleId(String? selectedVal) async {
    await FirebaseFirestore.instance
        .collection('Role')
        .where('role', isEqualTo: selectedVal)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        roleId = snapshot.docs[0].id;
      } else {
        debugPrint('No room found with name $selectedVal');
      }
    }).catchError((error) {
      debugPrint('Error retrieving room id: $error');
    });
  }

  // Get user data based on user key
  void getRoleData(String userKey) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("Users").doc(userKey);
    DocumentSnapshot snapshot = await docRef.get();
    Map<String, dynamic> user = snapshot.data() as Map<String, dynamic>;
    userNameController.text = user['u_name'];
    userEmailController.text = user['email'];
    userRoleController.text = user['role'];
  }

  // Get role data from Firestore based on user key
  void getRoleFirestoreData(String userKey) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("Role").doc(userKey);
    DocumentSnapshot snapshot = await docRef.get();
    Map<String, dynamic> user = snapshot.data() as Map<String, dynamic>;
    userNameController.text = user['u_name'];
    userEmailController.text = user['email'];
    userRoleController.text = user['role'];
  }

  // Update user role in Firestore
  Future<void> dbUpdateUser(String userKey) async {
    Map<String, String> user = {
      'u_name': userNameController.text,
      'email': userEmailController.text,
      'role_id': roleId
    };

    ref.doc(userKey).update(user).then(
      (value) async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FetchRoleData(
                flushBarMessage: "${user['u_name']} $dataAddedSuccessfully"),
          ),
        );
        Utils.clearTextFields([userNameController, userEmailController]);
      },
    ).catchError((error) {
      Utils.customErrorFlushBar(
          context, "Failed to update role $email: \n${error.toString()}");
    });
  }
}
