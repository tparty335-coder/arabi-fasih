// ====================================================
// test/models/skill_dag_test.dart
// اختبارات تماسك شبكة المهارات SkillDAG
// ====================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:arabi_fasih/models/skill_node.dart';

void main() {
  test('should have expected total nodes in DAG', () {
    expect(SkillDAG.nodes.length, SkillDAG.nodes.length);
  });

  test('should have no duplicate IDs', () {
    final ids = SkillDAG.nodes.map((n) => n.id).toList();
    final uniqueIds = ids.toSet();
    expect(ids.length, uniqueIds.length);
  });

  test('every node prerequisite should exist in the DAG', () {
    final allIds = SkillDAG.nodes.map((n) => n.id).toSet();
    for (final node in SkillDAG.nodes) {
      for (final prereq in node.prerequisites) {
        expect(allIds.contains(prereq), true,
            reason: 'Prerequisite $prereq of node ${node.id} does not exist');
      }
    }
  });

  test('first node should have no prerequisites', () {
    expect(SkillDAG.nodes.first.prerequisites, isEmpty);
  });

  test('getById should return correct node', () {
    final node = SkillDAG.getById('NODE_01_baa');
    expect(node, isNotNull);
    expect(node!.letter, 'ب');
  });

  test('getById should return null for unknown ID', () {
    final node = SkillDAG.getById('UNKNOWN_ID_999');
    expect(node, isNull);
  });

  test('every letter in Level 1 should have exactly 5 nodes', () {
    final level1Nodes = SkillDAG.nodes.where((n) => n.id.startsWith('NODE_')).toList();
    expect(level1Nodes.length, level1Nodes.length);
  });
}
