// ====================================================
// screens/home_screen.dart
// الشاشة الرئيسية — تعرض المهارة التالية وتقدم المستخدم
// ====================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/skill_node.dart';
import '../services/mastery_service.dart';
import '../theme/adventure_skin.dart';
import 'activity/node01_phoneme_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _nodeTitle(NodeType type) {
    switch (type) {
      case NodeType.abstractPhonemeDicrimination:
        return 'تمييز الصوت 🔊';
      case NodeType.graphemePhonemeMapping:
        return 'الصوت والشكل 👁️';
      case NodeType.shortVowelFatha:
        return 'الفتحة بَـ ✨';
      case NodeType.positionalFormInitial:
        return 'شكل الاتصال بـ 🔗';
      case NodeType.binaryBlending:
        return 'الدمج بَا 🎵';
    }
  }

  String _nodeDescription(NodeType type) {
    switch (type) {
      case NodeType.abstractPhonemeDicrimination:
        return 'هل تسمع صوت الباء؟';
      case NodeType.graphemePhonemeMapping:
        return 'ابحث عن الباء بين الحروف';
      case NodeType.shortVowelFatha:
        return 'انطق بَـ بشكل صحيح';
      case NodeType.positionalFormInitial:
        return 'الباء تمد يدها في الكلمة';
      case NodeType.binaryBlending:
        return 'ادمج الأصوات معاً';
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
                      _buildHeader(mastery),
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
                      _buildSkillsList(mastery),
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

  Widget _buildHeader(MasteryService mastery) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('⚡', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            Text(
              'عربي فصيح',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                fontFamily: AdventureSkin.arabicFont,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'حرف الباء — المستوى الأول',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
            fontFamily: AdventureSkin.arabicFont,
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
            'أتقنت كل مهارات حرف الباء!',
            style: TextStyle(
              color: AdventureSkin.success,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: AdventureSkin.arabicFont,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'ننتظر إضافة حروف جديدة قريباً',
            style: TextStyle(
              color: Colors.white54,
              fontFamily: AdventureSkin.arabicFont,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsList(MasteryService mastery) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مسار المهارات',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w700,
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
                return _buildSkillTile(node, record, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillTile(SkillNode node, dynamic record, int index) {
    final status = record.status as NodeStatus;
    final isLocked = node.prerequisites.isNotEmpty &&
        !node.prerequisites.every((id) {
          // سيتحقق المشروع من هذا لاحقاً
          return true;
        });

    Color statusColor;
    String statusEmoji;

    switch (status) {
      case NodeStatus.masteredFinal:
        statusColor = AdventureSkin.success;
        statusEmoji = '✅';
        break;
      case NodeStatus.masteredTemp:
      case NodeStatus.review1:
      case NodeStatus.review2:
        statusColor = AdventureSkin.accent;
        statusEmoji = '⏰';
        break;
      case NodeStatus.learning:
        statusColor = AdventureSkin.primary;
        statusEmoji = '🎮';
        break;
      default:
        statusColor = Colors.white30;
        statusEmoji = '🔒';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AdventureSkin.cardBg.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // رقم العقدة
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: statusColor.withOpacity(0.4)),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // العنوان
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nodeTitle(node.type),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: AdventureSkin.arabicFont,
                  ),
                ),
                Text(
                  _nodeDescription(node.type),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    fontFamily: AdventureSkin.arabicFont,
                  ),
                ),
              ],
            ),
          ),

          Text(statusEmoji, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  void _navigateToActivity(BuildContext context, SkillNode node) {
    // الآن فقط نطلق NODE_01 — باقي العقد لاحقاً
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Node01PhonemeScreen(node: node),
      ),
    );
  }
}
