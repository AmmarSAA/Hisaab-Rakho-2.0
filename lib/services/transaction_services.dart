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
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hisaab_rakho/utils/constants.dart';

class TransactionService {
  static const String _baseUrl = '${Constants.DATABASE_URL}/transaction';

  // Fetch expenses and income, and calculate sums
  static Future<Map<String, int>> getExpensesAndIncome(String userID) async {
    try {
      final List<Transactions> transactions =
          await getTransactionsByUserID(userID);
      int expenses = 0;
      int income = 0;

      for (var transaction in transactions) {
        if (transaction.income != null && transaction.amount != null) {
          if (transaction.income!) {
            income += transaction.amount!.toInt();
          } else {
            expenses += transaction.amount!.toInt();
          }
        }
      }

      return {'expenses': expenses, 'income': income};
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      return {'expenses': 0, 'income': 0};
    }
  }

  // Calculate the balance (income - expenses)
  static Future<int> calculateBalance(String email) async {
    try {
      final Map<String, int> results = await getExpensesAndIncome(email);
      return results['income']! - results['expenses']!;
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
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaction.toJson()),
      );

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
      final response = await http.get(
        Uri.parse('$_baseUrl?user_id=$userID'),
      );
      // debugPrint('$_baseUrl?user_id=$userID');
      // debugPrint('Response: ${response.body}');
      if (response.statusCode == 200) {
        return transactionsFromJson(response.body);
      } else {
        // debugPrint('Failed to fetch transactions: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // debugPrint('Error fetching transactions: $e');
      return [];
    }
  }

  // Delete a transaction by ID
  static Future<bool> deleteTransaction(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('Failed to delete transaction: ${response.statusCode}');
        return false;
      }
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
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaction.toJson()),
      );

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
