/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: transaction_actions.dart                                               |*/
/*| Path: lib/views/widget/transaction_actions.dart                              |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Transaction Actions Widget                                          |*/
/*| Output: Implement Transaction Actions Widget                                 |*/
/*| Description: Implement the transaction actions widget                        |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisaab_rakho/controllers/transaction.dart';
import 'package:hisaab_rakho/utils/responsive.dart';

class TransactionActions extends StatelessWidget {
  final Responsive responsive;
  final bool isUpdate;
  final String? transactionId;

  const TransactionActions({
    super.key,
    required this.responsive,
    this.isUpdate = false,
    this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    // Find the TransactionController (it should already be initialized)
    final TransactionController controller = Get.find<TransactionController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Transaction Type Buttons (Income/Expense)
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.isIncomeSelected.value = true;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isIncomeSelected.value
                      ? Colors.green.shade700
                      : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  minimumSize: Size(responsive.wp(38), responsive.hp(6)),
                ),
                child: Text(
                  'Income',
                  style: TextStyle(
                    fontSize: responsive.sp(16),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: responsive.wp(5)),
              ElevatedButton(
                onPressed: () {
                  controller.isIncomeSelected.value = false;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: !controller.isIncomeSelected.value
                      ? Colors.red.shade700
                      : Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  minimumSize: Size(responsive.wp(38), responsive.hp(6)),
                ),
                child: Text(
                  'Expense',
                  style: TextStyle(
                    fontSize: responsive.sp(16),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        }),

        SizedBox(height: responsive.hp(2)),

        // Create or Update Transaction Button
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(10)),
            child: ElevatedButton(
              onPressed: () async {
                if (isUpdate) {
                  final response = await controller.updateTransaction(
                      transactionId.toString(), context);
                  if (response['success']) {
                    Get.snackbar("Woohoo!", response['message'],
                        snackPosition: SnackPosition.BOTTOM);
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.popAndPushNamed(context, '/dashboard');
                  } else {
                    Get.snackbar("Oops!", response['message'],
                        snackPosition: SnackPosition.BOTTOM);
                  }
                } else {
                  final response = await controller.createTransaction(context);
                  if (response['success']) {
                    Get.snackbar("Woohoo!", response['message'],
                        snackPosition: SnackPosition.BOTTOM);
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.popAndPushNamed(context, '/dashboard');
                  } else {
                    Get.snackbar("Oops!", response['message'],
                        snackPosition: SnackPosition.BOTTOM);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                minimumSize: Size(responsive.wp(50), responsive.hp(7)),
              ),
              child: Text(
                isUpdate ? 'Update Transaction' : 'Create Transaction',
                style: TextStyle(
                  fontSize: responsive.sp(18),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
