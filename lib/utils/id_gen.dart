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

int currentTimeLength = DateTime.now().toIso8601String().length;
String id = DateTime.now().toIso8601String().substring(currentTimeLength - 4,currentTimeLength).toLowerCase();