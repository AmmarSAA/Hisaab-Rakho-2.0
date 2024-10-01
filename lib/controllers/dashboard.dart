/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File Name: dashboard.dart                                                    |*/
/*| Path: /lib/controllers/dashboard.dart                                        |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: GetX Controller for Dashboard                                       |*/
/*| Output: Implement Dashboard Controller                                       |*/
/*| Description: Implement the Dashboard controller with                         |*/
/*| the following fields:                                                        |*/
/*| - balance (RxDouble)                                                         |*/
/*| - expenseAmount (RxDouble)                                                   |*/
/*| - incomeAmount (RxDouble)                                                    |*/
/*| - currencySymbol (RxString)                                                  |*/
/*| - isLoading (RxBool)                                                         |*/
/*| - userEmail (RxString)                                                       |*/
/*| - userName (RxString)                                                        |*/
/*| - userAvatar (RxString)                                                      |*/
/*| - transactions (RxList<Transactions>)                                        |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisaab_rakho/models/transactions.dart';
import 'package:hisaab_rakho/models/users.dart';
import 'package:hisaab_rakho/services/transaction_services.dart';
import 'package:hisaab_rakho/services/user_services.dart';
import 'package:hisaab_rakho/utils/session_manager.dart';

class DashboardController extends GetxController {
  var balance = 0.0.obs;
  var expenseAmount = 0.0.obs;
  var incomeAmount = 0.0.obs;
  var currencySymbol = ''.obs;
  var isLoading = true.obs;
  var userEmail = ''.obs;
  var userName = ''.obs;
  var userAvatar = ''.obs;
  RxList<Transactions> transactions = <Transactions>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrencySymbol();
    loadData();
  }

  // Load user data
  Future<void> loadData() async {
    isLoading(true);
    try {
      // Fetch user email and ID from session
      final email = await SessionManager().get('email');
      final userID = await SessionManager().get('id');

      if (email != null && userID != null) {
        // Fetch user details
        AppUser? user = await UserService.getUserDetails(email);
        if (user != null) {
          userEmail.value = user.email.toString();
          userName.value = user.name.toString();
          userAvatar.value = user.avatar.toString();
          debugPrint('dashboard User fetched: ${user.name}');
        } else {
          debugPrint('No user found.');
        }

        // Fetch balance, income, expenses, and transactions for the user
        balance.value =
            (await TransactionService.calculateBalance(userID)).toDouble();
        final expenseAndIncome =
            await TransactionService.getExpensesAndIncome(userID);
        expenseAmount.value = (expenseAndIncome['expenses'] ?? 0).toDouble();
        incomeAmount.value = (expenseAndIncome['income'] ?? 0).toDouble();

        await _fetchUserTransactions(userID);
      } else {
        debugPrint("User ID or email not found in session.");
      }
    } catch (e) {
      debugPrint("Error loading dashboard data: $e");
      Get.snackbar('Error', 'Failed to load dashboard data');
    } finally {
      isLoading(false);
    }
  }
  
  // Delete a transaction
  void deleteTransaction(String id) async {
    final success = await TransactionService.deleteTransaction(id);
    if (success) {
      transactions.removeWhere((transaction) => transaction.id == id);
      Get.snackbar("Success", "Transaction deleted successfully.",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("Error", "Failed to delete transaction.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Fetch transactions for the user
  Future<void> _fetchUserTransactions(String userId) async {
    try {
      List<Transactions> fetchedTransactions =
          await TransactionService.getTransactionsByUserID(userId);
      transactions.assignAll(fetchedTransactions);
    } catch (e) {
      debugPrint("Error fetching transactions: $e");
    }
  }

  // Fetch currency symbol from session
  Future<void> fetchCurrencySymbol() async {
    try {
      String symbol = await SessionManager().get('currencySymbol') ?? '';
      currencySymbol.value = symbol;
    } catch (e) {
      debugPrint("Error fetching currency symbol: $e");
    }
  }
}
