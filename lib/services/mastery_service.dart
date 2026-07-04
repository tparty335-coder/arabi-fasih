// ====================================================
// services/mastery_service.dart
// خدمة التخزين المحلي — shared_preferences (Web + Android + iOS)
// ====================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mastery_record.dart';
import '../models/skill_node.dart';

class MasteryService extends ChangeNotifier {
  static const String _storageKey = 'arabi_fasih_mastery_v1';

  // Cache في الذاكرة
  final Map<String, MasteryRecord> _records = {};

  // =============================================
  // تهيئة الخدمة عند بدء التطبيق
  // =============================================
  Future<void> initialize() async {
    await _loadFromStorage();
    // أنشئ سجلاً لكل مهارة غير موجودة
    for (final node in SkillDAG.nodes) {
      _records.putIfAbsent(
        node.id,
        () => MasteryRecord(skillId: node.id, status: NodeStatus.unseen),
      );
    }
    notifyListeners();
  }

  // =============================================
  // قراءة سجل مهارة
  // =============================================
  MasteryRecord getRecord(String skillId) {
    return _records[skillId] ??
        MasteryRecord(skillId: skillId, status: NodeStatus.unseen);
  }

  // =============================================
  // تسجيل محاولة
  // =============================================
  Future<void> recordAttempt(
    String skillId,
    bool isCorrect,
    int responseTimeMs, {
    String? wrongChoice,
  }) async {
    final record = _records[skillId] ??
        MasteryRecord(skillId: skillId, status: NodeStatus.unseen);

    if (record.status == NodeStatus.unseen) {
      record.status = NodeStatus.learning;
    }

    record.recordAttempt(isCorrect, responseTimeMs, wrongChoice: wrongChoice);
    _records[skillId] = record;

    await _saveToStorage();
    notifyListeners();
  }

  // =============================================
  // تسجيل "لم أفهم"
  // =============================================
  Future<void> recordConfusion(String skillId) async {
    final record = _records[skillId];
    if (record != null) {
      record.recordConfusion();
      await _saveToStorage();
    }
  }

  // =============================================
  // محرك التعلم — المهارة التالية
  // =============================================
  SkillNode? getNextSkill() {
    for (final node in SkillDAG.nodes) {
      final record = _records[node.id];
      final status = record?.status ?? NodeStatus.unseen;

      // تحقق من المتطلبات
      final prereqsMet = node.prerequisites.every((prereqId) {
        final prereq = _records[prereqId];
        return prereq?.status == NodeStatus.masteredTemp ||
            prereq?.status == NodeStatus.review1 ||
            prereq?.status == NodeStatus.review2 ||
            prereq?.status == NodeStatus.masteredFinal;
      });

      if (!prereqsMet) continue;

      // أولوية للمراجعات المستحقة
      if ((status == NodeStatus.masteredTemp ||
              status == NodeStatus.review1 ||
              status == NodeStatus.review2) &&
          (record?.isDueForReview ?? false)) {
        return node;
      }

      // مهارة لم تُتقَن بعد
      if (status == NodeStatus.unseen || status == NodeStatus.learning) {
        return node;
      }
    }
    return null;
  }

  // =============================================
  // إحصائيات
  // =============================================
  int get totalMastered => _records.values
      .where((r) => r.status == NodeStatus.masteredFinal)
      .length;

  int get totalNodes => SkillDAG.nodes.length;

  double get progressPercent =>
      totalNodes == 0 ? 0 : totalMastered / totalNodes;

  // =============================================
  // حفظ وتحميل
  // =============================================
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonEncode({
        'version': 1,
        'records': _records.map((k, v) => MapEntry(k, v.toJson())),
      });
      await prefs.setString(_storageKey, data);
    } catch (e) {
      debugPrint('MasteryService: Error saving — $e');
    }
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null) return;
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final records = data['records'] as Map<String, dynamic>;
      records.forEach((k, v) {
        _records[k] = MasteryRecord.fromJson(v as Map<String, dynamic>);
      });
    } catch (e) {
      debugPrint('MasteryService: Error loading — $e');
    }
  }

  Future<void> resetAll() async {
    _records.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    await initialize();
  }
}
