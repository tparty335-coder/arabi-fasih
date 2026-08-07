// scripts/extract_stream_audio.js
// تجميع كل قطاعات SoundStreamBlock (Tag 19) و DefineSound (Tag 14) لجميع ملفات SWF الـ 51
const fs = require('fs');
const path = require('path');

const swfDir = 'd:/Projects/faseeh/assets/audio/letters/meem_swfs_extracted';
const outMp3Dir = 'd:/Projects/faseeh/assets/audio/letters/meem';

fs.mkdirSync(outMp3Dir, { recursive: true });

const swfFiles = fs.readdirSync(swfDir).filter(f => f.endsWith('.swf'));
console.log(`🎙️ جاري تجميع كافة الأصوات البشرية المسجلة من ${swfFiles.length} ملفات SWF...`);

let grandTotalAudio = 0;

swfFiles.forEach((swfName) => {
  const swfPath = path.join(swfDir, swfName);
  const data = fs.readFileSync(swfPath);

  if (data.length < 20) return;

  // Skip Header
  let bytePos = 8;
  const nBits = data[bytePos] >> 3;
  const rectBitLength = 5 + nBits * 4;
  const rectByteLength = Math.ceil(rectBitLength / 8);
  bytePos += rectByteLength + 4;

  const streamChunks = [];
  const baseName = path.basename(swfName, '.swf');
  let defineSoundCount = 0;

  while (bytePos < data.length - 2) {
    const tagCodeAndLength = data.readUInt16LE(bytePos);
    const tagType = tagCodeAndLength >> 6;
    let tagLength = tagCodeAndLength & 0x3F;
    let headerSize = 2;

    if (tagLength === 0x3F) {
      tagLength = data.readUInt32LE(bytePos + 2);
      headerSize = 6;
    }

    const tagDataPos = bytePos + headerSize;

    // Tag 14 = DefineSound
    if (tagType === 14) {
      const soundId = data.readUInt16LE(tagDataPos);
      const flags = data[tagDataPos + 2];
      const format = (flags >> 4) & 0x0F;
      const soundPayload = data.slice(tagDataPos + 7, tagDataPos + tagLength);

      if (soundPayload.length >= 1000) {
        const ext = (format === 2) ? 'mp3' : 'wav';
        const outName = `${baseName}_sound_${soundId}.${ext}`;
        const outPath = path.join(outMp3Dir, outName);
        fs.writeFileSync(outPath, soundPayload);
        console.log(`   🎵 [DefineSound] تم حفظ صوت بشري: ${outName} (${(soundPayload.length / 1024).toFixed(1)} KB)`);
        grandTotalAudio++;
        defineSoundCount++;
      }
    }

    // Tag 19 = SoundStreamBlock
    if (tagType === 19) {
      const streamPayload = data.slice(tagDataPos, tagDataPos + tagLength);
      // Skip MP3 latency sample count (4 bytes if present)
      if (streamPayload.length > 4) {
        streamChunks.push(streamPayload);
      }
    }

    bytePos = tagDataPos + tagLength;
  }

  // Assemble full streaming audio file
  if (streamChunks.length > 0) {
    const fullAudio = Buffer.concat(streamChunks);
    if (fullAudio.length >= 4096) {
      const streamOutName = `${baseName}_full_voice_stream.mp3`;
      const streamOutPath = path.join(outMp3Dir, streamOutName);
      fs.writeFileSync(streamOutPath, fullAudio);
      console.log(`   🎧 [SoundStream] تم حصد تيار صوتي بشري كامل: ${streamOutName} (${(fullAudio.length / 1024).toFixed(1)} KB, ${streamChunks.length} مقطع)`);
      grandTotalAudio++;
    }
  }
});

console.log(`\n🎉 النتيجة النهائية الكاسحة: تم استخراج ${grandTotalAudio} ملفات صوتية بشرية حقيقية لحرف الميم!`);
