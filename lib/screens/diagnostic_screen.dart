// screens/diagnostic_screen.dart
// تشخيص المستوى — 5 أسئلة سريعة تحدد نقطة البداية
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mastery_service.dart';
import '../models/skill_node.dart';
import '../theme/adventure_skin.dart';
import 'home_screen.dart';

class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key});
  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  int _step = 0;
  int _score = 0;
  String? _selected;
  bool _processing = false;

  final _questions = [
    _DQ(q: 'أيّ هذه الحروف هو  ب  ؟', choices: ['ب','ت','ث'], correct: 'ب'),
    _DQ(q: 'أيّ الكلمات تبدأ بحرف الباء؟', choices: ['بَيتٌ','كِتابٌ','لَبَنٌ'], correct: 'بَيتٌ'),
    _DQ(q: 'أيّ الأصوات هو  بَـ  (بالفتحة) ؟', choices: ['بَ','بِ','بُ'], correct: 'بَ'),
    _DQ(q: 'أيّ هذه الحروف هو  ت  ؟', choices: ['ن','ت','ب'], correct: 'ت'),
    _DQ(q: 'ما اسم هذا الحرف؟  ث', choices: ['ثاء','باء','تاء'], correct: 'ثاء'),
  ];

  Future<void> _answer(String choice) async {
    if (_processing || _selected != null) return;
    final correct = choice == _questions[_step].correct;
    setState(() { _selected = choice; _processing = true; });
    if (correct) _score++;
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    if (_step < _questions.length - 1) {
      setState(() { _step++; _selected = null; _processing = false; });
    } else {
      _finish();
    }
  }

  void _finish() {
    // بناءً على النتيجة — حدد نقطة البداية
    final mastery = context.read<MasteryService>();
    if (_score >= 4) {
      // متقدم — ابدأ من NODE_03
      mastery.markAsLearning('NODE_01_baa');
      mastery.markAsLearning('NODE_02_baa');
    }
    // وإلا — ابدأ من البداية (افتراضي)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_step];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AdventureSkin.backgroundGradient),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                const SizedBox(height: 16),
                // شريط التقدم
                Row(children: [
                  Text('تشخيص المستوى', style: TextStyle(color: Colors.white.withValues(alpha: 0.7),
                      fontFamily: AdventureSkin.arabicFont, fontSize: 16)),
                  const Spacer(),
                  Text('${_step + 1} / ${_questions.length}',
                      style: AdventureSkin.xpStyle),
                ]),
                const SizedBox(height: 8),
                ClipRRect(borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (_step + 1) / _questions.length,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(AdventureSkin.primary),
                    minHeight: 8,
                  )),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity, padding: const EdgeInsets.all(24),
                  decoration: AdventureSkin.cardDecoration,
                  child: Text(q.q, textAlign: TextAlign.center, style: AdventureSkin.questionStyle),
                ),
                const SizedBox(height: 28),
                ...q.choices.map((c) {
                  final isSelected = _selected == c;
                  final isCorrect = c == q.correct;
                  Color borderColor = AdventureSkin.secondary.withValues(alpha: 0.4);
                  Color bg = AdventureSkin.cardBg;
                  if (_selected != null) {
                    if (isCorrect) { borderColor = AdventureSkin.success; bg = AdventureSkin.success.withValues(alpha: 0.15); }
                    else if (isSelected) { borderColor = AdventureSkin.error; bg = AdventureSkin.error.withValues(alpha: 0.15); }
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => _answer(c),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor, width: 1.5)),
                        child: Text(c, textAlign: TextAlign.center,
                            style: AdventureSkin.letterStyle.copyWith(fontSize: 26)),
                      ),
                    ),
                  );
                }),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _DQ {
  final String q;
  final List<String> choices;
  final String correct;
  const _DQ({required this.q, required this.choices, required this.correct});
}
