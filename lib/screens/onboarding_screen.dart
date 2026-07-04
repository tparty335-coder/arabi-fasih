// screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/adventure_skin.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int? _selectedAge;

  Future<void> _continue() async {
    if (_selectedAge == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_age', _selectedAge!);
    if (!mounted) return;
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
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text('⚡', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  const Text('عربي فصيح',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900,
                          color: Colors.white, fontFamily: AdventureSkin.arabicFont)),
                  const SizedBox(height: 4),
                  Text('العب. تعلم. افصح.',
                      style: TextStyle(fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.6),
                          fontFamily: AdventureSkin.arabicFont)),
                  const SizedBox(height: 48),
                  Text('كم عمرك؟',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontFamily: AdventureSkin.arabicFont)),
                  const SizedBox(height: 20),
                  ...[
                    _AgeOption(label: '3 – 6 سنوات 🌟', age: 5,
                        color: AdventureSkin.success, desc: 'وضع الحضانة'),
                    _AgeOption(label: '7 – 10 سنوات 🎮', age: 9,
                        color: AdventureSkin.primary, desc: 'وضع المغامرة'),
                    _AgeOption(label: '11+ سنة ⚡', age: 13,
                        color: AdventureSkin.secondary, desc: 'وضع السرعة'),
                  ].map((opt) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedAge = opt.age),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: _selectedAge == opt.age
                              ? opt.color.withValues(alpha: 0.2)
                              : AdventureSkin.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _selectedAge == opt.age ? opt.color : opt.color.withValues(alpha: 0.3),
                            width: _selectedAge == opt.age ? 2 : 1,
                          ),
                        ),
                        child: Row(children: [
                          Text(opt.label,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
                                  color: Colors.white, fontFamily: AdventureSkin.arabicFont)),
                          const Spacer(),
                          Text(opt.desc,
                              style: TextStyle(fontSize: 13, color: opt.color,
                                  fontFamily: AdventureSkin.arabicFont)),
                          if (_selectedAge == opt.age) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.check_circle, color: opt.color, size: 20),
                          ],
                        ]),
                      ),
                    ),
                  )),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity, height: 56,
                    child: ElevatedButton(
                      onPressed: _selectedAge != null ? _continue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdventureSkin.primary,
                        disabledBackgroundColor: AdventureSkin.cardBg,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('ابدأ الرحلة 🚀',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                              fontFamily: AdventureSkin.arabicFont, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AgeOption {
  final String label, desc;
  final int age;
  final Color color;
  const _AgeOption({required this.label, required this.age, required this.color, required this.desc});
}
