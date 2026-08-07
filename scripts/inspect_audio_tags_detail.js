// scripts/inspect_audio_tags_detail.js
const fs = require('fs');
const path = require('path');

const swfDir = 'd:/Projects/faseeh/assets/audio/letters/meem_swfs_extracted';
const swfFiles = fs.readdirSync(swfDir).filter(f => f.endsWith('.swf'));

console.log(`Inspecting audio formats across ${swfFiles.length} SWF files...`);

const formatNames = {
  0: 'Uncompressed PCM BE',
  1: 'ADPCM',
  2: 'MP3',
  3: 'Uncompressed PCM LE',
  4: 'Nellymoser 8kHz',
  5: 'Nellymoser 16kHz',
  6: 'Nellymoser',
  11: 'Speex'
};

const formatCounts = {};
let totalSoundTags = 0;

swfFiles.forEach((file) => {
  const data = fs.readFileSync(path.join(swfDir, file));
  let pos = 8;

  // Skip RECT
  const nBits = data[pos] >> 3;
  const rectBytes = Math.ceil((5 + nBits * 4) / 8);
  pos += rectBytes + 4;

  while (pos < data.length - 6) {
    const headerWord = data.readUInt16LE(pos);
    const tagType = headerWord >> 6;
    let tagLen = headerWord & 0x3F;
    let headerLen = 2;

    if (tagLen === 0x3F) {
      tagLen = data.readUInt32LE(pos + 2);
      headerLen = 6;
    }

    if (tagType === 0) break;

    // Tag 14: DefineSound
    if (tagType === 14) {
      const flags = data[pos + headerLen + 2];
      const format = (flags >> 4) & 0x0F;
      const fmtName = formatNames[format] || `Unknown (${format})`;
      formatCounts[fmtName] = (formatCounts[fmtName] || 0) + 1;
      totalSoundTags++;

      // Save sound payload
      const soundData = data.slice(pos + headerLen + 7, pos + headerLen + tagLen);
      const outDir = 'd:/Projects/faseeh/assets/audio/letters/meem';
      fs.mkdirSync(outDir, { recursive: true });
      const outName = `${path.basename(file, '.swf')}_sound_${totalSoundTags}_fmt${format}.wav`;
      fs.writeFileSync(path.join(outDir, outName), soundData);
      console.log(`   🎵 Found DefineSound [#${totalSoundTags}] in ${file}: Format=${fmtName}, Size=${soundData.length} bytes -> Saved to ${outName}`);
    }

    pos += headerLen + tagLen;
  }
});

console.log('\n📊 Audio Format Summary Across All Files:');
console.log(formatCounts);
console.log(`Total Sound Tags Extracted: ${totalSoundTags}`);
