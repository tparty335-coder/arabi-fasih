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
    // المرور 1: أولوية للمراجعات المستحقة
    for (final node in SkillDAG.nodes) {
      final record = _records[node.id];
      final status = record?.status ?? NodeStatus.unseen;
      final prereqsMet = _prereqsMet(node);
      if (!prereqsMet) continue;
      if ((status == NodeStatus.masteredTemp ||
              status == NodeStatus.review1 ||
              status == NodeStatus.review2) &&
          (record?.isDueForReview ?? false)) {
        return node;
      }
    }
    // المرور 2: أول مهارة لم تُتقَن بعد
    for (final node in SkillDAG.nodes) {
      final record = _records[node.id];
      final status = record?.status ?? NodeStatus.unseen;
      final prereqsMet = _prereqsMet(node);
      if (!prereqsMet) continue;
      if (status == NodeStatus.unseen || status == NodeStatus.learning) {
        return node;
      }
    }
    return null;
  }

  bool _prereqsMet(SkillNode node) {
    return node.prerequisites.every((prereqId) {
      final prereq = _records[prereqId];
      // ✅ FIX: masteredTemp كافي لفتح العقدة التالية
      return prereq != null &&
          prereq.status != NodeStatus.unseen &&
          prereq.status != NodeStatus.learning;
    });
  }

  // =============================================
  // إحصائيات
  // =============================================
  int get totalMastered => _records.values
      .where((r) =>
          r.status == NodeStatus.masteredTemp ||
          r.status == NodeStatus.review1 ||
          r.status == NodeStatus.review2 ||
          r.status == NodeStatus.masteredFinal)
      .length;

  int get totalFullyMastered => _records.values
      .where((r) => r.status == NodeStatus.masteredFinal)
      .length;

  int get totalNodes => SkillDAG.nodes.length;

  double get progressPercent =>
      totalNodes == 0 ? 0 : totalMastered / totalNodes;

  // =============================================
  // XP + Streak + Badges System
  // =============================================
  int _totalXp = 0;
  int _currentStreak = 0;
  DateTime? _lastActivityDate;
  final List<String> _earnedBadges = [];

  int get totalXp => _totalXp;
  int get currentStreak => _currentStreak;
  List<String> get earnedBadges => List.unmodifiable(_earnedBadges);
  int get level => (_totalXp / 500).floor() + 1; // كل 500 XP = مستوى

  static const Map<String, Map<String, dynamic>> badgeDefinitions = {
    'first_letter': {'name': 'الحرف الأول ✨', 'desc': 'أتقنت أول حرف', 'icon': '⭐'},
    'five_letters': {'name': 'خمسة حروف 🌟', 'desc': 'أتقنت 5 حروف', 'icon': '🏅'},
    'ten_letters': {'name': 'عشرة حروف 💫', 'desc': 'أتقنت 10 حروف', 'icon': '🏆'},
    'all_letters': {'name': 'كل الحروف 👑', 'desc': 'أتقنت 28 حرفاً', 'icon': '👑'},
    'streak_3': {'name': '3 أيام متتالية 🔥', 'desc': 'تعلمت 3 أيام متواصلة', 'icon': '🔥'},
    'streak_7': {'name': 'أسبوع كامل 💪', 'desc': 'تعلمت 7 أيام متواصلة', 'icon': '💪'},
    'speed_demon': {'name': 'سريع البرق ⚡', 'desc': 'أجبت في أقل من 3 ثوانٍ', 'icon': '⚡'},
    'perfect_session': {'name': 'جلسة مثالية 💯', 'desc': '3/3 إجابات صحيحة', 'icon': '💯'},
    'level_2': {'name': 'المستوى الثاني 📚', 'desc': 'وصلت للسكون', 'icon': '📚'},
    'xp_1000': {'name': 'ألف نقطة 🎯', 'desc': 'جمعت 1000 XP', 'icon': '🎯'},
  };

  Future<void> addXp(int amount) async {
    _totalXp += amount;
    _updateStreak();
    _checkBadges();
    await _saveToStorage();
    notifyListeners();
  }

  void unlockBadge(String badgeKey) {
    if (badgeDefinitions.containsKey(badgeKey) && !_earnedBadges.contains(badgeKey)) {
      _earnedBadges.add(badgeKey);
      _saveToStorage();
      notifyListeners();
    }
  }

  void _checkBadges() {
    if (totalMastered >= 1 && !_earnedBadges.contains('first_letter')) _earnedBadges.add('first_letter');
    if (totalMastered >= 5 && !_earnedBadges.contains('five_letters')) _earnedBadges.add('five_letters');
    if (totalMastered >= 10 && !_earnedBadges.contains('ten_letters')) _earnedBadges.add('ten_letters');
    if (totalMastered >= 28 && !_earnedBadges.contains('all_letters')) _earnedBadges.add('all_letters');
    if (_currentStreak >= 3 && !_earnedBadges.contains('streak_3')) _earnedBadges.add('streak_3');
    if (_currentStreak >= 7 && !_earnedBadges.contains('streak_7')) _earnedBadges.add('streak_7');
    if (_totalXp >= 1000 && !_earnedBadges.contains('xp_1000')) _earnedBadges.add('xp_1000');
    final lvl2Record = _records['L2_01_cvc_fatha'];
    if (lvl2Record != null && lvl2Record.status != NodeStatus.unseen && !_earnedBadges.contains('level_2')) {
      _earnedBadges.add('level_2');
    }
  }

  void _updateStreak() {
    final today = DateTime.now();
    if (_lastActivityDate == null) {
      _currentStreak = 1;
    } else {
      final lastDate = DateTime(_lastActivityDate!.year, _lastActivityDate!.month, _lastActivityDate!.day);
      final currentDate = DateTime(today.year, today.month, today.day);
      final diff = currentDate.difference(lastDate).inDays;
      if (diff == 1) {
        _currentStreak++;
      } else if (diff > 1) {
        _currentStreak = 1;
      }
    }
    _lastActivityDate = today;
  }

  // =============================================
  // حفظ وتحميل
  // =============================================
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonEncode({
        'version': 1,
        'records': _records.map((k, v) => MapEntry(k, v.toJson())),
        'totalXp': _totalXp,
        'currentStreak': _currentStreak,
        'lastActivityDate': _lastActivityDate?.toIso8601String(),
        'earnedBadges': _earnedBadges,
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
      _totalXp = (data['totalXp'] as num?)?.toInt() ?? 0;
      _currentStreak = (data['currentStreak'] as num?)?.toInt() ?? 0;
      if (data['lastActivityDate'] != null) {
        _lastActivityDate = DateTime.tryParse(data['lastActivityDate'] as String);
      }
      if (data['earnedBadges'] != null) {
        _earnedBadges.clear();
        _earnedBadges.addAll((data['earnedBadges'] as List).cast<String>());
      }
    } catch (e) {
      debugPrint('MasteryService: Error loading — $e');
    }
  }

  Future<void> markAsLearning(String skillId) async {
    final record = _records[skillId];
    if (record != null && record.status == NodeStatus.unseen) {
      record.status = NodeStatus.masteredTemp;
      record.masteryCount = 1;
      record.nextReview = DateTime.now().add(MasteryRecord.review1Delay);
      _records[skillId] = record;
      await _saveToStorage();
      notifyListeners();
    }
  }

  Future<void> resetAll() async {
    _records.clear();
    _totalXp = 0;
    _currentStreak = 0;
    _earnedBadges.clear();
    _lastActivityDate = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    await initialize();
  }

  // =============================================
  // تحديد نقطة الدخول من اختبار التشخيص
  // يجعل العقدة قابلة للفتح دون منح إتقان حقيقي
  // =============================================
  Future<void> setEntryPoint(String skillId) async {
    final record = _records[skillId];
    if (record != null && record.status == NodeStatus.unseen) {
      record.status = NodeStatus.learning; // مفتوح لكن غير مُتقَن
      _records[skillId] = record;
      await _saveToStorage();
      notifyListeners();
    }
  }
}
