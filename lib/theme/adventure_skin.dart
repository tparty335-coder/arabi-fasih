// ====================================================
// theme/adventure_skin.dart
// غلاف المغامرة — الفئة العمرية 7-10 سنوات
// من Learning Bible: 03_age_skins.md
// ====================================================

import 'package:flutter/material.dart';

class AdventureSkin {
  // =============================================
  // الألوان الرئيسية
  // =============================================
  static const Color primary = Color(0xFFFF6B35);      // برتقالي
  static const Color secondary = Color(0xFF7C4DFF);    // بنفسجي
  static const Color accent = Color(0xFFFFC107);        // ذهبي
  static const Color background = Color(0xFF1A1A2E);   // داكن دافئ
  static const Color surface = Color(0xFF16213E);      // أغمق قليلاً
  static const Color cardBg = Color(0xFF0F3460);       // بطاقات
  static const Color success = Color(0xFF00E676);      // أخضر فوسفوري
  static const Color error = Color(0xFFFF5252);        // أحمر

  // ألوان الحروف في الخيارات
  static const Color letterCard = Color(0xFF1E3A5F);
  static const Color letterCardSelected = Color(0xFF7C4DFF);
  static const Color letterCardCorrect = Color(0xFF00C853);
  static const Color letterCardWrong = Color(0xFFD50000);

  // =============================================
  // Typography
  // =============================================
  static const String arabicFont = 'Cairo';

  static const TextStyle letterStyle = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    fontFamily: arabicFont,
    height: 1.2,
  );

  static const TextStyle questionStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: arabicFont,
    height: 1.5,
  );

  static const TextStyle xpStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: accent,
    fontFamily: arabicFont,
  );

  static const TextStyle feedbackStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    fontFamily: arabicFont,
  );

  // =============================================
  // ThemeData كامل
  // =============================================
  static ThemeData get theme => ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: primary,
          secondary: secondary,
          surface: surface,
          error: error,
        ),
        fontFamily: arabicFont,
        scaffoldBackgroundColor: background,
        cardColor: cardBg,
        useMaterial3: true,
      );

  // =============================================
  // رسائل التشجيع (من Learning Bible)
  // =============================================
  static const List<String> successMessages = [
    '🎯 مذهل! +50 XP',
    '🔥 رائع! استمر!',
    '⚡ سريع جداً! +75 XP',
    '🏆 أنت بطل! +50 XP',
    '💎 إجابة مثالية! +100 XP',
  ];

  static const List<String> wrongMessages = [
    '🎮 حاول مرة أخرى!',
    '💪 قريب! جرّب ثانية',
    '🎯 ركّز وحاول!',
  ];

  static String getSuccessMessage() {
    final index = DateTime.now().millisecond % successMessages.length;
    return successMessages[index];
  }

  static String getWrongMessage() {
    final index = DateTime.now().millisecond % wrongMessages.length;
    return wrongMessages[index];
  }

  // =============================================
  // Decoration للبطاقات
  // =============================================
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: secondary.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: secondary.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get letterCardDecoration => BoxDecoration(
        color: letterCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: secondary.withOpacity(0.4), width: 2),
      );

  static BoxDecoration letterCardCorrectDecoration = BoxDecoration(
        color: letterCardCorrect.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: letterCardCorrect, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: letterCardCorrect.withOpacity(0.4),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      );

  static BoxDecoration letterCardWrongDecoration = BoxDecoration(
        color: letterCardWrong.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: letterCardWrong, width: 2.5),
      );

  // =============================================
  // Gradient للخلفية
  // =============================================
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, Color(0xFF0A0A1A)],
  );
}
