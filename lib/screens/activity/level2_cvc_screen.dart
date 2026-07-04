// screens/activity/level2_cvc_screen.dart
// شاشة قراءة الكلمات ذات الساكن (Level 2)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/level2_content.dart';
import '../../models/skill_node.dart';
import '../../services/mastery_service.dart';
import '../../services/tts_service.dart';
import '../../theme/adventure_skin.dart';
import 'session_complete_screen.dart';

class Level2CvcScreen extends StatefulWidget {
  final SkillNode node;
  const Level2CvcScreen({super.key, required this.node});

  @override
  State<Level2CvcScreen> createState() => _Level2CvcScreenState();
}

class _Level2CvcScreenState extends State<Level2CvcScreen>
    with TickerProviderStateMixin {
  late List<CvcWord> _wordList;
  int _step = 0;
  int _correct = 0;
  bool? _lastResult;
  String _feedback = '';
  bool _showFullWord = false;
  bool _tapped = false;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _wordList = _getWords()..shuffle();
    if (_wordList.length > 5) _wordList = _wordList.sublist(0, 5);

    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _pulseCtrl.repeat(reverse: true);

    _speakCurrent();
  }

  List<CvcWord> _getWords() {
    if (widget.node.type == NodeType.sukunCvcDamma) return Level2DB.dammaWords;
    if (widget.node.type == NodeType.sukunCvcKasra) return Level2DB.kasraWords;
    return Level2DB.fathaWords;
  }

  CvcWord get _current => _wordList[_step];

  Future<void> _speakCurrent() async {
    await TtsService().speak(_current.syllable1);
    await Future.delayed(const Duration(milliseconds: 600));
    await TtsService().speak(_current.syllable2);
    await Future.delayed(const Duration(milliseconds: 400));
    await TtsService().speak(_current.word);
  }

  Future<void> _onAnswer(bool correct) async {
    if (_tapped) return;
    _tapped = true;

    await context.read<MasteryService>().recordAttempt(
        widget.node.id, correct,
        DateTime.now().millisecondsSinceEpoch % 5000);

    setState(() {
      _lastResult = correct;
      _showFullWord = true;
      _feedback = correct
          ? AdventureSkin.getSuccessMessage()
          : AdventureSkin.getWrongMessage();
      if (correct) _correct++;
    });

    await TtsService().speak(_current.word);
    await Future.delayed(const Duration(milliseconds: 1200));

    if (_step + 1 >= _wordList.length) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => SessionCompleteScreen(
          skillId: widget.node.id,
          correctCount: _correct,
          totalSteps: _wordList.length,
          xpEarned: _correct * 20,
        ),
      ));
    } else {
      setState(() {
        _step++;
        _lastResult = null;
        _showFullWord = false;
        _feedback = '';
        _tapped = false;
      });
      _speakCurrent();
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
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
              _buildProgress(),
              Expanded(child: _buildContent()),
              if (!_tapped) _buildButtons(),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.close, color: Colors.white54, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(_nodeTitle(),
            style: const TextStyle(color: Colors.white, fontSize: 18,
                fontWeight: FontWeight.w800, fontFamily: AdventureSkin.arabicFont))),
        Text('${_step + 1}/${_wordList.length}',
            style: AdventureSkin.xpStyle.copyWith(fontSize: 14)),
      ]),
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: (_step + 1) / _wordList.length,
          backgroundColor: Colors.white12,
          valueColor: const AlwaysStoppedAnimation<Color>(AdventureSkin.primary),
          minHeight: 6,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الإيموجي
          Text(_current.emoji, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 24),

          // عرض المقاطع
          _buildSyllableDisplay(),
          const SizedBox(height: 20),

          // زر النطق
          GestureDetector(
            onTap: _speakCurrent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AdventureSkin.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AdventureSkin.secondary.withValues(alpha: 0.5)),
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Text('🔊', style: TextStyle(fontSize: 18)),
                SizedBox(width: 8),
                Text('استمع', style: TextStyle(color: Colors.white70,
                    fontFamily: AdventureSkin.arabicFont, fontSize: 14)),
              ]),
            ),
          ),
          const SizedBox(height: 24),

          // الملاحظة التعليمية
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Text(
              'انطق "${_current.syllable1}" فى نَفَس واحد مع "${_current.syllable2}"',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70,
                  fontFamily: AdventureSkin.arabicFont, fontSize: 13),
            ),
          ),

          if (_feedback.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(_feedback, style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w900,
              fontFamily: AdventureSkin.arabicFont,
              color: _lastResult == true ? AdventureSkin.success : AdventureSkin.error,
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildSyllableDisplay() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, child) => Transform.scale(scale: _pulseAnim.value, child: child),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        decoration: BoxDecoration(
          color: _lastResult == true
              ? AdventureSkin.letterCardCorrect.withValues(alpha: 0.15)
              : _lastResult == false
                  ? AdventureSkin.letterCardWrong.withValues(alpha: 0.15)
                  : AdventureSkin.cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _lastResult == true
                ? AdventureSkin.letterCardCorrect
                : _lastResult == false
                    ? AdventureSkin.letterCardWrong
                    : AdventureSkin.secondary.withValues(alpha: 0.4),
            width: 2,
          ),
        ),
        child: Column(children: [
          if (!_showFullWord) ...[
            // عرض المقطع الأول فقط
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text(_current.syllable1,
                  style: const TextStyle(fontSize: 48, color: AdventureSkin.primary,
                      fontWeight: FontWeight.w900, fontFamily: AdventureSkin.arabicFont)),
              Text(' + ${_current.syllable2}',
                  style: const TextStyle(fontSize: 32, color: Colors.white54,
                      fontFamily: AdventureSkin.arabicFont)),
            ]),
            const SizedBox(height: 8),
            const Text('= ؟', style: TextStyle(fontSize: 24, color: Colors.white38,
                fontFamily: AdventureSkin.arabicFont)),
          ] else ...[
            Text(_current.word,
                style: const TextStyle(fontSize: 52, color: Colors.white,
                    fontWeight: FontWeight.w900, fontFamily: AdventureSkin.arabicFont)),
          ],
        ]),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _onAnswer(false),
            style: ElevatedButton.styleFrom(
              backgroundColor: AdventureSkin.error.withValues(alpha: 0.2),
              foregroundColor: AdventureSkin.error,
              side: const BorderSide(color: AdventureSkin.error),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('لم أفهم 🤔', style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700,
                fontFamily: AdventureSkin.arabicFont)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _onAnswer(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AdventureSkin.success.withValues(alpha: 0.15),
              foregroundColor: AdventureSkin.success,
              side: const BorderSide(color: AdventureSkin.success),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('قرأت ✅', style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700,
                fontFamily: AdventureSkin.arabicFont)),
          ),
        ),
      ]),
    );
  }

  String _nodeTitle() {
    switch (widget.node.type) {
      case NodeType.sukunCvcFatha: return 'الساكن مع الفتحة 🔓';
      case NodeType.sukunCvcDamma: return 'الساكن مع الضمة 🔓';
      case NodeType.sukunCvcKasra: return 'الساكن مع الكسرة 🔓';
      default: return 'الحرف الساكن';
    }
  }
}
