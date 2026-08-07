// ====================================================
// scripts/extract_meem_node.js
// استخراج دقيق بـ Node.js لملفات CWS SWF والأصوات البشرية
// ====================================================

const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const swfDir = 'd:/Projects/faseeh/assets/audio/letters/meem_swfs';
const outMp3Dir = 'd:/Projects/faseeh/assets/audio/letters/meem';

if (!fs.existsSync(outMp3Dir)) {
  fs.mkdirSync(outMp3Dir, { recursive: true });
}

const files = fs.readdirSync(swfDir).filter(f => f.endsWith('.swf'));
console.log(`🚀 جاري معالجة ${files.length} ملف SWF بـ Node.js zlib...`);

let totalMp3 = 0;

files.forEach((file, index) => {
  const filePath = path.join(swfDir, file);
  const buffer = fs.readFileSync(filePath);

  if (buffer.length < 8) return;

  const header = buffer.slice(0, 8);
  const compressed = buffer.slice(8);

  let decompressed;
  try {
    // Try inflate / unzip
    decompressed = zlib.inflateSync(compressed);
  } catch (e1) {
    try {
      decompressed = zlib.inflateRawSync(compressed);
    } catch (e2) {
      try {
        decompressed = zlib.unzipSync(compressed);
      } catch (e3) {
        console.log(`⚠️ فشل فك الضغط لـ ${file}: ${e3.message}`);
        return;
      }
    }
  }

  console.log(`✅ فك ضغط ${file} بنجاح! الحجم غير المضغوط: ${decompressed.length} بايت`);

  // Save uncompressed FWS SWF
  const fwsHeader = Buffer.from([0x46, 0x57, 0x53, header[3], header[4], header[5], header[6], header[7]]);
  const fullFwsSwf = Buffer.concat([fwsHeader, decompressed]);
  fs.writeFileSync(path.join(outMp3Dir, `meem_uncompressed_${index}.swf`), fullFwsSwf);

  // Scan decompressed payload for MP3 frames or Sound chunks
  // MP3 Sync Word: 0xFF 0xFB, 0xFF 0xF3, 0xFF 0xF2, 0xFF 0xE3, 0xFF 0xF0
  let i = 0;
  while (i < decompressed.length - 4) {
    if (decompressed[i] === 0xFF && (decompressed[i + 1] & 0xE0) === 0xE0) {
      const start = i;
      let end = i + 4;
      while (end < decompressed.length - 2) {
        if (decompressed[end] === 0xFF && (decompressed[end + 1] & 0xE0) === 0xE0) {
          end += 512;
        } else {
          break;
        }
      }

      const streamLen = end - start;
      if (streamLen > 4096) { // More than 4KB audio
        const mp3Buffer = decompressed.slice(start, end);
        const mp3Name = `meem_audio_${index}_${totalMp3}.mp3`;
        fs.writeFileSync(path.join(outMp3Dir, mp3Name), mp3Buffer);
        console.log(`   🎵 تم استخراج صوت بشري حقيقي: ${mp3Name} (${mp3Buffer.length} بايت)`);
        totalMp3++;
        i = end;
        continue;
      }
    }
    i++;
  }
});

console.log(`🎉 النتيجة الفعالية: تم استخراج ${totalMp3} ملف صوتي بشري حقيقي لحرف الميم!`);
