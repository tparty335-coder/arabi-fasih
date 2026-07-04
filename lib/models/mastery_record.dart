// ====================================================
// models/mastery_record.dart
// سجل الإتقان المحلي — يُخزَّن في JSON على الجهاز
// ====================================================

import 'dart:convert';
import 'skill_node.dart';

class AttemptRecord {
  final DateTime timestamp;
  final bool isCorrect;
  final int responseTimeMs;
  final String? wrongChoice; // ماذا اختار بدلاً من الصح؟

  AttemptRecord({
    required this.timestamp,
    required this.isCorrect,
    required this.responseTimeMs,
    this.wrongChoice,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'is_correct': isCorrect,
        'response_time_ms': responseTimeMs,
        'wrong_choice': wrongChoice,
      };

  factory AttemptRecord.fromJson(Map<String, dynamic> json) => AttemptRecord(
        timestamp: DateTime.parse(json['timestamp']),
        isCorrect: json['is_correct'],
        responseTimeMs: json['response_time_ms'],
        wrongChoice: json['wrong_choice'],
      );
}

class MasteryRecord {
  final String skillId;
  NodeStatus status;
  List<AttemptRecord> attempts;
  int correctStreak;       // إجابات صحيحة متتالية في الجلسة الحالية
  int masteryCount;        // عدد جلسات الإتقان الناجحة (هدف: 3)
  DateTime? nextReview;    // موعد المراجعة القادمة
  int confusionCount;      // عدد ضغطات "لم أفهم"

  MasteryRecord({
    required this.skillId,
    this.status = NodeStatus.unseen,
    List<AttemptRecord>? attempts,
    this.correctStreak = 0,
    this.masteryCount = 0,
    this.nextReview,
    this.confusionCount = 0,
  }) : attempts = attempts ?? [];

  // =============================================
  // قواعد الإتقان (من Learning Bible)
  // =============================================
  static const int requiredCorrectInSession = 2;  // 2/3 لإتقان مؤقت
  static const int requiredMasterySessions = 3;    // 3 جلسات ناجحة = إتقان نهائي
  static const Duration review1Delay = Duration(hours: 24);
  static const Duration review2Delay = Duration(days: 7);

  /// سجّل محاولة جديدة وحدّث الحالة
  void recordAttempt(bool isCorrect, int responseTimeMs, {String? wrongChoice}) {
    attempts.add(AttemptRecord(
      timestamp: DateTime.now(),
      isCorrect: isCorrect,
      responseTimeMs: responseTimeMs,
      wrongChoice: wrongChoice,
    ));

    if (isCorrect) {
      correctStreak++;
    } else {
      correctStreak = 0;
    }
    // ✅ FIX: استدعِ دائماً بعد كل محاولة (سواء صح أو خطأ)
    _checkMasteryAdvance();
  }

  /// هل هذه الجلسة انتهت؟ (3 محاولات)
  bool get isSessionComplete {
    // آخر 3 محاولات
    if (attempts.length < 3) return false;
    final lastThree = attempts.sublist(attempts.length - 3);
    return lastThree.every((a) => true); // كل محاولة = تفاعل واحد
  }

  /// هل أتقن هذه الجلسة؟ (2 من آخر 3 صح)
  bool get isSessionMastered {
    if (attempts.length < 3) return false;
    final lastThree = attempts.sublist(attempts.length - 3);
    final correctCount = lastThree.where((a) => a.isCorrect).length;
    return correctCount >= requiredCorrectInSession;
  }

  void _checkMasteryAdvance() {
    if (!isSessionMastered) return;

    switch (status) {
      case NodeStatus.unseen:
      case NodeStatus.learning:
        status = NodeStatus.masteredTemp;
        nextReview = DateTime.now().add(review1Delay);
        masteryCount = 1;
        break;
      case NodeStatus.review1:
        status = NodeStatus.review2;
        nextReview = DateTime.now().add(review2Delay);
        masteryCount = 2;
        break;
      case NodeStatus.review2:
        status = NodeStatus.masteredFinal;
        masteryCount = 3;
        nextReview = null;
        break;
      default:
        break;
    }
  }

  /// هل حان وقت المراجعة؟
  bool get isDueForReview {
    if (nextReview == null) return false;
    return DateTime.now().isAfter(nextReview!);
  }

  /// سجّل ضغط "لم أفهم"
  void recordConfusion() => confusionCount++;

  Map<String, dynamic> toJson() => {
        'skill_id': skillId,
        'status': status.name,
        'attempts': attempts.map((a) => a.toJson()).toList(),
        'correct_streak': correctStreak,
        'mastery_count': masteryCount,
        'next_review': nextReview?.toIso8601String(),
        'confusion_count': confusionCount,
      };

  factory MasteryRecord.fromJson(Map<String, dynamic> json) => MasteryRecord(
        skillId: json['skill_id'],
        status: NodeStatus.values.firstWhere((s) => s.name == json['status']),
        attempts: (json['attempts'] as List)
            .map((a) => AttemptRecord.fromJson(a))
            .toList(),
        correctStreak: json['correct_streak'] ?? 0,
        masteryCount: json['mastery_count'] ?? 0,
        nextReview: json['next_review'] != null
            ? DateTime.parse(json['next_review'])
            : null,
        confusionCount: json['confusion_count'] ?? 0,
      );
}


