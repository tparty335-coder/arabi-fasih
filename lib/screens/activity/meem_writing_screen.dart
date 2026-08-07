// ====================================================
// screens/activity/meem_writing_screen.dart
// شاشة تعليم كتابة حرف الميم — بصوت بشري أصلي خطوة بخطوة
// ====================================================

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../theme/adventure_skin.dart';
import '../../widgets/falcon_mascot.dart';

class MeemWritingScreen extends StatefulWidget {
  const MeemWritingScreen({super.key});

  @override
  State<MeemWritingScreen> createState() => _MeemWritingScreenState();
}

class _MeemWritingScreenState extends State<MeemWritingScreen>
    with TickerProviderStateMixin {
  final _player = AudioPlayer();
  int _step = 0;
  bool _isPlaying = false;
  late AnimationController _arrowCtrl;
  late Animation<double> _arrowAnim;

  // Writing steps mapped to extracted audio (mov1 folder)
  static const _steps = [
    _WriteStep(
      audio: 'audio/letters/meem/mov1/7_me1.mp3',
      title: 'الخطوة الأولى',
      instruction: 'ابدأ من النقطة العليا\nاكتب نصف دائرة صغيرة',
      shape: 'م',
      hint: 'كالدائرة الصغيرة — م',
    ),
    _WriteStep(
      audio: 'audio/letters/meem/mov1/6_me2.mp3',
      title: 'الخطوة الثانية',
      instruction: 'أكمل الدائرة الصغيرة\nثم انزل بذيل للأسفل',
      shape: 'مـ',
      hint: 'في بداية الكلمة — مـ',
    ),
    _WriteStep(
      audio: 'audio/letters/meem/mov1/5_me3.mp3',
      title: 'الخطوة الثالثة',
      instruction: 'في وسط الكلمة\nالشكل يتصل من الطرفين',
      shape: 'ـمـ',
      hint: 'في وسط الكلمة — ـمـ',
    ),
    _WriteStep(
      audio: 'audio/letters/meem/mov1/4_me4a.mp3',
      title: 'الشكل الكامل',
      instruction: 'في نهاية الكلمة\nيتصل من اليمين فقط',
      shape: 'ـم',
      hint: 'في نهاية الكلمة — ـم',
    ),
    _WriteStep(
      audio: 'audio/letters/meem/write/1_wf2.mp3',
      title: 'تدريب الكتابة',
      instruction: 'تابع التوجيهات الصوتية\nواكتب الحرف بنفسك',
      shape: 'م',
      hint: 'الآن جرّب بنفسك! ✏️',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _arrowCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _arrowAnim = Tween<double>(begin: 0, end: 8).animate(
        CurvedAnimation(parent: _arrowCtrl, curve: Curves.easeInOut));
    _player.onPlayerComplete
        .listen((_) => mounted ? setState(() => _isPlaying = false) : null);

    // Auto-play first step
    Future.delayed(const Duration(milliseconds: 400), () => _playStep(0));
  }

  @override
  void dispose() {
    _player.dispose();
    _arrowCtrl.dispose();
    super.dispose();
  }

  Future<void> _playStep(int idx) async {
    setState(() { _isPlaying = true; });
    await _player.stop();
    try {
      await _player.play(AssetSource(_steps[idx].audio));
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  void _next() {
    if (_step < _steps.length - 1) {
      setState(() => _step++);
      _playStep(_step);
    }
  }

  void _prev() {
    if (_step > 0) {
      setState(() => _step--);
      _playStep(_step);
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _steps[_step];
    final isLast = _step == _steps.length - 1;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AdventureSkin.backgroundGradient),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      const Text('تعلّم كتابة الميم ✏️',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: AdventureSkin.arabicFont)),
                      const Spacer(),
                    ],
                  ),
                ),

                // Step dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _steps.asMap().entries.map((e) {
                    final active = e.key == _step;
                    final done = e.key < _step;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 28 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: done
                            ? AdventureSkin.success
                            : active
                                ? AdventureSkin.accent
                                : Colors.white24,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Step title
                        Text(current.title,
                            style: const TextStyle(
                                color: AdventureSkin.accent,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: AdventureSkin.arabicFont)),

                        const SizedBox(height: 20),

                        // Letter display
                        GestureDetector(
                          onTap: () => _playStep(_step),
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: AdventureSkin.cardBg,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: _isPlaying
                                      ? AdventureSkin.accent
                                      : AdventureSkin.primary.withValues(alpha: 0.4),
                                  width: 3),
                              boxShadow: [
                                BoxShadow(
                                    color: AdventureSkin.accent
                                        .withValues(alpha: _isPlaying ? 0.4 : 0.1),
                                    blurRadius: 30)
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(current.shape,
                                    style: const TextStyle(
                                        fontSize: 80,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: AdventureSkin.arabicFont)),
                                AnimatedBuilder(
                                  animation: _arrowAnim,
                                  builder: (_, __) => Transform.translate(
                                    offset: Offset(0, _isPlaying ? _arrowAnim.value : 0),
                                    child: Icon(
                                      _isPlaying
                                          ? Icons.volume_up_rounded
                                          : Icons.touch_app_rounded,
                                      color: AdventureSkin.accent,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Falcon + instruction
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FalconMascot(mood: FalconMood.encouraging),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AdventureSkin.cardBg,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(current.instruction,
                                        style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.9),
                                            fontSize: 16,
                                            height: 1.6,
                                            fontFamily: AdventureSkin.arabicFont)),
                                    const SizedBox(height: 8),
                                    Text(current.hint,
                                        style: const TextStyle(
                                            color: AdventureSkin.primary,
                                            fontSize: 13,
                                            fontFamily: AdventureSkin.arabicFont)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Nav buttons
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      if (_step > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _prev,
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white24),
                                padding: const EdgeInsets.symmetric(vertical: 14)),
                            child: const Text('السابق',
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontFamily: AdventureSkin.arabicFont)),
                          ),
                        ),
                      if (_step > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: isLast ? () => Navigator.pop(context) : _next,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: isLast
                                  ? AdventureSkin.success
                                  : AdventureSkin.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14))),
                          child: Text(
                            isLast ? 'أحسنتَ! 🌟' : 'التالي',
                            style: const TextStyle(
                                fontFamily: AdventureSkin.arabicFont,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WriteStep {
  final String audio, title, instruction, shape, hint;
  const _WriteStep(
      {required this.audio,
      required this.title,
      required this.instruction,
      required this.shape,
      required this.hint});
}
