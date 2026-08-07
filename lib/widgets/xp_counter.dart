// ====================================================
// widgets/xp_counter.dart
// عدّاد XP متحرك صاعد
// ====================================================

import 'package:flutter/material.dart';
import '../theme/adventure_skin.dart';

class XpCounterAnimation extends StatefulWidget {
  final int targetXp;
  final TextStyle? style;

  const XpCounterAnimation({
    super.key,
    required this.targetXp,
    this.style,
  });

  @override
  State<XpCounterAnimation> createState() => _XpCounterAnimationState();
}

class _XpCounterAnimationState extends State<XpCounterAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _anim = IntTween(begin: 0, end: widget.targetXp).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
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
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Text(
          '⚡ +${_anim.value} XP',
          style: widget.style ??
              const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFFFFD700),
                fontFamily: AdventureSkin.arabicFont,
              ),
        );
      },
    );
  }
}
