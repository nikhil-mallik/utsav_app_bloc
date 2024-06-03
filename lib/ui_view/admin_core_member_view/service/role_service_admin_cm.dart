import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../helper/custom_flushbar.dart';

class RoleService {
  List adminRolePermission = [
    'CREATE_ROOM',
    'VIEW_ROOM',
    'EDIT_ROOM',
    'ROOM_LIST',
    'DELETE_ROOM',
    'ADD_MEMBER',
    'DELETE_MEMBER',
    'DEMOTE_MEMBER',
    'VIEW_MEMBER',
    'VIEW_PARTICIPANT',
    'ADD_PARTICIPANT',
    'DELETE_PARTICIPANT',
    'PROMOTE_PARTICIPANT',
    'VIEW_CELEBRATION',
    'CREATE_CELEBRATION',
    'EDIT_CELEBRATION',
    'DELETE_CELEBRATION',
    'CREATE_EXPENSE',
    'EDIT_EXPENSE',
    'DELETE_EXPENSE',
    'VIEW_EXPENSE',
    'ADD_CONTRIBUTION',
    'VIEW_CONTRIBUTION',
  ];

  List coreMemberRolePermission = [
    'VIEW_PARTICIPANT',
    'ADD_PARTICIPANT',
    'DELETE_PARTICIPANT',
    'PROMOTE_PARTICIPANT',
    'VIEW_CELEBRATION',
    'CREATE_CELEBRATION',
    'EDIT_CELEBRATION',
    'DELETE_CELEBRATION',
    'CREATE_EXPENSE',
    'EDIT_EXPENSE',
    'DELETE_EXPENSE',
    'VIEW_EXPENSE',
    'ADD_CONTRIBUTION',
    'VIEW_CONTRIBUTION',
  ];

  bool isAdmin = false; // initialize as false

  Future<bool> checkRoleAdminCoreMember(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userRef =
          FirebaseFirestore.instance.collection('Users').doc(userId);
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final roleId = userSnapshot.get('role_id') as String?;
        final roleRef =
            FirebaseFirestore.instance.collection('Role').doc(roleId);
        final roleSnapshot = await roleRef.get();
        if (roleSnapshot.exists) {
          final role = roleSnapshot.data()!;
          final roleName = role['role'];
          final rolePermission = role['permission'] as List;
          if (roleName == 'Admin' || rolePermission == adminRolePermission) {
            debugPrint("$rolePermission");
            return true;
          } else {
            debugPrint("$rolePermission");
            return false;
          }
        }
      } else {
        // ignore: use_build_context_synchronously
        Utils.customFlushBar(context, 'Role not found.');
      }
    } else {
      Utils.customFlushBar(context, 'User not found.');
    }
    return false;
  }
}

class ButtonEnable {
  // late final DatabaseEvent REF;
  late final String currentUserId;
  bool currentUserID = false;

  getCurrentUserId() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user != null) {
      currentUserId = user.uid;
    }
  }
}

class RolePrint extends StatefulWidget {
  const RolePrint({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RolePrintState createState() => _RolePrintState();
}

class _RolePrintState extends State<RolePrint> {
  RoleService roleService = RoleService();
  bool isAdmin = false; // initialize as false

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      roleService.checkRoleAdminCoreMember(context).then((value) {
        setState(() {
          isAdmin = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello"),
      ),
      body: Center(
        child: Column(
          children: [
            Visibility(
              visible: isAdmin, // show the button if isAdmin is true
              child: ElevatedButton(
                onPressed: () {
                  // handle button press
                },
                child: const Text('CanCreate room'),
              ),
            ),
            const Text('Create room'),
          ],
        ),
      ),
    );
  }
}
