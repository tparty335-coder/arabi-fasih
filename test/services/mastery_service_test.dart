// ====================================================
// test/services/mastery_service_test.dart
// اختبارات وحدة لـ MasteryService
// ====================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arabi_fasih/services/mastery_service.dart';
import 'package:arabi_fasih/models/skill_node.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MasteryService masteryService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    masteryService = MasteryService();
    await masteryService.initialize();
  });

  test('should initialize with all nodes as unseen', () {
    final record = masteryService.getRecord('NODE_01_baa');
    expect(record.status, NodeStatus.unseen);
    expect(masteryService.totalMastered, 0);
  });

  test('should record attempt and update mastery status', () async {
    await masteryService.recordAttempt('NODE_01_baa', true, 1200);
    final record = masteryService.getRecord('NODE_01_baa');
    expect(record.status, NodeStatus.learning);
    expect(record.attempts.length, 1);
  });

  test('should transition unseen -> learning -> masteredTemp after 2/3 correct', () async {
    await masteryService.recordAttempt('NODE_01_baa', true, 1000);
    await masteryService.recordAttempt('NODE_01_baa', true, 1000);
    await masteryService.recordAttempt('NODE_01_baa', false, 1000);
    final record = masteryService.getRecord('NODE_01_baa');
    expect(record.status, NodeStatus.masteredTemp);
  });

  test('should not grant mastery if less than 2/3 correct', () async {
    await masteryService.recordAttempt('NODE_01_baa', true, 1000);
    await masteryService.recordAttempt('NODE_01_baa', false, 1000);
    await masteryService.recordAttempt('NODE_01_baa', false, 1000);
    final record = masteryService.getRecord('NODE_01_baa');
    expect(record.status, isNot(NodeStatus.masteredTemp));
  });

  test('should add XP correctly', () async {
    expect(masteryService.totalXp, 0);
    await masteryService.addXp(150);
    expect(masteryService.totalXp, 150);
  });

  test('should calculate level from XP', () async {
    expect(masteryService.level, 1);
    await masteryService.addXp(1200);
    expect(masteryService.level, 3);
  });

  test('should update streak on consecutive activity', () async {
    expect(masteryService.currentStreak, 0);
    await masteryService.addXp(50);
    expect(masteryService.currentStreak, 1);
  });

  test('should award badge on first mastered letter', () async {
    expect(masteryService.earnedBadges.contains('first_letter'), false);
    await masteryService.markAsLearning('NODE_01_baa');
    await masteryService.addXp(50); // triggers _checkBadges
    expect(masteryService.earnedBadges.contains('first_letter'), true);
  });

  test('setEntryPoint should set to learning without mastery', () async {
    await masteryService.setEntryPoint('NODE_01_baa');
    final record = masteryService.getRecord('NODE_01_baa');
    expect(record.status, NodeStatus.learning);
    expect(masteryService.totalMastered, 0);
  });

  test('resetAll should clear everything', () async {
    await masteryService.addXp(500);
    await masteryService.resetAll();
    expect(masteryService.totalXp, 0);
    expect(masteryService.totalMastered, 0);
  });
}
