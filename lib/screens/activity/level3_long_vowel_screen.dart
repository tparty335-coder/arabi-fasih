// screens/activity/level3_long_vowel_screen.dart
// شاشة الأصوات الطويلة (المدود) — Level 3
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/level3_content.dart';
import '../../models/skill_node.dart';
import '../../services/mastery_service.dart';
import '../../services/tts_service.dart';
import '../../theme/adventure_skin.dart';
import 'session_complete_screen.dart';

class Level3LongVowelScreen extends StatefulWidget {
  final SkillNode node;
  const Level3LongVowelScreen({super.key, required this.node});

  @override
  State<Level3LongVowelScreen> createState() => _Level3LongVowelScreenState();
}

class _Level3LongVowelScreenState extends State<Level3LongVowelScreen>
    with SingleTickerProviderStateMixin {
  late List<LongVowelWord> _words;
  int _step = 0, _correct = 0;
  bool? _lastResult;
  String _feedback = '';
  bool _showFull = false, _tapped = false;
  String _vowelType = 'alif';

  late AnimationController _waveCtrl;
  late Animation<double> _waveAnim;

  @override
  void initState() {
    super.initState();
    _vowelType = _getVowelType();
    _words = List.from(_getWordList())..shuffle();
    if (_words.length > 6) _words = _words.sublist(0, 6);

    _waveCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _waveAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _waveCtrl, curve: Curves.easeInOut));

    _speakWord();
  }

  String _getVowelType() {
    switch (widget.node.type) {
      case NodeType.longVowelYa:  return 'ya';
      case NodeType.longVowelWaw: return 'waw';
      default:                    return 'alif';
    }
  }

  List<LongVowelWord> _getWordList() {
    switch (_vowelType) {
      case 'ya':  return L3DB.yaWords + L3DB.twoSyllableWords.where((w) => w.vowelType == 'ya').toList();
      case 'waw': return L3DB.wawWords + L3DB.twoSyllableWords.where((w) => w.vowelType == 'waw').toList();
      default:    return L3DB.alifWords + L3DB.twoSyllableWords.where((w) => w.vowelType == 'alif').toList();
    }
  }

  LongVowelWord get _cur => _words[_step];

  Color get _vowelColor {
    switch (_vowelType) {
      case 'ya':  return const Color(0xFF7C4DFF);
      case 'waw': return const Color(0xFF00BCD4);
      default:    return AdventureSkin.primary;
    }
  }

  String get _vowelLabel {
    switch (_vowelType) {
      case 'ya':  return 'مد الياء (كسرة + ي)';
      case 'waw': return 'مد الواو (ضمة + و)';
      default:    return 'مد الألف (فتحة + ا)';
    }
  }

  Future<void> _speakWord() async {
    _waveCtrl.repeat(reverse: true);
    if (!_showFull) {
      await TtsService().speak(_cur.part1);
      await Future.delayed(const Duration(milliseconds: 400));
      // مد الصوت
      await TtsService().speak(_cur.part1 + _cur.vowelChar + _cur.vowelChar);
    } else {
      await TtsService().speak(_cur.word);
    }
    _waveCtrl.stop();
    _waveCtrl.reset();
  }

  Future<void> _revealWord() async {
    setState(() => _showFull = true);
    await TtsService().speak(_cur.word);
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
          xpEarned: _correct * 20,
        ),
      ));
    } else {
      setState(() {
        _step++;
        _lastResult = null;
        _showFull = false;
        _tapped = false;
        _feedback = '';
      });
      _speakWord();
    }
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    super.dispose();
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
              _buildControls(),
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
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_vowelLabel, style: TextStyle(color: _vowelColor,
            fontSize: 16, fontWeight: FontWeight.w800,
            fontFamily: AdventureSkin.arabicFont)),
        Text('المستوى الثالث', style: const TextStyle(color: Colors.white38,
            fontSize: 12, fontFamily: AdventureSkin.arabicFont)),
      ])),
      Text('${_step + 1}/${_words.length}', style: AdventureSkin.xpStyle),
    ]),
  );

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        // الإيموجي
        Text(_cur.emoji, style: const TextStyle(fontSize: 72)),
        const SizedBox(height: 28),

        // عرض الكلمة مع المد
        _buildWordDisplay(),
        const SizedBox(height: 20),

        // زر الاستماع
        GestureDetector(
          onTap: _speakWord,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _vowelColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: _vowelColor.withValues(alpha: 0.5)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              AnimatedBuilder(
                animation: _waveAnim,
                builder: (_, __) => Text('🔊',
                    style: TextStyle(fontSize: 18 + _waveAnim.value * 4)),
              ),
              const SizedBox(width: 8),
              Text('استمع للمد', style: TextStyle(color: _vowelColor,
                  fontFamily: AdventureSkin.arabicFont, fontSize: 14,
                  fontWeight: FontWeight.w700)),
            ]),
          ),
        ),

        if (!_showFull) ...[
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _revealWord,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: AdventureSkin.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('أكمل الكلمة 🔍',
                  style: TextStyle(color: AdventureSkin.accent,
                      fontFamily: AdventureSkin.arabicFont,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],

        if (_feedback.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(_feedback, style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.w900, fontFamily: AdventureSkin.arabicFont,
              color: _lastResult == true ? AdventureSkin.success : AdventureSkin.error)),
        ],
      ]),
    );
  }

  Widget _buildWordDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _lastResult == true
            ? AdventureSkin.letterCardCorrect.withValues(alpha: 0.1)
            : _lastResult == false
                ? AdventureSkin.letterCardWrong.withValues(alpha: 0.1)
                : AdventureSkin.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _lastResult == true
              ? AdventureSkin.letterCardCorrect
              : _lastResult == false
                  ? AdventureSkin.letterCardWrong
                  : _vowelColor.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Column(children: [
        if (!_showFull) ...[
          // عرض مع المد مكشوف والنهاية مخفية
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(_cur.part1, style: const TextStyle(fontSize: 44,
                color: Colors.white70, fontWeight: FontWeight.w900,
                fontFamily: AdventureSkin.arabicFont)),
            Text(_cur.vowelChar, style: TextStyle(fontSize: 52,
                color: _vowelColor, fontWeight: FontWeight.w900,
                fontFamily: AdventureSkin.arabicFont)),
            Text('_ _', style: const TextStyle(fontSize: 40,
                color: Colors.white24, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 8),
          Text('← انطق مع المد ثم أكمل الكلمة',
              style: TextStyle(color: Colors.white38, fontSize: 12,
                  fontFamily: AdventureSkin.arabicFont)),
        ] else ...[
          // الكلمة كاملة
          Text(_cur.word, style: const TextStyle(fontSize: 52,
              color: Colors.white, fontWeight: FontWeight.w900,
              fontFamily: AdventureSkin.arabicFont)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _syllableChip(_cur.part1, Colors.white54),
            const Text(' + ', style: TextStyle(color: Colors.white38, fontSize: 16)),
            _syllableChip(_cur.vowelChar, AdventureSkin.accent),
            const Text(' + ', style: TextStyle(color: Colors.white38, fontSize: 16)),
            _syllableChip(_cur.part2, Colors.white54),
          ]),
        ],
      ]),
    );
  }

  Widget _syllableChip(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Text(text, style: TextStyle(color: color, fontSize: 18,
        fontWeight: FontWeight.w800, fontFamily: AdventureSkin.arabicFont)),
  );

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
          child: const Text('لم أتقنها 🤔', style: TextStyle(
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
          child: const Text('أتقنتها ✅', style: TextStyle(
              fontFamily: AdventureSkin.arabicFont, fontWeight: FontWeight.w700)),
        )),
      ]),
    );
  }
}
