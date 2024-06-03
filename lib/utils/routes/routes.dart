import 'package:flutter/material.dart';

import '../../ui_view/admin_core_member_view/Dashboard/Home.dart';
import '../../ui_view/admin_core_member_view/Rooms/View/fetch_room_data.dart';
import '../../ui_view/admin_core_member_view/Rooms/view/insert_room_data.dart';
import '../../ui_view/admin_core_member_view/Rooms/view/update_room_data.dart';
import '../../ui_view/admin_core_member_view/celebration/View/fetch_celebration_data.dart';
import '../../ui_view/admin_core_member_view/celebration/View/insert_celebration_data.dart';
import '../../ui_view/admin_core_member_view/contribution/view/fetch_contribution_ui.dart';
import '../../ui_view/admin_core_member_view/expense/View/fetch_Expense_data.dart';
import '../../ui_view/admin_core_member_view/user_role_details/View/fetch_role_data.dart';
import '../../ui_view/admin_core_member_view/user_role_details/View/update_role_data.dart';
import '../../ui_view/authentication_screen/Email_verification/email_verification.dart';
import '../../ui_view/authentication_screen/forget_reset_password/change_password.dart';
import '../../ui_view/authentication_screen/forget_reset_password/forgot_password.dart';
import '../../ui_view/authentication_screen/login/View/login_page.dart';
import '../../ui_view/authentication_screen/signup/View/signup_view.dart';
import '../../ui_view/common_screens/contribution/view/insert_celebration_ui.dart';
import '../../ui_view/common_screens/dashboard/Dashboard.dart';
import '../../ui_view/common_screens/dashboard/setting.dart';
import '../../ui_view/common_screens/expense/view/insert_Expense_data.dart';
import '../../ui_view/common_screens/expense/view/update_Expense_data.dart';
import '../../ui_view/splash/view/splash_view.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashView(),
        );

      case RoutesName.verificationPage:
        return MaterialPageRoute(
          builder: (BuildContext context) => const VerifyEmailPage(),
        );

      case RoutesName.login:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage(),
        );

      case RoutesName.signup:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SignUp(),
        );

      case RoutesName.dashboard:
        return MaterialPageRoute(
          builder: (BuildContext context) => const Dashboard(),
        );

      case RoutesName.home:
        return MaterialPageRoute(
          builder: (BuildContext context) => const Home(),
        );

      case RoutesName.forgotPassword:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ForgotPassword(),
        );

      case RoutesName.changePassword:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ResetPassword(),
        );

      case RoutesName.setting:
        return MaterialPageRoute(
          builder: (BuildContext context) => const Setting(),
        );

      case RoutesName.fetchRoom:
        return MaterialPageRoute(
          builder: (BuildContext context) => const FetchRoomData(),
        );

      case RoutesName.insertRoom:
        return MaterialPageRoute(
          builder: (BuildContext context) => const InsertRoomData(),
        );

      case RoutesName.updateRoom:
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              const UpdateRoomData(employeeKey: ''),
        );

      case RoutesName.fetchRole:
        return MaterialPageRoute(
          builder: (BuildContext context) => const FetchRoleData(),
        );

      case RoutesName.updateRole:
        return MaterialPageRoute(
          builder: (BuildContext context) => const UpdateRoleData(userKey: ''),
        );

      case RoutesName.fetchExpense:
        return MaterialPageRoute(
          builder: (BuildContext context) => const FetchExpenseData(),
        );

      case RoutesName.insertExpense:
        return MaterialPageRoute(
          builder: (BuildContext context) => const InsertExpenseData(),
        );

      case RoutesName.updateExpense:
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              const UpdateExpenseData(expenseKey: ''),
        );

      case RoutesName.fetchCelebration:
        return MaterialPageRoute(
          builder: (BuildContext context) => const FetchCeleData(),
        );

      case RoutesName.insertCelebration:
        return MaterialPageRoute(
          builder: (BuildContext context) => const InsertCeleData(),
        );

      case RoutesName.fetchContribute:
        return MaterialPageRoute(
          builder: (BuildContext context) => const FetchPaymentData(),
        );

      case RoutesName.insertContribute:
        return MaterialPageRoute(
          builder: (BuildContext context) => const InsertPaymentData(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined'),
              ),
            );
          },
        );
    }
  }
}
