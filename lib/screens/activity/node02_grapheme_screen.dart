// ====================================================
// screens/activity/node02_grapheme_screen.dart
// NODE_02: الربط الصوتي البصري — صوت + شكل
// الطفل يختار الحرف الصحيح بين حروف متشابهة
// ====================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/skill_node.dart';
import '../../services/mastery_service.dart';
import '../../theme/adventure_skin.dart';
import '../../widgets/micro_session_scaffold.dart';
import 'session_complete_screen.dart';

class Node02GraphemeScreen extends StatefulWidget {
  final SkillNode node;
  const Node02GraphemeScreen({super.key, required this.node});

  @override
  State<Node02GraphemeScreen> createState() => _Node02GraphemeScreenState();
}

class _Node02GraphemeScreenState extends State<Node02GraphemeScreen>
    with TickerProviderStateMixin {
  int _currentStep = 1;
  int _xpEarned = 0;
  String? _selectedAnswer;
  bool? _isAnswerCorrect;
  bool _isProcessing = false;
  int _correctCount = 0;
  final _stopwatch = Stopwatch();

  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;

  // =============================================
  // 3 تفاعلات — تصاعد الصعوبة
  // =============================================
  final List<_GraphemeQuestion> _questions = [
    _GraphemeQuestion(
      instruction: 'أيّ هذه الحروف\nصوته  /بَـ/ ؟',
      choices: ['تَ', 'بَ', 'ثَ'],
      correctAnswer: 'بَ',
      hint: 'الباء نقطة واحدة تحتها',
    ),
    _GraphemeQuestion(
      instruction: 'أيّ هذه الحروف\nهو حرف  الباء ؟',
      choices: ['ن', 'ب', 'ي'],
      correctAnswer: 'ب',
      hint: 'الباء: جسم مسطّح + نقطة أسفله',
    ),
    _GraphemeQuestion(
      instruction: 'استمع جيداً...\nاختر الحرف الذي تسمعه',
      choices: ['م', 'ف', 'ب'],
      correctAnswer: 'ب',
      soundLabel: '🔊  /بَـ/',
      hint: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _feedbackScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.elasticOut),
    );
    _stopwatch.start();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _onAnswerSelected(String answer) async {
    if (_isProcessing || _selectedAnswer != null) return;
    final elapsed = _stopwatch.elapsedMilliseconds;
    _stopwatch.reset();
    _stopwatch.start();

    final question = _questions[_currentStep - 1];
    final isCorrect = answer == question.correctAnswer;

    setState(() {
      _selectedAnswer = answer;
      _isAnswerCorrect = isCorrect;
      _isProcessing = true;
    });

    _feedbackController.forward(from: 0);

    await context.read<MasteryService>().recordAttempt(
          widget.node.id, isCorrect, elapsed,
          wrongChoice: isCorrect ? null : answer,
        );

    if (isCorrect) {
      _xpEarned += 50;
      _correctCount++;
    }

    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
        _selectedAnswer = null;
        _isAnswerCorrect = null;
        _isProcessing = false;
      });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => SessionCompleteScreen(
          skillId: widget.node.id,
          correctCount: _correctCount,
          totalSteps: 3,
          xpEarned: _xpEarned,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentStep - 1];
    return MicroSessionScaffold(
      skillTitle: 'الصوت والشكل',
      currentStep: _currentStep,
      totalSteps: 3,
      xpEarned: _xpEarned,
      onConfusionPressed: () =>
          context.read<MasteryService>().recordConfusion(widget.node.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            _buildQuestionCard(question),
            const SizedBox(height: 28),
            _buildLetterGrid(question),
            if (question.hint != null) ...[
              const SizedBox(height: 16),
              _buildHint(question.hint!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(_GraphemeQuestion q) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: AdventureSkin.cardDecoration,
      child: Column(
        children: [
          if (q.soundLabel != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                color: AdventureSkin.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AdventureSkin.primary.withValues(alpha: 0.3)),
              ),
              child: Text(q.soundLabel!,
                  style: AdventureSkin.letterStyle.copyWith(fontSize: 26)),
            ),
            const SizedBox(height: 14),
          ],
          Text(q.instruction,
              textAlign: TextAlign.center,
              style: AdventureSkin.questionStyle),
        ],
      ),
    );
  }

  Widget _buildLetterGrid(_GraphemeQuestion q) {
    return Row(
      children: q.choices.map((letter) {
        final isSelected = _selectedAnswer == letter;
        final isCorrect = letter == q.correctAnswer;

        BoxDecoration deco;
        Color textColor = Colors.white;

        if (_selectedAnswer == null) {
          deco = AdventureSkin.letterCardDecoration;
        } else if (isCorrect) {
          deco = AdventureSkin.letterCardCorrectDecoration;
          textColor = AdventureSkin.letterCardCorrect;
        } else if (isSelected) {
          deco = AdventureSkin.letterCardWrongDecoration;
          textColor = AdventureSkin.letterCardWrong;
        } else {
          deco = AdventureSkin.letterCardDecoration.copyWith(
              color: AdventureSkin.letterCard.withValues(alpha: 0.3));
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ScaleTransition(
              scale: isSelected
                  ? _feedbackScale
                  : const AlwaysStoppedAnimation(1.0),
              child: GestureDetector(
                onTap: () => _onAnswerSelected(letter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 120,
                  decoration: deco,
                  child: Center(
                    child: Text(
                      letter,
                      style: AdventureSkin.letterStyle.copyWith(
                        fontSize: 52,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHint(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AdventureSkin.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdventureSkin.secondary.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💡', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(hint,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
                fontFamily: AdventureSkin.arabicFont,
              )),
        ],
      ),
    );
  }
}

class _GraphemeQuestion {
  final String instruction;
  final List<String> choices;
  final String correctAnswer;
  final String? soundLabel;
  final String? hint;
  const _GraphemeQuestion({
    required this.instruction,
    required this.choices,
    required this.correctAnswer,
    this.soundLabel,
    this.hint,
  });
}
