/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File Name: profile.dart                                                      |*/
/*| Path: /lib/controllers/profile.dart                                          |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: GetX Controller for Profile                                         |*/
/*| Output: Implement Profile Controller                                         |*/
/*| Description: Implement the Profile controller with                           |*/
/*| the following fields:                                                        |*/
/*| - userEmail (RxString)                                                       |*/
/*| - userName (RxString)                                                        |*/
/*| - userAvatar (RxString)                                                      |*/
/*| - isLoading (RxBool)                                                         |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisaab_rakho/models/users.dart';
import 'package:hisaab_rakho/services/user_services.dart';
import 'package:hisaab_rakho/utils/session_manager.dart';

class ProfileController extends GetxController {
  var userEmail = ''.obs;
  var userName = ''.obs;
  var userAvatar = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      isLoading.value = true;

      // Get the email from session
      String? email = await SessionManager().get("email");

      if (email == null || email.isEmpty) {
        debugPrint('No email found in session');
        userName.value = 'User not logged in';
        return;
      }

      // Fetch user details from API
      AppUser? user = await UserService.getUserDetails(email);

      if (user != null) {
        userEmail.value = user.email.toString();
        userName.value = user.name.toString();
        userAvatar.value = user.avatar.toString();
        debugPrint('User fetched: ${user.name}');
        debugPrint('Email fetched: ${user.email}');
      } else {
        debugPrint('No user found or error occurred');
        userName.value = 'User not found';
      }
    } catch (e) {
      debugPrint('Error in fetching user details: $e');
      userName.value = 'Error fetching user';
    } finally {
      isLoading.value = false;
    }
  }
}
