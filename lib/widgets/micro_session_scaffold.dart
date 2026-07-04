// ====================================================
// widgets/micro_session_scaffold.dart
// الهيكل المشترك لكل شاشة نشاط (3 تفاعلات - 40 ثانية)
// ====================================================

import 'package:flutter/material.dart';
import '../theme/adventure_skin.dart';

class MicroSessionScaffold extends StatelessWidget {
  final String skillTitle;       // 'تمييز الصوت'
  final int currentStep;         // 1, 2, 3
  final int totalSteps;          // 3 دائماً
  final int xpEarned;
  final Widget child;
  final VoidCallback? onConfusionPressed;

  const MicroSessionScaffold({
    super.key,
    required this.skillTitle,
    required this.currentStep,
    required this.totalSteps,
    required this.xpEarned,
    required this.child,
    this.onConfusionPressed,
  });

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
            child: Column(
              children: [
                // ===== الشريط العلوي =====
                _buildTopBar(context),
                const SizedBox(height: 8),

                // ===== شريط التقدم =====
                _buildProgressBar(),
                const SizedBox(height: 24),

                // ===== المحتوى الرئيسي =====
                Expanded(child: child),

                // ===== زر "لم أفهم" =====
                _buildConfusionButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // زر الرجوع
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 18),
            ),
          ),

          const SizedBox(width: 12),

          // عنوان المهارة
          Text(
            skillTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: AdventureSkin.arabicFont,
            ),
          ),

          const Spacer(),

          // عداد XP
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AdventureSkin.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AdventureSkin.accent.withOpacity(0.4), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⚡', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '$xpEarned XP',
                  style: AdventureSkin.xpStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$currentStep / $totalSteps',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontFamily: AdventureSkin.arabicFont,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: currentStep / totalSteps,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  AdventureSkin.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfusionButton() {
    return TextButton.icon(
      onPressed: onConfusionPressed,
      icon: const Icon(Icons.help_outline,
          color: Colors.white54, size: 18),
      label: const Text(
        'لم أفهم',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 14,
          fontFamily: AdventureSkin.arabicFont,
        ),
      ),
    );
  }
}
