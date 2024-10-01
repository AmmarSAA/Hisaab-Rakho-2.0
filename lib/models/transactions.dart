/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: transactions.dart                                                      |*/
/*| Path: lib/models/transactions.dart                                           |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Transactions Model                                                  |*/
/*| Output: Implement Transactions Model                                         |*/
/*| Description:                                                                 |*/
/*| Implement the Transactions model with the following fields:                  |*/
/*| - createdAt(DateTime)                                                        |*/
/*| - updatedAt(DateTime)                                                        |*/
/*| - name(String)                                                               |*/
/*| - avatar(String)                                                             |*/
/*| - userId(int)                                                                |*/
/*| - category(String)                                                           |*/
/*| - amount(double)                                                             |*/
/*| - income(bool)                                                               |*/
/*| - id(String)                                                                 |*/
/*| - description(String)                                                        |*/
/*| Implement the following methods:                                             |*/
/*| - transactionsFromJson                                                       |*/
/*| - transactionsToJson                                                         |*/
/*| - Transactions.fromJson                                                      |*/
/*| - Transactions.toJson                                                        |*/
/*+------------------------------------------------------------------------------+*/

import 'dart:convert';

List<Transactions> transactionsFromJson(String str) => List<Transactions>.from(
    json.decode(str).map((x) => Transactions.fromJson(x)));

String transactionsToJson(List<Transactions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Transactions {
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? avatar;
  String? userId;
  String? category;
  double? amount;
  bool? income;
  String? id;
  String? description;

  Transactions({
    this.createdAt,
    this.updatedAt,
    this.name,
    this.avatar,
    this.userId,
    this.category,
    this.amount,
    this.income,
    this.id,
    this.description,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        name: json["name"],
        avatar: json["avatar"],
        userId: json["user_id"],
        category: json["category"],
        amount: json["amount"] != null
            ? double.tryParse(json["amount"].toString())
            : null,
        income: json["income"],
        id: json["id"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "name": name,
        "avatar": avatar,
        "user_id": userId,
        "category": category,
        "amount": amount?.toString(),
        "income": income,
        "id": id,
        "description": description,
      };
}
