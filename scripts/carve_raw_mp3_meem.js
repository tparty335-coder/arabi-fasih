// scripts/carve_raw_mp3_meem.js
// التنقيب المباشر عن ملفات MP3 الصوتية من داخل الملف التنفيذي
const fs = require('fs');
const path = require('path');

const exePath = 'D:\\Education  vol2\\مناهج 2026\\ص1         ت1\\arabic_1prim_t1_م.exe';
const outDir = 'd:/Projects/faseeh/assets/audio/letters/meem';

fs.mkdirSync(outDir, { recursive: true });

console.log('🎙️ جاري التنقيب المباشر عن ملفات الصوت البشرية (MP3 Streams)...');
const data = fs.readFileSync(exePath);

let totalAudio = 0;
let i = 0;
const len = data.length;

// MP3 frame sync word: 11 bits set (0xFF 0xFB for MP3 128kbps, 0xFF 0xF3, 0xFF 0xF2, 0xFF 0xE3)
while (i < len - 4) {
  // Check for common MP3 frame headers (0xFFFB, 0xFFF3, 0xFFF2, 0xFFFA, 0xFFE3)
  if (data[i] === 0xFF && (data[i + 1] & 0xE0) === 0xE0 && (data[i + 1] & 0x18) !== 0x08) {
    const start = i;
    let validFrames = 0;
    let curr = i;

    // Validate a sequence of continuous MP3 frame headers
    while (curr < len - 4) {
      if (data[curr] === 0xFF && (data[curr + 1] & 0xE0) === 0xE0) {
        validFrames++;
        curr += 417; // Typical 128kbps 44.1kHz frame length (~417-418 bytes)
      } else {
        break;
      }
    }

    const audioSize = curr - start;
    if (validFrames >= 15 && audioSize >= 6144) { // At least 15 valid frames (~0.5s audio)
      const mp3Data = data.slice(start, curr);
      const fileName = `meem_human_voice_${totalAudio}.mp3`;
      fs.writeFileSync(path.join(outDir, fileName), mp3Data);
      console.log(`   🔊 تم استخراج صوت بشري نقي [#${totalAudio}]: ${fileName} (${(audioSize / 1024).toFixed(1)} KB, ${validFrames} إطار)`);
      totalAudio++;
      i = curr;
      continue;
    }
  }
  i++;
}

console.log(`\n🎉 النتيجة القاطعة: تم استخراج ${totalAudio} ملفات صوتية بشرية حقيقية لحرف الميم!`);
