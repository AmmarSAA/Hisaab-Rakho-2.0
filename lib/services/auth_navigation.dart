import 'package:get/get.dart';
import 'package:hisaab_rakho/controllers/dashboard.dart';
import 'package:hisaab_rakho/controllers/profile.dart';
import 'package:hisaab_rakho/controllers/transaction.dart';
import 'package:hisaab_rakho/services/api_client.dart';
import 'package:hisaab_rakho/utils/session_manager.dart';

class AuthNavigation {
  static bool _clearing = false;

  static void configure() {
    Api.client.session.onExpired = returnToSignIn;
  }

  static Future<void> returnToSignIn() async {
    if (_clearing) return;
    _clearing = true;
    try {
      await SessionManager().clear();
      if (Get.isRegistered<DashboardController>()) {
        final dashboard = Get.find<DashboardController>();
        dashboard.transactions.clear();
        dashboard.balance.value = 0;
        dashboard.incomeAmount.value = 0;
        dashboard.expenseAmount.value = 0;
        dashboard.userEmail.value = '';
        dashboard.userName.value = '';
      }
      await Get.delete<ProfileController>(force: true);
      await Get.delete<DashboardController>(force: true);
      await Get.delete<TransactionController>(force: true);
      if (Get.key.currentState != null) Get.offAllNamed('/sign-in');
    } finally {
      _clearing = false;
    }
  }
}
