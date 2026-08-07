// ====================================================
// screens/activity/meem_song_screen.dart
// شاشة أنشودة حرف الميم — تشغيل son1 + son2 بصوت بشري أصلي
// ====================================================

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../theme/adventure_skin.dart';
import '../../widgets/falcon_mascot.dart';

class MeemSongScreen extends StatefulWidget {
  const MeemSongScreen({super.key});

  @override
  State<MeemSongScreen> createState() => _MeemSongScreenState();
}

class _MeemSongScreenState extends State<MeemSongScreen>
    with TickerProviderStateMixin {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  int _currentSong = 0;
  late AnimationController _pulseCtrl;
  late AnimationController _noteCtrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _noteAnim;

  static const _songs = [
    ('audio/letters/meem/stosong/2_son1.mp3', 'أنشودة الميم — الجزء الأول 🎵'),
    ('audio/letters/meem/stosong/1_son2.mp3', 'أنشودة الميم — الجزء الثاني 🎶'),
  ];

  static const _lyrics = [
    'مَـ مَـ مِـ مِـ مُـ مُـ\nحرف الميم يا ولدي\nفي الماء وفي المدرسة\nميم في كل كلمة حلوة',
    'مَن يتعلم يا صغيري\nحرف الميم النظيف\nمَلِك وماء ومنزل\nكلها بالميم تبدأ',
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _noteCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
    _pulseAnim =
        Tween<double>(begin: 0.95, end: 1.05).animate(_pulseCtrl);
    _noteAnim =
        Tween<double>(begin: 0.0, end: 1.0).animate(_noteCtrl);

    _player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _pulseCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _playSong(int idx) async {
    setState(() { _currentSong = idx; _isPlaying = true; });
    await _player.stop();
    await _player.play(AssetSource(_songs[idx].$1));
  }

  Future<void> _togglePause() async {
    if (_isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      await _player.resume();
      setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      const Text('أناشيد حرف الميم 🎵',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: AdventureSkin.arabicFont)),
                      const Spacer(),
                    ],
                  ),
                ),

                // Falcon + note animations
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _isPlaying ? _pulseAnim : const AlwaysStoppedAnimation(1.0),
                        child: const FalconMascot(mood: FalconMood.celebrating),
                      ),
                      const SizedBox(height: 8),
                      if (_isPlaying)
                        AnimatedBuilder(
                          animation: _noteAnim,
                          builder: (_, __) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: ['🎵', '🎶', '🎵'].asMap().entries.map((e) {
                                final offset = ((_noteAnim.value + e.key * 0.3) % 1.0);
                                return Transform.translate(
                                  offset: Offset(0, -10 * offset),
                                  child: Opacity(
                                    opacity: (1 - offset).clamp(0.0, 1.0),
                                    child: Text(e.value,
                                        style: const TextStyle(fontSize: 28)),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),

                      const SizedBox(height: 24),

                      // Lyrics card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AdventureSkin.cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AdventureSkin.accent.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          children: [
                            Text(_songs[_currentSong].$2,
                                style: const TextStyle(
                                    color: AdventureSkin.accent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AdventureSkin.arabicFont)),
                            const SizedBox(height: 12),
                            Text(_lyrics[_currentSong],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 18,
                                    height: 1.8,
                                    fontFamily: AdventureSkin.arabicFont)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SongBtn(
                            label: 'الأنشودة الأولى',
                            icon: Icons.music_note_rounded,
                            active: _currentSong == 0,
                            onTap: () => _playSong(0),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: _isPlaying
                                ? _togglePause
                                : () => _playSong(_currentSong),
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: AdventureSkin.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: AdventureSkin.primary.withValues(alpha: 0.4),
                                      blurRadius: 20)
                                ],
                              ),
                              child: Icon(
                                _isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          _SongBtn(
                            label: 'الأنشودة الثانية',
                            icon: Icons.queue_music_rounded,
                            active: _currentSong == 1,
                            onTap: () => _playSong(1),
                          ),
                        ],
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

class _SongBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  const _SongBtn(
      {required this.label,
      required this.icon,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: active
              ? AdventureSkin.accent.withValues(alpha: 0.2)
              : Colors.white10,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: active ? AdventureSkin.accent : Colors.white24),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: active ? AdventureSkin.accent : Colors.white54,
                size: 24),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: active ? AdventureSkin.accent : Colors.white54,
                    fontSize: 12,
                    fontFamily: AdventureSkin.arabicFont)),
          ],
        ),
      ),
    );
  }
}
