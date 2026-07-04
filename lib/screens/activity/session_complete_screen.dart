// ====================================================
// screens/activity/session_complete_screen.dart
// شاشة انتهاء الجلسة — نتيجة الـ 3 تفاعلات
// ====================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/mastery_service.dart';
import '../../theme/adventure_skin.dart';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final record = context.read<MasteryService>().getRecord(widget.skillId);

    return Scaffold(
      body: Container(
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
                    // ===== أيقونة النتيجة =====
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: Text(
                        _isMastered ? '🏆' : '🎮',
                        style: const TextStyle(fontSize: 80),
                      ),
                    ),
                    const SizedBox(height: 24),

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
                    const SizedBox(height: 32),

                    // ===== حالة الإتقان =====
                    if (_isMastered) _buildMasteryStatus(record),
                    const SizedBox(height: 32),

                    // ===== أزرار =====
                    _buildButtons(context),
                  ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: AdventureSkin.accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AdventureSkin.accent.withOpacity(0.5)),
      ),
      child: Text(
        '⚡ +${widget.xpEarned} XP',
        style: AdventureSkin.xpStyle.copyWith(fontSize: 18),
      ),
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
        color: AdventureSkin.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdventureSkin.secondary.withOpacity(0.3)),
      ),
      child: Text(
        '⏰ ستظهر لك مراجعة خلال 24 ساعة لتثبيت المهارة',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
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
