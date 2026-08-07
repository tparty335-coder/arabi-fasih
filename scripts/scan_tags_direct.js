// scripts/scan_tags_direct.js
const fs = require('fs');
const path = require('path');

const swfDir = 'd:/Projects/faseeh/assets/audio/letters/meem_swfs_extracted';
const outMp3Dir = 'd:/Projects/faseeh/assets/audio/letters/meem';

fs.mkdirSync(outMp3Dir, { recursive: true });

const swfFiles = fs.readdirSync(swfDir).filter(f => f.endsWith('.swf'));
console.log(`🔎 مسح دقيق لترويسات الـ Tags في ${swfFiles.length} ملفات SWF...`);

let grandTotalAudio = 0;

swfFiles.forEach((swfName) => {
  const swfPath = path.join(swfDir, swfName);
  const data = fs.readFileSync(swfPath);

  if (data.length < 30) return;

  const baseName = path.basename(swfName, '.swf');
  let tagCount = 0;
  const streamChunks = [];

  // Start scanning from byte 8 (after FWS + version + 4-byte len)
  let pos = 8;
  // Skip RECT bounding box
  const nBits = data[pos] >> 3;
  const rectBytes = Math.ceil((5 + nBits * 4) / 8);
  pos += rectBytes + 4; // skip RECT + frameRate (2) + frameCount (2)

  while (pos < data.length - 2) {
    const headerWord = data.readUInt16LE(pos);
    const tagType = headerWord >> 6;
    let tagLen = headerWord & 0x3F;
    let headerLen = 2;

    if (tagLen === 0x3F) {
      if (pos + 6 > data.length) break;
      tagLen = data.readUInt32LE(pos + 2);
      headerLen = 6;
    }

    if (tagType === 0) break; // End tag

    // Tag 14 = DefineSound
    if (tagType === 14 && tagLen > 10) {
      const soundData = data.slice(pos + headerLen + 7, pos + headerLen + tagLen);
      if (soundData.length >= 1000) {
        const outPath = path.join(outMp3Dir, `${baseName}_definesound_${tagCount}.mp3`);
        fs.writeFileSync(outPath, soundData);
        console.log(`   🎵 [DefineSound] تم استخراج: ${path.basename(outPath)} (${(soundData.length / 1024).toFixed(1)} KB)`);
        grandTotalAudio++;
      }
    }

    // Tag 19 = SoundStreamBlock
    if (tagType === 19 && tagLen > 4) {
      const chunk = data.slice(pos + headerLen, pos + headerLen + tagLen);
      streamChunks.push(chunk);
    }

    pos += headerLen + tagLen;
    tagCount++;
  }

  if (streamChunks.length > 0) {
    const fullAudio = Buffer.concat(streamChunks);
    if (fullAudio.length >= 4096) {
      const outPath = path.join(outMp3Dir, `${baseName}_stream_voice.mp3`);
      fs.writeFileSync(outPath, fullAudio);
      console.log(`   🎧 [SoundStreamBlock] تم استخراج تيار صوتي بشري كاملاً: ${path.basename(outPath)} (${(fullAudio.length / 1024).toFixed(1)} KB)`);
      grandTotalAudio++;
    }
  }
});

console.log(`\n🎉 النتيجة القاطعة: تم استخراج ${grandTotalAudio} ملفات صوتية بشرية حقيقية!`);
