// ====================================================
// screens/splash_screen.dart
// شاشة البداية — Splash Screen مع أنيميشن الترحيب
// ====================================================

import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/adventure_skin.dart';
import '../utils/app_images.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isFirstLaunch;

  const SplashScreen({super.key, required this.isFirstLaunch});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => widget.isFirstLaunch
              ? const OnboardingScreen()
              : const HomeScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AdventureSkin.backgroundGradient,
          image: DecorationImage(
            image: const AssetImage(AppImages.splashBg),
            fit: BoxFit.cover,
            onError: (_, __) {},
          ),
        ),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Stack(
              children: [
                Center(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('⚡', style: TextStyle(fontSize: 72)),
                          const SizedBox(height: 16),
                          const Text(
                            'عربي فصيح',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontFamily: AdventureSkin.arabicFont,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'رحلتكَ الممتعة لتعلم اللغة العربية',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.7),
                              fontFamily: AdventureSkin.arabicFont,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 60,
                  right: 60,
                  bottom: 50,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const LinearProgressIndicator(
                          minHeight: 4,
                          backgroundColor: Colors.white12,
                          valueColor: AlwaysStoppedAnimation<Color>(AdventureSkin.primary),
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
    );
  }
}
