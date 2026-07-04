// ====================================================
// screens/activity/node01_phoneme_screen.dart
// NODE_01: الوعي الصوتي المجرد — سمعي فقط
// ====================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/skill_node.dart';
import '../../services/mastery_service.dart';
import '../../theme/adventure_skin.dart';
import '../../widgets/micro_session_scaffold.dart';
import 'session_complete_screen.dart';

class Node01PhonemeScreen extends StatefulWidget {
  final SkillNode node;
  const Node01PhonemeScreen({super.key, required this.node});

  @override
  State<Node01PhonemeScreen> createState() => _Node01PhonemeScreenState();
}

class _Node01PhonemeScreenState extends State<Node01PhonemeScreen>
    with TickerProviderStateMixin {
  // =============================================
  // حالة الشاشة
  // =============================================
  int _currentStep = 1;        // التفاعل الحالي (1, 2, 3)
  int _xpEarned = 0;
  String? _selectedAnswer;
  bool? _isAnswerCorrect;
  bool _isProcessing = false;
  int _correctCount = 0;
  final _stopwatch = Stopwatch();

  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;

  // =============================================
  // بيانات التفاعلات الـ 3 — حرف الباء
  // (مُعرَّفة هنا مؤقتاً — لاحقاً من Content Repository)
  // =============================================
  final List<_PhonemeQuestion> _questions = [
    _PhonemeQuestion(
      instruction: 'استمع جيداً\nهل تسمع صوت  /ب/  في هذا الصوت؟',
      soundLabel: '🔊   بَحَثَ',
      choices: ['نعم ✅', 'لا ❌'],
      correctAnswer: 'نعم ✅',
      type: QuestionType.yesNo,
    ),
    _PhonemeQuestion(
      instruction: 'أيّ هذه الأصوات هو\nصوت  /ب/ ؟',
      soundLabel: null,
      choices: ['مَ', 'بَ', 'رَ'],
      correctAnswer: 'بَ',
      type: QuestionType.choose,
    ),
    _PhonemeQuestion(
      instruction: 'أيّ هذه الكلمات\nتبدأ بصوت  /ب/ ؟',
      soundLabel: null,
      choices: ['بَيتٌ 🏠', 'قَلَمٌ ✏️', 'كِتابٌ 📖'],
      correctAnswer: 'بَيتٌ 🏠',
      type: QuestionType.choose,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _feedbackScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.elasticOut),
    );
    _stopwatch.start();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  // =============================================
  // منطق الإجابة
  // =============================================
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

    // تسجيل في MasteryService
    await context.read<MasteryService>().recordAttempt(
          widget.node.id,
          isCorrect,
          elapsed,
          wrongChoice: isCorrect ? null : answer,
        );

    if (isCorrect) {
      _xpEarned += 50;
      _correctCount++;
    }

    // انتظر ثانية ثم انتقل
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
        _selectedAnswer = null;
        _isAnswerCorrect = null;
        _isProcessing = false;
      });
    } else {
      // انتهت الجلسة
      _navigateToComplete();
    }
  }

  void _navigateToComplete() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SessionCompleteScreen(
          skillId: widget.node.id,
          correctCount: _correctCount,
          totalSteps: 3,
          xpEarned: _xpEarned,
        ),
      ),
    );
  }

  void _onConfusion() {
    context.read<MasteryService>().recordConfusion(widget.node.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم التسجيل 📝 سنساعدك أكثر في هذه النقطة',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: AdventureSkin.arabicFont)),
        backgroundColor: AdventureSkin.cardBg,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // =============================================
  // البناء
  // =============================================
  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentStep - 1];

    return MicroSessionScaffold(
      skillTitle: 'تمييز الصوت',
      currentStep: _currentStep,
      totalSteps: 3,
      xpEarned: _xpEarned,
      onConfusionPressed: _onConfusion,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // ===== بطاقة السؤال =====
            _buildQuestionCard(question),
            const SizedBox(height: 32),

            // ===== خيارات الإجابة =====
            ..._buildChoices(question),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(_PhonemeQuestion question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: AdventureSkin.cardDecoration,
      child: Column(
        children: [
          // أيقونة الاستماع
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AdventureSkin.primary.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AdventureSkin.primary.withOpacity(0.4), width: 2),
            ),
            child: const Icon(Icons.volume_up_rounded,
                color: AdventureSkin.primary, size: 36),
          ),
          const SizedBox(height: 16),

          // تعليمات السؤال
          Text(
            question.instruction,
            textAlign: TextAlign.center,
            style: AdventureSkin.questionStyle,
          ),

          // الصوت المعروض (إن وجد)
          if (question.soundLabel != null) ...[
            const SizedBox(height: 16),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AdventureSkin.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AdventureSkin.primary.withOpacity(0.3)),
              ),
              child: Text(
                question.soundLabel!,
                style: AdventureSkin.letterStyle.copyWith(fontSize: 28),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildChoices(_PhonemeQuestion question) {
    if (question.type == QuestionType.yesNo) {
      // زرّا نعم ولا
      return [
        Row(
          children: question.choices.map((choice) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildChoiceButton(choice, question.correctAnswer),
              ),
            );
          }).toList(),
        ),
      ];
    }

    // 3 خيارات
    return question.choices.map((choice) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildChoiceButton(choice, question.correctAnswer),
      );
    }).toList();
  }

  Widget _buildChoiceButton(String choice, String correctAnswer) {
    final isSelected = _selectedAnswer == choice;
    final isCorrect = choice == correctAnswer;

    BoxDecoration decoration;
    Color textColor = Colors.white;

    if (_selectedAnswer == null) {
      decoration = AdventureSkin.letterCardDecoration;
    } else if (isCorrect) {
      decoration = AdventureSkin.letterCardCorrectDecoration;
      textColor = AdventureSkin.letterCardCorrect;
    } else if (isSelected && !isCorrect) {
      decoration = AdventureSkin.letterCardWrongDecoration;
      textColor = AdventureSkin.letterCardWrong;
    } else {
      decoration = AdventureSkin.letterCardDecoration.copyWith(
        color: AdventureSkin.letterCard.withOpacity(0.4),
      );
    }

    return ScaleTransition(
      scale: isSelected ? _feedbackScale : const AlwaysStoppedAnimation(1.0),
      child: GestureDetector(
        onTap: () => _onAnswerSelected(choice),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: decoration,
          child: Text(
            choice,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: textColor,
              fontFamily: AdventureSkin.arabicFont,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================
// نماذج البيانات الداخلية
// =============================================
enum QuestionType { yesNo, choose }

class _PhonemeQuestion {
  final String instruction;
  final String? soundLabel;
  final List<String> choices;
  final String correctAnswer;
  final QuestionType type;

  const _PhonemeQuestion({
    required this.instruction,
    required this.soundLabel,
    required this.choices,
    required this.correctAnswer,
    required this.type,
  });
}
