// screens/activity/level45_comparison_screen.dart
// شاشة المقارنة: الشدة (Level 4) والتنوين (Level 5)
// المفهوم: نعرض الكلمة ثم نقارنها مع / بدون شدة أو تنوين
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/level45_content.dart';
import '../../models/skill_node.dart';
import '../../services/mastery_service.dart';
import '../../services/tts_service.dart';
import '../../theme/adventure_skin.dart';
import 'session_complete_screen.dart';

class Level45ComparisonScreen extends StatefulWidget {
  final SkillNode node;
  const Level45ComparisonScreen({super.key, required this.node});

  @override
  State<Level45ComparisonScreen> createState() =>
      _Level45ComparisonScreenState();
}

class _Level45ComparisonScreenState
    extends State<Level45ComparisonScreen> with TickerProviderStateMixin {
  late List<_CompareItem> _items;
  int _step = 0, _correct = 0;
  bool? _lastResult;
  String _feedback = '';
  bool _showBoth = false, _tapped = false;

  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _items = _buildItems()..shuffle();
    if (_items.length > 6) _items = _items.sublist(0, 6);

    _scaleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);

    _speakCurrent();
  }

  List<_CompareItem> _buildItems() {
    switch (widget.node.type) {
      case NodeType.shaddaBasic:
        return L4DB.simpleWords.map((w) =>
            _CompareItem(w.withShadda, w.withoutShadda, w.emoji, 'fatha')).toList();
      case NodeType.shaddaProfession:
        return L4DB.professionPattern.map((w) =>
            _CompareItem(w.withShadda, w.withoutShadda, w.emoji, w.vowelType)).toList();
      case NodeType.shaddaComplex:
        return L4DB.complexWords.map((w) =>
            _CompareItem(w.withShadda, w.withoutShadda, w.emoji, w.vowelType)).toList();
      case NodeType.tanwinFath:
        return L5DB.fathTanwin.map((w) =>
            _CompareItem(w.withTanwin, w.withoutTanwin, w.emoji, 'fath')).toList();
      case NodeType.tanwinKasr:
        return L5DB.kasrTanwin.map((w) =>
            _CompareItem(w.withTanwin, w.withoutTanwin, w.emoji, 'kasr')).toList();
      case NodeType.tanwinDamm:
        return L5DB.dammTanwin.map((w) =>
            _CompareItem(w.withTanwin, w.withoutTanwin, w.emoji, 'damm')).toList();
      default:
        return L4DB.simpleWords.map((w) =>
            _CompareItem(w.withShadda, w.withoutShadda, w.emoji, 'fatha')).toList();
    }
  }

  _CompareItem get _cur => _items[_step];

  bool get _isShadda => widget.node.type == NodeType.shaddaBasic ||
      widget.node.type == NodeType.shaddaProfession ||
      widget.node.type == NodeType.shaddaComplex;

  Color get _accentColor {
    switch (widget.node.type) {
      case NodeType.tanwinFath:    return const Color(0xFFFF9800);
      case NodeType.tanwinKasr:    return const Color(0xFF9C27B0);
      case NodeType.tanwinDamm:    return const Color(0xFF00BCD4);
      case NodeType.shaddaBasic:   return AdventureSkin.primary;
      case NodeType.shaddaProfession: return const Color(0xFF4CAF50);
      case NodeType.shaddaComplex: return const Color(0xFFE91E63);
      default:                     return AdventureSkin.primary;
    }
  }

  String get _screenTitle {
    switch (widget.node.type) {
      case NodeType.shaddaBasic:      return 'الشدة — كلمات أساسية ّ';
      case NodeType.shaddaProfession: return 'الشدة — نمط المهن فَعَّال';
      case NodeType.shaddaComplex:    return 'الشدة — كلمات مركبة';
      case NodeType.tanwinFath:       return 'تنوين الفتح  ًـ';
      case NodeType.tanwinKasr:       return 'تنوين الكسر  ٍـ';
      case NodeType.tanwinDamm:       return 'تنوين الضم  ٌـ';
      default:                        return 'مقارنة';
    }
  }

  Future<void> _speakCurrent() async {
    await TtsService().speak(_cur.withMark);
    await Future.delayed(const Duration(milliseconds: 500));
    if (_showBoth) {
      await TtsService().speak(_cur.withoutMark);
    }
  }

  Future<void> _revealComparison() async {
    setState(() => _showBoth = true);
    _scaleCtrl.forward(from: 0);
    await TtsService().speak(_cur.withMark);
    await Future.delayed(const Duration(milliseconds: 600));
    await TtsService().speak(_cur.withoutMark);
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

    if (_step + 1 >= _items.length) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => SessionCompleteScreen(
          skillId: widget.node.id,
          correctCount: _correct,
          totalSteps: _items.length,
          xpEarned: _correct * 20,
        ),
      ));
    } else {
      setState(() {
        _step++;
        _lastResult = null;
        _showBoth = false;
        _tapped = false;
        _feedback = '';
      });
      _scaleCtrl.reset();
      _speakCurrent();
    }
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
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
      Expanded(child: Text(_screenTitle, style: TextStyle(color: _accentColor,
          fontSize: 16, fontWeight: FontWeight.w800,
          fontFamily: AdventureSkin.arabicFont))),
      Text('${_step + 1}/${_items.length}', style: AdventureSkin.xpStyle),
    ]),
  );

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(_cur.emoji, style: const TextStyle(fontSize: 72)),
        const SizedBox(height: 24),

        // الكلمة الرئيسية (مع الشدة أو التنوين)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _accentColor.withValues(alpha: 0.5), width: 2),
          ),
          child: Column(children: [
            Text(_isShadda ? 'مع الشدة ّ' : 'مع التنوين',
                style: TextStyle(color: _accentColor, fontSize: 12,
                    fontFamily: AdventureSkin.arabicFont)),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () => TtsService().speak(_cur.withMark),
              child: Text(_cur.withMark, style: TextStyle(fontSize: 48,
                  color: _accentColor, fontWeight: FontWeight.w900,
                  fontFamily: AdventureSkin.arabicFont)),
            ),
          ]),
        ),

        const SizedBox(height: 16),

        if (!_showBoth) ...[
          GestureDetector(
            onTap: _revealComparison,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Text('قارن مع بدون ${_isShadda ? 'شدة' : 'تنوين'} 👁️',
                  style: const TextStyle(color: Colors.white60,
                      fontFamily: AdventureSkin.arabicFont,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ] else ...[
          // المقارنة
          ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    Text(_isShadda ? 'مع الشدة' : 'مع التنوين',
                        style: const TextStyle(color: Colors.white38,
                            fontSize: 11, fontFamily: AdventureSkin.arabicFont)),
                    GestureDetector(
                      onTap: () => TtsService().speak(_cur.withMark),
                      child: Text(_cur.withMark, style: TextStyle(fontSize: 34,
                          color: _accentColor, fontWeight: FontWeight.w900,
                          fontFamily: AdventureSkin.arabicFont)),
                    ),
                  ]),
                  Text('≠', style: TextStyle(fontSize: 28,
                      color: _accentColor.withValues(alpha: 0.5))),
                  Column(children: [
                    Text(_isShadda ? 'بدون شدة' : 'بدون تنوين',
                        style: const TextStyle(color: Colors.white38,
                            fontSize: 11, fontFamily: AdventureSkin.arabicFont)),
                    GestureDetector(
                      onTap: () => TtsService().speak(_cur.withoutMark),
                      child: Text(_cur.withoutMark, style: const TextStyle(
                          fontSize: 34, color: Colors.white54,
                          fontWeight: FontWeight.w900,
                          fontFamily: AdventureSkin.arabicFont)),
                    ),
                  ]),
                ],
              ),
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

  Widget _buildControls() {
    if (!_showBoth) return const SizedBox.shrink();
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
          child: const Text('فهمت ✅', style: TextStyle(
              fontFamily: AdventureSkin.arabicFont, fontWeight: FontWeight.w700)),
        )),
      ]),
    );
  }
}

class _CompareItem {
  final String withMark;
  final String withoutMark;
  final String emoji;
  final String type;
  _CompareItem(this.withMark, this.withoutMark, this.emoji, this.type);
}
