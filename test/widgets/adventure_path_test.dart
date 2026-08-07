// ====================================================
// test/widgets/adventure_path_test.dart
// اختبارات عنصر مسار المغامرة البصري
// ====================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arabi_fasih/models/skill_node.dart';
import 'package:arabi_fasih/services/mastery_service.dart';
import 'package:arabi_fasih/widgets/adventure_path.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MasteryService masteryService;
  late List<SkillNode> sampleNodes;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    masteryService = MasteryService();
    await masteryService.initialize();

    sampleNodes = SkillDAG.nodes.where((n) => n.type == NodeType.abstractPhonemeDicrimination).take(5).toList();
  });

  testWidgets('should render AdventurePath without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider.value(
            value: masteryService,
            child: AdventurePath(
              nodes: sampleNodes,
              mastery: masteryService,
              onTap: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(find.byType(AdventurePath), findsOneWidget);
  });

  testWidgets('should render correct letter symbols in node circles', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider.value(
            value: masteryService,
            child: AdventurePath(
              nodes: sampleNodes,
              mastery: masteryService,
              onTap: (_) {},
            ),
          ),
        ),
      ),
    );

    // الحرف الأول (ألف) مفتوح، الباقي مقفل 🔒
    expect(find.text('🔒'), findsWidgets);
  });
}
