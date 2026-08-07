// ====================================================
// services/tts_service.dart
// خدمة الصوت والنطق الهجينة — Hybrid Audio & TTS Engine
// ====================================================
//
// المعمارية:
// 1. Convention-Based Asset Lookup: يبحث عن ملف صوتي في
//    assets/audio/letters/{letter_name}_{vowel}.mp3
//    بدلاً من خريطة يدوية. هذا يعني أن إضافة صوت حرف جديد
//    تحتاج فقط لوضع الملف في المجلد الصحيح.
//
// 2. AudioPlayer (من audioplayers): يُشغّل الأصوات المسجلة
//    الاحترافية فعلياً (لا مجرد debugPrint).
//
// 3. FlutterTts Fallback: إذا لم يوجد ملف صوتي مسجل،
//    يسقط تلقائياً لمحرك TTS المدمج في الجهاز.
// ====================================================

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;

  static const Map<String, String> _letterFileNames = {
    'ب': 'ba', 'ت': 'ta', 'ث': 'tha', 'ج': 'ja', 'ح': 'ha',
    'خ': 'kha', 'د': 'da', 'ذ': 'dha', 'ر': 'ra', 'ز': 'za',
    'س': 'sa', 'ش': 'sha', 'ص': 'sad', 'ض': 'dad', 'ط': 'tah',
    'ظ': 'dhah', 'ع': 'ain', 'غ': 'ghain', 'ف': 'fa', 'ق': 'qaf',
    'ك': 'kaf', 'ل': 'lam', 'م': 'mim', 'ن': 'nun', 'هـ': 'ha2',
    'ه': 'ha2', 'و': 'waw', 'ي': 'ya', 'أ': 'hamza', 'ا': 'alif',
    'ء': 'hamza',
  };

  static const Map<String, String> _vowelSuffixes = {
    'َ': 'fatha', 'ِ': 'kasra', 'ُ': 'damma',
  };

  final Set<String> _existingAssets = {};
  bool _assetCacheBuilt = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await _tts.setLanguage('ar-SA');
      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _isInitialized = true;
    } catch (e) {
      debugPrint('TtsService: init error — $e');
    }
  }

  Future<void> _buildAssetCache() async {
    if (_assetCacheBuilt) return;

    for (final letterEntry in _letterFileNames.entries) {
      for (final vowelEntry in _vowelSuffixes.entries) {
        final path = 'assets/audio/letters/${letterEntry.value}_${vowelEntry.value}.mp3';
        try {
          await rootBundle.load(path);
          _existingAssets.add(path);
        } catch (_) {}
      }
      final namePath = 'assets/audio/letters/${letterEntry.value}_name.mp3';
      try {
        await rootBundle.load(namePath);
        _existingAssets.add(namePath);
      } catch (_) {}
    }

    _assetCacheBuilt = true;
  }

  String? _resolveAssetPath(String text) {
    if (text.isEmpty || text.length > 2) return null;

    final letter = text[0];
    final fileName = _letterFileNames[letter];
    if (fileName == null) return null;

    if (text.length == 2) {
      final vowel = text[1];
      final suffix = _vowelSuffixes[vowel];
      if (suffix != null) {
        return 'assets/audio/letters/${fileName}_$suffix.mp3';
      }
    }

    return 'assets/audio/letters/${fileName}_name.mp3';
  }

  Future<void> speak(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    if (!_assetCacheBuilt) await _buildAssetCache();

    final assetPath = _resolveAssetPath(cleanText);
    if (assetPath != null && _existingAssets.contains(assetPath)) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(assetPath.replaceFirst('assets/', '')));
        await _audioPlayer.onPlayerComplete.first.timeout(
          const Duration(seconds: 5),
          onTimeout: () => null,
        );
        return;
      } catch (e) {
        debugPrint('TtsService: Asset play error ($assetPath) — $e');
      }
    }

    if (!_isInitialized) await initialize();
    try {
      await _tts.stop();
      await _tts.speak(cleanText);
    } catch (e) {
      debugPrint('TtsService: TTS speak error — $e');
    }
  }

  Future<void> speakLetter(String letter) async => speak(letter);

  Future<void> speakWord(String word) async => speak(word);

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

  static const Map<String, String> _uiSounds = {
    'correct': 'audio/ui/momtaz.mp3', // "ممتاز" - Native extracted voice
    'wrong': 'audio/ui/hawel.mp3',    // "حاول مرة أخرى" - Native extracted voice
    'complete': 'audio/ui/b2.mp3',    // Native celebration chime
    'badge': 'audio/ui/fnd2.mp3',     // Native badge sound
    'tap': 'audio/ui/momtaz.mp3',     // Fallback to momtaz for tap (tap.wav missing)
  };

  /// تشغيل صوت واجهة المستخدم (UI Sound)
  Future<void> playUiSound(String key) async {
    final assetPath = _uiSounds[key];
    if (assetPath == null) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(assetPath));
      debugPrint('TtsService: ▶ Playing UI sound — $assetPath');
    } catch (e) {
      debugPrint('TtsService: UI sound error ($key) — $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      await _tts.stop();
    } catch (_) {}
  }

  /// تنظيف الموارد عند إغلاق التطبيق
  Future<void> dispose() async {
    await stop();
    await _audioPlayer.dispose();
  }
}
