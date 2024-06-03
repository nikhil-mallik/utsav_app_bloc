import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/widget_string.dart';
import '../../../../services/role_service.dart';

import '../../admin_core_member_view/contribution/view/fetch_contribution_ui.dart';
import '../../admin_core_member_view/dashboard/Home.dart';
import '../../admin_core_member_view/expense/view/fetch_Expense_data.dart';
import '../../participant_view/contribution/view/fetch_form_ui.dart';
import '../../participant_view/expense/view/fetch_Expense_data.dart';
import 'setting.dart';

class Dashboard extends StatefulWidget {
  static int defaultSelectedIndex = 0;
  final int initialSelectedIndex;
  final String? flushBarMessage;

  const Dashboard(
      {super.key, this.initialSelectedIndex = 0, this.flushBarMessage});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
  bool loading = true;

  // Handle item tap in bottom navigation bar
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Pages for Admin and Core members
  final List<Widget> isAdminCoreMemberPages = [
    const Home(),
    const FetchPaymentData(),
    const FetchExpenseData(),
    const Setting(),
  ];

  // Pages for participants
  final List<Widget> isParticipantPages = [
    const Home(),
    const User_FetchPaymentData(),
    const User_FetchExpenseData(),
    const Setting(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelectedIndex;
    // Check if flushBarMessage is not null, then display FlushBar
    if (widget.flushBarMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Utils.customFlushBar(context, widget.flushBarMessage!);
      });
    }
    updateRoles();
  }

  // Update user roles
  Future<void> updateRoles() async {
    await RoleUtils.updateRoles();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevent popping from navigation stack
      canPop: false,
      onPopInvoked: (bool didPop) async {
        Dashboard.defaultSelectedIndex = selectedIndex;
        Utils.onBackpressed(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: RoleUtils.isAdminCoreMember
            ? isAdminCoreMemberPages[selectedIndex]
            : isParticipantPages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.bgColor,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home), label: dashboardLabelText),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.handshake_outlined),
                  label: contributionLabelText),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.menu_book_rounded),
                  label: expenseLabelText),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.settings_suggest_outlined),
                  label: settingLabelText),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: AppColors.appbariconColor,
            onTap: _onItemTapped),
      ),
    );
  }
}
