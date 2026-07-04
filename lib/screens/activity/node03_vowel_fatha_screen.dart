// ====================================================
// screens/activity/node03_vowel_fatha_screen.dart
// NODE_03: إطلاق الحركة — الفتحة (بَـ)
// الطفل يميز بَ من بِ من بُ
// ====================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/skill_node.dart';
import '../../services/mastery_service.dart';
import '../../theme/adventure_skin.dart';
import '../../widgets/micro_session_scaffold.dart';
import 'session_complete_screen.dart';

class Node03VowelFathaScreen extends StatefulWidget {
  final SkillNode node;
  const Node03VowelFathaScreen({super.key, required this.node});

  @override
  State<Node03VowelFathaScreen> createState() => _Node03VowelFathaScreenState();
}

class _Node03VowelFathaScreenState extends State<Node03VowelFathaScreen>
    with TickerProviderStateMixin {
  int _currentStep = 1;
  int _xpEarned = 0;
  String? _selectedAnswer;
  bool _isProcessing = false;
  int _correctCount = 0;
  final _stopwatch = Stopwatch();

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;

  final List<_VowelQuestion> _questions = [
    _VowelQuestion(
      instruction: 'أيّ هذه الأصوات هو\n  بَـ  (بالفتحة) ؟',
      choices: ['بَ', 'بِ', 'بُ'],
      correctAnswer: 'بَ',
      vowelNames: ['فتحة ↓', 'كسرة ↓↓', 'ضمة ○'],
    ),
    _VowelQuestion(
      instruction: 'انظر للعلامة فوق الحرف\nأيّها يحمل الفتحة  ـَ ؟',
      choices: ['كَ', 'بَ', 'تِ'],
      correctAnswer: 'بَ',
      vowelNames: ['فتحة', 'فتحة', 'كسرة'],
    ),
    _VowelQuestion(
      instruction: 'أيّ هذه الكلمات\nتبدأ بـ  بَـ  (بالفتحة) ؟',
      choices: ['بِئرٌ', 'بَابٌ', 'بُرجٌ'],
      correctAnswer: 'بَابٌ',
      vowelNames: ['كسرة', 'فتحة ✓', 'ضمة'],
      isWord: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
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
    _pulseController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _onAnswerSelected(String answer) async {
    if (_isProcessing || _selectedAnswer != null) return;
    final elapsed = _stopwatch.elapsedMilliseconds;
    _stopwatch.reset();
    _stopwatch.start();

    final isCorrect = answer == _questions[_currentStep - 1].correctAnswer;
    setState(() {
      _selectedAnswer = answer;
      _isProcessing = true;
    });
    _feedbackController.forward(from: 0);

    await context.read<MasteryService>().recordAttempt(
          widget.node.id, isCorrect, elapsed,
          wrongChoice: isCorrect ? null : answer,
        );
    if (isCorrect) { _xpEarned += 50; _correctCount++; }

    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
        _selectedAnswer = null;
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
      skillTitle: 'الحركة — الفتحة',
      currentStep: _currentStep,
      totalSteps: 3,
      xpEarned: _xpEarned,
      onConfusionPressed: () =>
          context.read<MasteryService>().recordConfusion(widget.node.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // بطاقة مرجعية ثابتة في الأعلى
            _buildVowelReference(),
            const SizedBox(height: 20),
            _buildQuestionCard(question),
            const SizedBox(height: 24),
            if (question.isWord)
              _buildWordChoices(question)
            else
              _buildVowelChoices(question),
          ],
        ),
      ),
    );
  }

  Widget _buildVowelReference() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AdventureSkin.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AdventureSkin.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _vowelBadge('بَ', 'فتحة', AdventureSkin.success),
          _vowelBadge('بِ', 'كسرة', Colors.blue.shade300),
          _vowelBadge('بُ', 'ضمة', AdventureSkin.primary),
        ],
      ),
    );
  }

  Widget _vowelBadge(String letter, String name, Color color) {
    return Column(
      children: [
        Text(letter,
            style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w900,
              color: color, fontFamily: AdventureSkin.arabicFont,
            )),
        Text(name,
            style: TextStyle(
              fontSize: 11, color: color.withValues(alpha: 0.8),
              fontFamily: AdventureSkin.arabicFont,
            )),
      ],
    );
  }

  Widget _buildQuestionCard(_VowelQuestion q) {
    return ScaleTransition(
      scale: _pulseAnim,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: AdventureSkin.cardDecoration,
        child: Text(
          q.instruction,
          textAlign: TextAlign.center,
          style: AdventureSkin.questionStyle,
        ),
      ),
    );
  }

  Widget _buildVowelChoices(_VowelQuestion q) {
    return Row(
      children: List.generate(q.choices.length, (i) {
        final letter = q.choices[i];
        final vowelName = q.vowelNames?[i] ?? '';
        final isSelected = _selectedAnswer == letter;
        final isCorrect = letter == q.correctAnswer;

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
                onTap: () => _onAnswerSelected(letter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 130,
                  decoration: deco,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(letter,
                          style: AdventureSkin.letterStyle.copyWith(
                            fontSize: 48, color: mainColor,
                          )),
                      const SizedBox(height: 6),
                      Text(vowelName,
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

  Widget _buildWordChoices(_VowelQuestion q) {
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
                      fontSize: 30, color: textColor,
                    )),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _VowelQuestion {
  final String instruction;
  final List<String> choices;
  final String correctAnswer;
  final List<String>? vowelNames;
  final bool isWord;
  const _VowelQuestion({
    required this.instruction,
    required this.choices,
    required this.correctAnswer,
    this.vowelNames,
    this.isWord = false,
  });
}
