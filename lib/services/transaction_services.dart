/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: transaction_services.dart                                              |*/
/*| Path: lib/services/transaction_services.dart                                 |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Financial Services                                                  |*/
/*| Output: Implement Financial Services                                         |*/
/*| Description:                                                                 |*/
/*| Implement the TransactionService class with the following methods:           |*/
/*| - getExpensesAndIncome                                                       |*/
/*| - calculateBalance                                                           |*/
/*| - createTransaction                                                          |*/
/*| - getTransactionsByUserID                                                    |*/
/*| - deleteTransaction                                                          |*/
/*| - updateTransaction                                                          |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/foundation.dart';
import 'package:hisaab_rakho/models/transactions.dart';
import 'package:hisaab_rakho/services/api_client.dart';

class TransactionService {
  static const String _baseUrl = '/transaction';

  // Fetch expenses and income, and calculate sums
  static Future<Map<String, double>> getExpensesAndIncome(String userID) async {
    try {
      final List<Transactions> transactions =
          await getTransactionsByUserID(userID);
      double expenses = 0;
      double income = 0;

      for (var transaction in transactions) {
        if (transaction.income != null && transaction.amount != null) {
          if (transaction.income!) {
            income += transaction.amount!;
          } else {
            expenses += transaction.amount!;
          }
        }
      }

      return {'expenses': expenses, 'income': income};
    } on SessionExpired {
      rethrow;
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      return {'expenses': 0, 'income': 0};
    }
  }

  // Calculate the balance (income - expenses)
  static Future<double> calculateBalance(String email) async {
    try {
      final Map<String, double> results = await getExpensesAndIncome(email);
      return results['income']! - results['expenses']!;
    } on SessionExpired {
      rethrow;
    } catch (e) {
      debugPrint('Error calculating balance: $e');
      return 0;
    }
  }

  // Create a new transaction for the user
  static Future<Object> createTransaction(Transactions transaction) async {
    Object message = {
      "message": "Failed to create transaction.",
      "success": false
    };

    try {
      final response = await Api.client
          .request('POST', _baseUrl, body: transaction.toJson());

      if (response.statusCode == 201) {
        message = {
          "message": "Transaction created successfully.",
          "success": true
        };
      } else {
        debugPrint('Failed to create transaction: ${response.statusCode}');
        message = {
          "message": "Failed to create transaction.",
          "success": false
        };
      }
    } on SessionExpired {
      rethrow;
    } catch (e) {
      debugPrint('Error creating transaction: $e');
      message = {"message": "Failed to create transaction.", "success": false};
    }

    return message;
  }

  // Get transactions for the user by id
  static Future<List<Transactions>> getTransactionsByUserID(
      String userID) async {
    try {
      final response = await Api.client
          .request('GET', '$_baseUrl?user_id=${Uri.encodeComponent(userID)}');
      // debugPrint('$_baseUrl?user_id=$userID');
      // debugPrint('Response: ${response.body}');
      if (response.statusCode == 200) {
        return transactionsFromJson(response.body);
      } else {
        // debugPrint('Failed to fetch transactions: ${response.statusCode}');
        throw Exception('Unable to load transactions');
      }
    } on SessionExpired {
      rethrow;
    } catch (e) {
      throw Exception('Unable to load transactions');
    }
  }

  // Delete a transaction by ID
  static Future<bool> deleteTransaction(String id) async {
    try {
      final response = await Api.client
          .request('DELETE', '$_baseUrl/${Uri.encodeComponent(id)}');

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('Failed to delete transaction: ${response.statusCode}');
        return false;
      }
    } on SessionExpired {
      rethrow;
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      return false;
    }
  }

  // Update a transaction by ID
  Future<Object> updateTransaction(String id, Transactions transaction) async {
    Object message = {
      "message": "Failed to update transaction.",
      "success": false
    };
    try {
      final response = await Api.client.request(
          'PUT', '$_baseUrl/${Uri.encodeComponent(id)}',
          body: transaction.toJson());

      if (response.statusCode == 200) {
        message = {
          "message": "Transaction updated successfully.",
          "success": true
        };
      } else {
        debugPrint('Failed to update transaction: ${response.statusCode}');
        message = {
          "message": "Failed to update transaction.",
          "success": false
        };
      }
    } on SessionExpired {
      rethrow;
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      message = {
        "message": "Failed to update transaction.The error: $e",
        "success": false
      };
    }
    return message;
  }
}
