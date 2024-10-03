/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: id_gen.dart                                                            |*/
/*| Path: lib/utils/id_gen.dart                                                  |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Generate Unique ID                                                  |*/
/*| Output: Implement ID Generator                                               |*/
/*| Description: Generate a unique ID for the user                               |*/
/*+------------------------------------------------------------------------------+*/

import 'dart:math';

String generateUniqueId() {
  // Get the current timestamp in milliseconds since epoch
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  // Generate a random 4-character alphanumeric string
  const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();
  String randomString = List.generate(4, (index) => chars[random.nextInt(chars.length)]).join();

  // Combine the timestamp and the random string
  return '$timestamp-$randomString';
}

String id = generateUniqueId();
