/// App-wide constants for Wasiyati
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'Wasiyati';
  static const String appNameArabic = 'وصيتي';
  static const String tagline = 'Leave your words behind. Forever.';
  static const String appVersion = '1.0.0';

  // Free tier limits
  static const int freeMaxMessages = 5;
  static const int freeMaxRecipients = 3;
  static const int freeTrustedContacts = 1;
  static const int freeRecurringMonths = 3;

  // Premium tier
  static const int premiumTrustedContacts = 2;
  static const double premiumMonthlyPrice = 4.99;
  static const double premiumYearlyPrice = 39.99;
  static const double familyPlanPrice = 9.99;
  static const int familyPlanMaxMembers = 5;

  // Dead Man's Switch
  static const int checkInIntervalDays = 30;
  static const int checkInResponseWindowDays = 7;
  static const int gracePeriodHours = 48;

  // Message limits
  static const int freeVoiceMaxMinutes = 5;
  static const int autoSaveIntervalSeconds = 30;

  // Security
  static const int autoLogoutMinutes = 5;
  static const int pinLength = 6;

  // Content types
  static const List<String> freeContentTypes = ['text'];
  static const List<String> premiumContentTypes = [
    'text',
    'voice',
    'photo',
    'video',
    'file',
  ];

  // Supported languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'ar': 'العربية',
    'fr': 'Français',
    'tr': 'Türkçe',
    'ur': 'اردو',
  };

  // RTL languages
  static const List<String> rtlLanguages = ['ar', 'ur'];

  // Relationship tags
  static const List<String> relationshipTags = [
    'Father',
    'Mother',
    'Son',
    'Daughter',
    'Brother',
    'Sister',
    'Husband',
    'Wife',
    'Friend',
    'Partner',
    'Grandparent',
    'Other',
  ];

  // Delivery channels
  static const List<String> deliveryChannels = [
    'email',
    'sms',
    'whatsapp',
  ];
}
