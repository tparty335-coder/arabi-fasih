// ====================================================
// main.dart — نقطة دخول التطبيق
// عربي فصيح | Arabi Fasih
// ====================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/mastery_service.dart';
import 'services/tts_service.dart';
import 'theme/adventure_skin.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // إخفاء شريط الحالة — تجربة غامرة
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // تهيئة خدمة الإتقان
  final masteryService = MasteryService();
  await masteryService.initialize();

  // تهيئة خدمة الصوت
  await TtsService().initialize();

  runApp(
    ChangeNotifierProvider.value(
      value: masteryService,
      child: const ArabiFasihApp(),
    ),
  );
}

class ArabiFasihApp extends StatelessWidget {
  const ArabiFasihApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عربي فصيح',
      debugShowCheckedModeBanner: false,
      theme: AdventureSkin.theme,

      // الاتجاه العربي (RTL)
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },

      home: const HomeScreen(),
    );
  }
}
