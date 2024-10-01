/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: shared_preferences.dart                                                |*/
/*| Path: lib/utils/shared_preferences.dart                                      |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Shared Preferences                                                  |*/
/*| Output: Implement Shared Preferences                                         |*/
/*| Description: Store user data in shared preferences                           |*/
/*+------------------------------------------------------------------------------+*/

import 'package:hisaab_rakho/utils/session_manager.dart';
import 'package:hisaab_rakho/models/users.dart';

class SharedPreferences {
  
  // Store user data in shared preferences
  static Future<void> storeUserInSession(AppUser user) async {

    await SessionManager().set('email', user.email);
    await SessionManager().set('name', user.name);
    await SessionManager().set('avatar', user.avatar);
    await SessionManager().set('income', user.income);
    await SessionManager().set('currencySymbol', user.currencySymbol);
    await SessionManager().set('currencyName', user.currencyName);
    await SessionManager().set('expense', user.expense);
    await SessionManager().set('amount', user.amount);
    await SessionManager().set('gender', user.gender);
    await SessionManager().set('createdAt', user.createdAt.toString());
    await SessionManager().set('id', user.id);
  }

  // Store user transactions in shared preferences
  static Future<void> storeTransactionsInSession(AppUser userId) async {
    // await SessionManager().set('expanses', transaction)
  } 
  
}