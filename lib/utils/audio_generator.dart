// ====================================================
// utils/audio_generator.dart
// مولّد المؤثرات الصوتية للواجهة (Pure PCM WAV Generator)
// ====================================================

import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class AudioGenerator {
  static Future<void> generateIfMissing() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final sounds = {
        'correct_answer.wav': _generateBeep(freqStart: 440, freqEnd: 880, durationMs: 250),
        'wrong_answer.wav': _generateBeep(freqStart: 440, freqEnd: 220, durationMs: 250),
        'celebration.wav': _generateChime(durationMs: 500),
        'tap.wav': _generateBeep(freqStart: 1000, freqEnd: 1000, durationMs: 40),
        'streak.wav': _generateBeep(freqStart: 523, freqEnd: 659, durationMs: 300),
      };

      for (final entry in sounds.entries) {
        final file = File('${dir.path}/${entry.key}');
        if (!await file.exists()) {
          await file.writeAsBytes(entry.value);
          debugPrint('🎵 AudioGenerator: Generated ${entry.key}');
        }
      }
    } catch (e) {
      debugPrint('⚠️ AudioGenerator error: $e');
    }
  }

  static Uint8List _generateBeep({
    required double freqStart,
    required double freqEnd,
    required int durationMs,
  }) {
    const int sampleRate = 22050;
    final int numSamples = (sampleRate * durationMs / 1000).round();
    final ByteData buffer = ByteData(44 + numSamples * 2);

    // WAV Header
    _writeString(buffer, 0, 'RIFF');
    buffer.setUint32(4, 36 + numSamples * 2, Endian.little);
    _writeString(buffer, 8, 'WAVE');
    _writeString(buffer, 12, 'fmt ');
    buffer.setUint32(16, 16, Endian.little); // Subchunk1Size
    buffer.setUint16(20, 1, Endian.little);  // AudioFormat (PCM)
    buffer.setUint16(22, 1, Endian.little);  // NumChannels (1)
    buffer.setUint32(24, sampleRate, Endian.little); // SampleRate
    buffer.setUint32(28, sampleRate * 2, Endian.little); // ByteRate
    buffer.setUint16(32, 2, Endian.little);  // BlockAlign
    buffer.setUint16(34, 16, Endian.little); // BitsPerSample
    _writeString(buffer, 36, 'data');
    buffer.setUint32(40, numSamples * 2, Endian.little);

    // Audio PCM samples
    double phase = 0.0;
    for (int i = 0; i < numSamples; i++) {
      final double progress = i / numSamples;
      final double freq = freqStart + (freqEnd - freqStart) * progress;
      final double sample = sin(phase);
      phase += 2.0 * pi * freq / sampleRate;

      // Envelope fade out
      final double envelope = 1.0 - progress;
      final int pcm = (sample * envelope * 28000).toInt().clamp(-32768, 32767);
      buffer.setInt16(44 + i * 2, pcm, Endian.little);
    }

    return buffer.buffer.asUint8List();
  }

  static Uint8List _generateChime({required int durationMs}) {
    const int sampleRate = 22050;
    final int numSamples = (sampleRate * durationMs / 1000).round();
    final ByteData buffer = ByteData(44 + numSamples * 2);

    _writeString(buffer, 0, 'RIFF');
    buffer.setUint32(4, 36 + numSamples * 2, Endian.little);
    _writeString(buffer, 8, 'WAVE');
    _writeString(buffer, 12, 'fmt ');
    buffer.setUint32(16, 16, Endian.little);
    buffer.setUint16(20, 1, Endian.little);
    buffer.setUint16(22, 1, Endian.little);
    buffer.setUint32(24, sampleRate, Endian.little);
    buffer.setUint32(28, sampleRate * 2, Endian.little);
    buffer.setUint16(32, 2, Endian.little);
    buffer.setUint16(34, 16, Endian.little);
    _writeString(buffer, 36, 'data');
    buffer.setUint32(40, numSamples * 2, Endian.little);

    final List<double> notes = [523.25, 659.25, 783.99]; // C5, E5, G5
    double phase1 = 0, phase2 = 0, phase3 = 0;

    for (int i = 0; i < numSamples; i++) {
      final double progress = i / numSamples;
      final double sample1 = sin(phase1);
      final double sample2 = sin(phase2);
      final double sample3 = sin(phase3);

      phase1 += 2.0 * pi * notes[0] / sampleRate;
      phase2 += 2.0 * pi * notes[1] / sampleRate;
      phase3 += 2.0 * pi * notes[2] / sampleRate;

      final double mix = (sample1 + sample2 + sample3) / 3.0;
      final double envelope = 1.0 - progress;
      final int pcm = (mix * envelope * 28000).toInt().clamp(-32768, 32767);
      buffer.setInt16(44 + i * 2, pcm, Endian.little);
    }

    return buffer.buffer.asUint8List();
  }

  static void _writeString(ByteData data, int offset, String value) {
    for (int i = 0; i < value.length; i++) {
      data.setUint8(offset + i, value.codeUnitAt(i));
    }
  }
}
