import 'user_session.dart';

class RoleUtils {
  // Static variables to track user roles
  static bool isAdmin = false;
  static bool isAdminCoreMember = false;
  static bool isCoreMember = false;
  static bool isParticipant = false;

  // Function to update user roles
  static Future<void> updateRoles() async {
    // Get role data from user data
    Map<String, String> roleData = await UserData.getRoleData();

    // Extract role name from role data
    String isAdminRole = roleData['roleName'] ?? '';

    // Update role variables based on role name
    isAdmin = isAdminRole == 'Admin';
    isAdminCoreMember = isAdminRole == 'Admin' || isAdminRole == 'Core Member';
    isCoreMember = isAdminRole == 'Core Member';
    isParticipant = isAdminRole == 'Participant';
  }
}