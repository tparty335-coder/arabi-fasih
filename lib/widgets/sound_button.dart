// ====================================================
// widgets/sound_button.dart
// زر النطق — يظهر في كل شاشة نشاط
// ====================================================

import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import '../theme/adventure_skin.dart';

class SoundButton extends StatefulWidget {
  final String textToSpeak;
  final double size;
  final bool autoPlay;

  const SoundButton({
    super.key,
    required this.textToSpeak,
    this.size = 56,
    this.autoPlay = false,
  });

  @override
  State<SoundButton> createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  final _tts = TtsService();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _speak() async {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);
    _pulseController.repeat(reverse: true);
    await _tts.speak(widget.textToSpeak);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _isPlaying = false);
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnim,
      child: GestureDetector(
        onTap: _speak,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _isPlaying
                ? AdventureSkin.primary.withValues(alpha: 0.3)
                : AdventureSkin.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: _isPlaying
                  ? AdventureSkin.primary
                  : AdventureSkin.primary.withValues(alpha: 0.4),
              width: _isPlaying ? 2.5 : 1.5,
            ),
          ),
          child: Icon(
            _isPlaying ? Icons.volume_up_rounded : Icons.play_circle_outline_rounded,
            color: AdventureSkin.primary,
            size: widget.size * 0.48,
          ),
        ),
      ),
    );
  }
}
