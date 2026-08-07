// ====================================================
// widgets/falcon_mascot.dart
// شخصية الصقر الرئاسي (Falcon Mascot Widget)
// ====================================================

import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/adventure_skin.dart';
import '../utils/app_images.dart';

enum FalconMood {
  happy,
  encouraging,
  thinking,
  celebrating,
}

class FalconMascot extends StatefulWidget {
  final FalconMood mood;
  final String? customMessage;

  const FalconMascot({
    super.key,
    this.mood = FalconMood.happy,
    this.customMessage,
  });

  @override
  State<FalconMascot> createState() => _FalconMascotState();
}

class _FalconMascotState extends State<FalconMascot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _message {
    if (widget.customMessage != null) return widget.customMessage!;
    switch (widget.mood) {
      case FalconMood.happy:
        return 'أهلاً بك يا فصيح! 👋';
      case FalconMood.encouraging:
        return 'أنت تستطيع! استمر 💪';
      case FalconMood.thinking:
        return 'فكّر معي جلياً... 🤔';
      case FalconMood.celebrating:
        return 'رائع! أنت بطل حقيقي! 🌟';
    }
  }

  String get _emoji {
    switch (widget.mood) {
      case FalconMood.happy:
        return '🦅';
      case FalconMood.encouraging:
        return '💪🦅';
      case FalconMood.thinking:
        return '🤔🦅';
      case FalconMood.celebrating:
        return '🎉🦅';
    }
  }

  String get _imagePath {
    switch (widget.mood) {
      case FalconMood.happy:
        return AppImages.falconHappy;
      case FalconMood.encouraging:
        return AppImages.falconEncouraging;
      case FalconMood.thinking:
        return AppImages.falconThinking;
      case FalconMood.celebrating:
        return AppImages.falconCelebrating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double offsetY = sin(_controller.value * pi) * 6.0;

        return Transform.translate(
          offset: Offset(0, offsetY),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // فقاعة الكلام (Speech Bubble)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  _message,
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    fontFamily: AdventureSkin.arabicFont,
                  ),
                ),
              ),

              // صقر المغامرة — إما صورة أو Emoji كخيار بديل
              Image.asset(
                _imagePath,
                width: 72,
                height: 72,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    _emoji,
                    style: const TextStyle(fontSize: 54),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
