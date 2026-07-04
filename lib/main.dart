import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/mastery_service.dart';
import 'services/tts_service.dart';
import 'theme/adventure_skin.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  final masteryService = MasteryService();
  await masteryService.initialize();
  await TtsService().initialize();

  // هل المستخدم مر بالـ Onboarding؟
  final prefs = await SharedPreferences.getInstance();
  final userAge = prefs.getInt('user_age');
  final isFirstLaunch = userAge == null;

  runApp(
    ChangeNotifierProvider.value(
      value: masteryService,
      child: ArabiFasihApp(isFirstLaunch: isFirstLaunch),
    ),
  );
}

class ArabiFasihApp extends StatelessWidget {
  final bool isFirstLaunch;
  const ArabiFasihApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عربي فصيح',
      debugShowCheckedModeBanner: false,
      theme: AdventureSkin.theme,
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: isFirstLaunch ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}
