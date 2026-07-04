// ====================================================
// screens/activity/generic_letter_activity.dart
// شاشة نشاط عامة — تعمل مع أي حرف من الـ DB
// تستبدل NODE_01-05 بملف واحد قابل للبرمجة
// ====================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/letters_content.dart';
import '../../models/skill_node.dart';
import '../../services/mastery_service.dart';
import '../../services/tts_service.dart';
import '../../theme/adventure_skin.dart';
import '../../widgets/micro_session_scaffold.dart';
import '../../widgets/sound_button.dart';
import 'session_complete_screen.dart';

// =============================================
// أنواع الأنشطة المتاحة
// =============================================
enum ActivityType {
  phonemeYesNo,      // هل تسمع الصوت؟ نعم/لا
  pickLetter,        // أيّ الحروف هو X؟
  pickVowel,         // أيّ الحروف يحمل الحركة X؟
  pickWordWithLetter, // أيّ الكلمات تبدأ بـ X؟
  blending,          // بَ + ا = ؟
}

class GenericLetterActivity extends StatefulWidget {
  final SkillNode node;
  final LetterData letterData;
  final ActivityType activityType;
  final String title;

  const GenericLetterActivity({
    super.key,
    required this.node,
    required this.letterData,
    required this.activityType,
    required this.title,
  });

  @override
  State<GenericLetterActivity> createState() => _GenericLetterActivityState();
}

class _GenericLetterActivityState extends State<GenericLetterActivity>
    with TickerProviderStateMixin {
  int _currentStep = 1;
  int _xpEarned = 0;
  String? _selectedAnswer;
  bool _isProcessing = false;
  int _correctCount = 0;
  final _stopwatch = Stopwatch();
  final _tts = TtsService();

  late AnimationController _feedbackCtrl;
  late Animation<double> _feedbackScale;

  // =============================================
  // بناء الأسئلة ديناميكياً من بيانات الحرف
  // =============================================
  late final List<_ActivityQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _feedbackCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400),
    );
    _feedbackScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackCtrl, curve: Curves.elasticOut),
    );
    _questions = _buildQuestions();
    _stopwatch.start();
    // انطق السؤال الأول تلقائياً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakCurrentQuestion();
    });
  }

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    _tts.stop();
    super.dispose();
  }

  void _speakCurrentQuestion() {
    if (_questions.isEmpty) return;
    final q = _questions[_currentStep - 1];
    if (q.autoSpeakText != null) {
      _tts.speak(q.autoSpeakText!);
    }
  }

  List<_ActivityQuestion> _buildQuestions() {
    final ld = widget.letterData;
    switch (widget.activityType) {
      case ActivityType.phonemeYesNo:
        return [
          _ActivityQuestion(
            instruction: 'هل تسمع صوت\n/${ld.soundFatha}/\nفي هذه الكلمة؟',
            choices: ['نعم ✅', 'لا ❌'],
            correctAnswer: 'نعم ✅',
            displayText: ld.fathaWords[0].word,
            autoSpeakText: ld.fathaWords[0].ttsText,
          ),
          _ActivityQuestion(
            instruction: 'اختر الصوت الصحيح\nلـ ${ld.name}',
            choices: [ld.soundFatha, ld.confusedWith.isNotEmpty
                ? '${ld.confusedWith[0]}َ' : 'مَ', 'رَ'],
            correctAnswer: ld.soundFatha,
            autoSpeakText: ld.soundFatha,
          ),
          _ActivityQuestion(
            instruction: 'أيّ الكلمات\nتبدأ بصوت /${ld.soundFatha}/؟',
            choices: [
              ld.fathaWords[0].word,
              ld.confusedWith.isNotEmpty
                  ? '${ld.confusedWith[0]}َبَلٌ' : 'قَلَمٌ',
              'كِتابٌ',
            ],
            correctAnswer: ld.fathaWords[0].word,
            autoSpeakText: ld.fathaWords[0].ttsText,
          ),
        ];

      case ActivityType.pickLetter:
        return [
          _ActivityQuestion(
            instruction: 'أيّ هذه الحروف\nيمثّل  ${ld.name}  ؟',
            choices: [
              ld.letter,
              ld.confusedWith.isNotEmpty ? ld.confusedWith[0] : 'ر',
              ld.confusedWith.length > 1 ? ld.confusedWith[1] : 'م',
            ],
            correctAnswer: ld.letter,
            autoSpeakText: ld.name,
            isLetterGrid: true,
          ),
          _ActivityQuestion(
            instruction: 'أيّ هذه الحروف\nصوته  ${ld.soundFatha} ؟',
            choices: [
              ld.confusedWith.isNotEmpty ? ld.confusedWith[0] : 'ر',
              ld.letter,
              ld.confusedWith.length > 1 ? ld.confusedWith[1] : 'م',
            ],
            correctAnswer: ld.letter,
            isLetterGrid: true,
          ),
          _ActivityQuestion(
            instruction: 'أيّ هذه الحروف\nhint: نقطة ${_getDotHint(ld.letter)} تحته',
            choices: [
              ld.letter,
              ld.confusedWith.isNotEmpty ? ld.confusedWith[0] : 'ز',
              'ر',
            ],
            correctAnswer: ld.letter,
            isLetterGrid: true,
          ),
        ];

      case ActivityType.pickVowel:
        return [
          _ActivityQuestion(
            instruction: 'أيّ هذه الأصوات\nيُنطق بالفتحة؟',
            choices: [ld.soundFatha, ld.soundKasra, ld.soundDamma],
            correctAnswer: ld.soundFatha,
            autoSpeakText: ld.soundFatha,
            isLetterGrid: true,
          ),
          _ActivityQuestion(
            instruction: 'ابحث عن\n${ld.soundFatha}\nبين هذه الأصوات',
            choices: ['${ld.confusedWith.isNotEmpty ? ld.confusedWith[0] : "ر"}َ',
              ld.soundFatha, ld.soundKasra],
            correctAnswer: ld.soundFatha,
            isLetterGrid: true,
          ),
          _ActivityQuestion(
            instruction: 'أيّ الكلمات\nتبدأ بـ ${ld.soundFatha}؟',
            choices: [
              ld.kasraWords.isNotEmpty ? ld.kasraWords[0].word : 'بِئرٌ',
              ld.fathaWords[0].word,
              ld.dammaWords.isNotEmpty ? ld.dammaWords[0].word : 'بُرجٌ',
            ],
            correctAnswer: ld.fathaWords[0].word,
            autoSpeakText: ld.fathaWords[0].ttsText,
          ),
        ];

      case ActivityType.pickWordWithLetter:
        return [
          _ActivityQuestion(
            instruction: 'أيّ الكلمات\nتبدأ بـ  ${ld.initialForm}  ؟',
            choices: [
              '${ld.fathaWords[0].word} ${ld.fathaWords[0].emoji}',
              '${ld.confusedWith.isNotEmpty ? ld.confusedWith[0] : "ر"}َبيعٌ 🌸',
              'قَمَرٌ 🌙',
            ],
            correctAnswer: '${ld.fathaWords[0].word} ${ld.fathaWords[0].emoji}',
            autoSpeakText: ld.fathaWords[0].ttsText,
          ),
          _ActivityQuestion(
            instruction: 'أيّ الكلمات\nتبدأ بحرف  ${ld.name}  ؟',
            choices: [
              '${ld.fathaWords[1].word} ${ld.fathaWords[1].emoji}',
              'كِتابٌ 📖',
              'شَجَرةٌ 🌳',
            ],
            correctAnswer: '${ld.fathaWords[1].word} ${ld.fathaWords[1].emoji}',
            autoSpeakText: ld.fathaWords[1].ttsText,
          ),
          _ActivityQuestion(
            instruction: 'اختر كلمة أخرى\nتبدأ بـ  ${ld.name}',
            choices: [
              'سَمَكٌ 🐟',
              '${ld.fathaWords[2].word} ${ld.fathaWords[2].emoji}',
              'لَبَنٌ 🥛',
            ],
            correctAnswer: '${ld.fathaWords[2].word} ${ld.fathaWords[2].emoji}',
            autoSpeakText: ld.fathaWords[2].ttsText,
          ),
        ];

      case ActivityType.blending:
        return [
          _ActivityQuestion(
            instruction: 'ادمج هذين الصوتين\nماذا تسمع؟',
            choices: ['${ld.soundFatha}ا',
              '${ld.confusedWith.isNotEmpty ? ld.confusedWith[0] : "د"}َا', 'مَا'],
            correctAnswer: '${ld.soundFatha}ا',
            blendPart1: ld.soundFatha,
            blendPart2: 'ا',
            isLetterGrid: true,
          ),
          _ActivityQuestion(
            instruction: 'أيّ المقاطع\nيُنطق  "${ld.soundFatha}ا" ؟',
            choices: [
              '${ld.confusedWith.isNotEmpty ? ld.confusedWith[0] : "ر"}َا',
              '${ld.soundFatha}ا',
              '${ld.confusedWith.length > 1 ? ld.confusedWith[1] : "م"}َا',
            ],
            correctAnswer: '${ld.soundFatha}ا',
            isLetterGrid: true,
          ),
          _ActivityQuestion(
            instruction: 'أيّ الكلمات\nتبدأ بمقطع  ${ld.soundFatha}ا ؟',
            choices: [
              '${ld.fathaWords[0].word} ${ld.fathaWords[0].emoji}',
              'دَارٌ 🏠',
              'مَاءٌ 💧',
            ],
            correctAnswer: '${ld.fathaWords[0].word} ${ld.fathaWords[0].emoji}',
            autoSpeakText: ld.fathaWords[0].ttsText,
          ),
        ];
    }
  }

  String _getDotHint(String letter) {
    const dotMap = {
      'ب': 'واحدة',
      'ت': 'اثنتان',
      'ث': 'ثلاث',
      'ن': 'واحدة',
    };
    return dotMap[letter] ?? '';
  }

  // =============================================
  // منطق الإجابة
  // =============================================
  Future<void> _onAnswerSelected(String answer) async {
    if (_isProcessing || _selectedAnswer != null) return;
    final elapsed = _stopwatch.elapsedMilliseconds;
    _stopwatch.reset();
    _stopwatch.start();

    final isCorrect = answer == _questions[_currentStep - 1].correctAnswer;
    setState(() { _selectedAnswer = answer; _isProcessing = true; });
    _feedbackCtrl.forward(from: 0);

    // انطق الإجابة الصحيحة عند الاختيار
    await _tts.speak(answer.replaceAll(RegExp(r'[✅❌🎯💡🏠🐄🦆🌊👑🌴🍎🐊✏️📖⛰️🦊🐂🍇🐪🥕🌉💂🚪🌳🕳️🌅🗼💰]'), '').trim());

    // حفظ reference للـ service قبل الـ await
    final mastery = context.read<MasteryService>();
    await mastery.recordAttempt(
      widget.node.id, isCorrect, elapsed,
      wrongChoice: isCorrect ? null : answer,
    );
    if (isCorrect) { _xpEarned += 50; _correctCount++; }

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    if (_currentStep < 3) {
      setState(() { _currentStep++; _selectedAnswer = null; _isProcessing = false; });
      _speakCurrentQuestion();
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
    final q = _questions[_currentStep - 1];
    return MicroSessionScaffold(
      skillTitle: widget.title,
      currentStep: _currentStep,
      totalSteps: 3,
      xpEarned: _xpEarned,
      onConfusionPressed: () =>
          context.read<MasteryService>().recordConfusion(widget.node.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            _buildQuestionCard(q),
            const SizedBox(height: 24),
            if (q.blendPart1 != null)
              _buildBlendVisual(q)
            else if (q.isLetterGrid)
              _buildLetterGrid(q)
            else
              _buildWordList(q),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(_ActivityQuestion q) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AdventureSkin.cardDecoration,
      child: Column(
        children: [
          if (q.displayText != null) ...[
            Text(q.displayText!,
                style: AdventureSkin.letterStyle.copyWith(
                  color: AdventureSkin.accent, fontSize: 36,
                )),
            const SizedBox(height: 8),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(q.instruction,
                    textAlign: TextAlign.center,
                    style: AdventureSkin.questionStyle),
              ),
              const SizedBox(width: 12),
              if (q.autoSpeakText != null)
                SoundButton(
                  textToSpeak: q.autoSpeakText!,
                  size: 44,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLetterGrid(_ActivityQuestion q) {
    return Row(
      children: q.choices.map((choice) {
        final isSelected = _selectedAnswer == choice;
        final isCorrect = choice == q.correctAnswer;
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
                onTap: () => _onAnswerSelected(choice),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 120,
                  decoration: deco,
                  child: Center(
                    child: Text(choice,
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

  Widget _buildWordList(_ActivityQuestion q) {
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: deco,
                child: Text(word,
                    textAlign: TextAlign.center,
                    style: AdventureSkin.letterStyle.copyWith(
                      fontSize: 24, color: textColor,
                    )),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBlendVisual(_ActivityQuestion q) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AdventureSkin.cardDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _bubble(q.blendPart1!, AdventureSkin.primary),
          const Text('➕', style: TextStyle(fontSize: 24)),
          _bubble(q.blendPart2!, AdventureSkin.accent),
          const Text('=', style: TextStyle(fontSize: 28, color: Colors.white54)),
          _bubble('؟', AdventureSkin.secondary),
        ],
      ),
    );
  }

  Widget _bubble(String text, Color color) {
    return Container(
      width: 64, height: 64,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15), shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
      ),
      child: Center(
        child: Text(text,
            style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.w900,
              color: color, fontFamily: AdventureSkin.arabicFont,
            )),
      ),
    );
  }
}

class _ActivityQuestion {
  final String instruction;
  final List<String> choices;
  final String correctAnswer;
  final String? displayText;
  final String? autoSpeakText;
  final bool isLetterGrid;
  final String? blendPart1;
  final String? blendPart2;

  const _ActivityQuestion({
    required this.instruction,
    required this.choices,
    required this.correctAnswer,
    this.displayText,
    this.autoSpeakText,
    this.isLetterGrid = false,
    this.blendPart1,
    this.blendPart2,
  });
}
