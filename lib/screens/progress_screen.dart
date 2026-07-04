// screens/progress_screen.dart — تقرير التقدم الكامل
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/skill_node.dart';
import '../services/mastery_service.dart';
import '../theme/adventure_skin.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AdventureSkin.backgroundGradient),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Consumer<MasteryService>(
              builder: (context, mastery, _) {
                // تجميع الحروف
                final letterGroups = <String, List<SkillNode>>{};
                for (final node in SkillDAG.nodes) {
                  letterGroups.putIfAbsent(node.letter, () => []).add(node);
                }
                return Column(children: [
                  _buildHeader(context, mastery),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: letterGroups.length,
                      itemBuilder: (_, i) {
                        final letter = letterGroups.keys.toList()[i];
                        final nodes = letterGroups[letter]!;
                        return _buildLetterCard(mastery, letter, nodes);
                      },
                    ),
                  ),
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MasteryService mastery) {
    final pct = (mastery.progressPercent * 100).toStringAsFixed(1);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Row(children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text('تقرير التقدم', style: TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900,
            fontFamily: AdventureSkin.arabicFont,
          )),
          const Spacer(),
          Text('$pct%', style: AdventureSkin.xpStyle.copyWith(fontSize: 18)),
        ]),
        const SizedBox(height: 16),
        _StatRow(mastery: mastery),
      ]),
    );
  }

  Widget _buildLetterCard(MasteryService mastery, String letter, List<SkillNode> nodes) {
    final mastered = nodes.where((n) =>
        mastery.getRecord(n.id).status == NodeStatus.masteredFinal).length;
    final inProgress = nodes.where((n) =>
        mastery.getRecord(n.id).status == NodeStatus.learning ||
        mastery.getRecord(n.id).status == NodeStatus.masteredTemp).length;
    final progress = mastered / nodes.length;

    Color borderColor = Colors.white12;
    if (mastered == nodes.length) borderColor = AdventureSkin.success;
    else if (inProgress > 0) borderColor = AdventureSkin.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AdventureSkin.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(children: [
        // الحرف
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: borderColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Center(child: Text(letter, style: TextStyle(
            fontSize: 26, fontWeight: FontWeight.w900,
            color: mastered == nodes.length ? AdventureSkin.success : Colors.white,
            fontFamily: AdventureSkin.arabicFont,
          ))),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('$mastered/${nodes.length} مهارات', style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8), fontSize: 13,
              fontFamily: AdventureSkin.arabicFont,
            )),
            const Spacer(),
            if (mastered == nodes.length)
              const Text('✅ مكتمل', style: TextStyle(
                color: AdventureSkin.success, fontSize: 12,
                fontFamily: AdventureSkin.arabicFont,
              ))
            else if (inProgress > 0)
              const Text('🎮 جارٍ', style: TextStyle(
                color: AdventureSkin.primary, fontSize: 12,
                fontFamily: AdventureSkin.arabicFont,
              ))
            else
              const Text('🔒 مقفل', style: TextStyle(
                color: Colors.white30, fontSize: 12,
                fontFamily: AdventureSkin.arabicFont,
              )),
          ]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation(
                mastered == nodes.length ? AdventureSkin.success : AdventureSkin.primary,
              ),
              minHeight: 6,
            ),
          ),
        ])),
      ]),
    );
  }
}

class _StatRow extends StatelessWidget {
  final MasteryService mastery;
  const _StatRow({required this.mastery});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _StatCard(label: 'مُتقَن', value: '${mastery.totalMastered}', emoji: '🏆', color: AdventureSkin.success),
      const SizedBox(width: 10),
      _StatCard(label: 'إجمالي', value: '${mastery.totalNodes}', emoji: '📚', color: AdventureSkin.accent),
      const SizedBox(width: 10),
      _StatCard(label: 'تقدم', value: '${(mastery.progressPercent * 100).toStringAsFixed(0)}%', emoji: '📈', color: AdventureSkin.primary),
    ]);
  }
}

class _StatCard extends StatelessWidget {
  final String label, value, emoji;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.emoji, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900)),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.5),
          fontSize: 11, fontFamily: AdventureSkin.arabicFont)),
      ]),
    ));
  }
}
