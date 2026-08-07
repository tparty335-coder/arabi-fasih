// ====================================================
// screens/parents_screen.dart
// شاشة الوالدين لمتابعة التقدم التفصيلي وإدارة الحساب
// ====================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/letters_content.dart';
import '../models/skill_node.dart';
import '../services/mastery_service.dart';
import '../theme/adventure_skin.dart';

class ParentsScreen extends StatelessWidget {
  const ParentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mastery = context.watch<MasteryService>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AdventureSkin.backgroundGradient),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Header =====
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '👨‍👩‍👧 لوحة الوالدين',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          fontFamily: AdventureSkin.arabicFont,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ===== بطاقة الملخص الإجمالي =====
                  _buildSummaryCard(mastery),
                  const SizedBox(height: 20),

                  const Text(
                    'تقدم الحروف الـ 28:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: AdventureSkin.arabicFont,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ===== قائمة الحروف وإنجاز كل حرف =====
                  Expanded(
                    child: ListView.builder(
                      itemCount: ArabicLettersDB.letters.length,
                      itemBuilder: (context, index) {
                        final letterObj = ArabicLettersDB.letters.values.elementAt(index);
                        final letterChar = letterObj.letter;

                        // عقد هذا الحرف (5 عقد لكل حرف في المستوى الأول)
                        final letterNodes = SkillDAG.nodes.where((n) => n.letter == letterChar).toList();
                        int masteredCount = 0;
                        for (final node in letterNodes) {
                          final status = mastery.getRecord(node.id).status;
                          if (status == NodeStatus.masteredFinal ||
                              status == NodeStatus.masteredTemp ||
                              status == NodeStatus.review1 ||
                              status == NodeStatus.review2) {
                            masteredCount++;
                          }
                        }
                        final double progress = letterNodes.isEmpty ? 0.0 : (masteredCount / letterNodes.length);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AdventureSkin.cardBg.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AdventureSkin.primary.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    letterChar,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AdventureSkin.arabicFont,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'حرف ${letterObj.name}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AdventureSkin.arabicFont,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        minHeight: 6,
                                        backgroundColor: Colors.white12,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          progress == 1.0
                                              ? AdventureSkin.success
                                              : AdventureSkin.accent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AdventureSkin.arabicFont,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===== زر إعادة الضبط =====
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        'إعادة ضبط كافة البيانات',
                        style: TextStyle(
                          fontFamily: AdventureSkin.arabicFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _showResetDialog(context, mastery),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(MasteryService mastery) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AdventureSkin.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AdventureSkin.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('⚡ XP', '${mastery.totalXp}', Colors.amber),
          _buildSummaryItem('🔥 Streak', '${mastery.currentStreak} يوم', Colors.orange),
          _buildSummaryItem('📚 الإتقان', '${mastery.totalMastered} / ${mastery.totalNodes}', AdventureSkin.success),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontFamily: AdventureSkin.arabicFont,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            fontFamily: AdventureSkin.arabicFont,
          ),
        ),
      ],
    );
  }

  void _showResetDialog(BuildContext context, MasteryService mastery) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AdventureSkin.cardBg,
        title: const Text(
          'تأكيد إعادة الضبط',
          style: TextStyle(color: Colors.white, fontFamily: AdventureSkin.arabicFont),
        ),
        content: const Text(
          'هل أنت تأكد من إغلاق كل السجلات وإعادة جميع مهارات الطفل للصفر؟ لا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(color: Colors.white70, fontFamily: AdventureSkin.arabicFont),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await mastery.resetAll();
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تمت إعادة الضبط بنجاح.')),
                );
              }
            },
            child: const Text('نعم، إعادة الضبط', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
