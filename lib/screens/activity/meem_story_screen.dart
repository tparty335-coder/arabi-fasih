// ====================================================
// screens/activity/meem_story_screen.dart
// شاشة قصة حرف الميم — تشغيل sto1-sto6 بصوت بشري أصلي
// ====================================================

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../theme/adventure_skin.dart';
import '../../widgets/falcon_mascot.dart';

class MeemStoryScreen extends StatefulWidget {
  const MeemStoryScreen({super.key});

  @override
  State<MeemStoryScreen> createState() => _MeemStoryScreenState();
}

class _MeemStoryScreenState extends State<MeemStoryScreen>
    with SingleTickerProviderStateMixin {
  final _player = AudioPlayer();
  int _currentPart = 0;
  bool _isPlaying = false;
  bool _isLoading = false;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  static const _storyParts = [
    _StoryPart(
      audioPath: 'audio/letters/meem/sto1/1_st1.mp3',
      title: 'الجزء الأول 📖',
      text: 'في يوم جميل، قرّر الميم أن يتجوّل في المدينة...\nرأى ماءً رائقاً ومنزلاً كبيراً ومدرسةً واسعة.',
      emoji: '🏙️',
    ),
    _StoryPart(
      audioPath: 'audio/letters/meem/sto2/1_st2.mp3',
      title: 'الجزء الثاني 🌊',
      text: 'وصل الميم إلى النهر وشرب ماءً عذباً...\nقال: "الماء نعمة يبدأ بحرف الميم!"',
      emoji: '🌊',
    ),
    _StoryPart(
      audioPath: 'audio/letters/meem/sto3/1_st3.mp3',
      title: 'الجزء الثالث 🏠',
      text: 'عاد الميم إلى منزله السعيد...\nوجد الأم تطبخ طعاماً لذيذاً في المطبخ.',
      emoji: '🏠',
    ),
    _StoryPart(
      audioPath: 'audio/letters/meem/sto4/1_st6a.mp3',
      title: 'الجزء الرابع 📚',
      text: 'في المساء، فتح الميم كتابه وقرأ...\nكلمات كثيرة تبدأ بالميم: مصباح، مدرسة، معلّم.',
      emoji: '📚',
    ),
    _StoryPart(
      audioPath: 'audio/letters/meem/sto5/1_st7.mp3',
      title: 'الجزء الخامس 🌙',
      text: 'جاء المساء وأضاء المصباح البيت...\nنام الميم سعيداً بكل ما تعلّمه اليوم.',
      emoji: '🌙',
    ),
    _StoryPart(
      audioPath: 'audio/letters/meem/sto6/1_st9.mp3',
      title: 'الخاتمة 🌟',
      text: 'تعلّمنا اليوم حرف الميم العظيم!\nالميم في: ماء، منزل، مدرسة، معلّم، محبة.',
      emoji: '🌟',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(_fadeCtrl);
    _fadeCtrl.forward();

    _player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
      // Auto-advance to next part after 1.5 seconds
      if (_currentPart < _storyParts.length - 1) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) _goToNext();
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _playCurrentPart() async {
    if (_isLoading) return;
    setState(() { _isLoading = true; _isPlaying = false; });
    await _player.stop();
    try {
      await _player.play(AssetSource(_storyParts[_currentPart].audioPath));
      if (mounted) setState(() { _isPlaying = true; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _goToNext() async {
    if (_currentPart >= _storyParts.length - 1) return;
    await _player.stop();
    _fadeCtrl.reset();
    setState(() {
      _currentPart++;
      _isPlaying = false;
    });
    _fadeCtrl.forward();
    await _playCurrentPart();
  }

  Future<void> _goToPrev() async {
    if (_currentPart <= 0) return;
    await _player.stop();
    _fadeCtrl.reset();
    setState(() {
      _currentPart--;
      _isPlaying = false;
    });
    _fadeCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final part = _storyParts[_currentPart];
    final isLast = _currentPart == _storyParts.length - 1;

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
                      const Text('قصة حرف الميم 📖',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: AdventureSkin.arabicFont)),
                      const Spacer(),
                      // Progress indicator
                      Text('${_currentPart + 1}/${_storyParts.length}',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 14,
                              fontFamily: AdventureSkin.arabicFont)),
                    ],
                  ),
                ),

                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: LinearProgressIndicator(
                    value: (_currentPart + 1) / _storyParts.length,
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AdventureSkin.accent),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Emoji + Falcon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(part.emoji,
                                  style: const TextStyle(fontSize: 60)),
                              const SizedBox(width: 16),
                              const FalconMascot(mood: FalconMood.thinking),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Story title
                          Text(part.title,
                              style: const TextStyle(
                                  color: AdventureSkin.accent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AdventureSkin.arabicFont)),

                          const SizedBox(height: 16),

                          // Story text
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AdventureSkin.cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color:
                                      AdventureSkin.primary.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              part.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 18,
                                  height: 1.8,
                                  fontFamily: AdventureSkin.arabicFont),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Play button
                          GestureDetector(
                            onTap: _isLoading ? null : _playCurrentPart,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 14),
                              decoration: BoxDecoration(
                                color: _isPlaying
                                    ? AdventureSkin.accent
                                    : AdventureSkin.primary,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                      color: AdventureSkin.primary
                                          .withValues(alpha: 0.4),
                                      blurRadius: 16)
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isLoading
                                        ? Icons.hourglass_empty_rounded
                                        : _isPlaying
                                            ? Icons.volume_up_rounded
                                            : Icons.play_circle_filled_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _isLoading
                                        ? 'جاري التحميل...'
                                        : _isPlaying
                                            ? 'يُشغَّل الآن...'
                                            : 'استمع للقصة 🔊',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AdventureSkin.arabicFont),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Navigation
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      if (_currentPart > 0)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _goToPrev,
                            icon: const Icon(Icons.arrow_forward_ios_rounded,
                                color: Colors.white54, size: 16),
                            label: const Text('السابق',
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontFamily: AdventureSkin.arabicFont)),
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white24),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14)),
                          ),
                        ),
                      if (_currentPart > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: isLast
                              ? () => Navigator.pop(context)
                              : _goToNext,
                          icon: Icon(
                              isLast
                                  ? Icons.check_circle_rounded
                                  : Icons.arrow_back_ios_rounded,
                              size: 18),
                          label: Text(
                              isLast ? 'انتهت القصة 🌟' : 'التالي',
                              style: const TextStyle(
                                  fontFamily: AdventureSkin.arabicFont,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: isLast
                                  ? AdventureSkin.success
                                  : AdventureSkin.primary,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14))),
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

class _StoryPart {
  final String audioPath, title, text, emoji;
  const _StoryPart(
      {required this.audioPath,
      required this.title,
      required this.text,
      required this.emoji});
}
