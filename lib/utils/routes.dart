/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: routes.dart                                                            |*/
/*| Path: lib/utils/routes.dart                                                  |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Application Routes                                                  |*/
/*| Output: Implement Application Routes                                         |*/
/*| Description: Implement the routes for the application                        |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:hisaab_rakho/views/screens/transaction_form.dart';
import 'package:hisaab_rakho/views/screens/home.dart';
import 'package:hisaab_rakho/views/screens/profile.dart';
import 'package:hisaab_rakho/views/screens/sign_up.dart';
import 'package:hisaab_rakho/views/screens/splash.dart';
import 'package:hisaab_rakho/views/screens/sign_in.dart';
import 'package:hisaab_rakho/views/screens/dashboard.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const Splash(),
  '/sign-in': (context) => SignIn(),
  '/sign-up': (context) => SignUp(),
  '/dashboard': (context) => Dashboard(),
  '/home': (context) => const Home(),
  '/profile': (context) => Profile(),
  '/splash': (context) => const Splash(),
  '/create-transaction': (context) => TransactionFormScreen(),
};
