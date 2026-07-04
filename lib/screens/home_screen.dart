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
import 'activity/level2_cvc_screen.dart';
import 'activity/level2_multisyllable_screen.dart';
import 'activity/level3_long_vowel_screen.dart';
import 'progress_screen.dart';
import 'diagnostic_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      default:                                    return 'مهارة';
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
      default:                                    return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AdventureSkin.backgroundGradient,
        ),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Consumer<MasteryService>(
              builder: (context, mastery, _) {
                final nextNode = mastery.getNextSkill();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // ===== الترحيب =====
                      _buildHeader(context, mastery),
                      const SizedBox(height: 32),

                      // ===== شريط التقدم العام =====
                      _buildProgressSection(mastery),
                      const SizedBox(height: 32),

                      // ===== بطاقة المهارة التالية =====
                      if (nextNode != null)
                        _buildNextSkillCard(context, nextNode)
                      else
                        _buildAllMasteredCard(),

                      const SizedBox(height: 24),

                      // ===== قائمة كل المهارات =====
                      _buildSkillsList(context, mastery),
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
            const Text('⚡', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            const Text('عربي فصيح', style: TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900,
              fontFamily: AdventureSkin.arabicFont,
            )),
            const Spacer(),
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
                child: const Text('🧠', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 8),
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
                child: const Text('📊', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'تعلم الحروف العربية الـ 28',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14, fontFamily: AdventureSkin.arabicFont,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(MasteryService mastery) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AdventureSkin.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تقدمك',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontFamily: AdventureSkin.arabicFont,
                ),
              ),
              Text(
                '${mastery.totalMastered} / ${mastery.totalNodes} مهارة',
                style: AdventureSkin.xpStyle,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: mastery.progressPercent,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AdventureSkin.success),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(mastery.progressPercent * 100).toStringAsFixed(0)}% مكتمل',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
              fontFamily: AdventureSkin.arabicFont,
            ),
          ),
        ],
      ),
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
              color: AdventureSkin.primary.withOpacity(0.4),
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
                    color: Colors.white.withOpacity(0.2),
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
        color: AdventureSkin.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: AdventureSkin.success.withOpacity(0.4), width: 2),
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

  Widget _buildSkillsList(BuildContext context, MasteryService mastery) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مسار المهارات',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16, fontWeight: FontWeight.w700,
              fontFamily: AdventureSkin.arabicFont,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: SkillDAG.nodes.length,
              itemBuilder: (context, index) {
                final node = SkillDAG.nodes[index];
                final record = mastery.getRecord(node.id);
                // تحقق من المتطلبات بشكل صحيح
                final isLocked = node.prerequisites.any((prereqId) {
                  final prereq = mastery.getRecord(prereqId);
                  return prereq.status == NodeStatus.unseen ||
                         prereq.status == NodeStatus.learning;
                });
                return _buildSkillTile(context, node, record, index, isLocked);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillTile(BuildContext context, SkillNode node, dynamic record, int index, bool isLocked) {
    final status = record.status as NodeStatus;

    Color statusColor;
    String statusEmoji;

    switch (status) {
      case NodeStatus.masteredFinal:
        statusColor = AdventureSkin.success; statusEmoji = '✅'; break;
      case NodeStatus.masteredTemp:
      case NodeStatus.review1:
      case NodeStatus.review2:
        statusColor = AdventureSkin.accent; statusEmoji = '⏰'; break;
      case NodeStatus.learning:
        statusColor = AdventureSkin.primary; statusEmoji = '🎮'; break;
      default:
        statusColor = isLocked ? Colors.white24 : Colors.white54;
        statusEmoji = isLocked ? '🔒' : '▶️';
    }

    return GestureDetector(
      onTap: isLocked ? null : () => _navigateToActivity(context, node),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isLocked ? 0.4 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AdventureSkin.cardBg.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: statusColor.withValues(alpha: 0.3)),
          ),
          child: Row(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: statusColor.withValues(alpha: 0.4)),
              ),
              child: Center(child: Text(node.letter,
                  style: TextStyle(color: statusColor,
                      fontWeight: FontWeight.w900, fontSize: 18,
                      fontFamily: AdventureSkin.arabicFont))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_nodeTitle(node.type),
                    style: const TextStyle(color: Colors.white,
                        fontSize: 14, fontWeight: FontWeight.w700,
                        fontFamily: AdventureSkin.arabicFont)),
                Text(_nodeDescription(node.type),
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12, fontFamily: AdventureSkin.arabicFont)),
              ],
            )),
            Text(statusEmoji, style: const TextStyle(fontSize: 20)),
          ]),
        ),
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
    } else {
      final letterData = ArabicLettersDB.get(node.letter) ?? ArabicLettersDB.get('ب')!;
      screen = GenericLetterActivity(
        node: node, letterData: letterData,
        activityType: _nodeTypeToActivity(node.type),
        title: 'حرف ${node.letter} — ${_nodeTitle(node.type)}',
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
