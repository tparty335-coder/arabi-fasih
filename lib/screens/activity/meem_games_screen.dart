// ====================================================
// screens/activity/meem_games_screen.dart
// شاشة ألعاب حرف الميم — 4 ألعاب تفاعلية بصوت بشري أصلي
// ====================================================

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../theme/adventure_skin.dart';
import '../../widgets/falcon_mascot.dart';

class MeemGamesScreen extends StatefulWidget {
  const MeemGamesScreen({super.key});

  @override
  State<MeemGamesScreen> createState() => _MeemGamesScreenState();
}

class _MeemGamesScreenState extends State<MeemGamesScreen>
    with TickerProviderStateMixin {
  final _player = AudioPlayer();
  int _gameIndex = 0;
  int _score = 0;
  int _questionIndex = 0;
  String? _feedback; // 'correct' | 'wrong' | null
  bool _isProcessing = false;

  late AnimationController _feedbackCtrl;
  late Animation<double> _feedbackScale;
  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;

  // =============================================
  // ألعاب 4: هل تبدأ بالميم؟ + اختر الكلمة + موضع الحرف + الاختبار الكامل
  // =============================================
  static const _games = [
    _Game(
      title: 'هل تبدأ بالميم؟ 🐝',
      icon: '🐝',
      color: Color(0xFF8E6B2E),
      questions: [
        _Question(
          prompt: 'مَاء 💧',
          emoji: '💧',
          options: ['نعم ✅', 'لا ❌'],
          correct: 'نعم ✅',
          audio: 'audio/letters/meem/words1/4_ka22.mp3',
          feedbackAudio: 'audio/letters/meem/fish1/3_sah.mp3',
        ),
        _Question(
          prompt: 'شَمس ☀️',
          emoji: '☀️',
          options: ['نعم ✅', 'لا ❌'],
          correct: 'لا ❌',
          audio: 'audio/letters/meem/words1/5_hawel.mp3',
          feedbackAudio: 'audio/letters/meem/fish1/3_sah.mp3',
        ),
        _Question(
          prompt: 'مَنزل 🏠',
          emoji: '🏠',
          options: ['نعم ✅', 'لا ❌'],
          correct: 'نعم ✅',
          audio: 'audio/letters/meem/words4/3_ka20.mp3',
          feedbackAudio: 'audio/letters/meem/fish1/3_sah.mp3',
        ),
        _Question(
          prompt: 'قَلَم ✏️',
          emoji: '✏️',
          options: ['نعم ✅', 'لا ❌'],
          correct: 'لا ❌',
          audio: 'audio/letters/meem/words1/5_hawel.mp3',
          feedbackAudio: 'audio/letters/meem/fish1/3_sah.mp3',
        ),
        _Question(
          prompt: 'مِصباح 💡',
          emoji: '💡',
          options: ['نعم ✅', 'لا ❌'],
          correct: 'نعم ✅',
          audio: 'audio/letters/meem/words2/5_a214.mp3',
          feedbackAudio: 'audio/letters/meem/fish1/3_sah.mp3',
        ),
      ],
    ),
    _Game(
      title: 'اختر كلمة الميم 🐟',
      icon: '🐟',
      color: Color(0xFF2E5F8E),
      questions: [
        _Question(
          prompt: 'أيّ كلمة تبدأ بحرف الميم؟',
          emoji: '🔤',
          options: ['مَاء 💧', 'بَاب 🚪', 'دَار 🏠'],
          correct: 'مَاء 💧',
          audio: 'audio/letters/meem/words1/4_ka22.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
        _Question(
          prompt: 'أيّ كلمة تبدأ بحرف الميم؟',
          emoji: '🔤',
          options: ['نَجم ⭐', 'مَلِك 👑', 'كتاب 📚'],
          correct: 'مَلِك 👑',
          audio: 'audio/letters/meem/words2/3_ka7.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
        _Question(
          prompt: 'أيّ كلمة تبدأ بحرف الميم؟',
          emoji: '🔤',
          options: ['وَرد 🌹', 'سَمك 🐟', 'مَدرسة 🏫'],
          correct: 'مَدرسة 🏫',
          audio: 'audio/letters/meem/words3/3_ka2.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
        _Question(
          prompt: 'أيّ كلمة تبدأ بحرف الميم؟',
          emoji: '🔤',
          options: ['مِقص ✂️', 'قَمر 🌙', 'تُفاح 🍎'],
          correct: 'مِقص ✂️',
          audio: 'audio/letters/meem/words2/6_081.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
        _Question(
          prompt: 'أيّ كلمة تبدأ بحرف الميم؟',
          emoji: '🔤',
          options: ['أسد 🦁', 'دُب 🐻', 'مُعلّم 👨‍🏫'],
          correct: 'مُعلّم 👨‍🏫',
          audio: 'audio/letters/meem/words3/3_ka2.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
      ],
    ),
    _Game(
      title: 'موضع حرف الميم 🔵',
      icon: '🔵',
      color: Color(0xFF2E8E6B),
      questions: [
        _Question(
          prompt: 'أين الميم في "مَاء"؟',
          emoji: 'مَاء',
          options: ['أول الكلمة', 'وسط الكلمة', 'آخر الكلمة'],
          correct: 'أول الكلمة',
          audio: 'audio/letters/meem/mov1/7_me1.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
        _Question(
          prompt: 'أين الميم في "قَمَر"؟',
          emoji: 'قَمَر',
          options: ['أول الكلمة', 'وسط الكلمة', 'آخر الكلمة'],
          correct: 'وسط الكلمة',
          audio: 'audio/letters/meem/mov1/6_me2.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
        _Question(
          prompt: 'أين الميم في "قَلَم"؟',
          emoji: 'قَلَم',
          options: ['أول الكلمة', 'وسط الكلمة', 'آخر الكلمة'],
          correct: 'آخر الكلمة',
          audio: 'audio/letters/meem/mov1/5_me3.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
        _Question(
          prompt: 'أين الميم في "مَدرسة"؟',
          emoji: 'مَدرسة',
          options: ['أول الكلمة', 'وسط الكلمة', 'آخر الكلمة'],
          correct: 'أول الكلمة',
          audio: 'audio/letters/meem/mov1/7_me1.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
        _Question(
          prompt: 'أين الميم في "عَلَم"؟',
          emoji: 'عَلَم',
          options: ['أول الكلمة', 'وسط الكلمة', 'آخر الكلمة'],
          correct: 'آخر الكلمة',
          audio: 'audio/letters/meem/mov1/5_me3.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
      ],
    ),
    _Game(
      title: 'اختبار الميم الكامل 🏆',
      icon: '🏆',
      color: Color(0xFF8E2E6B),
      questions: [
        _Question(
          prompt: 'اختر حرف الميم الصحيح',
          emoji: '🔤',
          options: ['م', 'ن', 'و'],
          correct: 'م',
          audio: 'audio/letters/mim_name.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
        _Question(
          prompt: 'كيف ينطق حرف الميم بالفتحة؟',
          emoji: 'مَـ',
          options: ['مَ', 'بَ', 'نَ'],
          correct: 'مَ',
          audio: 'audio/letters/mim_fatha.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
        _Question(
          prompt: 'أيّ كلمة فيها حرف الميم؟',
          emoji: '🔍',
          options: ['سَمَكة 🐟', 'بَيتة 🏠', 'نَهر 🌊'],
          correct: 'سَمَكة 🐟',
          audio: 'audio/letters/meem/quesall/3_quesall2.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
        _Question(
          prompt: 'ما الشكل الصحيح للميم في بداية الكلمة؟',
          emoji: '✍️',
          options: ['مـ', 'ـم', 'ـمـ'],
          correct: 'مـ',
          audio: 'audio/letters/meem/mov1/7_me1.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
        _Question(
          prompt: 'أيّ كلمة تنتهي بالميم؟',
          emoji: '🔤',
          options: ['مَاء', 'عَلَم ⛳', 'مَدرسة'],
          correct: 'عَلَم ⛳',
          audio: 'audio/letters/meem/mov1/5_me3.mp3',
          feedbackAudio: 'audio/ui/momtaz.mp3',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _feedbackCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _feedbackScale = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _feedbackCtrl, curve: Curves.elasticOut));
    _bounceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: -4, end: 4).animate(
        CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut));

    _playQuestionAudio();
  }

  @override
  void dispose() {
    _player.dispose();
    _feedbackCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  _Game get _currentGame => _games[_gameIndex];
  _Question get _currentQ => _currentGame.questions[_questionIndex];

  Future<void> _playQuestionAudio() async {
    try {
      await _player.stop();
      await _player.play(AssetSource(_currentQ.audio));
    } catch (_) {}
  }

  Future<void> _onAnswer(String choice) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    final isCorrect = choice == _currentQ.correct;
    setState(() => _feedback = isCorrect ? 'correct' : 'wrong');
    _feedbackCtrl.forward(from: 0);

    // Play feedback audio
    try {
      await _player.stop();
      await _player.play(AssetSource(
          isCorrect ? _currentQ.feedbackAudio : 'audio/ui/hawel.mp3'));
    } catch (_) {}

    if (isCorrect) _score++;

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final isLastQ = _questionIndex >= _currentGame.questions.length - 1;
    if (isLastQ) {
      _showGameComplete();
    } else {
      setState(() {
        _questionIndex++;
        _feedback = null;
        _isProcessing = false;
      });
      _playQuestionAudio();
    }
  }

  void _showGameComplete() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => _GameCompleteSheet(
        score: _score,
        total: _currentGame.questions.length,
        hasNextGame: _gameIndex < _games.length - 1,
        onNextGame: () {
          Navigator.pop(context);
          setState(() {
            _gameIndex++;
            _questionIndex = 0;
            _feedback = null;
            _isProcessing = false;
          });
          _playQuestionAudio();
        },
        onReplay: () {
          Navigator.pop(context);
          setState(() {
            _questionIndex = 0;
            _score = 0;
            _feedback = null;
            _isProcessing = false;
          });
          _playQuestionAudio();
        },
        onExit: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = _currentGame;
    final q = _currentQ;
    final progress = (_questionIndex + 1) / game.questions.length;

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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(game.title,
                                style: TextStyle(
                                    color: game.color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: AdventureSkin.arabicFont)),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white12,
                              valueColor: AlwaysStoppedAnimation<Color>(game.color),
                              borderRadius: BorderRadius.circular(4),
                              minHeight: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: game.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('⭐ $_score',
                            style: TextStyle(
                                color: game.color,
                                fontWeight: FontWeight.w900,
                                fontSize: 16)),
                      ),
                    ],
                  ),
                ),

                // Game tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: _games.asMap().entries.map((e) {
                      final active = e.key == _gameIndex;
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 6,
                          decoration: BoxDecoration(
                            color: active
                                ? e.value.color
                                : e.key < _gameIndex
                                    ? AdventureSkin.success
                                    : Colors.white12,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // Question card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Falcon bounce
                        AnimatedBuilder(
                          animation: _bounceAnim,
                          builder: (_, child) => Transform.translate(
                            offset: Offset(0, _bounceAnim.value),
                            child: child,
                          ),
                          child: FalconMascot(
                            mood: _feedback == 'correct'
                                ? FalconMood.celebrating
                                : _feedback == 'wrong'
                                    ? FalconMood.encouraging
                                    : FalconMood.happy,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Question prompt
                        GestureDetector(
                          onTap: _playQuestionAudio,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                              color: game.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: game.color.withValues(alpha: 0.4),
                                  width: 2),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.volume_up_rounded,
                                        color: Colors.white54, size: 18),
                                    const SizedBox(width: 8),
                                    Text(q.prompt,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: AdventureSkin.arabicFont)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(q.emoji,
                                    style: const TextStyle(
                                        fontSize: 44,
                                        fontFamily: AdventureSkin.arabicFont)),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Choices
                        ...q.options.map((opt) {
                          Color btnColor = AdventureSkin.cardBg;
                          Color borderColor = Colors.white24;
                          if (_feedback != null) {
                            if (opt == q.correct) {
                              btnColor =
                                  AdventureSkin.success.withValues(alpha: 0.25);
                              borderColor = AdventureSkin.success;
                            } else if (opt == _feedback) {
                              btnColor = Colors.red.withValues(alpha: 0.2);
                              borderColor = Colors.red;
                            }
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: _feedback == null
                                  ? () => _onAnswer(opt)
                                  : null,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: btnColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: borderColor, width: 2),
                                ),
                                child: Text(opt,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AdventureSkin.arabicFont)),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                // Feedback banner
                if (_feedback != null)
                  ScaleTransition(
                    scale: _feedbackScale,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _feedback == 'correct'
                            ? AdventureSkin.success
                            : Colors.red.shade700,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _feedback == 'correct'
                                ? '✅ ممتاز! إجابة صحيحة'
                                : '❌ حاول مرة أخرى',
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
    );
  }
}

// =============================================
class _GameCompleteSheet extends StatelessWidget {
  final int score, total;
  final bool hasNextGame;
  final VoidCallback onNextGame, onReplay, onExit;
  const _GameCompleteSheet(
      {required this.score,
      required this.total,
      required this.hasNextGame,
      required this.onNextGame,
      required this.onReplay,
      required this.onExit});

  @override
  Widget build(BuildContext context) {
    final pct = score / total;
    final isExcellent = pct >= 0.8;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AdventureSkin.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: isExcellent
                ? AdventureSkin.success
                : AdventureSkin.accent,
            width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isExcellent ? '🏆' : '💪',
              style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text(
            isExcellent ? 'ممتاز! أتقنت اللعبة!' : 'جهد جميل! حاول مرة أخرى',
            style: TextStyle(
                color: isExcellent ? AdventureSkin.success : AdventureSkin.accent,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                fontFamily: AdventureSkin.arabicFont),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text('$score / $total إجابة صحيحة',
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: AdventureSkin.arabicFont)),
          const SizedBox(height: 24),
          if (hasNextGame)
            ElevatedButton.icon(
              onPressed: onNextGame,
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 16),
              label: const Text('اللعبة التالية 🎮',
                  style: TextStyle(
                      fontFamily: AdventureSkin.arabicFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AdventureSkin.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
            ),
          if (hasNextGame) const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReplay,
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('إعادة',
                      style: TextStyle(
                          color: Colors.white70,
                          fontFamily: AdventureSkin.arabicFont)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onExit,
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('خروج',
                      style: TextStyle(
                          color: Colors.white70,
                          fontFamily: AdventureSkin.arabicFont)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================
class _Game {
  final String title, icon;
  final Color color;
  final List<_Question> questions;
  const _Game(
      {required this.title,
      required this.icon,
      required this.color,
      required this.questions});
}

class _Question {
  final String prompt, emoji;
  final List<String> options;
  final String correct, audio, feedbackAudio;
  const _Question(
      {required this.prompt,
      required this.emoji,
      required this.options,
      required this.correct,
      required this.audio,
      required this.feedbackAudio});
}
