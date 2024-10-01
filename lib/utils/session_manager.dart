/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: session_manager.dart                                                   |*/
/*| Path: lib/utils/session_manager.dart                                         |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Session Manager                                                     |*/
/*| Output: Implement Session Manager                                            |*/
/*| Description: Manage the session of the user                                  |*/
/*| - Save session data                                                          |*/
/*| - Retrieve session data                                                      |*/
/*| - Check if a session key exists                                              |*/
/*| - Remove a specific session key                                              |*/
/*| - Clear the entire session                                                   |*/
/*| - Update (reload) preferences                                                |*/
/*+------------------------------------------------------------------------------+*/

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SessionManager {
  // Singleton pattern to have only one instance of SessionManager
  static final SessionManager _instance = SessionManager._internal();

  // Private constructor
  SessionManager._internal();

  // Factory constructor to return the singleton instance
  factory SessionManager() {
    return _instance;
  }

  // Access to SharedPreferences instance
  SharedPreferences? _prefs;

  // Internal method to access SharedPreferences
  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Method to save session data
  Future<void> set(String key, dynamic value) async {
    await _initPrefs();

    switch (value.runtimeType) {
      case const (String):
        await _prefs!.setString(key, value as String);
        break;
      case const (int):
        await _prefs!.setInt(key, value as int);
        break;
      case const (bool):
        await _prefs!.setBool(key, value as bool);
        break;
      case const (double):
        await _prefs!.setDouble(key, value as double);
        break;
      case const (List<String>):
        await _prefs!.setStringList(key, value as List<String>);
        break;
      default:
        await _prefs!.setString(key, jsonEncode(value));
    }
  }

  /// Method to retrieve session data
  Future<dynamic> get(String key) async {
    await _initPrefs();
    return _prefs!.get(key);
  }

  /// Method to retrieve object data and decode it
  Future<Map<String, dynamic>?> getObject(String key) async {
    await _initPrefs();
    String? jsonString = _prefs!.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  /// Method to check if a session key exists
  Future<bool> containsKey(String key) async {
    await _initPrefs();
    return _prefs!.containsKey(key);
  }

  /// Method to remove a specific session key
  Future<void> remove(String key) async {
    await _initPrefs();
    await _prefs!.remove(key);
  }

  /// Method to clear the entire session
  Future<bool> clear() async {
    await _initPrefs();
    await _prefs!.clear();
    return true;
  }

  /// Method to update (reload) preferences, though it happens automatically
  Future<void> reload() async {
    await _initPrefs();
    await _prefs!.reload();
  }

}
