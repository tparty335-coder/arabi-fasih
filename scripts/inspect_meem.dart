// ====================================================
// scripts/inspect_meem.dart
// فحص وتفكيك ملف حرف الميم المستخرج حديثاً
// ====================================================
// ignore_for_file: avoid_print

import 'dart:io';
import 'package:archive/archive.dart';

void main() async {
  print('🔍 جاري فحص وتشريح ملف حرف الميم (arabic_1prim_t1_م.exe)...');

  final String meemPath = r'D:\Education  vol2\مناهج 2026\ص1         ت1\arabic_1prim_t1_م.exe';
  final String outputDir = r'd:\Projects\faseeh\assets\audio\letters\meem_extracted';

  final meemFile = File(meemPath);
  if (!await meemFile.exists()) {
    print('❌ لم يتم العثور على ملف حرف الميم في: $meemPath');
    return;
  }

  print('📦 حجم ملف حرف الميم: ${(await meemFile.length()) / (1024 * 1024)} MB');

  final bytes = await meemFile.readAsBytes();
  int zipHeaderIndex = -1;

  for (int i = 0; i < bytes.length - 4; i++) {
    if (bytes[i] == 0x50 && bytes[i + 1] == 0x4B && bytes[i + 2] == 0x03 && bytes[i + 3] == 0x04) {
      zipHeaderIndex = i;
      break;
    }
  }

  if (zipHeaderIndex != -1) {
    print('✅ تم العثور على أرشيف ZIP مدمج في البايت: $zipHeaderIndex');
    final zipBytes = bytes.sublist(zipHeaderIndex);
    final archive = ZipDecoder().decodeBytes(zipBytes);

    print('📄 محتويات حرف الميم الداخلية:');
    final outDirectory = Directory(outputDir);
    if (!await outDirectory.exists()) await outDirectory.create(recursive: true);

    int fileCount = 0;
    for (final file in archive) {
      print('   - ${file.name} (${file.size} bytes)');
      if (file.isFile) {
        final outFile = File('$outputDir/${file.name}');
        await outFile.parent.create(recursive: true);
        await outFile.writeAsBytes(file.content as List<int>);
        fileCount++;
      }
    }
    print('🎉 تم استخراج $fileCount ملفات من داخل حرف الميم إلى $outputDir');
  } else {
    print('⚠️ لم يتم العثور على ZIP signature مدمج مباشرة في ملف الميم.');
  }
}
