// ====================================================
// screens/home_screen.dart
// الشاشة الرئيسية — تعرض المهارة التالية وتقدم المستخدم
// ====================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/letters_content.dart';
import '../models/skill_node.dart';
import '../services/mastery_service.dart';
import '../theme/adventure_skin.dart';
import 'activity/node01_phoneme_screen.dart';
import 'activity/node02_grapheme_screen.dart';
import 'activity/node03_vowel_fatha_screen.dart';
import 'activity/node04_positional_screen.dart';
import 'activity/node05_blending_screen.dart';
import 'activity/generic_letter_activity.dart';
import 'activity/letter_intro_screen.dart';
import 'activity/level2_cvc_screen.dart';
import 'activity/level2_multisyllable_screen.dart';
import 'activity/level3_long_vowel_screen.dart';
import 'activity/level45_comparison_screen.dart';
import 'activity/meem_hub_screen.dart';
import 'progress_screen.dart';
import 'diagnostic_screen.dart';
import 'badges_screen.dart';
import 'parents_screen.dart';
import '../widgets/falcon_mascot.dart';
import '../widgets/adventure_path.dart';
import '../utils/app_images.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'صباح الخير! ☀️';
    if (hour < 17) return 'مرحباً! 🌤️';
    return 'مساء الخير! 🌙';
  }

  String _nodeTitle(NodeType type) {
    switch (type) {
      case NodeType.abstractPhonemeDicrimination: return 'تمييز الصوت 🔊';
      case NodeType.graphemePhonemeMapping:       return 'الصوت والشكل 👁️';
      case NodeType.shortVowelFatha:              return 'الفتحة بَـ ✨';
      case NodeType.positionalFormInitial:        return 'شكل الاتصال 🔗';
      case NodeType.binaryBlending:               return 'الدمج 🎵';
      case NodeType.sukunCvcFatha:                return 'الساكن + فتح 🔓';
      case NodeType.sukunCvcDamma:                return 'الساكن + ضم 🔓';
      case NodeType.sukunCvcKasra:                return 'الساكن + كسر 🔓';
      case NodeType.multiSyllable:                return 'تقطيع الكلمات 📚';
      case NodeType.verbConjugation:              return 'تصريف الفعل 🌱';
      case NodeType.longVowelAlif:                return 'مد الألف اآا';
      case NodeType.longVowelYa:                  return 'مد الياء إِيـ';
      case NodeType.longVowelWaw:                 return 'مد الواو أُوـ';
      case NodeType.longVowelAdvanced:            return 'كلمات متقدمة 🌟';
      case NodeType.shaddaBasic:                  return 'الشدة ّ — أساسي';
      case NodeType.shaddaProfession:             return 'الشدة ّ — مهن';
      case NodeType.shaddaComplex:                return 'الشدة ّ — مركب';
      case NodeType.tanwinFath:                   return 'تنوين الفتح ًـ';
      case NodeType.tanwinKasr:                   return 'تنوين الكسر ٍـ';
      case NodeType.tanwinDamm:                   return 'تنوين الضم ٌـ';
    }
  }

  String _nodeDescription(NodeType type) {
    switch (type) {
      case NodeType.abstractPhonemeDicrimination: return 'هل تسمع الصوت؟';
      case NodeType.graphemePhonemeMapping:       return 'ابحث عن الحرف بين الخيارات';
      case NodeType.shortVowelFatha:              return 'انطق بَـ بشكل صحيح';
      case NodeType.positionalFormInitial:        return 'شكل الحرف في الكلمة';
      case NodeType.binaryBlending:               return 'ادمج الأصوات معاً';
      case NodeType.sukunCvcFatha:                return 'فَأْس • بَيْت • شَمْس';
      case NodeType.sukunCvcDamma:                return 'بُرْج • أُخْت • غُرْفَة';
      case NodeType.sukunCvcKasra:                return 'بِنْت • طِفْل • مِلْح';
      case NodeType.multiSyllable:                return 'مَدْرَسَة • أَرْنَب • شَمْعَة';
      case NodeType.verbConjugation:              return 'أَكْتُب • نَكْتُب • يَكْتُب';
      case NodeType.longVowelAlif:                return 'بَاب • تَاج • نَار';
      case NodeType.longVowelYa:                  return 'فِيل • دِيك • كِتَاب';
      case NodeType.longVowelWaw:                 return 'حُوت • كُوب • نُور';
      case NodeType.longVowelAdvanced:            return 'مدَارِس • مصَانِع • طَوَابِير';
      case NodeType.shaddaBasic:                  return 'قِطّة • حَبّة • بَطّة';
      case NodeType.shaddaProfession:             return 'فَتّاح • كَذّاب • نَجّار';
      case NodeType.shaddaComplex:                return 'مُعَلِّم • سَيّارَة • ثَلّاجَة';
      case NodeType.tanwinFath:                   return 'بَيْتًا • قَلْبًا • وَرْدًا';
      case NodeType.tanwinKasr:                   return 'بَيْتٍ • قَلْبٍ • رَجُلٍ';
      case NodeType.tanwinDamm:                   return 'بَيْتٌ • قَلْبٌ • رَجُلٌ';
    }
  }

  List<SkillNode> _getVisibleNodes() {
    // عرض عقد الحروف الـ 28 (Node_01 من كل حرف)
    return SkillDAG.nodes.where((n) => n.type == NodeType.abstractPhonemeDicrimination).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AdventureSkin.backgroundGradient,
          image: DecorationImage(
            image: const AssetImage(AppImages.desertBg),
            fit: BoxFit.cover,
            onError: (_, __) {},
          ),
        ),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Consumer<MasteryService>(
              builder: (context, mastery, _) {
                final nextNode = mastery.getNextSkill();
                final visibleNodes = _getVisibleNodes();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // ===== الترحيب =====
                      _buildHeader(context, mastery),
                      const SizedBox(height: 16),

                      // ===== الصقر الرئاسي (Falcon Mascot) =====
                      Center(
                        child: FalconMascot(
                          mood: mastery.currentStreak >= 3
                              ? FalconMood.celebrating
                              : mastery.totalMastered > 0
                                  ? FalconMood.encouraging
                                  : FalconMood.happy,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ===== بطاقة المهارة التالية =====
                      if (nextNode != null)
                        _buildNextSkillCard(context, nextNode)
                      else
                        _buildAllMasteredCard(),

                      const SizedBox(height: 16),

                      // ===== خريطة مسار المغامرة البصري (Adventure Path Map) =====
                      Expanded(
                        child: AdventurePath(
                          nodes: visibleNodes,
                          mastery: mastery,
                          onTap: (node) => _navigateToActivity(context, node),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MasteryService mastery) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('⚡', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontFamily: AdventureSkin.arabicFont,
                  ),
                ),
                const Text(
                  'عربي فصيح',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    fontFamily: AdventureSkin.arabicFont,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // زر لوحة الوالدين
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const ParentsScreen())),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Text('👨‍👩‍👧', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 6),
            // زر الأوسمة
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const BadgesScreen())),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Text('🏅', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 6),
            // زر التشخيص
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const DiagnosticScreen())),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AdventureSkin.accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Text('🧠', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 6),
            // زر التقدم
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const ProgressScreen())),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AdventureSkin.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Text('📊', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // ===== شريط الإحصائيات (XP / Streak / Level / Badges) =====
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AdventureSkin.cardBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatChip('⚡', '${mastery.totalXp} XP', Colors.amber),
              _buildStatChip('🔥', '${mastery.currentStreak} يوم', Colors.orange),
              _buildStatChip('🏅', '${mastery.earnedBadges.length} وسام', Colors.purpleAccent),
              _buildStatChip('⭐', 'مستوى ${mastery.level}', AdventureSkin.accent),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(String emoji, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 12,
            fontFamily: AdventureSkin.arabicFont,
          ),
        ),
      ],
    );
  }

  Widget _buildNextSkillCard(BuildContext context, SkillNode node) {
    return GestureDetector(
      onTap: () => _navigateToActivity(context, node),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AdventureSkin.primary, AdventureSkin.secondary],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AdventureSkin.primary.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المهارة التالية 🎯',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontFamily: AdventureSkin.arabicFont,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _nodeTitle(node.type),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                fontFamily: AdventureSkin.arabicFont,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _nodeDescription(node.type),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: AdventureSkin.arabicFont,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Text('▶️', style: TextStyle(fontSize: 14)),
                      SizedBox(width: 8),
                      Text('ابدأ الآن',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: AdventureSkin.arabicFont,
                          )),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '3 تفاعلات · 40 ثانية',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    fontFamily: AdventureSkin.arabicFont,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllMasteredCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdventureSkin.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: AdventureSkin.success.withValues(alpha: 0.4), width: 2),
      ),
      child: const Column(
        children: [
          Text('🏆', style: TextStyle(fontSize: 48)),
          SizedBox(height: 12),
          Text(
            'أتقنت كل المهارات المتاحة!',
            style: TextStyle(
              color: AdventureSkin.success, fontSize: 18,
              fontWeight: FontWeight.w900, fontFamily: AdventureSkin.arabicFont,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'استمر في المراجعة للحفاظ على إتقانك',
            style: TextStyle(color: Colors.white54, fontFamily: AdventureSkin.arabicFont),
          ),
        ],
      ),
    );
  }

  void _navigateToActivity(BuildContext context, SkillNode node) {
    Widget screen;

    // Level 2 nodes
    if (node.type == NodeType.sukunCvcFatha ||
        node.type == NodeType.sukunCvcDamma ||
        node.type == NodeType.sukunCvcKasra) {
      screen = Level2CvcScreen(node: node);
    } else if (node.type == NodeType.multiSyllable ||
        node.type == NodeType.verbConjugation) {
      screen = Level2MultiSyllableScreen(node: node);
    } else if (node.type == NodeType.longVowelAlif ||
        node.type == NodeType.longVowelYa ||
        node.type == NodeType.longVowelWaw ||
        node.type == NodeType.longVowelAdvanced) {
      screen = Level3LongVowelScreen(node: node);
    } else if (node.type == NodeType.shaddaBasic ||
        node.type == NodeType.shaddaProfession ||
        node.type == NodeType.shaddaComplex ||
        node.type == NodeType.tanwinFath ||
        node.type == NodeType.tanwinKasr ||
        node.type == NodeType.tanwinDamm) {
      screen = Level45ComparisonScreen(node: node);
    } else if (node.letter == 'ب') {
      // حرف الباء — الشاشات المخصصة (MVP)
      switch (node.type) {
        case NodeType.abstractPhonemeDicrimination:
          screen = Node01PhonemeScreen(node: node); break;
        case NodeType.graphemePhonemeMapping:
          screen = Node02GraphemeScreen(node: node); break;
        case NodeType.shortVowelFatha:
          screen = Node03VowelFathaScreen(node: node); break;
        case NodeType.positionalFormInitial:
          screen = Node04PositionalScreen(node: node); break;
        case NodeType.binaryBlending:
          screen = Node05BlendingScreen(node: node); break;
        default:
          screen = Node01PhonemeScreen(node: node);
      }
    } else if (node.letter == 'م') {
      // حرف الميم — بوابة التجربة الكاملة بصوت بشري أصلي
      screen = const MeemHubScreen();
    } else {
      // جميع الحروف الأخرى — GenericLetterActivity مسبوقة بشاشة التعليم
      final letterData = ArabicLettersDB.get(node.letter);
      if (letterData == null) {
        debugPrint('HomeScreen: No LetterData found for "${node.letter}" — skipping navigation.');
        return;
      }
      final activityScreen = GenericLetterActivity(
        node: node, letterData: letterData,
        activityType: _nodeTypeToActivity(node.type),
        title: 'حرف ${node.letter} — ${_nodeTitle(node.type)}',
      );
      // ✅ التسلسل التربوي الصحيح: عرض الحرف أولاً ثم الاختبار
      screen = LetterIntroScreen(
        node: node,
        letterData: letterData,
        nextScreen: activityScreen,
      );
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  ActivityType _nodeTypeToActivity(NodeType type) {
    switch (type) {
      case NodeType.abstractPhonemeDicrimination: return ActivityType.phonemeYesNo;
      case NodeType.graphemePhonemeMapping:        return ActivityType.pickLetter;
      case NodeType.shortVowelFatha:               return ActivityType.pickVowel;
      case NodeType.positionalFormInitial:          return ActivityType.pickWordWithLetter;
      case NodeType.binaryBlending:                return ActivityType.blending;
      // Level 2 — handled separately, but need a default
      default:                                     return ActivityType.phonemeYesNo;
    }
  }
}
