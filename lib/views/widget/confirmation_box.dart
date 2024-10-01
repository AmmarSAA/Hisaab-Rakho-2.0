/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: confirmation_box.dart                                                  |*/
/*| Path: lib/views/widget/confirmation_box.dart                                 |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Confirmation Box Widget                                             |*/
/*| Output: Implement Confirmation Box Widget                                    |*/
/*| Description: Implement a confirmation box widget                             |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';

class ConfirmationBox extends StatelessWidget {
  final String title;
  final String message;
  final Color color;
  final String confirmText;

  const ConfirmationBox(
      {super.key, this.confirmText = 'Yes',
      required this.title,
      required this.message,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      backgroundColor: color,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}
