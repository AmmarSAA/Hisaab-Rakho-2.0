/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: sign_out.dart                                                          |*/
/*| Path: lib/utils/sign_out.dart                                                |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Sign Out User                                                       |*/
/*| Output: Implement Sign Out                                                   |*/
/*| Description: Sign out the user from the application                          |*/
/*|              and clear the session                                           |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisaab_rakho/controllers/dashboard.dart';
import 'package:hisaab_rakho/controllers/profile.dart';
import 'package:hisaab_rakho/controllers/transaction.dart';
import 'package:hisaab_rakho/utils/session_manager.dart';

class SignOut {
  Future<void> signOut(BuildContext context) async {
    try {
      // Clear the session
      await SessionManager().clear();

      // Delete the controller instance
      Get.delete<ProfileController>();
      Get.delete<DashboardController>();
      Get.delete<TransactionController>();

      Get.snackbar('Success', 'You have been signed out');

      debugPrint("User signed out");
    } catch (e) {
      debugPrint("Error signing out: $e");
    }
  }
}
