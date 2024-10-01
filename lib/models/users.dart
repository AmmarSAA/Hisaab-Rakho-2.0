/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: users.dart                                                             |*/
/*| Path: lib/models/users.dart                                                  |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Users Model                                                         |*/
/*| Output: Implement Users Model                                                |*/
/*| Description:                                                                 |*/
/*| Implement the Users model with the following fields:                         |*/
/*| - createdAt(DateTime)                                                        |*/
/*| - updatedAt(DateTime)                                                        |*/
/*| - name(String)                                                               |*/
/*| - avatar(String)                                                             |*/
/*| - email(String)                                                              |*/
/*| - password(String)                                                           |*/
/*| - income(String)                                                             |*/
/*| - currencySymbol(String)                                                     |*/
/*| - currencyName(String)                                                       |*/
/*| - expense(String)                                                            |*/
/*| - amount(String)                                                             |*/
/*| - gender(bool)                                                               |*/
/*| - id(String)                                                                 |*/
/*| Implement the following methods:                                             |*/
/*| - AppUserFromJson                                                            |*/
/*| - AppUserToJson                                                              |*/
/*| - AppUser.fromJson                                                           |*/
/*| - AppUser.toJson                                                             |*/
/*+------------------------------------------------------------------------------+*/

import 'dart:convert';

List<AppUser> appUserFromJson(String str) =>
    List<AppUser>.from(json.decode(str).map((x) => AppUser.fromJson(x)));

String appUserToJson(List<AppUser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppUser {
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? avatar;
  String? email;
  String? password;
  String? income;
  String? currencySymbol;
  String? currencyName;
  String? expense;
  String? amount;
  bool? gender;
  String? id;

  AppUser({
    this.createdAt,
    this.updatedAt,
    this.name,
    this.avatar =
        "https://www.iconpacks.net/icons/2/free-user-icon-3296-thumb.png",
    this.email,
    this.password,
    this.currencySymbol = "Rs.",
    this.currencyName = "Rupees",
    this.income = '0',
    this.expense = '0',
    this.amount = '0',
    this.gender = true,
    this.id,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        name: json["name"],
        avatar: json["avatar"],
        email: json["email"],
        password: json["password"],
        currencySymbol: json["currency_symbol"],
        currencyName: json["currency_name"],
        income: json["income"] != null ? json["income"].toString() : '0',
        expense: json["expense"] != null ? json["expense"].toString() : '0',
        amount: json["amount"] != null ? json["amount"].toString() : '0',
        gender: json["gender"],
        id: json["id"], 
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "name": name,
        "avatar": avatar,
        "email": email,
        "password": password,
        "currency_symbol": currencySymbol,
        "currency_name": currencyName,
        "income": income,
        "expense": expense,
        "amount": amount,
        "gender": gender,
        "id": id,
      };
}
