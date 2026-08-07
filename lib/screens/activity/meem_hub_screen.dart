// ====================================================
// screens/activity/meem_hub_screen.dart
// بوابة حرف الميم — كل الأنشطة والأصوات في مكان واحد
// ====================================================

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../theme/adventure_skin.dart';
import '../../widgets/falcon_mascot.dart';
import 'meem_games_screen.dart';
import 'meem_song_screen.dart';
import 'meem_story_screen.dart';
import 'meem_words_screen.dart';
import 'meem_writing_screen.dart';

class MeemHubScreen extends StatefulWidget {
  const MeemHubScreen({super.key});

  @override
  State<MeemHubScreen> createState() => _MeemHubScreenState();
}

class _MeemHubScreenState extends State<MeemHubScreen>
    with SingleTickerProviderStateMixin {
  final _player = AudioPlayer();
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  bool _playingLetter = false;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn));
    _fadeCtrl.forward();

    // Auto-play letter name on open
    Future.delayed(const Duration(milliseconds: 500), _playLetterName);
    _player.onPlayerComplete
        .listen((_) => mounted ? setState(() => _playingLetter = false) : null);
  }

  @override
  void dispose() {
    _player.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _playLetterName() async {
    if (_playingLetter) return;
    setState(() => _playingLetter = true);
    await _player.stop();
    try {
      await _player.play(AssetSource('audio/letters/mim_name.mp3'));
    } catch (_) {
      if (mounted) setState(() => _playingLetter = false);
    }
  }

  Future<void> _playFatha() async {
    await _player.stop();
    await _player.play(AssetSource('audio/letters/mim_fatha.mp3'));
  }

  Future<void> _playKasra() async {
    await _player.stop();
    await _player.play(AssetSource('audio/letters/mim_kasra.mp3'));
  }

  Future<void> _playDamma() async {
    await _player.stop();
    await _player.play(AssetSource('audio/letters/mim_damma.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AdventureSkin.backgroundGradient),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          const Text('بوابة حرف الميم',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: AdventureSkin.arabicFont)),
                          const Spacer(),
                        ],
                      ),
                    ),

                    // Letter display + Falcon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _playLetterName,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AdventureSkin.cardBg,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: _playingLetter
                                      ? AdventureSkin.accent
                                      : AdventureSkin.primary.withValues(alpha: 0.5),
                                  width: _playingLetter ? 3 : 2),
                              boxShadow: [
                                BoxShadow(
                                    color: AdventureSkin.accent
                                        .withValues(alpha: _playingLetter ? 0.4 : 0.1),
                                    blurRadius: 24)
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('م',
                                    style: TextStyle(
                                        fontSize: 64,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: AdventureSkin.arabicFont)),
                                Icon(
                                    _playingLetter
                                        ? Icons.volume_up_rounded
                                        : Icons.touch_app_rounded,
                                    color: AdventureSkin.accent,
                                    size: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        const FalconMascot(mood: FalconMood.happy),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Letter name
                    const Text('حرف الميم',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: AdventureSkin.arabicFont)),

                    const SizedBox(height: 20),

                    // Vowel buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _VowelBtn(text: 'مَ', label: 'فتحة', onTap: _playFatha),
                          const SizedBox(width: 12),
                          _VowelBtn(text: 'مِ', label: 'كسرة', onTap: _playKasra),
                          const SizedBox(width: 12),
                          _VowelBtn(text: 'مُ', label: 'ضمة', onTap: _playDamma),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 20),

                    // Activity cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _ActivityCard(
                            icon: '📚',
                            title: 'قصة الميم',
                            subtitle: '6 أجزاء — بصوت بشري أصلي',
                            color: const Color(0xFF3D6B8E),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MeemStoryScreen())),
                          ),
                          const SizedBox(height: 14),
                          _ActivityCard(
                            icon: '🎵',
                            title: 'أناشيد الميم',
                            subtitle: 'أنشودتان — بصوت بشري أصلي',
                            color: const Color(0xFF6B3D8E),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MeemSongScreen())),
                          ),
                          const SizedBox(height: 14),
                          _ActivityCard(
                            icon: '🔤',
                            title: 'كلمات الميم',
                            subtitle: 'أكثر من 30 كلمة — بصوت أصلي',
                            color: const Color(0xFF3D8E6B),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MeemWordsScreen())),
                          ),
                          const SizedBox(height: 14),
                          _ActivityCard(
                            icon: '✏️',
                            title: 'تعلّم الكتابة',
                            subtitle: 'خطوة بخطوة مع صوت أصلي',
                            color: const Color(0xFF8E7B3D),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MeemWritingScreen())),
                          ),
                          const SizedBox(height: 14),
                          _ActivityCard(
                            icon: '🎮',
                            title: 'ألعاب الميم التفاعلية',
                            subtitle: '4 ألعاب ممتعة — بصوت بشري أصلي',
                            color: const Color(0xFF8E2E6B),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MeemGamesScreen())),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VowelBtn extends StatelessWidget {
  final String text, label;
  final VoidCallback onTap;
  const _VowelBtn({required this.text, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AdventureSkin.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AdventureSkin.primary.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Text(text,
                style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontFamily: AdventureSkin.arabicFont,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.volume_up_rounded,
                    color: AdventureSkin.primary, size: 14),
                const SizedBox(width: 4),
                Text(label,
                    style: const TextStyle(
                        color: AdventureSkin.primary,
                        fontSize: 12,
                        fontFamily: AdventureSkin.arabicFont)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String icon, title, subtitle;
  final Color color;
  final VoidCallback onTap;
  const _ActivityCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
                color: color.withValues(alpha: 0.15), blurRadius: 12)
          ],
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: AdventureSkin.arabicFont)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 13,
                          fontFamily: AdventureSkin.arabicFont)),
                ],
              ),
            ),
            Icon(Icons.arrow_back_ios_rounded,
                color: Colors.white.withValues(alpha: 0.4), size: 16),
          ],
        ),
      ),
    );
  }
}
