// ====================================================
// screens/activity/session_complete_screen.dart
// شاشة انتهاء الجلسة — نتيجة الـ 3 تفاعلات
// ====================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/mastery_service.dart';
import '../../services/tts_service.dart';
import '../../theme/adventure_skin.dart';
import '../../widgets/reward_animation.dart';
import '../../widgets/xp_counter.dart';
import '../../widgets/falcon_mascot.dart';

class SessionCompleteScreen extends StatefulWidget {
  final String skillId;
  final int correctCount;
  final int totalSteps;
  final int xpEarned;

  const SessionCompleteScreen({
    super.key,
    required this.skillId,
    required this.correctCount,
    required this.totalSteps,
    required this.xpEarned,
  });

  @override
  State<SessionCompleteScreen> createState() => _SessionCompleteScreenState();
}

class _SessionCompleteScreenState extends State<SessionCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  bool get _isMastered =>
      widget.correctCount >= 2; // 2/3 = إتقان مؤقت

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
    // 🔊 صوت الاحتفال من الأسطوانة عند انتهاء الجلسة
    Future.delayed(const Duration(milliseconds: 300), () {
      TtsService().playUiSound(_isMastered ? 'complete' : 'wrong');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mastery = context.read<MasteryService>();
    final record = mastery.getRecord(widget.skillId);

    return Scaffold(
      body: RewardAnimation(
        trigger: _isMastered,
        child: Container(
          decoration: const BoxDecoration(
            gradient: AdventureSkin.backgroundGradient,
          ),
          child: SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ===== أيقونة النتيجة والصقر =====
                      ScaleTransition(
                        scale: _scaleAnim,
                        child: FalconMascot(
                          mood: _isMastered
                              ? FalconMood.celebrating
                              : FalconMood.encouraging,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ===== رسالة النتيجة =====
                      Text(
                        _isMastered
                            ? 'أحسنتَ! أتقنتَ هذه المهارة! 🔥'
                            : 'حاول مرة أخرى! 💪',
                        textAlign: TextAlign.center,
                        style: AdventureSkin.feedbackStyle.copyWith(
                          color: _isMastered
                              ? AdventureSkin.success
                              : AdventureSkin.accent,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ===== النتيجة =====
                      _buildScoreCard(),
                      const SizedBox(height: 12),

                      // ===== XP المكتسب =====
                      _buildXPBadge(),
                      const SizedBox(height: 16),

                      // ===== Streak =====
                      _buildStreakAndBadges(mastery),
                      const SizedBox(height: 24),

                      // ===== حالة الإتقان =====
                      if (_isMastered) _buildMasteryStatus(record),
                      const SizedBox(height: 24),

                      // ===== أزرار =====
                      _buildButtons(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: AdventureSkin.cardDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.correctCount}',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: AdventureSkin.success,
              fontFamily: AdventureSkin.arabicFont,
            ),
          ),
          Text(
            ' / ${widget.totalSteps}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.white54,
              fontFamily: AdventureSkin.arabicFont,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXPBadge() {
    return XpCounterAnimation(
      targetXp: widget.xpEarned,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        color: Color(0xFFFFD700),
        fontFamily: AdventureSkin.arabicFont,
      ),
    );
  }

  Widget _buildStreakAndBadges(MasteryService mastery) {
    return Column(
      children: [
        if (mastery.currentStreak > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🔥 ', style: TextStyle(fontSize: 16)),
                Text(
                  'حافَظتَ على نشاطكَ لـ ${mastery.currentStreak} يوم متتالي!',
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    fontFamily: AdventureSkin.arabicFont,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMasteryStatus(dynamic record) {
    if (record.status.name == 'masteredFinal') {
      return const Text('🎯 إتقان نهائي! انتقلت للمهارة التالية',
          style: TextStyle(color: AdventureSkin.success,
              fontFamily: AdventureSkin.arabicFont, fontSize: 14));
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AdventureSkin.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdventureSkin.secondary.withValues(alpha: 0.3)),
      ),
      child: Text(
        '⏰ ستظهر لك مراجعة خلال 24 ساعة لتثبيت المهارة',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontFamily: AdventureSkin.arabicFont,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        // زر المهارة التالية / الاستمرار
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // العودة للشاشة الرئيسية — ستختار next skill تلقائياً
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdventureSkin.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text(
              '🚀 المهارة التالية',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  fontFamily: AdventureSkin.arabicFont),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // زر إعادة المحاولة (إذا لم يُتقن)
        if (!_isMastered)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'أعد المحاولة 🔄',
              style: TextStyle(
                color: Colors.white54,
                fontFamily: AdventureSkin.arabicFont,
                fontSize: 15,
              ),
            ),
          ),
      ],
    );
  }
}
