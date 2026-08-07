// ====================================================
// widgets/reward_animation.dart
// أنيميشن احتفالي بالجسيمات (Confetti Particles)
// ====================================================

import 'dart:math';
import 'package:flutter/material.dart';

class RewardAnimation extends StatefulWidget {
  final Widget child;
  final bool trigger;

  const RewardAnimation({
    super.key,
    required this.child,
    this.trigger = true,
  });

  @override
  State<RewardAnimation> createState() => _RewardAnimationState();
}

class _RewardAnimationState extends State<RewardAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _generateParticles();

    if (widget.trigger) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(RewardAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _generateParticles();
      _controller.forward(from: 0);
    }
  }

  void _generateParticles() {
    _particles.clear();
    final colors = [
      const Color(0xFFFFD700), // ذهبي
      const Color(0xFFFF5252), // أحمر
      const Color(0xFF448AFF), // أزرق
      const Color(0xFF69F0AE), // أخضر
      const Color(0xFFE040FB), // بنفسجي
      const Color(0xFFFFAB40), // برتقالي
    ];

    for (int i = 0; i < 35; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: -0.1 - _random.nextDouble() * 0.3,
        size: 6 + _random.nextDouble() * 8,
        color: colors[_random.nextInt(colors.length)],
        speedY: 0.8 + _random.nextDouble() * 1.2,
        speedX: (_random.nextDouble() - 0.5) * 0.6,
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 4,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            widget.child,
            if (_controller.isAnimating || _controller.isCompleted)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _ConfettiPainter(
                      particles: _particles,
                      progress: _controller.value,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  final double size;
  final Color color;
  final double speedY;
  final double speedX;
  double rotation;
  final double rotationSpeed;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speedY,
    required this.speedX,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final fadeOut = (1.0 - progress).clamp(0.0, 1.0);

    for (final p in particles) {
      final px = (p.x + p.speedX * progress) * size.width;
      final py = (p.y + p.speedY * progress) * size.height;
      final rot = p.rotation + p.rotationSpeed * progress;

      final paint = Paint()
        ..color = p.color.withValues(alpha: fadeOut)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(rot);

      // رسم شكل الجسيم (مربع أو مستطيل محول)
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.7),
        const Radius.circular(2),
      );
      canvas.drawRRect(rect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}
