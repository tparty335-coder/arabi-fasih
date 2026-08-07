// scripts/unpack_saf_files.js
// تفكيك واستخراج كافة ملفات SWF والوسائط من حزمة SWFKit SAF
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const overlayPath = 'd:/Projects/faseeh/assets/audio/letters/meem_swfkit/meem_swfkit_overlay.bin';
const outDir = 'd:/Projects/faseeh/assets/audio/letters/meem_extracted_swfs';

fs.mkdirSync(outDir, { recursive: true });
const data = fs.readFileSync(overlayPath);

console.log('🚀 جاري استخراج وتفريغ كافة أصول حرف الميم الـ 29 من حزمة SAF...');

// Known filename offsets from scan
const recordOffsets = [
  0x16b1dc, 0x22b16c, 0x33f248, 0x59dd04, 0x7041f6, 0x777dd2, 0x8df002, 0x95d5ce,
  0x9fd99a, 0xa82312, 0xb169b0, 0xba7c4e, 0xd2a05a, 0xd9a84a, 0x1026e98, 0x109afe6,
  0x11199ae, 0x121c910, 0x130fd42, 0x13ea6b8, 0x14d28da, 0x1536d86, 0x15a8bd2, 0x1622c50,
  0x169a912, 0x1802a96, 0x1c09ab4, 0x1c7bb18, 0x1cfc2c2
];

let extractedCount = 0;

recordOffsets.forEach((nameOffset, idx) => {
  // Read string backwards or forwards
  let nameEnd = nameOffset;
  while (data[nameEnd] !== 0x00 || data[nameEnd + 1] !== 0x00) {
    nameEnd += 2;
  }
  const fileName = data.slice(nameOffset, nameEnd).toString('utf16le');

  // Examine bytes before and after filename for file size and offset fields
  // In SWFKit SAF, right after the name (and padding) comes:
  // - 4 bytes: Uncompressed size
  // - 4 bytes: Compressed size
  // - Data payload!
  // Or immediately following the header byte sequence `CWS` or `FWS`
  const searchStart = nameEnd + 2;
  const cwsIndex = data.indexOf(Buffer.from('CWS'), searchStart);
  const fwsIndex = data.indexOf(Buffer.from('FWS'), searchStart);

  let swfStart = -1;
  if (cwsIndex !== -1 && fwsIndex !== -1) {
    swfStart = Math.min(cwsIndex, fwsIndex);
  } else if (cwsIndex !== -1) {
    swfStart = cwsIndex;
  } else if (fwsIndex !== -1) {
    swfStart = fwsIndex;
  }

  if (swfStart !== -1 && swfStart - nameOffset < 200) {
    const isCws = data[swfStart] === 0x43;
    const version = data[swfStart + 3];
    const declaredSize = data.readUInt32LE(swfStart + 4);

    console.log(`\n[#${idx + 1}] استخراج "${fileName}": نوع SWF = ${isCws ? 'CWS' : 'FWS'} v${version}, الحجم المصرح = ${declaredSize} بايت (الأوفست: 0x${swfStart.toString(16)})`);

    let swfBuffer;
    if (isCws) {
      // Decompress CWS payload starting at swfStart + 8
      const compressedPayload = data.slice(swfStart + 8, swfStart + 8 + declaredSize);
      try {
        const decompressedBody = zlib.inflateSync(compressedPayload);
        const fwsHeader = Buffer.from([0x46, 0x57, 0x53, version, data[swfStart + 4], data[swfStart + 5], data[swfStart + 6], data[swfStart + 7]]);
        swfBuffer = Buffer.concat([fwsHeader, decompressedBody]);
        console.log(`   🔓 تم فك الضغط بنجاح! الحجم النهائي: ${swfBuffer.length} بايت`);
      } catch (err) {
        // Try raw inflate
        try {
          const decompressedBody = zlib.inflateRawSync(compressedPayload);
          const fwsHeader = Buffer.from([0x46, 0x57, 0x53, version, data[swfStart + 4], data[swfStart + 5], data[swfStart + 6], data[swfStart + 7]]);
          swfBuffer = Buffer.concat([fwsHeader, decompressedBody]);
          console.log(`   🔓 تم فك الضغط بـ raw inflate بنجاح! الحجم النهائي: ${swfBuffer.length} بايت`);
        } catch (err2) {
          console.log(`   ⚠️ خطأ فك الضغط: ${err2.message}`);
        }
      }
    } else {
      swfBuffer = data.slice(swfStart, swfStart + declaredSize);
    }

    if (swfBuffer) {
      const targetPath = path.join(outDir, fileName);
      fs.writeFileSync(targetPath, swfBuffer);
      console.log(`   💾 تم الحفظ بنجاح: ${targetPath}`);
      extractedCount++;
    }
  }
});

console.log(`\n🎉 النتيجة النهائية: تم استخراج ${extractedCount} من أصل 29 ملف SWF تعليمي لحرف الميم!`);
