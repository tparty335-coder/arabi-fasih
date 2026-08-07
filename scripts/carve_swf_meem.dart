// ====================================================
// scripts/carve_swf_meem.dart
// استخراج واستخراج ملفات SWF الحقيقية من بايتات EXE (CWS/FWS)
// ====================================================
// ignore_for_file: avoid_print

import 'dart:io';


void main() async {
  print('🔬 بدء المسح الثنائي العميق عن تواقيع SWF (FWS / CWS / ZWS)...');

  final String meemPath = r'D:\Education  vol2\مناهج 2026\ص1         ت1\arabic_1prim_t1_م.exe';
  final String outDirPath = r'd:\Projects\faseeh\assets\audio\letters\meem_swfs';

  final meemFile = File(meemPath);
  if (!await meemFile.exists()) {
    print('❌ لم يتم العثور على الملف: $meemPath');
    return;
  }

  final outDir = Directory(outDirPath);
  if (!await outDir.exists()) {
    await outDir.create(recursive: true);
  }

  final bytes = await meemFile.readAsBytes();
  print('📊 تم تحميل $meemPath (${bytes.length} بايت)');

  int swfCount = 0;
  for (int i = 0; i < bytes.length - 8; i++) {
    // Check magic bytes: CWS (0x43, 0x57, 0x53) or FWS (0x46, 0x57, 0x53)
    final b0 = bytes[i];
    final b1 = bytes[i + 1];
    final b2 = bytes[i + 2];

    final isCws = (b0 == 0x43 && b1 == 0x57 && b2 == 0x53);
    final isFws = (b0 == 0x46 && b1 == 0x57 && b2 == 0x53);
    final isZws = (b0 == 0x5A && b1 == 0x57 && b2 == 0x53);

    if (isCws || isFws || isZws) {
      final version = bytes[i + 3];
      // Valid SWF versions are usually 1 to 50
      if (version < 1 || version > 50) continue;

      // Read length (4 bytes Little Endian)
      final length = bytes[i + 4] |
          (bytes[i + 5] << 8) |
          (bytes[i + 6] << 16) |
          (bytes[i + 7] << 24);

      // SWF length should be reasonable (e.g. > 1000 bytes and <= bytes.length - i)
      if (length < 1000 || length > 15000000) continue;

      print('🎉 تم اكتشاف ${isCws ? "CWS" : isFws ? "FWS" : "ZWS"} v$version في الأوفست: 0x${i.toRadixString(16).toUpperCase()} الطول المصرح: $length بايت');

      // Carve out SWF file bytes
      final swfEnd = (i + length <= bytes.length) ? i + length : bytes.length;
      final swfBytes = bytes.sublist(i, swfEnd);

      final typeStr = isCws ? 'CWS' : isFws ? 'FWS' : 'ZWS';
      final swfFile = File('$outDirPath/meem_${swfCount}_${typeStr}_v$version.swf');
      await swfFile.writeAsBytes(swfBytes);
      print('   💾 تم الحفظ: ${swfFile.path} (${swfBytes.length} بايت)');

      swfCount++;
      // Skip ahead to avoid duplicate carving of inner bytes
      i += (length > 100 ? length - 1 : 10);
    }
  }

  print('✅ اكتمل المسح الثنائي: تم استخراج $swfCount ملفات SWF حقيقية في $outDirPath');
}
