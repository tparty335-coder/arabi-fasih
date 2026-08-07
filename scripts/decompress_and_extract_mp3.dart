// ====================================================
// scripts/decompress_and_extract_mp3.dart
// فك ضغط zlib لملفات CWS SWF واستخراج إطارات MP3 البشرية الأصلية
// ====================================================
// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

void main() async {
  print('🎧 بدء فك ضغط CWS SWF واستخراج الملفات الصوتية البشرية...');

  final String swfDirPath = r'd:\Projects\faseeh\assets\audio\letters\meem_swfs';
  final String mp3OutDirPath = r'd:\Projects\faseeh\assets\audio\letters\meem_mp3s';

  final swfDir = Directory(swfDirPath);
  if (!await swfDir.exists()) {
    print('❌ المجلد غير موجود: $swfDirPath');
    return;
  }

  final mp3OutDir = Directory(mp3OutDirPath);
  if (!await mp3OutDir.exists()) {
    await mp3OutDir.create(recursive: true);
  }

  final swfFiles = swfDir.listSync().whereType<File>().where((f) => f.path.endsWith('.swf')).toList();
  print('📁 تم العثور على ${swfFiles.length} ملفات SWF حقيقية.');

  int totalMp3Extracted = 0;

  for (final swfFile in swfFiles) {
    try {
      final cwsBytes = await swfFile.readAsBytes();
      if (cwsBytes.length < 8) continue;

      // Header: CWS (3 bytes), version (1 byte), length (4 bytes)
      final compressedData = cwsBytes.sublist(8);

      // Decompress with ZLib
      Uint8List uncompressedSwf;
      try {
        uncompressedSwf = Uint8List.fromList(zlib.decode(compressedData));
      } catch (e) {
        print('⚠️ خطأ فك ضغط zlib في ${swfFile.path}: $e');
        continue;
      }

      print('🔓 فك ضغط ${swfFile.path}: تم الحصول على ${uncompressedSwf.length} بايت من الكود البصري والصوتي');

      // Now scan uncompressed SWF for MP3 frames or Sound tags
      final mp3List = _scanForMp3Frames(uncompressedSwf);
      final swfBasename = swfFile.uri.pathSegments.last.replaceAll('.swf', '');

      for (int i = 0; i < mp3List.length; i++) {
        final mp3Data = mp3List[i];
        if (mp3Data.length >= 8192) { // 8KB minimum for a real voice sample
          final outFile = File('$mp3OutDirPath/${swfBasename}_voice_$i.mp3');
          await outFile.writeAsBytes(mp3Data);
          print('   🎵 تم استخراج صوت بشري نقي: ${outFile.path} (${mp3Data.length} بايت)');
          totalMp3Extracted++;
        }
      }
    } catch (e) {
      print('⚠️ خطأ في معالجة ${swfFile.path}: $e');
    }
  }

  print('🎉 تم بحمد الله استخراج $totalMp3Extracted ملفات صوتية بشرية حقيقية في $mp3OutDirPath');
}

/// ينقب عن إطارات MP3 المتتالية داخل البايتات غير المضغوطة
List<Uint8List> _scanForMp3Frames(Uint8List bytes) {
  List<Uint8List> results = [];
  int i = 0;
  final int len = bytes.length;

  while (i < len - 4) {
    // Check MP3 Frame Sync: 11 bits set -> 0xFF followed by (byte & 0xE0) == 0xE0
    // Common MPEG 1/2 Layer 3 headers start with 0xFF 0xFB, 0xFF 0xF3, 0xFF 0xF2, 0xFF 0xFA
    if (bytes[i] == 0xFF && (bytes[i + 1] & 0xE0) == 0xE0) {
      int start = i;
      int end = i;

      // Scan continuous stream of MP3 frames
      while (end < len - 4) {
        if (bytes[end] == 0xFF && (bytes[end + 1] & 0xE0) == 0xE0) {
          end += 2; // Jump frame boundary
        } else {
          break;
        }
      }

      final streamLen = end - start;
      if (streamLen >= 8192) { // Audio sample bigger than 8KB
        results.add(bytes.sublist(start, end));
        i = end;
        continue;
      }
    }
    i++;
  }

  return results;
}
