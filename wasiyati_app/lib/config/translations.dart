import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vault_provider.dart';

class S {
  final String locale;
  S(this.locale);

  static final Map<String, Map<String, String>> _dict = {
    'en': {
      // Navigation
      'dashboard': 'Dashboard',
      'messages': 'Messages',
      'vault': 'Vault',
      'people': 'People',
      'profile': 'Profile',
      
      // Dashboard Screen
      'hello': 'Hello',
      'good_morning': 'Good morning',
      'welcome_back': 'Welcome back,',
      'will_status': 'Will Status',
      'secured_encrypted': 'Secured & Encrypted',
      'legacy_safe': 'Legacy is safe',
      'your_messages': 'Your Messages',
      'recipients_label': 'Recipients',
      'trusted_contacts': 'Trusted Contacts',
      'active_checkin': 'Active Check-in Trigger',
      'days_remaining': 'days remaining',
      'next_checkin': 'Next Check-in',
      
      // Messages Screen
      'new_message': 'New Message',
      'all': 'All',
      'immediate': 'Immediate',
      'recurring': 'Recurring',
      'occasion': 'Occasion',
      'milestone': 'Milestone',
      'no_messages': 'No messages yet',
      'start_legacy': 'Start writing your legacy.',
      
      // Vault Screen
      'wills': 'Digital Wills',
      'credentials': 'Credentials Locker',
      'vault_empty': 'Your Vault is empty',
      'vault_desc': 'Add secure notes or documents.',
      'encrypted_private_space': 'Your encrypted private space',
      'premium_feature': 'Premium Feature',
      'premium_desc': 'Store your digital will, credentials,\nvideo testament, and more.',
      'unlock_premium': 'Unlock Premium — \$4.99/mo',
      'digital_will': 'Digital Will',
      'credentials_label': 'Credentials',
      'video_testament': 'Video Testament',
      'letter_world': 'Letter to World',
      'zero_knowledge': 'Zero-Knowledge Architecture',
      'zero_knowledge_desc': 'Your vault is encrypted with AES-256. Even we can\'t read your content.',
      
      // People Screen
      'add_recipient': 'Add Recipient',
      'edit_recipient': 'Edit Recipient',
      'remove_recipient': 'Remove Recipient?',
      'confirm_remove_recipient': 'Are you sure you want to remove this recipient?',
      'preferred_language': 'Preferred Language',
      'relationship': 'Relationship',
      'contact_channels': 'Contact Channels',
      'add_channel_notice': 'Add at least one channel to deliver messages',
      
      // Check-in Screen
      'checkin': 'Check-in',
      'let_us_know_alright': 'Let us know you\'re alright.',
      'are_you_still_with_us': 'Are you still with us?',
      'checkin_desc': 'Your loved ones are waiting for your messages.\nLet us know you\'re alright.',
      'yes_im_alright': 'Yes, I\'m alright',
      'remind_tomorrow': 'Remind me tomorrow',
      'days_left': 'days\nleft',
      
      // Profile Screen
      'account': 'Account',
      'edit_profile': 'Edit Profile',
      'checkin_settings': 'Check-in Settings',
      'security': 'Security',
      'security_privacy': 'Security & Privacy',
      'security_phrase': 'Security Phrase',
      'preferences': 'Preferences',
      'language_region': 'Language & Region',
      'subscription': 'Subscription & Billing',
      'support': 'Support',
      'help_support': 'Help & Support',
      'sign_out': 'Sign Out',
      
      // Common buttons / alerts
      'save': 'Save',
      'save_changes': 'Save Changes',
      'cancel': 'Cancel',
      'remove': 'Remove',
      'add': 'Add',
      'close': 'Close',
      'error': 'Error',
      'success': 'Success',
      'changes_saved': 'Changes saved successfully!',
    },
    'ar': {
      // Navigation
      'dashboard': 'الرئيسية',
      'messages': 'الرسائل',
      'vault': 'الخزنة',
      'people': 'الأشخاص',
      'profile': 'حسابي',
      
      // Dashboard Screen
      'hello': 'مرحباً',
      'good_morning': 'صباح الخير',
      'welcome_back': 'أهلاً بك من جديد،',
      'will_status': 'حالة الوصية',
      'secured_encrypted': 'مؤمن ومشفر',
      'legacy_safe': 'إرثك الرقمي آمن ومحمي',
      'your_messages': 'رسائلك المحفوظة',
      'recipients_label': 'المستلمون',
      'trusted_contacts': 'جهات الاتصال الموثوقة',
      'active_checkin': 'مفتاح التحقق النشط',
      'days_remaining': 'أيام متبقية',
      'next_checkin': 'التحقق القادم',
      
      // Messages Screen
      'new_message': 'رسالة جديدة',
      'all': 'الكل',
      'immediate': 'فوري',
      'recurring': 'دوري',
      'occasion': 'مناسبة',
      'milestone': 'حدث هام',
      'no_messages': 'لا توجد رسائل بعد',
      'start_legacy': 'ابدأ بكتابة وصيتك وإرثك الآن.',
      
      // Vault Screen
      'wills': 'الوصايا الرقمية',
      'credentials': 'خزنة كلمات المرور',
      'vault_empty': 'الخزنة فارغة',
      'vault_desc': 'قم بإضافة ملاحظات أو وثائق سرية.',
      'encrypted_private_space': 'مساحتك الخاصة والمشفرة بالكامل',
      'premium_feature': 'ميزة بريميوم الفاخرة',
      'premium_desc': 'احفظ وصيتك الرقمية، كلمات المرور،\nتسجيلاتك المرئية والمزيد.',
      'unlock_premium': 'ترقية إلى بريميوم — ٤.٩٩\$ شهرياً',
      'digital_will': 'الوصية الرقمية',
      'credentials_label': 'بيانات المرور الحساسة',
      'video_testament': 'الوصية المرئية',
      'letter_world': 'رسالة إلى العالم',
      'zero_knowledge': 'بنية التشفير الآمن (Zero-Knowledge)',
      'zero_knowledge_desc': 'خزنتك محمية بالكامل بتشفير AES-256. لا يمكن لأحد سواك الاطلاع عليها.',
      
      // People Screen
      'add_recipient': 'إضافة مستلم',
      'edit_recipient': 'تعديل مستلم',
      'remove_recipient': 'حذف المستلم؟',
      'confirm_remove_recipient': 'هل أنت متأكد من رغبتك في حذف هذا المستلم؟',
      'preferred_language': 'اللغة المفضلة',
      'relationship': 'صلة القرابة',
      'contact_channels': 'قنوات الاتصال',
      'add_channel_notice': 'أضف قناة واحدة على الأقل لإرسال الرسائل',
      
      // Check-in Screen
      'checkin': 'تسجيل الحضور',
      'let_us_know_alright': 'طمنا عليك لنعرف أنك بخير.',
      'are_you_still_with_us': 'هل ما زلت معنا؟',
      'checkin_desc': 'أحباؤك ينتظرون رسائلك في الوقت المناسب.\nطمنا على حالك الآن.',
      'yes_im_alright': 'نعم، أنا بخير',
      'remind_tomorrow': 'ذكرني غداً',
      'days_left': 'أيام\nمتبقية',
      
      // Profile Screen
      'account': 'الحساب',
      'edit_profile': 'تعديل الملف الشخصي',
      'checkin_settings': 'إعدادات التحقق',
      'security': 'الأمان',
      'security_privacy': 'الأمان والخصوصية',
      'security_phrase': 'عبارة الأمان السرية',
      'preferences': 'التفضيلات',
      'language_region': 'اللغة والمنطقة',
      'subscription': 'الاشتراك والدفع',
      'support': 'الدعم والمساعدة',
      'help_support': 'التعليمات والدعم',
      'sign_out': 'تسجيل الخروج',
      
      // Common buttons / alerts
      'save': 'حفظ',
      'save_changes': 'حفظ التغييرات',
      'cancel': 'إلغاء',
      'remove': 'إزالة',
      'add': 'إضافة',
      'close': 'إغلاق',
      'error': 'خطأ',
      'success': 'تم بنجاح',
      'changes_saved': 'تم حفظ التغييرات بنجاح!',
    }
  };

  String get(String key) {
    return _dict[locale]?[key] ?? _dict['en']?[key] ?? key;
  }
}

final translationsProvider = Provider<S>((ref) {
  final locale = ref.watch(localeProvider);
  return S(locale);
});
