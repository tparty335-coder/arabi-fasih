// ====================================================
// screens/activity/node04_positional_screen.dart
// NODE_04: التحول الموضعي — الباء في أول الكلمة (بـ)
// الطفل يتعرف على الباء المتصلة بما بعدها
// ====================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/skill_node.dart';
import '../../services/mastery_service.dart';
import '../../theme/adventure_skin.dart';
import '../../widgets/micro_session_scaffold.dart';
import 'session_complete_screen.dart';

class Node04PositionalScreen extends StatefulWidget {
  final SkillNode node;
  const Node04PositionalScreen({super.key, required this.node});

  @override
  State<Node04PositionalScreen> createState() => _Node04PositionalScreenState();
}

class _Node04PositionalScreenState extends State<Node04PositionalScreen>
    with TickerProviderStateMixin {
  int _currentStep = 1;
  int _xpEarned = 0;
  String? _selectedAnswer;
  bool _isProcessing = false;
  int _correctCount = 0;
  final _stopwatch = Stopwatch();

  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;

  // المفهوم: الحرف نفسه يمد يده ليتصل بما بعده
  final List<_PositionalQuestion> _questions = [
    _PositionalQuestion(
      instruction: 'أيّ هذه الأشكال يمثّل\nالباء في  أوّل  الكلمة؟',
      choices: ['ـبـ', 'بـ', 'ـب'],
      correctAnswer: 'بـ',
      labels: ['وسط', 'أول ✓', 'آخر'],
    ),
    _PositionalQuestion(
      instruction: 'في كلمة  "بَـاب"\nأيّ شكل هو الباء الأولى؟',
      choices: ['بـ', 'ب', 'ـب'],
      correctAnswer: 'بـ',
      labels: ['أول الكلمة', 'مستقل', 'آخر الكلمة'],
      targetWord: 'بَـاب',
    ),
    _PositionalQuestion(
      instruction: 'أيّ الكلمات التالية\nتبدأ بحرف  الباء ؟',
      choices: ['كِتابٌ', 'بَيتٌ', 'لَبَنٌ'],
      correctAnswer: 'بَيتٌ',
      labels: ['لا', 'نعم ✓', 'لا'],
      isWord: true,
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

    final isCorrect = answer == _questions[_currentStep - 1].correctAnswer;
    setState(() { _selectedAnswer = answer; _isProcessing = true; });
    _feedbackController.forward(from: 0);

    await context.read<MasteryService>().recordAttempt(
          widget.node.id, isCorrect, elapsed,
          wrongChoice: isCorrect ? null : answer,
        );
    if (isCorrect) { _xpEarned += 50; _correctCount++; }

    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

    if (_currentStep < 3) {
      setState(() { _currentStep++; _selectedAnswer = null; _isProcessing = false; });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => SessionCompleteScreen(
          skillId: widget.node.id, correctCount: _correctCount,
          totalSteps: 3, xpEarned: _xpEarned,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentStep - 1];
    return MicroSessionScaffold(
      skillTitle: 'شكل الاتصال',
      currentStep: _currentStep,
      totalSteps: 3,
      xpEarned: _xpEarned,
      onConfusionPressed: () =>
          context.read<MasteryService>().recordConfusion(widget.node.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // مرجع ثابت: الأشكال الثلاثة
            _buildPositionReference(),
            const SizedBox(height: 20),
            _buildQuestionCard(question),
            const SizedBox(height: 24),
            if (question.isWord)
              _buildWordChoices(question)
            else
              _buildFormChoices(question),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionReference() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AdventureSkin.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AdventureSkin.secondary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _formBadge('بـ', 'أول', AdventureSkin.success),
          _formBadge('ـبـ', 'وسط', AdventureSkin.accent),
          _formBadge('ـب', 'آخر', AdventureSkin.primary),
          _formBadge('ب', 'منفرد', Colors.white60),
        ],
      ),
    );
  }

  Widget _formBadge(String form, String label, Color color) {
    return Column(
      children: [
        Text(form,
            style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.w900,
              color: color, fontFamily: AdventureSkin.arabicFont,
            )),
        Text(label,
            style: TextStyle(
              fontSize: 11, color: color.withValues(alpha: 0.8),
              fontFamily: AdventureSkin.arabicFont,
            )),
      ],
    );
  }

  Widget _buildQuestionCard(_PositionalQuestion q) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AdventureSkin.cardDecoration,
      child: Column(
        children: [
          if (q.targetWord != null) ...[
            Text(q.targetWord!,
                style: AdventureSkin.letterStyle.copyWith(
                  color: AdventureSkin.accent,
                  fontSize: 42,
                )),
            const SizedBox(height: 12),
          ],
          Text(q.instruction,
              textAlign: TextAlign.center,
              style: AdventureSkin.questionStyle),
        ],
      ),
    );
  }

  Widget _buildFormChoices(_PositionalQuestion q) {
    return Row(
      children: List.generate(q.choices.length, (i) {
        final choice = q.choices[i];
        final label = q.labels?[i] ?? '';
        final isSelected = _selectedAnswer == choice;
        final isCorrect = choice == q.correctAnswer;

        BoxDecoration deco;
        Color mainColor = Colors.white;
        if (_selectedAnswer == null) {
          deco = AdventureSkin.letterCardDecoration;
        } else if (isCorrect) {
          deco = AdventureSkin.letterCardCorrectDecoration;
          mainColor = AdventureSkin.letterCardCorrect;
        } else if (isSelected) {
          deco = AdventureSkin.letterCardWrongDecoration;
          mainColor = AdventureSkin.letterCardWrong;
        } else {
          deco = AdventureSkin.letterCardDecoration.copyWith(
              color: AdventureSkin.letterCard.withValues(alpha: 0.3));
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ScaleTransition(
              scale: isSelected ? _feedbackScale : const AlwaysStoppedAnimation(1.0),
              child: GestureDetector(
                onTap: () => _onAnswerSelected(choice),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 120,
                  decoration: deco,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(choice,
                          style: AdventureSkin.letterStyle.copyWith(
                            fontSize: 40, color: mainColor,
                          )),
                      const SizedBox(height: 6),
                      Text(label,
                          style: TextStyle(
                            fontSize: 11,
                            color: mainColor.withValues(alpha: 0.7),
                            fontFamily: AdventureSkin.arabicFont,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildWordChoices(_PositionalQuestion q) {
    return Column(
      children: q.choices.map((word) {
        final isSelected = _selectedAnswer == word;
        final isCorrect = word == q.correctAnswer;
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
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ScaleTransition(
            scale: isSelected ? _feedbackScale : const AlwaysStoppedAnimation(1.0),
            child: GestureDetector(
              onTap: () => _onAnswerSelected(word),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: deco,
                child: Text(word,
                    textAlign: TextAlign.center,
                    style: AdventureSkin.letterStyle.copyWith(
                      fontSize: 28, color: textColor,
                    )),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PositionalQuestion {
  final String instruction;
  final List<String> choices;
  final String correctAnswer;
  final List<String>? labels;
  final String? targetWord;
  final bool isWord;
  const _PositionalQuestion({
    required this.instruction,
    required this.choices,
    required this.correctAnswer,
    this.labels,
    this.targetWord,
    this.isWord = false,
  });
}
