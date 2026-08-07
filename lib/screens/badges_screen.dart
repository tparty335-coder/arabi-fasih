// ====================================================
// screens/badges_screen.dart
// شاشة الأوسمة والشارات المكتسبة
// ====================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mastery_service.dart';
import '../theme/adventure_skin.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mastery = context.watch<MasteryService>();
    final earned = mastery.earnedBadges;
    final allBadges = MasteryService.badgeDefinitions;

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
                        'لوحة الأوسمة 🏅',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          fontFamily: AdventureSkin.arabicFont,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AdventureSkin.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AdventureSkin.primary.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          '${earned.length} / ${allBadges.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontFamily: AdventureSkin.arabicFont,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ===== Grid of Badges =====
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.95,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: allBadges.length,
                      itemBuilder: (context, index) {
                        final key = allBadges.keys.elementAt(index);
                        final badge = allBadges[key]!;
                        final isEarned = earned.contains(key);

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isEarned
                                ? AdventureSkin.cardBg.withValues(alpha: 0.8)
                                : Colors.black.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isEarned
                                  ? AdventureSkin.accent.withValues(alpha: 0.5)
                                  : Colors.white10,
                              width: isEarned ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isEarned ? (badge['icon'] as String) : '🔒',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: isEarned ? null : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isEarned ? (badge['name'] as String) : 'وسام مقفل',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isEarned ? Colors.white : Colors.white38,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  fontFamily: AdventureSkin.arabicFont,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                badge['desc'] as String,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isEarned
                                      ? Colors.white.withValues(alpha: 0.6)
                                      : Colors.white24,
                                  fontSize: 11,
                                  fontFamily: AdventureSkin.arabicFont,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
}
