// ====================================================
// scripts/extract_all_letters.dart
// استخراج واستخراج ملفات SWF والصوتيات من أرشيفات EXE
// ====================================================
// ignore_for_file: avoid_print

import 'dart:io';
import 'package:archive/archive.dart';

void main() async {
  print('🚀 تشريح الأسطوانة والبحث عن ملفات SWF والصوتيات...');

  final String sourceDirPath = r'D:\Education  vol2\مناهج 2026\ص1         ت1';
  final String targetDirPath = r'd:\Projects\faseeh\assets\audio\letters';

  final sourceDir = Directory(sourceDirPath);
  final exeFiles = sourceDir.listSync().whereType<File>().where((f) => f.path.toLowerCase().endsWith('.exe')).toList();

  int totalSwfExtracted = 0;
  int totalAudioExtracted = 0;

  for (final exeFile in exeFiles) {
    final fileName = exeFile.uri.pathSegments.last;

    try {
      final bytes = await exeFile.readAsBytes();

      // ابحث عن كل بداية ZIP header PK\x03\x04
      for (int i = 0; i < bytes.length - 4; i++) {
        if (bytes[i] == 0x50 && bytes[i + 1] == 0x4B && bytes[i + 2] == 0x03 && bytes[i + 3] == 0x04) {
          try {
            final zipBytes = bytes.sublist(i);
            final archive = ZipDecoder().decodeBytes(zipBytes);

            for (final file in archive) {
              if (!file.isFile) continue;
              final nameLower = file.name.toLowerCase();
              final data = file.content as List<int>;

              if (nameLower.endsWith('.swf')) {
                totalSwfExtracted++;
                final extractedMp3s = _extractMp3FromSwf(data);
                for (int j = 0; j < extractedMp3s.length; j++) {
                  final mp3File = File('$targetDirPath/${file.name}_$j.mp3');
                  await mp3File.parent.create(recursive: true);
                  await mp3File.writeAsBytes(extractedMp3s[j]);
                  totalAudioExtracted++;
                }
              } else if (nameLower.endsWith('.mp3') || nameLower.endsWith('.wav')) {
                final audioFile = File('$targetDirPath/${file.name}');
                await audioFile.parent.create(recursive: true);
                await audioFile.writeAsBytes(data);
                totalAudioExtracted++;
              }
            }
          } catch (_) {
            // استمر بالبحث عن أرشيفات أخرى إن وجدت
          }
        }
      }
    } catch (e) {
      print('⚠️ خطأ في معالجة $fileName: $e');
    }
  }

  print('✅ تم استخراج $totalSwfExtracted ملفات SWF و $totalAudioExtracted ملفات صوتية MP3!');
}

/// يستخرج إطارات MP3 المباشرة من بايتات SWF
List<List<int>> _extractMp3FromSwf(List<int> bytes) {
  List<List<int>> mp3Files = [];
  int i = 0;
  while (i < bytes.length - 3) {
    // MP3 Frame sync: 11 bits set (0xFF followed by 0xFB/0xF3/0xFA/0xF2)
    if (bytes[i] == 0xFF && (bytes[i + 1] & 0xE0) == 0xE0) {
      int start = i;
      int end = i + 1024;
      while (end < bytes.length - 2) {
        if (bytes[end] == 0xFF && (bytes[end + 1] & 0xE0) == 0xE0) {
          end += 512;
        } else {
          break;
        }
      }
      if (end - start > 4096) { // الصوت الحقيقي أكبر من 4KB
        mp3Files.add(bytes.sublist(start, end));
        i = end;
        continue;
      }
    }
    i++;
  }
  return mp3Files;
}
