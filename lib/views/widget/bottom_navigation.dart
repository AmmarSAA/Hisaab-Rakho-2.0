/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: bottom_navigation.dart                                                 |*/
/*| Path: lib/views/widget/bottom_navigation.dart                                |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Bottom Navigation Widget                                            |*/
/*| Output: Implement Bottom Navigation Widget                                   |*/
/*| Description: Implement the bottom navigation widget                          |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';

BottomNavigationBar bottomNavigation(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    fixedColor: const Color(0xFF7f3dff),
    currentIndex: currentIndex,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add),
        label: 'Add',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'Profile',
      ),
    ],
    onTap: (index) async {
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/dashboard');
          break;
        case 1:
          // Navigate to "Create Transaction" and await its result
          final result =
              await Navigator.pushNamed(context, '/create-transaction');
          if (result == true) {
            // If a transaction was created, refresh the dashboard
            Navigator.pushNamedAndRemoveUntil(
                context, '/dashboard', (route) => false);
          }
          break;
        case 2:
          Navigator.pushNamed(context, '/profile');
          break;
      }
    },
  );
}
