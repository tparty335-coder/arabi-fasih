// screens/diagnostic_screen.dart
// تشخيص المستوى — شجرة تفرع تكيفية (Adaptive Decision Tree)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mastery_service.dart';
import '../theme/adventure_skin.dart';
import 'home_screen.dart';

class _AdaptiveQuestion {
  final int difficultyLevel; // 1: مبتدئ جداً, 2: صوتيات, 3: بداية الكلمة, 4: مدود وتركيب
  final String questionText;
  final List<String> choices;
  final String correctAnswer;

  const _AdaptiveQuestion({
    required this.difficultyLevel,
    required this.questionText,
    required this.choices,
    required this.correctAnswer,
  });
}

class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key});

  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  int _currentStep = 0;
  final int _maxSteps = 4;
  int _currentDifficulty = 2; // ابدأ من المستوى المتوازن (2)
  int _highestLevelPassed = 0;
  
  String? _selectedChoice;
  bool _isProcessing = false;

  // بنك الأسئلة المبوب حسب مستوى الصعوبة
  final Map<int, List<_AdaptiveQuestion>> _questionBank = {
    1: const [
      _AdaptiveQuestion(
        difficultyLevel: 1,
        questionText: 'أيّ هذه الحروف هو حرف  ب  ؟',
        choices: ['ب', 'ت', 'ث'],
        correctAnswer: 'ب',
      ),
      _AdaptiveQuestion(
        difficultyLevel: 1,
        questionText: 'أيّ هذه الحروف هو حرف  ت  ؟',
        choices: ['ن', 'ت', 'ب'],
        correctAnswer: 'ت',
      ),
    ],
    2: const [
      _AdaptiveQuestion(
        difficultyLevel: 2,
        questionText: 'أيّ الأصوات هو  بَـ  (بالفتحة) ؟',
        choices: ['بَ', 'بِ', 'بُ'],
        correctAnswer: 'بَ',
      ),
      _AdaptiveQuestion(
        difficultyLevel: 2,
        questionText: 'أيّ الأصوات هو  تِـ  (بالكسرة) ؟',
        choices: ['تُ', 'تِ', 'تَ'],
        correctAnswer: 'تِ',
      ),
    ],
    3: const [
      _AdaptiveQuestion(
        difficultyLevel: 3,
        questionText: 'أيّ الكلمات تبدأ بحرف الباء؟',
        choices: ['بَيتٌ', 'كِتابٌ', 'لَبَنٌ'],
        correctAnswer: 'بَيتٌ',
      ),
      _AdaptiveQuestion(
        difficultyLevel: 3,
        questionText: 'أيّ الكلمات تبدأ بحرف التاء؟',
        choices: ['قَلَمٌ', 'تَمْرٌ', 'مَاءٌ'],
        correctAnswer: 'تَمْرٌ',
      ),
    ],
    4: const [
      _AdaptiveQuestion(
        difficultyLevel: 4,
        questionText: 'أيّ المقاطع يُنطق  بَا  (مد بالألف) ؟',
        choices: ['بَا', 'بُو', 'بِي'],
        correctAnswer: 'بَا',
      ),
      _AdaptiveQuestion(
        difficultyLevel: 4,
        questionText: 'ما هي الكلمة التي تحتوي على مَدّ بالألف؟',
        choices: ['بَابٌ', 'بِئْرٌ', 'بُرْجٌ'],
        correctAnswer: 'بَابٌ',
      ),
    ],
  };

  late _AdaptiveQuestion _currentQuestion;

  @override
  void initState() {
    super.initState();
    _loadNextQuestion();
  }

  void _loadNextQuestion() {
    final list = _questionBank[_currentDifficulty] ?? _questionBank[1]!;
    final index = _currentStep % list.length;
    _currentQuestion = list[index];
  }

  Future<void> _answer(String choice) async {
    if (_isProcessing || _selectedChoice != null) return;

    final bool isCorrect = choice == _currentQuestion.correctAnswer;

    setState(() {
      _selectedChoice = choice;
      _isProcessing = true;
    });

    if (isCorrect) {
      if (_currentDifficulty > _highestLevelPassed) {
        _highestLevelPassed = _currentDifficulty;
      }
      // التكيف للأعلى عند الإجابة الصحيحة
      if (_currentDifficulty < 4) {
        _currentDifficulty++;
      }
    } else {
      // التكيف لأسفل عند الإجابة الخاطئة
      if (_currentDifficulty > 1) {
        _currentDifficulty--;
      }
    }

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    _currentStep++;
    if (_currentStep < _maxSteps) {
      setState(() {
        _selectedChoice = null;
        _isProcessing = false;
        _loadNextQuestion();
      });
    } else {
      _finishAdaptiveAssessment();
    }
  }

  void _finishAdaptiveAssessment() {
    final mastery = context.read<MasteryService>();

    // ✅ الصواب: الاختبار التشخيصي يُحدد نقطة الدخول فقط
    // لا يمنح إتقاناً — الطفل لم يتعلم بعد، فقط حددنا من أين يبدأ
    if (_highestLevelPassed >= 4) {
      // مستوى متقدم — ابدأ من NODE_04 مباشرة (تجاوز الأساسيات)
      mastery.setEntryPoint('NODE_01_baa');
      mastery.setEntryPoint('NODE_02_baa');
      mastery.setEntryPoint('NODE_03_baa');
    } else if (_highestLevelPassed == 3) {
      // مستوى متوسط — ابدأ من NODE_02
      mastery.setEntryPoint('NODE_01_baa');
    }
    // مستوى 1-2: يبدأ من البداية (لا تعديل — التطبيق يبدأ من NODE_01 افتراضياً)

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AdventureSkin.backgroundGradient),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'تشخيص المستوى التكيفي',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontFamily: AdventureSkin.arabicFont,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'السؤال ${_currentStep + 1} من $_maxSteps',
                        style: AdventureSkin.xpStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / _maxSteps,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation(AdventureSkin.primary),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: AdventureSkin.cardDecoration,
                    child: Column(
                      children: [
                        Text(
                          _currentQuestion.questionText,
                          textAlign: TextAlign.center,
                          style: AdventureSkin.questionStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  ..._currentQuestion.choices.map((c) {
                    final isSelected = _selectedChoice == c;
                    final isCorrect = c == _currentQuestion.correctAnswer;
                    Color borderColor = AdventureSkin.secondary.withValues(alpha: 0.4);
                    Color bg = AdventureSkin.cardBg;

                    if (_selectedChoice != null) {
                      if (isCorrect) {
                        borderColor = AdventureSkin.success;
                        bg = AdventureSkin.success.withValues(alpha: 0.2);
                      } else if (isSelected) {
                        borderColor = AdventureSkin.error;
                        bg = AdventureSkin.error.withValues(alpha: 0.2);
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: GestureDetector(
                        onTap: () => _answer(c),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: Text(
                            c,
                            textAlign: TextAlign.center,
                            style: AdventureSkin.letterStyle.copyWith(fontSize: 26),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
