import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _onboardingKey = 'has_seen_onboarding';

  static Future<bool> hasSeenOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = prefs.getBool(_onboardingKey) ?? false;
      print('🔍 OnboardingService - hasSeenOnboarding: $result');
      return result;
    } catch (e) {
      print('❌ OnboardingService error: $e');
      return false; // Default to false if error
    }
  }

  static Future<void> setOnboardingSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
      print('✅ OnboardingService - Onboarding marked as seen');
    } catch (e) {
      print('❌ OnboardingService setOnboardingSeen error: $e');
    }
  }

  static Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, false);
      print('🔄 OnboardingService - Onboarding reset');
    } catch (e) {
      print('❌ OnboardingService resetOnboarding error: $e');
    }
  }
}
