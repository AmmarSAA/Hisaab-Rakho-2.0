/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: stat_card.dart                                                         |*/
/*| Path: lib/views/widget/stat_card.dart                                        |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Stat Card Widget                                                    |*/
/*| Output: Implement Stat Card Widget                                           |*/
/*| Description: Implement a Stat Card Widget                                    |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:hisaab_rakho/utils/responsive.dart';
import 'package:get/get.dart';
import 'package:hisaab_rakho/controllers/dashboard.dart';

final DashboardController controller = Get.put(DashboardController());

// Widget for Stat Card (for both Expense and Income)
Widget buildStatCard(BuildContext context, String title, String asset,
    int amount, Responsive responsive) {
  return Container(
    padding: const EdgeInsets.all(30),
    width: responsive.wp(45),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(asset),
        fit: BoxFit.fill,
        alignment: Alignment.center,
      ),
      borderRadius: BorderRadius.circular(responsive.wp(5)),
      color: Colors.white,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text('${controller.currencySymbol.value}$amount',
            style: const TextStyle(color: Colors.white)),
      ],
    ),
  );
}
