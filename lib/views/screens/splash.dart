/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: splash.dart                                                            |*/
/*| Path: lib/views/screens/splash.dart                                          |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Splash Screen                                                       |*/
/*| Output: Implement Splash Screen                                              |*/
/*| Description: Implement the splash screen for the application                 |*/
/*|              The splash screen will be displayed for 3 seconds               |*/
/*|              and then the user will be redirected to the dashboard           |*/
/*|              if the user is already signed in                                |*/
/*|              otherwise the user will be redirected to the sign in screen     |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:hisaab_rakho/utils/responsive.dart';
import 'package:hisaab_rakho/services/user_services.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final restored = await UserService.restoreSession();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
        context, restored ? '/dashboard' : '/sign-in', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hisaab Rakho',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: Responsive(context).hp(2)),
          ],
        ),
      ),
    );
  }
}
