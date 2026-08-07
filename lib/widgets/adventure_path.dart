// ====================================================
// widgets/adventure_path.dart
// مسار المغامرة البصري لعرض مهارات الحروف
// ====================================================

import 'package:flutter/material.dart';
import '../models/skill_node.dart';
import '../services/mastery_service.dart';
import '../theme/adventure_skin.dart';
import '../utils/app_images.dart';
import 'path_painter.dart';

class AdventurePath extends StatelessWidget {
  final List<SkillNode> nodes;
  final MasteryService mastery;
  final Function(SkillNode) onTap;

  const AdventurePath({
    super.key,
    required this.nodes,
    required this.mastery,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) return const SizedBox.shrink();

    final double nodeSpacing = 100.0;
    final double totalHeight = nodes.length * nodeSpacing + 100.0;

    final isMasteredList = nodes.map((node) {
      final rec = mastery.getRecord(node.id);
      return rec.status == NodeStatus.masteredFinal ||
          rec.status == NodeStatus.masteredTemp ||
          rec.status == NodeStatus.review1 ||
          rec.status == NodeStatus.review2;
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double centerX = constraints.maxWidth / 2;

        return SingleChildScrollView(
          reverse: true, // يبدأ من الأسفل (الحرف الأول)
          child: SizedBox(
            height: totalHeight,
            width: constraints.maxWidth,
            child: Stack(
              children: [
                // رسم الخط الوصل بين العقد
                CustomPaint(
                  size: Size(constraints.maxWidth, totalHeight),
                  painter: PathPainter(
                    nodeCount: nodes.length,
                    isMasteredList: isMasteredList,
                  ),
                ),

                // رسم العقد
                for (int i = 0; i < nodes.length; i++)
                  _buildNodeWidget(context, i, centerX, totalHeight),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNodeWidget(
      BuildContext context, int index, double centerX, double totalHeight) {
    final node = nodes[index];
    final record = mastery.getRecord(node.id);
    final status = record.status;

    final bool isLeft = index % 2 == 0;
    final double xOffset = isLeft ? -80.0 : 80.0;
    final double nodeX = centerX + xOffset;
    final double nodeY = totalHeight - (index * 100.0 + 50.0);

    final bool isMastered = status == NodeStatus.masteredFinal ||
        status == NodeStatus.masteredTemp ||
        status == NodeStatus.review1 ||
        status == NodeStatus.review2;
    final bool isLearning = status == NodeStatus.learning;
    final bool isLocked = status == NodeStatus.unseen;

    Color nodeColor;
    if (status == NodeStatus.masteredFinal) {
      nodeColor = const Color(0xFF4CAF50); // أخضر للإتقان النهائي
    } else if (isMastered) {
      nodeColor = const Color(0xFF2196F3); // أزرق للإتقان المؤقت/المراجعة
    } else if (isLearning) {
      nodeColor = const Color(0xFFFF9800); // برتقالي للتعلم الحالي
    } else {
      nodeColor = const Color(0xFF424242); // رمادي داكن للمقفل
    }

    final letterText = node.letter.isNotEmpty ? node.letter : '${index + 1}';

    return Positioned(
      left: nodeX - 36.0,
      top: nodeY - 36.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // حرف خلفي شفاف جانبي
          if (!isLeft)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                letterText,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white.withValues(alpha: 0.15),
                  fontFamily: AdventureSkin.arabicFont,
                ),
              ),
            ),

          GestureDetector(
            onTap: () {
              if (!isLocked) {
                onTap(node);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '🔒 هذه المهارة مقفلة، أكمل المهارات السابقة أولاً!',
                      style: TextStyle(fontFamily: AdventureSkin.arabicFont),
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: nodeColor,
                boxShadow: [
                  BoxShadow(
                    color: nodeColor.withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: isLocked ? 0.2 : 0.8),
                  width: 3,
                ),
              ),
              child: Center(
                child: isMastered
                    ? const Text('✅', style: TextStyle(fontSize: 24))
                    : isLocked
                        ? const Text('🔒', style: TextStyle(fontSize: 20))
                        : ClipOval(
                            child: Image.asset(
                              AppImages.letterImage(letterText),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Text(
                                  letterText,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontFamily: AdventureSkin.arabicFont,
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ),
          ),

          if (isLeft)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                letterText,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white.withValues(alpha: 0.15),
                  fontFamily: AdventureSkin.arabicFont,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
