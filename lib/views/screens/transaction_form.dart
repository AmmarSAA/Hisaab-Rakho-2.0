/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: transaction_form.dart                                                  |*/
/*| Path: lib/views/screens/transaction_form.dart                                |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Transaction Form Screen                                             |*/
/*| Output: Implement Transaction Form Screen                                    |*/
/*| Description: Screen to add or edit a transaction                             |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisaab_rakho/controllers/transaction.dart';
import 'package:hisaab_rakho/models/transactions.dart';
import 'package:hisaab_rakho/utils/responsive.dart';
import 'package:hisaab_rakho/views/widget/transaction_actions.dart';
import 'package:hisaab_rakho/views/widget/transaction_form.dart';

class TransactionFormScreen extends StatelessWidget {
  final Transactions? transaction;

  // Controller to manage the transaction
  final TransactionController controller = Get.put(TransactionController());

  TransactionFormScreen({super.key, this.transaction}) {
    // Pre-fill the controller's fields only if it's in edit mode
    if (transaction != null) {
      controller.createdAt.text = transaction!.createdAt.toString();
      debugPrint('Created At: ${transaction!.createdAt}');
      controller.amountController.text = transaction!.amount.toString();
      controller.categoryController.text = transaction!.category.toString();
      controller.descriptionController.text =
          transaction!.description.toString();
      controller.avatarController.text = transaction!.avatar.toString();
      controller.isIncomeSelected.value =
          transaction!.income.toString() == 'true';
    } else {
      // Reset controller fields for new transaction
      controller.createdAt.text = DateTime.now().toString();
      controller.amountController.clear();
      controller.categoryController.clear();
      controller.descriptionController.clear();
      controller.avatarController.clear();
      controller.isIncomeSelected.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive(context);

    // Determine if this is an update or create transaction based on transaction being passed
    final bool isUpdate = transaction != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? "Edit Transaction" : "Add Transaction"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(8),
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/light/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Container
              Image.asset(
                'assets/light/splash.png',
                height: responsive.hp(40),
                width: responsive.wp(100),
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
              ),
              SizedBox(height: responsive.hp(2)),

              // Transaction Form Fields
              TransactionForm(
                controller: controller,
                responsive: responsive,
              ),
              SizedBox(height: responsive.hp(2)),

              // Create or Update Button
              TransactionActions(
                responsive: responsive,
                isUpdate: isUpdate,
                transactionId:
                    transaction?.id,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
