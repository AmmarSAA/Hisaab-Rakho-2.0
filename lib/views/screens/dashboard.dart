/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: dashboard.dart                                                         |*/
/*| Path: lib/views/screens/dashboard.dart                                       |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Dashboard Screen                                                    |*/
/*| Output: Implement Dashboard Screen                                           |*/
/*| Description: Dashboard screen with user balance,                             |*/
/*|              transaction history and stat cards                              |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisaab_rakho/controllers/dashboard.dart';
import 'package:hisaab_rakho/utils/responsive.dart';
import 'package:hisaab_rakho/views/widget/bottom_navigation.dart';
import 'package:hisaab_rakho/views/widget/stat_card.dart';
import 'package:hisaab_rakho/views/widget/transaction_history.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    // Start loading data on widget build
    controller.loadData();

    return Scaffold(
      body: Obx(() {
        return Column(
          children: [
            // Stat Cards (stick on top)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Current Balance Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(responsive.wp(5)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Current Balance',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${controller.currencySymbol.value}${controller.balance.value}',
                          style: TextStyle(fontSize: responsive.hp(3)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: responsive.hp(2)),
                  // Expense and Income Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildStatCard(
                        context,
                        'Expense',
                        'assets/light/expense_card.png',
                        controller.expenseAmount.value.toInt(),
                        responsive,
                      ),
                      buildStatCard(
                        context,
                        'Income',
                        'assets/light/income_icon.png',
                        controller.incomeAmount.value.toInt(),
                        responsive,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Transaction History List
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: TransactionHistory(),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: bottomNavigation(context, 0),
      // FloatingActionButton to "Create Transaction"
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to CreateTransaction page and await result
          final result =
              await Navigator.pushNamed(context, "/create-transaction");
          if (result == true) {
            controller
                .loadData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
