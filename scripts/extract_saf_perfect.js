// scripts/extract_saf_perfect.js
// المستخرج التام والرسمي لأصول أسطوانة حرف الميم من حزمة SWFKit SAF
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const overlayPath = 'd:/Projects/faseeh/assets/audio/letters/meem_swfkit/meem_swfkit_overlay.bin';
const outSwfDir = 'd:/Projects/faseeh/assets/audio/letters/meem_swfs_extracted';

fs.mkdirSync(outSwfDir, { recursive: true });
const data = fs.readFileSync(overlayPath);

console.log('🚀 بدء الفك التام والكامل لأرشيف SWFKit SAF لحرف الميم...');

// Search for all asset filenames ending with .swf\0
let extractedCount = 0;
let pos = 4;

while (pos < data.length - 32) {
  // UTF-16LE '.swf\0' -> 2E 00 73 00 77 00 66 00 00 00
  if (data[pos] === 0x2E && data[pos + 1] === 0x00 &&
      data[pos + 2] === 0x73 && data[pos + 3] === 0x00 &&
      data[pos + 4] === 0x77 && data[pos + 5] === 0x00 &&
      data[pos + 6] === 0x66 && data[pos + 7] === 0x00 &&
      data[pos + 8] === 0x00 && data[pos + 9] === 0x00) {

    // Find start of UTF-16 string
    let nameStart = pos;
    while (nameStart > 4 && (data[nameStart - 2] !== 0x00 || data[nameStart - 1] !== 0x00)) {
      nameStart -= 2;
    }

    const nameBuf = data.slice(nameStart, pos + 8);
    const fileName = nameBuf.toString('utf16le');

    // Right after .swf\0\0 (offset pos + 10) is 4-byte LE compressed size
    const compressedSizeOffset = pos + 10;
    const compressedSize = data.readUInt32LE(compressedSizeOffset);

    // Zlib data starts at compressedSizeOffset + 4
    const zlibOffset = compressedSizeOffset + 4;
    const zlibHeaderHex = data.slice(zlibOffset, zlibOffset + 2).toString('hex');

    console.log(`\n📦 [#${extractedCount + 1}] إدخال SAF: "${fileName}"`);
    console.log(`   الأوفست: 0x${nameStart.toString(16)} | حجم الضغط: ${compressedSize} بايت | التوقيع: ${zlibHeaderHex}`);

    if (compressedSize > 1000 && compressedSize < 10000000 && zlibOffset + compressedSize <= data.length) {
      const compressedPayload = data.slice(zlibOffset, zlibOffset + compressedSize);
      try {
        const decompressedBody = zlib.inflateSync(compressedPayload);
        console.log(`   🔓 تم فك الضغط بنجاح بـ Zlib! الحجم المستخرج: ${decompressedBody.length} بايت`);

        const swfPath = path.join(outSwfDir, fileName);
        fs.writeFileSync(swfPath, decompressedBody);
        console.log(`   💾 تم حصد وتخزين ملف SWF النقي: ${fileName}`);
        extractedCount++;
      } catch (err) {
        console.log(`   ⚠️ خطأ فك الضغط: ${err.message}`);
      }
    }

    pos = zlibOffset + compressedSize;
    continue;
  }
  pos += 2;
}

console.log(`\n🎉 النتيجة النهائية: تم استخراج وتفكيك ${extractedCount} ملفات SWF تعليمية حقيقية 100%!`);
