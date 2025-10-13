import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SecureTokenStorage {
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userEmailKey = 'user_email';

  static bool _useSecureStorage = true;

  static Future<void> saveLoginTokens({
    required String accessToken,
    required String refreshToken,
    String? userEmail,
  }) async {
    try {
      if (_useSecureStorage) {
        await _secureStorage.write(key: _accessTokenKey, value: accessToken);
        await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
        if (userEmail != null) {
          await _secureStorage.write(key: _userEmailKey, value: userEmail);
        }
      } else {
        await _saveToSharedPreferences(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userEmail: userEmail,
        );
      }
    } catch (_) {
      _useSecureStorage = false;
      await _saveToSharedPreferences(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userEmail: userEmail,
      );
    }
  }

  static Future<void> _saveToSharedPreferences({
    required String accessToken,
    required String refreshToken,
    String? userEmail,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    if (userEmail != null) {
      await prefs.setString(_userEmailKey, userEmail);
    }
  }

  static Future<String?> getAccessToken() async {
    try {
      if (_useSecureStorage) {
        return await _secureStorage.read(key: _accessTokenKey);
      } else {
        return await _getFromSharedPreferences(_accessTokenKey);
      }
    } catch (_) {
      _useSecureStorage = false;
      return await _getFromSharedPreferences(_accessTokenKey);
    }
  }

  static Future<String?> getRefreshToken() async {
    try {
      if (_useSecureStorage) {
        return await _secureStorage.read(key: _refreshTokenKey);
      } else {
        return await _getFromSharedPreferences(_refreshTokenKey);
      }
    } catch (_) {
      _useSecureStorage = false;
      return await _getFromSharedPreferences(_refreshTokenKey);
    }
  }

  static Future<String?> getUserEmail() async {
    try {
      if (_useSecureStorage) {
        return await _secureStorage.read(key: _userEmailKey);
      } else {
        return await _getFromSharedPreferences(_userEmailKey);
      }
    } catch (_) {
      _useSecureStorage = false;
      return await _getFromSharedPreferences(_userEmailKey);
    }
  }

  static Future<String?> _getFromSharedPreferences(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clearAllTokens() async {
    try {
      if (_useSecureStorage) {
        await _secureStorage.deleteAll();
      }
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userEmailKey);
  }

  static Future<bool> testSecureStorage() async {
    try {
      const testKey = 'test_key';
      const testValue = 'test_value';
      await _secureStorage.write(key: testKey, value: testValue);
      final retrieved = await _secureStorage.read(key: testKey);
      await _secureStorage.delete(key: testKey);
      final isWorking = retrieved == testValue;
      _useSecureStorage = isWorking;
      return isWorking;
    } catch (_) {
      _useSecureStorage = false;
      return false;
    }
  }

  static Future<bool> isTokenValid() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty && token.length > 10;
  }

  static String getStorageMethod() {
    return _useSecureStorage ? 'FlutterSecureStorage' : 'SharedPreferences';
  }
}
