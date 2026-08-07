// scripts/parse_swf_tags.js
// مفسّر ترويسات SWF Tags لاستخراج الأصوات البشرية من DefineSound و SoundStream
const fs = require('fs');
const path = require('path');

const swfPath = 'd:/Projects/faseeh/assets/audio/letters/meem_swfs_extracted/words1.swf';
const data = fs.readFileSync(swfPath);

console.log(`Inspecting SWF tags in ${swfPath} (size: ${data.length} bytes)...`);

// Skip SWF header:
// 3 bytes (FWS) + 1 byte (version) + 4 bytes (file length) + RECT (variable bits) + 2 bytes (frame rate) + 2 bytes (frame count)
// BitReader for RECT:
let bytePos = 8;
const nBits = data[bytePos] >> 3;
const rectBitLength = 5 + nBits * 4;
const rectByteLength = Math.ceil(rectBitLength / 8);
bytePos += rectByteLength + 4; // Skip RECT + FrameRate (2) + FrameCount (2)

console.log(`First SWF Tag starts at byte offset: 0x${bytePos.toString(16)}`);

let tagCount = 0;
let audioCount = 0;

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

  // Tag 14 = DefineSound, Tag 19 = SoundStreamBlock, Tag 18 = SoundStreamHead, Tag 45 = SoundStreamHead2
  if (tagType === 14 || tagType === 18 || tagType === 19 || tagType === 45) {
    console.log(`   🏷️ Tag #${tagCount}: Type=${tagType} (${tagType === 14 ? 'DefineSound' : tagType === 19 ? 'SoundStreamBlock' : 'SoundStreamHead'}), Length=${tagLength} bytes at 0x${bytePos.toString(16)}`);

    if (tagType === 14) {
      // DefineSound: 2 bytes CharacterID + 1 byte FormatFlags + 4 bytes SampleCount + audioBytes
      const soundId = data.readUInt16LE(tagDataPos);
      const flags = data[tagDataPos + 2];
      const format = (flags >> 4) & 0x0F; // 2 = MP3, 1 = ADPCM, 0 = Uncompressed PCM
      const sampleCount = data.readUInt32LE(tagDataPos + 3);
      const soundPayload = data.slice(tagDataPos + 7, tagDataPos + tagLength);

      console.log(`      🎵 DefineSound ID=${soundId}, Format=${format} (2=MP3,1=ADPCM,0=PCM), Samples=${sampleCount}, Payload=${soundPayload.length} bytes`);

      if (soundPayload.length >= 1000) {
        const outName = `meem_sound_${soundId}_fmt${format}.mp3`;
        const outPath = path.join('d:/Projects/faseeh/assets/audio/letters/meem', outName);
        fs.writeFileSync(outPath, soundPayload);
        console.log(`      💾 SUCCESS! Saved human audio to: ${outPath} (${soundPayload.length} bytes)`);
        audioCount++;
      }
    }
  }

  bytePos = tagDataPos + tagLength;
  tagCount++;
}

console.log(`\n🎉 Total tags parsed: ${tagCount}, Total human audio files saved: ${audioCount}`);
