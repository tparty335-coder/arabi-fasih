// ====================================================
// utils/app_images.dart
// فهرس مركزي ومترجم لجميع أصول الصور في التطبيق
// ====================================================

class AppImages {
  static const String letterPrefix = 'assets/images/letters/';
  static const String uiPrefix = 'assets/images/ui/';

  // صور الحروف
  static String letterImage(String letter) =>
      '${letterPrefix}letter_${_transliterate(letter)}.jpg';

  // صور الواجهة
  static const String desertBg = '${uiPrefix}desert_bg.jpg';
  static const String falconHappy = '${uiPrefix}falcon_happy.jpg';
  static const String falconCelebrating = '${uiPrefix}falcon_celebrating.jpg';
  static const String falconEncouraging = '${uiPrefix}falcon_encouraging.jpg';
  static const String falconThinking = '${uiPrefix}falcon_thinking.jpg';
  static const String splashBg = '${uiPrefix}splash_bg.jpg';
  static const String appIcon = '${uiPrefix}app_icon.jpg';

  static String _transliterate(String letter) {
    const map = {
      'أ': 'alif',
      'إ': 'alif',
      'آ': 'alif',
      'ا': 'alif',
      'ب': 'ba',
      'ت': 'ta',
      'ث': 'tha',
      'ج': 'jim',
      'ح': 'ha',
      'خ': 'kha',
      'د': 'dal',
      'ذ': 'dhal',
      'ر': 'ra',
      'ز': 'zay',
      'س': 'sin',
      'ش': 'shin',
      'ص': 'sad',
      'ض': 'dad',
      'ط': 'ta_heavy',
      'ظ': 'dha_heavy',
      'ع': 'ain',
      'غ': 'ghain',
      'ف': 'fa',
      'ق': 'qaf',
      'ك': 'kaf',
      'ل': 'lam',
      'م': 'mim',
      'ن': 'nun',
      'هـ': 'ha2',
      'ه': 'ha2',
      'و': 'waw',
      'ي': 'ya',
    };
    return map[letter] ?? 'alif';
  }
}
