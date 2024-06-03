import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  // Keys for storing user data
  static const String roleIdKey = 'roleId';
  static const String roleNameKey = 'roleName';
  static const String currentUserIdKey = 'currentUserId';

  // Function to save current user ID
  static Future<void> saveCurrentUserId(String currentUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(currentUserIdKey, currentUserId);
  }

  // Function to get current user ID
  static Future<String> getCurrentUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentUserId = prefs.getString(currentUserIdKey) ?? '';
    return currentUserId;
  }

  // Function to save role data
  static Future<void> saveRoleData(String roleId, String roleName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(roleIdKey, roleId);
    await prefs.setString(roleNameKey, roleName);
  }

  // Function to get role data
  static Future<Map<String, String>> getRoleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roleId = prefs.getString(roleIdKey) ?? '';
    String roleName = prefs.getString(roleNameKey) ?? '';
    return {'roleId': roleId, 'roleName': roleName};
  }

  // Function to clear all stored user data
  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // currentLoginUserId = '';
    await prefs.clear();
  }
}