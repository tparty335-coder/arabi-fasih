// ====================================================
// screens/activity/meem_words_screen.dart
// شاشة كلمات حرف الميم — بصوت بشري أصلي من الأسطوانة
// ====================================================

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../theme/adventure_skin.dart';

class MeemWordsScreen extends StatefulWidget {
  const MeemWordsScreen({super.key});

  @override
  State<MeemWordsScreen> createState() => _MeemWordsScreenState();
}

class _MeemWordsScreenState extends State<MeemWordsScreen> {
  final _player = AudioPlayer();
  int? _playingIdx;
  int _activeTab = 0;

  // Words extracted from the CD audio naming conventions
  static const _wordGroups = [
    _WordGroup(
      title: 'كلمات - المجموعة الأولى',
      words: [
        _MeemWord('لَبَن', '🥛', 'audio/letters/meem/words1/3_leba.mp3'),
        _MeemWord('مَوز', '🍌', 'audio/letters/meem/words1/4_ka22.mp3'),
        _MeemWord('مَدرسة', '🏫', 'audio/letters/meem/words1/5_hawel.mp3'),
        _MeemWord('مَاء', '💧', 'audio/letters/meem/words2/3_ka7.mp3'),
        _MeemWord('مُعلّم', '👨‍🏫', 'audio/letters/meem/words3/3_ka2.mp3'),
        _MeemWord('مَنزل', '🏠', 'audio/letters/meem/words4/3_ka20.mp3'),
      ],
    ),
    _WordGroup(
      title: 'كلمات - المجموعة الثانية',
      words: [
        _MeemWord('مِصباح', '💡', 'audio/letters/meem/words2/5_a214.mp3'),
        _MeemWord('مِقص', '✂️', 'audio/letters/meem/words2/6_081.mp3'),
        _MeemWord('مُوز', '🍌', 'audio/letters/meem/words3/5_fish1.mp3'),
        _MeemWord('مِلعقة', '🥄', 'audio/letters/meem/words3/6_a214.mp3'),
        _MeemWord('مُربّع', '🟦', 'audio/letters/meem/words4/5_a214.mp3'),
        _MeemWord('مَاعز', '🐐', 'audio/letters/meem/words1/6_a221.mp3'),
      ],
    ),
    _WordGroup(
      title: 'أشكال حرف الميم',
      words: [
        _MeemWord('مَـ (أول)', '📍', 'audio/letters/meem/mov1/7_me1.mp3'),
        _MeemWord('ـمَـ (وسط)', '📍', 'audio/letters/meem/mov1/6_me2.mp3'),
        _MeemWord('ـم (آخر)', '📍', 'audio/letters/meem/mov1/5_me3.mp3'),
        _MeemWord('مَ (فتحة)', '📍', 'audio/letters/mim_fatha.mp3'),
        _MeemWord('مِ (كسرة)', '📍', 'audio/letters/mim_kasra.mp3'),
        _MeemWord('مُ (ضمة)', '📍', 'audio/letters/mim_damma.mp3'),
      ],
    ),
  ];

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _play(int idx, String path) async {
    setState(() => _playingIdx = idx);
    await _player.stop();
    try {
      await _player.play(AssetSource(path));
      _player.onPlayerComplete.listen((_) {
        if (mounted) setState(() => _playingIdx = null);
      });
    } catch (_) {
      if (mounted) setState(() => _playingIdx = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = _wordGroups[_activeTab];
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
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      const Text('كلمات حرف الميم 🔤',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: AdventureSkin.arabicFont)),
                      const Spacer(),
                    ],
                  ),
                ),

                // Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: _wordGroups.asMap().entries.map((e) {
                      final active = e.key == _activeTab;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTab = e.key),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: active
                                  ? AdventureSkin.primary
                                  : Colors.white10,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              ['١', '٢', '٣'][e.key],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: active
                                      ? Colors.white
                                      : Colors.white54,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 8),
                Text(group.title,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontFamily: AdventureSkin.arabicFont,
                        fontSize: 14)),
                const SizedBox(height: 12),

                // Word grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: group.words.length,
                    itemBuilder: (ctx, i) {
                      final word = group.words[i];
                      final isPlaying = _playingIdx == (_activeTab * 10 + i);
                      return GestureDetector(
                        onTap: () => _play(_activeTab * 10 + i, word.audioPath),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isPlaying
                                ? AdventureSkin.accent.withValues(alpha: 0.25)
                                : AdventureSkin.cardBg,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: isPlaying
                                    ? AdventureSkin.accent
                                    : Colors.white24,
                                width: isPlaying ? 2 : 1),
                            boxShadow: isPlaying
                                ? [
                                    BoxShadow(
                                        color: AdventureSkin.accent
                                            .withValues(alpha: 0.3),
                                        blurRadius: 16)
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(word.emoji,
                                  style: const TextStyle(fontSize: 36)),
                              const SizedBox(height: 8),
                              Text(word.text,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: AdventureSkin.arabicFont)),
                              const SizedBox(height: 4),
                              Icon(
                                isPlaying
                                    ? Icons.volume_up_rounded
                                    : Icons.touch_app_rounded,
                                color: isPlaying
                                    ? AdventureSkin.accent
                                    : Colors.white38,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

class _MeemWord {
  final String text, emoji, audioPath;
  const _MeemWord(this.text, this.emoji, this.audioPath);
}

class _WordGroup {
  final String title;
  final List<_MeemWord> words;
  const _WordGroup({required this.title, required this.words});
}
