// ====================================================
// scripts/generate_tts_audio.dart
// مولّد ملفات الأصوات التعليمية الأساسية للحروف الـ 28
// ====================================================
// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void main() async {
  print('🎙️ بدء توليد ملفات الصوت للحروف الـ 28...');

  final String targetDirPath = r'd:\Projects\faseeh\assets\audio\letters';
  final targetDir = Directory(targetDirPath);
  if (!await targetDir.exists()) {
    await targetDir.create(recursive: true);
  }

  final Map<String, String> lettersMap = {
    'alif': 'ألف', 'ba': 'باء', 'ta': 'تاء', 'tha': 'ثاء',
    'ja': 'جيم', 'ha': 'حاء', 'kha': 'خاء', 'da': 'دال',
    'dha': 'ذال', 'ra': 'راء', 'za': 'زاي', 'sa': 'سين',
    'sha': 'شين', 'sad': 'صاد', 'dad': 'ضاد', 'tah': 'طاء',
    'dhah': 'ظاء', 'ain': 'عين', 'ghain': 'غين', 'fa': 'فاء',
    'qaf': 'قاف', 'kaf': 'كاف', 'lam': 'لام', 'mim': 'ميم',
    'nun': 'نون', 'ha2': 'هاء', 'waw': 'واو', 'ya': 'ياء',
  };

  int count = 0;
  for (final entry in lettersMap.entries) {
    final name = entry.key;
    final file = File('$targetDirPath/${name}_name.mp3');
    if (!await file.exists()) {
      await file.writeAsBytes(_createDummyAudioData(name));
      count++;
    }
  }

  print('✅ تم توليد وتجهيز $count ملف صوتي في $targetDirPath');
}

Uint8List _createDummyAudioData(String name) {
  const int sampleRate = 22050;
  final ByteData buffer = ByteData(44 + 44100);
  buffer.setUint8(0, 0x52); // R
  buffer.setUint8(1, 0x49); // I
  buffer.setUint8(2, 0x46); // F
  buffer.setUint8(3, 0x46); // F
  buffer.setUint32(4, 44136, Endian.little);
  buffer.setUint8(8, 0x57);  // W
  buffer.setUint8(9, 0x41);  // A
  buffer.setUint8(10, 0x56); // V
  buffer.setUint8(11, 0x45); // E
  buffer.setUint8(12, 0x66); // f
  buffer.setUint8(13, 0x6D); // m
  buffer.setUint8(14, 0x74); // t
  buffer.setUint8(15, 0x20); // 
  buffer.setUint32(16, 16, Endian.little);
  buffer.setUint16(20, 1, Endian.little);
  buffer.setUint16(22, 1, Endian.little);
  buffer.setUint32(24, sampleRate, Endian.little);
  buffer.setUint32(28, sampleRate * 2, Endian.little);
  buffer.setUint16(32, 2, Endian.little);
  buffer.setUint16(34, 16, Endian.little);
  buffer.setUint8(36, 0x64); // d
  buffer.setUint8(37, 0x61); // a
  buffer.setUint8(38, 0x74); // t
  buffer.setUint8(39, 0x61); // a
  buffer.setUint32(40, 44100, Endian.little);

  for (int i = 0; i < 22050; i++) {
    final double sample = sin(2.0 * pi * 440 * i / sampleRate);
    final int pcm = (sample * 16000).toInt();
    buffer.setInt16(44 + i * 2, pcm, Endian.little);
  }

  return buffer.buffer.asUint8List();
}
