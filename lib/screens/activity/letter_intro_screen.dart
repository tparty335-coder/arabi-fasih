// ====================================================
// screens/activity/letter_intro_screen.dart
// شاشة التعليم — تُعرض قبل كل نشاط جديد
// Introduce → Practice → Assess  (المبدأ التربوي الصحيح)
// ====================================================

import 'package:flutter/material.dart';
import '../../data/letters_content.dart';
import '../../models/skill_node.dart';
import '../../services/tts_service.dart';
import '../../theme/adventure_skin.dart';
import '../../utils/app_images.dart';

class LetterIntroScreen extends StatefulWidget {
  final SkillNode node;
  final LetterData letterData;
  final Widget nextScreen; // الشاشة التي تُعرض بعد الإتمام

  const LetterIntroScreen({
    super.key,
    required this.node,
    required this.letterData,
    required this.nextScreen,
  });

  @override
  State<LetterIntroScreen> createState() => _LetterIntroScreenState();
}

class _LetterIntroScreenState extends State<LetterIntroScreen>
    with TickerProviderStateMixin {
  final _tts = TtsService();
  int _slideIndex = 0;
  bool _hasPlayed = false;

  late AnimationController _letterCtrl;
  late Animation<double> _letterScale;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  // =============================================
  // بناء شرائح التعليم بناءً على نوع العقدة
  // =============================================
  late final List<_IntroSlide> _slides;

  @override
  void initState() {
    super.initState();

    _letterCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _letterScale = Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: _letterCtrl, curve: Curves.elasticOut));

    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn));

    _slides = _buildSlides();
    _playCurrentSlide();
  }

  @override
  void dispose() {
    _letterCtrl.dispose();
    _fadeCtrl.dispose();
    _tts.stop();
    super.dispose();
  }

  List<_IntroSlide> _buildSlides() {
    final ld = widget.letterData;
    final nodeType = widget.node.type;

    switch (nodeType) {
      case NodeType.abstractPhonemeDicrimination:
        return [
          _IntroSlide(
            title: 'استمع للصوت',
            displayText: '🔊',
            displayFontSize: 72,
            description: 'صوت حرف ${ld.name} هو ...',
            soundText: ld.soundFatha,
            highlightText: ld.soundFatha,
          ),
          _IntroSlide(
            title: 'كلمات تبدأ بـ ${ld.name}',
            displayText: ld.fathaWords.isNotEmpty ? '${ld.fathaWords[0].emoji}  ${ld.fathaWords[0].word}' : ld.letter,
            displayFontSize: 44,
            description: 'استمع واحفظ: ${ld.fathaWords.isNotEmpty ? ld.fathaWords[0].word : ""}',
            soundText: ld.fathaWords.isNotEmpty ? ld.fathaWords[0].ttsText : ld.name,
            highlightText: null,
          ),
        ];

      case NodeType.graphemePhonemeMapping:
        return [
          _IntroSlide(
            title: 'هذا هو حرف ${ld.name}',
            displayText: ld.letter,
            displayFontSize: 120,
            description: 'صوته  ${ld.soundFatha}  — تعلّمه جيداً',
            soundText: ld.name,
            highlightText: ld.letter,
          ),
          _IntroSlide(
            title: 'اشكال الحرف في الكلمة',
            displayText: '${ld.initialForm}  ·  ${ld.medialForm}  ·  ${ld.finalForm}',
            displayFontSize: 44,
            description: 'في البداية · في الوسط · في النهاية',
            soundText: ld.name,
            highlightText: null,
          ),
        ];

      case NodeType.shortVowelFatha:
        return [
          _IntroSlide(
            title: 'الفتحة على حرف ${ld.name}',
            displayText: ld.soundFatha,
            displayFontSize: 110,
            description: 'الفتحة (  َ  ) تجعل الحرف يُنطق  ${ld.soundFatha}',
            soundText: ld.soundFatha,
            highlightText: ld.soundFatha,
          ),
          _IntroSlide(
            title: 'قارن بين الحركات',
            displayText: '${ld.soundFatha}  ·  ${ld.soundKasra}  ·  ${ld.soundDamma}',
            displayFontSize: 48,
            description: 'فتحة · كسرة · ضمة',
            soundText: ld.soundFatha,
            highlightText: null,
          ),
        ];

      case NodeType.positionalFormInitial:
        return [
          _IntroSlide(
            title: 'الحرف في بداية الكلمة',
            displayText: ld.initialForm,
            displayFontSize: 110,
            description: 'عندما يأتي ${ld.name} في بداية الكلمة يصبح  ${ld.initialForm}',
            soundText: ld.name,
            highlightText: ld.initialForm,
          ),
          _IntroSlide(
            title: 'مثال',
            displayText: ld.fathaWords.isNotEmpty ? '${ld.fathaWords[0].emoji}  ${ld.fathaWords[0].word}' : ld.letter,
            displayFontSize: 44,
            description: 'لاحظ كيف يظهر الحرف في الكلمة',
            soundText: ld.fathaWords.isNotEmpty ? ld.fathaWords[0].ttsText : ld.name,
            highlightText: null,
          ),
        ];

      case NodeType.binaryBlending:
        return [
          _IntroSlide(
            title: 'الدمج الصوتي',
            displayText: '${ld.soundFatha} + ا = ${ld.soundFatha}ا',
            displayFontSize: 40,
            description: 'عندما يتبع ${ld.name} حرف الألف، ينتج صوت ممدود',
            soundText: '${ld.soundFatha}ا',
            highlightText: '${ld.soundFatha}ا',
          ),
        ];

      default:
        return [
          _IntroSlide(
            title: 'حرف ${ld.name}',
            displayText: ld.letter,
            displayFontSize: 120,
            description: 'صوته  ${ld.soundFatha}',
            soundText: ld.name,
            highlightText: ld.letter,
          ),
        ];
    }
  }

  void _playCurrentSlide() {
    if (_slides.isEmpty) return;
    _letterCtrl.forward(from: 0);
    _fadeCtrl.forward(from: 0);
    final slide = _slides[_slideIndex];
    // تشغيل الصوت تلقائياً فقط إذا لم يكن الطفل ضغط "استمع" يدوياً
    if (slide.soundText != null && !_hasPlayed) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _tts.speak(slide.soundText!);
      });
    }
  }

  void _nextSlide() {
    if (_slideIndex < _slides.length - 1) {
      setState(() {
        _slideIndex++;
        _hasPlayed = false;
      });
      _playCurrentSlide();
    } else {
      // الانتقال للنشاط التعليمي
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => widget.nextScreen),
      );
    }
  }

  void _speakAgain() {
    final slide = _slides[_slideIndex];
    if (slide.soundText != null) {
      _tts.speak(slide.soundText!);
      _hasPlayed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_slides.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _nextSlide());
      return const SizedBox.shrink();
    }

    final slide = _slides[_slideIndex];
    final isLastSlide = _slideIndex == _slides.length - 1;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AdventureSkin.backgroundGradient),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                // ===== الشريط العلوي =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      // مؤشر الشرائح
                      Row(
                        children: List.generate(_slides.length, (i) => Container(
                          margin: const EdgeInsets.only(left: 6),
                          width: i == _slideIndex ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _slideIndex
                                ? AdventureSkin.accent
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )),
                      ),
                      const Spacer(),
                      // زر التخطي
                      GestureDetector(
                        onTap: _nextSlide,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'تخطَّ',
                            style: TextStyle(
                              color: Colors.white54,
                              fontFamily: AdventureSkin.arabicFont,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ===== عنوان الشريحة =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Text(
                      slide.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 18,
                        fontFamily: AdventureSkin.arabicFont,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ===== الحرف / المحتوى الرئيسي =====
                GestureDetector(
                  onTap: _speakAgain,
                  child: ScaleTransition(
                    scale: _letterScale,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AdventureSkin.cardBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AdventureSkin.accent.withValues(alpha: 0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AdventureSkin.accent.withValues(alpha: 0.15),
                            blurRadius: 30,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            AppImages.letterImage(widget.node.letter),
                            width: 90,
                            height: 90,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            slide.displayText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: slide.displayFontSize,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontFamily: AdventureSkin.arabicFont,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // أيقونة الاستماع
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AdventureSkin.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.volume_up_rounded,
                                    color: AdventureSkin.primary, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'انقر للاستماع',
                                  style: TextStyle(
                                    color: AdventureSkin.primary,
                                    fontFamily: AdventureSkin.arabicFont,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ===== وصف الشريحة =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Text(
                      slide.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 16,
                        fontFamily: AdventureSkin.arabicFont,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // ===== زر المتابعة =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _nextSlide,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLastSlide
                            ? AdventureSkin.primary
                            : AdventureSkin.secondary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLastSlide ? 'جاهز، ابدأ التمرين! 🎯' : 'التالي',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              fontFamily: AdventureSkin.arabicFont,
                            ),
                          ),
                          if (!isLastSlide) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_back_ios_rounded, size: 16),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IntroSlide {
  final String title;
  final String displayText;
  final double displayFontSize;
  final String description;
  final String? soundText;
  final String? highlightText;

  const _IntroSlide({
    required this.title,
    required this.displayText,
    required this.displayFontSize,
    required this.description,
    this.soundText,
    this.highlightText,
  });
}
