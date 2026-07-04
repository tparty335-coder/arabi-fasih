// ====================================================
// services/tts_service.dart
// خدمة النطق — Text-to-Speech للغة العربية
// ====================================================

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await _tts.setLanguage('ar-SA');
      await _tts.setSpeechRate(0.45);   // بطيء للتعلم
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _isInitialized = true;
    } catch (e) {
      debugPrint('TtsService: init error — $e');
    }
  }

  /// انطق نصاً عربياً
  Future<void> speak(String text) async {
    if (!_isInitialized) await initialize();
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TtsService: speak error — $e');
    }
  }

  /// انطق حرفاً + حركة (مثال: "بَ")
  Future<void> speakLetter(String letter) async {
    await speak(letter);
  }

  /// انطق كلمة كاملة
  Future<void> speakWord(String word) async {
    await speak(word);
  }

  /// انطق جملة تعليمية
  Future<void> speakInstruction(String text) async {
    if (!_isInitialized) await initialize();
    try {
      await _tts.setSpeechRate(0.5);
      await speak(text);
      await _tts.setSpeechRate(0.45);
    } catch (e) {
      debugPrint('TtsService: instruction error — $e');
    }
  }

  Future<void> stop() async {
    try { await _tts.stop(); } catch (_) {}
  }
}
