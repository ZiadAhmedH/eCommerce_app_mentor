import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SecureTokenStorage {
  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  /// Save login tokens
  static Future<void> saveLoginTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, accessToken);
      await prefs.setString(_refreshTokenKey, refreshToken);

      if (kDebugMode) {
        print('✅ Tokens saved successfully');
        print('🔐 Access token length: ${accessToken.length}');
        print('🔐 Refresh token length: ${refreshToken.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to save tokens: $e');
      }
      rethrow;
    }
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_accessTokenKey);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to get access token: $e');
      }
      return null;
    }
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to get refresh token: $e');
      }
      return null;
    }
  }

  /// Check if user is logged in (has valid access token)
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all tokens (logout)
  static Future<void> clearAllTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);

      if (kDebugMode) {
        print('🗑️ All tokens cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to clear tokens: $e');
      }
      rethrow;
    }
  }
}
