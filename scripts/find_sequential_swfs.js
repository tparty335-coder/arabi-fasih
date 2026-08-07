// scripts/find_sequential_swfs.js
const fs = require('fs');
const zlib = require('zlib');
const path = require('path');

const exeData = fs.readFileSync('D:\\Education  vol2\\مناهج 2026\\ص1         ت1\\arabic_1prim_t1_م.exe');
const outDir = 'd:/Projects/faseeh/assets/audio/letters/meem_valid_swfs';
fs.mkdirSync(outDir, { recursive: true });

console.log('Finding true sequential SWF files starting from byte 2,568,697...');

let currentPos = 2568697;
let swfIndex = 0;
let totalAudioFound = 0;

while (currentPos < exeData.length - 8) {
  // Search for CWS or FWS
  if (exeData[currentPos] === 0x43 && exeData[currentPos + 1] === 0x57 && exeData[currentPos + 2] === 0x53) {
    const version = exeData[currentPos + 3];
    const declaredLen = exeData.readUInt32LE(currentPos + 4);

    if (version >= 1 && version <= 30 && declaredLen > 5000 && declaredLen < 15000000) {
      console.log(`\n📦 [SWF #${swfIndex}] Found CWS v${version} at offset ${currentPos} (0x${currentPos.toString(16)}), Size: ${declaredLen} bytes`);

      // Extract compressed zlib payload
      const compressedPayload = exeData.slice(currentPos + 8);

      try {
        // Try decompressing with inflateRaw or inflate
        let decompressedBody;
        try {
          decompressedBody = zlib.inflateSync(compressedPayload);
        } catch (e) {
          // If inflateSync fails on whole buffer, try creating a Inflate stream chunk
          try {
            decompressedBody = zlib.inflateRawSync(compressedPayload);
          } catch (e2) {
            console.log(`   ⚠️ Direct zlib inflate failed: ${e.message}`);
          }
        }

        if (decompressedBody) {
          console.log(`   🔓 DECOMPRESSED SUCCESSFULLY! Uncompressed size: ${decompressedBody.length} bytes`);
          const fwsHeader = Buffer.from([0x46, 0x57, 0x53, version, exeData[currentPos + 4], exeData[currentPos + 5], exeData[currentPos + 6], exeData[currentPos + 7]]);
          const fullSwf = Buffer.concat([fwsHeader, decompressedBody]);
          const swfFileName = `meem_unit_${swfIndex}.swf`;
          fs.writeFileSync(path.join(outDir, swfFileName), fullSwf);
          console.log(`   💾 SAVED UNCOMPRESSED SWF: ${swfFileName}`);
          swfIndex++;
        }
      } catch (err) {
        console.log(`   ⚠️ Failed to decompress: ${err.message}`);
      }
    }
  }
  currentPos++;
}

console.log(`\n✅ Complete scan finished.`);
