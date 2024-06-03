import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/widget_string.dart';
import '../../../services/role_service.dart';
import '../../participant_view/rooms/view/fetch_room_data.dart';
import '../Rooms/View/fetch_room_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    updateRoles();
  }

  // Method to update roles
  Future<void> updateRoles() async {
    await RoleUtils.updateRoles();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: appTitleText,
      ),
      body: RoleUtils.isAdminCoreMember
          ? const FetchRoomData()
          : const User_FetchRoomData(),
    );
  }
}
