/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: transaction_history.dart                                               |*/
/*| Path: lib/views/widget/transaction_history.dart                              |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Transaction History Widget                                          |*/
/*| Output: Implement Transaction History Widget                                 |*/
/*| Description: Implement the transaction history widget                        |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisaab_rakho/controllers/dashboard.dart';
import 'package:hisaab_rakho/models/transactions.dart';
import 'package:hisaab_rakho/utils/responsive.dart';
import 'package:hisaab_rakho/views/screens/transaction_form.dart';
import 'package:hisaab_rakho/views/widget/confirmation_box.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final responsive = Responsive(context);

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.transactions.isEmpty) {
        return const Center(child: Text('No transactions found.'));
      } else {
        // Reverse the transactions list to show the most recent first
        final reversedTransactions = controller.transactions.reversed.toList();

        return ListView.builder(
          itemCount: reversedTransactions.length,
          itemBuilder: (context, index) {
            final transaction = reversedTransactions[index];
            return _buildTransactionTile(
                transaction, responsive, context, controller);
          },
        );
      }
    });
  }

  Widget _buildTransactionTile(Transactions transaction, Responsive responsive,
      BuildContext context, DashboardController controller) {
    bool validURL = Uri.parse(transaction.avatar.toString()).isAbsolute;
    String avatarURL = validURL
        ? '${transaction.avatar}?t=${DateTime.now().millisecondsSinceEpoch}'
        : (transaction.income ?? false)
            ? 'assets/light/income_arrow.png'
            : 'assets/light/expense_arrow.png';

    return ListTile(
      leading: validURL
          ? Image.network(
              avatarURL,
              height: responsive.hp(5),
              fit: BoxFit.contain,
            )
          : Image.asset(
              avatarURL,
              width: responsive.hp(5),
              fit: BoxFit.contain,
            ),
      title: Text(
        transaction.category ?? 'Unknown Category',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(transaction.description ?? 'No description provided.'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${transaction.income == true ? "+" : "-"} ${transaction.amount}',
            style: TextStyle(
              color: (transaction.income ?? false) ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Popup Menu Button for actions
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TransactionFormScreen(transaction: transaction),
                  ),
                );
              } else if (value == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => const ConfirmationBox(
                    title: 'Delete Transaction',
                    message:
                        'Are you sure you want to delete this transaction?',
                    color: Colors.yellow,
                    confirmText: 'Delete',
                  ),
                );

                confirm ?? controller.deleteTransaction(transaction.id!);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
