// scripts/inspect_cws_header.js
const fs = require('fs');

const data = fs.readFileSync('D:\\Education  vol2\\مناهج 2026\\ص1         ت1\\arabic_1prim_t1_م.exe');
const offset = 2568697; // First CWS offset

console.log(`Inspecting header at offset ${offset}...`);
const slice = data.slice(offset, offset + 32);

console.log('Hex:', slice.toString('hex'));
console.log('Header string:', slice.slice(0, 3).toString('ascii'));
console.log('Version:', slice[3]);
const uncompressedLen = slice.readUInt32LE(4);
console.log('Uncompressed SWF size:', uncompressedLen, 'bytes (', (uncompressedLen / 1024).toFixed(1), 'KB )');
console.log('Next bytes (zlib header?):', slice.slice(8, 16).toString('hex'));
