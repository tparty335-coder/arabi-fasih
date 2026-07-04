// screens/activity/level2_multisyllable_screen.dart
// شاشة قراءة الكلمات المتعددة المقاطع (Level 2)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/level2_content.dart';
import '../../models/skill_node.dart';
import '../../services/mastery_service.dart';
import '../../services/tts_service.dart';
import '../../theme/adventure_skin.dart';
import 'session_complete_screen.dart';

class Level2MultiSyllableScreen extends StatefulWidget {
  final SkillNode node;
  const Level2MultiSyllableScreen({super.key, required this.node});

  @override
  State<Level2MultiSyllableScreen> createState() =>
      _Level2MultiSyllableScreenState();
}

class _Level2MultiSyllableScreenState extends State<Level2MultiSyllableScreen> {
  late List<MultiSyllableWord> _words;
  int _step = 0, _correct = 0, _syllableIndex = 0;
  bool _showFull = false, _tapped = false;
  String _feedback = '';
  bool? _lastResult;

  @override
  void initState() {
    super.initState();
    _words = List.from(Level2DB.multiSyllableWords)..shuffle();
    if (_words.length > 5) _words = _words.sublist(0, 5);
    _speakStep();
  }

  MultiSyllableWord get _cur => _words[_step];

  Future<void> _speakStep() async {
    for (int i = 0; i <= _syllableIndex && i < _cur.syllables.length; i++) {
      await TtsService().speak(_cur.syllables[i]);
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> _nextSyllable() async {
    if (_syllableIndex < _cur.syllables.length - 1) {
      setState(() => _syllableIndex++);
      await _speakStep();
    } else {
      await TtsService().speak(_cur.word);
      setState(() => _showFull = true);
    }
  }

  Future<void> _onAnswer(bool correct) async {
    if (_tapped) return;
    _tapped = true;

    await context.read<MasteryService>().recordAttempt(
        widget.node.id, correct,
        DateTime.now().millisecondsSinceEpoch % 5000);

    setState(() {
      _lastResult = correct;
      _feedback = correct
          ? AdventureSkin.getSuccessMessage()
          : AdventureSkin.getWrongMessage();
      if (correct) _correct++;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    if (_step + 1 >= _words.length) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => SessionCompleteScreen(
          skillId: widget.node.id,
          correctCount: _correct,
          totalSteps: _words.length,
          xpEarned: _correct * 25,
        ),
      ));
    } else {
      setState(() {
        _step++;
        _syllableIndex = 0;
        _showFull = false;
        _tapped = false;
        _lastResult = null;
        _feedback = '';
      });
      _speakStep();
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
            child: Column(children: [
              _buildHeader(),
              Expanded(child: _buildBody()),
              if (!_tapped) _buildControls(),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.all(20),
    child: Row(children: [
      GestureDetector(onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.close, color: Colors.white54)),
      const SizedBox(width: 12),
      const Expanded(child: Text('تقطيع الكلمات 📖',
          style: TextStyle(color: Colors.white, fontSize: 18,
              fontWeight: FontWeight.w800, fontFamily: AdventureSkin.arabicFont))),
      Text('${_step + 1}/${_words.length}', style: AdventureSkin.xpStyle),
    ]),
  );

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(_cur.emoji, style: const TextStyle(fontSize: 72)),
        const SizedBox(height: 28),

        // عرض المقاطع تدريجياً
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AdventureSkin.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AdventureSkin.secondary.withValues(alpha: 0.3)),
          ),
          child: Column(children: [
            if (!_showFull) ...[
              // مقاطع ظاهرة + مخفية
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: List.generate(_cur.syllables.length, (i) {
                  final visible = i <= _syllableIndex;
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: visible ? 1.0 : 0.2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: visible
                            ? AdventureSkin.primary.withValues(alpha: 0.2)
                            : Colors.white12,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: visible ? AdventureSkin.primary : Colors.white24,
                        ),
                      ),
                      child: Text(_cur.syllables[i],
                        style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w900,
                          fontFamily: AdventureSkin.arabicFont,
                          color: visible ? Colors.white : Colors.white38,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              if (!_showFull)
                GestureDetector(
                  onTap: _nextSyllable,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      color: AdventureSkin.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _syllableIndex < _cur.syllables.length - 1
                          ? 'المقطع التالي ▶️'
                          : 'اقرأ الكلمة كاملة 🔊',
                      style: const TextStyle(color: AdventureSkin.accent,
                          fontFamily: AdventureSkin.arabicFont,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
            ] else ...[
              Text(_cur.word,
                  style: const TextStyle(fontSize: 52, color: Colors.white,
                      fontWeight: FontWeight.w900, fontFamily: AdventureSkin.arabicFont)),
            ],
          ]),
        ),

        if (_feedback.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(_feedback, style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w900,
            fontFamily: AdventureSkin.arabicFont,
            color: _lastResult == true ? AdventureSkin.success : AdventureSkin.error,
          )),
        ],
      ]),
    );
  }

  Widget _buildControls() {
    if (!_showFull) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(children: [
        Expanded(child: ElevatedButton(
          onPressed: () => _onAnswer(false),
          style: ElevatedButton.styleFrom(
            backgroundColor: AdventureSkin.error.withValues(alpha: 0.15),
            foregroundColor: AdventureSkin.error,
            side: const BorderSide(color: AdventureSkin.error),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('صعبة 🤔', style: TextStyle(
              fontFamily: AdventureSkin.arabicFont, fontWeight: FontWeight.w700)),
        )),
        const SizedBox(width: 12),
        Expanded(child: ElevatedButton(
          onPressed: () => _onAnswer(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AdventureSkin.success.withValues(alpha: 0.15),
            foregroundColor: AdventureSkin.success,
            side: const BorderSide(color: AdventureSkin.success),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('قرأت ✅', style: TextStyle(
              fontFamily: AdventureSkin.arabicFont, fontWeight: FontWeight.w700)),
        )),
      ]),
    );
  }
}
