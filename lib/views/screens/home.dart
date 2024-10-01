/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: home.dart                                                              |*/
/*| Path: lib/views/screens/home.dart                                            |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Home Screen                                                         |*/
/*| Output: Implement Home Screen                                                |*/
/*| Description:                                                                 |*/
/*| Implement the Home screen with the following features:                       |*/
/*| - Splash Image                                                               |*/
/*| - Title                                                                      |*/
/*| - Description                                                                |*/
/*| - Continue Button                                                            |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.all(0),
            child: Image.asset(
              'assets/light/splash.png',
              height: 389,
              width: 360,
              alignment: Alignment.topCenter,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            child: const Column(
              children: [
                Text(
                  'Simple solution for your budget.',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Counter and distribute the income correctly...',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/sign-in");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  minimumSize: const Size(194, 42),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
