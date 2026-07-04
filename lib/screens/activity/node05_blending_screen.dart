// ====================================================
// screens/activity/node05_blending_screen.dart
// NODE_05: الدمج الثنائي — بَ + ا = بَا
// المهارة الأكثر إثارة: ولادة المقطع الأول
// ====================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/skill_node.dart';
import '../../services/mastery_service.dart';
import '../../theme/adventure_skin.dart';
import '../../widgets/micro_session_scaffold.dart';
import 'session_complete_screen.dart';

class Node05BlendingScreen extends StatefulWidget {
  final SkillNode node;
  const Node05BlendingScreen({super.key, required this.node});

  @override
  State<Node05BlendingScreen> createState() => _Node05BlendingScreenState();
}

class _Node05BlendingScreenState extends State<Node05BlendingScreen>
    with TickerProviderStateMixin {
  int _currentStep = 1;
  int _xpEarned = 0;
  String? _selectedAnswer;
  bool _isProcessing = false;
  int _correctCount = 0;
  final _stopwatch = Stopwatch();

  late AnimationController _blendController;
  late Animation<double> _blendAnim;
  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;

  // اللحظة السحرية: الطفل يرى كيف يُولد المقطع
  final List<_BlendQuestion> _questions = [
    _BlendQuestion(
      instruction: 'ادمج هذين الصوتين معاً\nماذا تسمع؟',
      part1: 'بَـ',
      part2: 'ا',
      choices: ['بَا', 'دَا', 'مَا'],
      correctAnswer: 'بَا',
    ),
    _BlendQuestion(
      instruction: 'أيّ هذه المقاطع\nيُنطق  "بَا" ؟',
      part1: null,
      part2: null,
      choices: ['تَا', 'بَا', 'كَا'],
      correctAnswer: 'بَا',
    ),
    _BlendQuestion(
      instruction: 'أيّ الكلمات التالية\nتبدأ بمقطع  بَا ؟',
      part1: null,
      part2: null,
      choices: ['بَابٌ 🚪', 'دَارٌ 🏠', 'مَاءٌ 💧'],
      correctAnswer: 'بَابٌ 🚪',
      isWord: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _blendController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _blendAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _blendController, curve: Curves.easeInOut),
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
    _blendController.dispose();
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
    if (isCorrect) { _xpEarned += 75; _correctCount++; } // XP أعلى للدمج

    await Future.delayed(const Duration(milliseconds: 1200));
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
      skillTitle: 'الدمج — بَا 🎵',
      currentStep: _currentStep,
      totalSteps: 3,
      xpEarned: _xpEarned,
      onConfusionPressed: () =>
          context.read<MasteryService>().recordConfusion(widget.node.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            if (question.part1 != null)
              _buildBlendVisual(question)
            else
              _buildSimpleInstruction(question),
            const SizedBox(height: 28),
            if (question.isWord)
              _buildWordChoices(question)
            else
              _buildSyllableChoices(question),
          ],
        ),
      ),
    );
  }

  // التأثير البصري لعملية الدمج
  Widget _buildBlendVisual(_BlendQuestion q) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AdventureSkin.cardDecoration,
      child: Column(
        children: [
          Text(q.instruction,
              textAlign: TextAlign.center,
              style: AdventureSkin.questionStyle),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الجزء الأول
              _soundBubble(q.part1!, AdventureSkin.primary),
              // سهم الدمج
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ScaleTransition(
                  scale: _blendAnim,
                  child: Column(
                    children: [
                      const Text('➕', style: TextStyle(fontSize: 24)),
                      const SizedBox(height: 4),
                      Text('ادمج',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 11,
                            fontFamily: AdventureSkin.arabicFont,
                          )),
                    ],
                  ),
                ),
              ),
              // الجزء الثاني
              _soundBubble(q.part2!, AdventureSkin.accent),
              // يساوي
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('=',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w900,
                    )),
              ),
              // علامة الاستفهام — سيجيب الطفل بالضغط
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AdventureSkin.secondary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AdventureSkin.secondary.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text('؟',
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white54,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w900,
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _soundBubble(String text, Color color) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
      ),
      child: Center(
        child: Text(text,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: color,
              fontFamily: AdventureSkin.arabicFont,
            )),
      ),
    );
  }

  Widget _buildSimpleInstruction(_BlendQuestion q) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: AdventureSkin.cardDecoration,
      child: Text(q.instruction,
          textAlign: TextAlign.center,
          style: AdventureSkin.questionStyle),
    );
  }

  Widget _buildSyllableChoices(_BlendQuestion q) {
    return Row(
      children: q.choices.map((syllable) {
        final isSelected = _selectedAnswer == syllable;
        final isCorrect = syllable == q.correctAnswer;
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
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ScaleTransition(
              scale: isSelected ? _feedbackScale : const AlwaysStoppedAnimation(1.0),
              child: GestureDetector(
                onTap: () => _onAnswerSelected(syllable),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 120,
                  decoration: deco,
                  child: Center(
                    child: Text(syllable,
                        style: AdventureSkin.letterStyle.copyWith(
                          fontSize: 44, color: textColor,
                        )),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWordChoices(_BlendQuestion q) {
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
                      fontSize: 26, color: textColor,
                    )),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _BlendQuestion {
  final String instruction;
  final String? part1;
  final String? part2;
  final List<String> choices;
  final String correctAnswer;
  final bool isWord;
  const _BlendQuestion({
    required this.instruction,
    required this.part1,
    required this.part2,
    required this.choices,
    required this.correctAnswer,
    this.isWord = false,
  });
}
