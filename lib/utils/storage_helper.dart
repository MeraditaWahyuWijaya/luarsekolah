// lib/utils/storage_helper.dart

import 'package:shared_preferences/shared_preferences.dart';
// Import package yang benar
import 'package:luarsekolah/utils/storage_keys.dart'; 

class StorageHelper {
  static StorageHelper? _instance;
  static SharedPreferences? _prefs;

  StorageHelper._();

  static Future<StorageHelper> getInstance() async {
    _prefs ??= await SharedPreferences.getInstance();
    _instance ??= StorageHelper._();
    return _instance!;
  }

  // Simpan data user
  Future<void> saveUserData({
    required String email,
    required String name,
    required String phone,
  }) async {
    // Memanggil StorageKeys yang diimport di atas
    await _prefs!.setString(StorageKeys.userEmail, email);
    await _prefs!.setString(StorageKeys.userName, name);
    await _prefs!.setString(StorageKeys.userPhone, phone);
  }

  Future<void> saveBool(String key, bool value) async {
    await _prefs!.setBool(key, value);
  }

  bool getBool(String key) => _prefs!.getBool(key) ?? false;

  String getString(String key) => _prefs!.getString(key) ?? '';

  Future<void> removeMultiple(List<String> keys) async {
    for (final key in keys) {
      await _prefs!.remove(key);
    }
  }
}