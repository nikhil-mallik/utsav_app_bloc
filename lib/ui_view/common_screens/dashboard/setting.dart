import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/widget_button.dart';
import '../../../../helper/widget_string.dart';
import '../../../../services/role_service.dart';
import '../../../helper/settings_tile.dart';
import '../../../services/user_session.dart';
import '../../admin_core_member_view/celebration/view/fetch_celebration_data.dart';
import '../../admin_core_member_view/rooms/view/insert_room_data.dart';
import '../../admin_core_member_view/user_role_details/view/fetch_role_data.dart';
import '../../authentication_screen/forget_reset_password/change_password.dart';
import '../../authentication_screen/login/view/login_page.dart';
import '../../participant_view/celebration/view/fetch_celebration_data.dart';
import 'profile.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late SharedPreferences logindata;
  bool loading = true;

  // Method to update user roles
  Future<void> updateRoles() async {
    await RoleUtils.updateRoles();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    updateRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: RoleUtils.isAdminCoreMember
            ? CustomAppBar(
                title: settingLabelText,
                trailingIcon: Icons.logout_outlined,
                trailingOnPressed: () => logOutAlert())
            : CustomAppBar(title: settingLabelText),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, color: AppColors.settingiconColor),
                    const GlobalSizedBox(height: 0, width: 8),
                    Text(accountText,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 12, thickness: 2),
                const GlobalSizedBox(height: 10),
                SettingsTile(
                  color: AppColors.settingiconColor,
                  icon: Ionicons.person_circle_outline,
                  title: profileTitleText,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserProfile()));
                  },
                ),
                const GlobalSizedBox(height: 10),
                SettingsTile(
                  color: AppColors.settingiconColor,
                  icon: Ionicons.finger_print_outline,
                  title: resetPasswordText,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPassword()));
                  },
                ),
                const GlobalSizedBox(height: 25),
                Row(
                  children: [
                    const Icon(Icons.share, color: AppColors.settingiconColor),
                    const GlobalSizedBox(height: 0, width: 8),
                    Text(shareLabelText,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 12, thickness: 2),
                const GlobalSizedBox(height: 10),
                SettingsTile(
                  color: AppColors.settingiconColor,
                  icon: Ionicons.share_social_outline,
                  title: socialLabelText,
                  onTap: () {
                    _socialURL();
                  },
                ),
                const GlobalSizedBox(height: 10),
                SettingsTile(
                  color: AppColors.settingiconColor,
                  icon: Ionicons.share_outline,
                  title: shareLabelText,
                  onTap: () {
                    _shareURL();
                  },
                ),
                const GlobalSizedBox(height: 25),
                Row(
                  children: [
                    const Icon(Icons.copyright,
                        color: AppColors.settingiconColor),
                    const GlobalSizedBox(height: 0, width: 8),
                    Text(termLabelText,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 12, thickness: 2),
                const GlobalSizedBox(height: 10),
                SettingsTile(
                  color: AppColors.settingiconColor,
                  icon: Icons.privacy_tip_sharp,
                  title: privacyPolicyLabelText,
                  onTap: () {
                    _privacyURL();
                  },
                ),
                const GlobalSizedBox(height: 10),
                SettingsTile(
                  color: AppColors.settingiconColor,
                  icon: Ionicons.documents_outline,
                  title: termsConditionLabelText,
                  onTap: () {
                    _termsURL();
                  },
                ),
                const GlobalSizedBox(height: 25),
                Row(
                  children: [
                    const Icon(Icons.people_outline_rounded,
                        color: AppColors.settingiconColor),
                    const GlobalSizedBox(height: 0, width: 8),
                    Text(
                      roomParticipantLabelText,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(height: 12, thickness: 2),
                const GlobalSizedBox(height: 10),
                Visibility(
                  visible: RoleUtils.isAdmin,
                  child: SettingsTile(
                    color: AppColors.settingiconColor,
                    icon: Icons.group_add_outlined,
                    title: addRoomLabelText,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InsertRoomData(),
                        ),
                      );
                    },
                  ),
                ),
                const GlobalSizedBox(height: 10),
                Visibility(
                  visible: RoleUtils.isAdminCoreMember,
                  child: SettingsTile(
                    color: AppColors.settingiconColor,
                    icon: Icons.change_circle_outlined,
                    title: roleLabelText,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FetchRoleData()));
                    },
                  ),
                ),
                const GlobalSizedBox(height: 10),
                SettingsTile(
                  color: AppColors.settingiconColor,
                  icon: Icons.handshake_outlined,
                  title: celebrationLabelText,
                  onTap: () => RoleUtils.isAdminCoreMember
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FetchCeleData()),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const User_FetchCeleData())),
                ),
                Visibility(
                  visible: RoleUtils.isParticipant,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const GlobalSizedBox(height: 15),
                        Center(
                            child:
                                SignOutButton(onPressed: () => logOutAlert())),
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
      Visibility(
        visible: loading,
        child: const Center(child: CircularProgressIndicator()),
      ),
    ]);
  }

  // Method to handle logout confirmation dialog
  logOutAlert() {
    Dialogs.materialDialog(
        title: sureWantToLogout,
        color: AppColors.bgColor,
        context: context,
        actions: [
          MaterialButton(
            onPressed: () {
              UserData.clearUserData();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            color: AppColors.submitbuttonColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: Text(yesButtonText,
                style: const TextStyle(color: AppColors.textColor)),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            color: AppColors.submitbuttonColor,
            child: Text(noButtonText,
                style: const TextStyle(color: AppColors.textColor)),
          ),
        ]);
  }

  // Method to open social URL
  _socialURL() async {
    const url = 'https://thegatewaycorp.com/';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

// Method to share URL
  _shareURL() async {
    const url =
        'https://install.appcenter.ms/users/mallik_jee/apps/gateway-utsav/distribution_groups/internal';
    try {
      await Share.share(url);
    } catch (e) {
      throw 'Could not share $url';
    }
  }

  // Method to open privacy URL
  _privacyURL() async {
    const url = 'https://thegatewaycorp.com/privacy-policy/';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Method to open terms URL
  _termsURL() async {
    const url = 'https://thegatewaycorp.com/terms-of-use/';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
