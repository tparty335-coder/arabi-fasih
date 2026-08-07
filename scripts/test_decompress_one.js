// scripts/test_decompress_one.js
const fs = require('fs');
const zlib = require('zlib');
const path = require('path');

const exeData = fs.readFileSync('D:\\Education  vol2\\مناهج 2026\\ص1         ت1\\arabic_1prim_t1_م.exe');
const offset = 2568697; // First CWS offset

const header = exeData.slice(offset, offset + 8);
const uncompressedLen = header.readUInt32LE(4);
console.log('Target uncompressed length:', uncompressedLen);

// Slice from offset 8 onwards (zlib payload starting with 78 9c)
const compressedData = exeData.slice(offset + 8);

// Use zlib Inflate object which stops as soon as the Zlib stream finishes!
const inflater = zlib.createInflate();
const chunks = [];

inflater.on('data', (chunk) => {
  chunks.push(chunk);
});

inflater.on('end', () => {
  const decompressedBody = Buffer.concat(chunks);
  console.log('✅ Successfully decompressed SWF body! Length:', decompressedBody.length, 'bytes');

  // Reconstruct full valid FWS SWF file
  // FWS header: FWS + version + 32-bit LE length
  const fwsHeader = Buffer.from([0x46, 0x57, 0x53, header[3], header[4], header[5], header[6], header[7]]);
  const fullSwf = Buffer.concat([fwsHeader, decompressedBody]);

  const outPath = 'd:/Projects/faseeh/assets/audio/letters/meem_extracted_main.swf';
  fs.mkdirSync(path.dirname(outPath), { recursive: true });
  fs.writeFileSync(outPath, fullSwf);
  console.log('🎉 SAVED VALID SWF TO:', outPath, '(', fullSwf.length, 'bytes )');
});

inflater.on('error', (err) => {
  console.error('Inflate error:', err);
});

inflater.write(compressedData);
inflater.end();
