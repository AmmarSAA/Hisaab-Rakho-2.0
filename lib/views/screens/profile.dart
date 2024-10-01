/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: profile.dart                                                           |*/
/*| Path: lib/views/screens/profile.dart                                         |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Profile Screen                                                      |*/
/*| Output: Implement Profile Screen                                             |*/
/*| Description: Profile Screen for the user                                     |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisaab_rakho/utils/responsive.dart';
import 'package:hisaab_rakho/utils/sign_out.dart';
import 'package:hisaab_rakho/views/widget/bottom_navigation.dart';
import 'package:hisaab_rakho/controllers/profile.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // User Profile Container
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Obx(() {
                    if (profileController.isLoading.value) {
                      return const CircularProgressIndicator();
                    }
                    return Image.network(
                      '${profileController.userAvatar.value}?t=${DateTime.now().millisecondsSinceEpoch}',
                      height: responsive.hp(20),
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    );
                  }),
                  SizedBox(height: responsive.hp(2)),
                  Obx(() => Text(
                        profileController.userName
                            .value, // Bind the userName from ProfileController
                        style: TextStyle(
                          fontSize: responsive.hp(3),
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Account Container
            GestureDetector(
              onTap: () {
                // Navigation logic for Account
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/light/account.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Account',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            // Settings Container
            GestureDetector(
              onTap: () {
                // Navigation logic for Settings
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/light/settings.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Settings',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            // Sign Out Container
            GestureDetector(
              onTap: () async {
                SignOut().signOut(context);
                Navigator.pushNamed(context, "/sign-in");
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/light/sign_out.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Sign Out',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigation(context, 2),
    );
  }
}
