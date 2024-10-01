/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File Name: transaction.dart                                                  |*/
/*| Path: /lib/controllers/transaction.dart                                      |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: GetX Controller for Transaction                                     |*/
/*| Output: Implement Transaction Controller                                     |*/
/*| Description: Implement the Transaction controller with                       |*/
/*| the following fields:                                                        |*/
/*| - createdAt (TextEditingController)                                          |*/
/*| - updatedAt (DateTime)                                                       |*/
/*| - amountController (TextEditingController)                                   |*/
/*| - categoryController (TextEditingController)                                 |*/
/*| - descriptionController (TextEditingController)                              |*/
/*| - avatarController (TextEditingController)                                   |*/
/*| - isIncomeSelected (RxBool)                                                  |*/
/*| - transactions (RxList<Transactions>)                                        |*/
/*| - transactionService (TransactionService)                                    |*/
/*| - createTransaction (Function)                                               |*/
/*| - updateTransaction (Function)                                               |*/
/*| - toggleIncome (Function)                                                    |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisaab_rakho/models/transactions.dart';
import 'package:hisaab_rakho/services/transaction_services.dart';
import 'package:hisaab_rakho/utils/session_manager.dart';

class TransactionController extends GetxController {
  var createdAt = TextEditingController();
  var updatedAt = DateTime.now();
  var amountController = TextEditingController();
  var categoryController = TextEditingController();
  var descriptionController = TextEditingController();
  var avatarController = TextEditingController();

  var isIncomeSelected = false.obs;
  var transactions = <Transactions>[].obs;

  final TransactionService transactionService = TransactionService();

  // Create a new transaction
  Future<Map<String, dynamic>> createTransaction(BuildContext context) async {
    Map<String, dynamic> message = {
      "message": "Failed to create transaction.",
      "success": false
    };

    final String amountStr = amountController.text.trim();
    final String category = categoryController.text.trim();
    final String description = descriptionController.text.trim();
    final String avatarUrl = avatarController.text.trim();

    try {
      final double amount = double.parse(amountStr);
      final userName = await SessionManager().get('name');
      final userId = await SessionManager().get('id');

      if (userName.isNotEmpty && userId.isNotEmpty) {
        final transaction = Transactions(
          createdAt: DateTime.now(),
          amount: amount,
          income: isIncomeSelected.value,
          category: category,
          description: description,
          name: userName,
          userId: userId,
          avatar: avatarUrl,
        );

        final response =
            await TransactionService.createTransaction(transaction);
        (response as Map<String, dynamic>)['success']
            ? message = {
                "message": "Transaction created successfully.",
                "success": true
              }
            : message = {
                "message": "Failed to create transaction.",
                "success": false
              };
      } else {
        message = {"message": "User not found.", "success": false};
      }
    } catch (e) {
      debugPrint('Error creating transaction: $e');
      message = {"message": "Invalid amount format.", "success": false};
    }

    return message;
  }

  // Update an existing transaction
  Future<Map<String, dynamic>> updateTransaction(
      String id, BuildContext context) async {
    Map<String, dynamic> message = {
      "message": "Failed to update transaction.",
      "success": false
    };

    try {
      // Constructing the updated transaction object
      final updatedTransaction = Transactions(
        id: id,
        createdAt: DateTime.parse(createdAt.text),
        updatedAt: DateTime.now(),
        amount: double.parse(amountController.text),
        category: categoryController.text,
        description: descriptionController.text,
        avatar: avatarController.text,
        income: isIncomeSelected.value,
        name: await SessionManager().get('name'),
        userId: await SessionManager().get('id'),
      );

      // Attempt to update the transaction via the service
      final response =
          await transactionService.updateTransaction(id, updatedTransaction);

      // Check if response is valid and contains the success key
      if (response is Map<String, dynamic> && response['success'] == true) {
        // Set success message
        message = {
          "message": "Transaction updated successfully.",
          "success": true,
        };
      } else {
        // Handle case where response does not indicate success
        message = {
          "message": "Failed to update transaction. Please try again.",
          "success": false,
        };
      }
    } catch (e) {
      // Handle specific types of exceptions if needed
      debugPrint('Error updating transaction: $e');
      message = {
        "message": "Error: $e",
        "success": false,
      };
    }

    return message;
  }

  // Toggle between income and expense
  void toggleIncome(bool value) {
    isIncomeSelected.value = value;
  }

  @override
  void onClose() {
    amountController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    avatarController.dispose();
    super.onClose();
  }
}
