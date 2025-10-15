import 'package:shared_preferences/shared_preferences.dart';
import 'package:luarsekolah/utils/storage_keys.dart';

class StorageHelper {
  static SharedPreferences? _prefs;


  static Future<SharedPreferences> getInstance() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

 //buat nyimpen datanya
  static Future<void> saveUserData({
    required String email,
    required String name,
    required String phone,
    required String password, 
    String? address,
    String? gender,
    String? jobStatus,
    String? dob,
  }) async {
    final prefs = await getInstance();
    await prefs.setString(StorageKeys.userEmail, email);
    await prefs.setString(StorageKeys.userName, name);
    await prefs.setString(StorageKeys.userPhone, phone);
    await prefs.setString(StorageKeys.userAddress, address ?? '');
    await prefs.setString(StorageKeys.userGender, gender ?? '');
    await prefs.setString(StorageKeys.userJobStatus, jobStatus ?? '');
    await prefs.setString(StorageKeys.userDOB, dob ?? '');
    await prefs.setString(StorageKeys.userPassword, password);
  }


  static Future<void> saveLastEmail(String email) async {
    final prefs = await getInstance();
    await prefs.setString('last_email', email);
  }


  static Future<String> getLastEmail() async {
    final prefs = await getInstance();
    return prefs.getString('last_email') ?? '';
  }

  static Future<Map<String, String>> getUserData() async {
    final prefs = await getInstance();
    return {
      'email': prefs.getString(StorageKeys.userEmail) ?? '',
      'name': prefs.getString(StorageKeys.userName) ?? '',
      'phone': prefs.getString(StorageKeys.userPhone) ?? '',
      'address': prefs.getString(StorageKeys.userAddress) ?? '',
      'gender': prefs.getString(StorageKeys.userGender) ?? '',
      'jobStatus': prefs.getString(StorageKeys.userJobStatus) ?? '',
      'dob': prefs.getString(StorageKeys.userDOB) ?? '',
      'password': prefs.getString(StorageKeys.userPassword) ?? '',
    };
  }

  static Future<void> clearUserData() async {
    final prefs = await getInstance();
    await prefs.remove(StorageKeys.userEmail);
    await prefs.remove(StorageKeys.userName);
    await prefs.remove(StorageKeys.userPhone);
    await prefs.remove(StorageKeys.userAddress);
    await prefs.remove(StorageKeys.userGender);
    await prefs.remove(StorageKeys.userJobStatus);
    await prefs.remove(StorageKeys.userDOB);
    await prefs.remove(StorageKeys.userPassword);
  }
}
