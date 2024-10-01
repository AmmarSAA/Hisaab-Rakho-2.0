/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: transaction_form.dart                                                  |*/
/*| Path: lib/views/widget/transaction_form.dart                                 |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Transaction Form Widget                                             |*/
/*| Output: Implement Transaction Form Widget                                    |*/
/*| Description: Implement a transaction form widget                             |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:hisaab_rakho/controllers/transaction.dart';
import 'package:hisaab_rakho/utils/responsive.dart';

class TransactionForm extends StatelessWidget {
  final TransactionController controller;
  final Responsive responsive;

  const TransactionForm(
      {super.key, required this.controller, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: responsive.wp(2), vertical: responsive.hp(2)),
      child: Column(
        children: [
          Visibility(
            visible: false,
            child: TextField(
              controller: controller.createdAt,
            ),
          ),
          TextField(
            controller: controller.amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter the amount',
              labelText: 'Amount',
              hintStyle: TextStyle(fontSize: responsive.sp(16)),
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.sp(18),
              ),
            ),
          ),
          SizedBox(height: responsive.hp(2)),
          TextField(
            controller: controller.categoryController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Enter the category',
              labelText: 'Category',
              hintStyle: TextStyle(fontSize: responsive.sp(16)),
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.sp(18),
              ),
            ),
          ),
          SizedBox(height: responsive.hp(2)),
          TextField(
            controller: controller.descriptionController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Enter the description',
              labelText: 'Description',
              hintStyle: TextStyle(fontSize: responsive.sp(16)),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: responsive.sp(18)),
            ),
          ),
          SizedBox(height: responsive.hp(2)),
          TextField(
            controller: controller.avatarController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'Upload Image (URL)',
              labelText: 'Picture',
              hintStyle: TextStyle(fontSize: responsive.sp(16)),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: responsive.sp(18)),
            ),
          ),
        ],
      ),
    );
  }
}
