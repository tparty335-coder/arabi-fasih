// scripts/analyze_exe.js
const fs = require('fs');

const exePath = 'D:\\Education  vol2\\مناهج 2026\\ص1         ت1\\arabic_1prim_t1_م.exe';
console.log('Loading EXE file...');

const data = fs.readFileSync(exePath);
console.log(`File size: ${data.length} bytes (${(data.length / (1024 * 1024)).toFixed(2)} MB)`);

function findPattern(pattern) {
  const matches = [];
  let index = data.indexOf(pattern, 0);
  while (index !== -1) {
    matches.push(index);
    if (matches.length > 50) break;
    index = data.indexOf(pattern, index + 1);
  }
  return matches;
}

console.log('PK (Zip) headers:', findPattern(Buffer.from([0x50, 0x4B, 0x03, 0x04])));
console.log('CWS headers:', findPattern(Buffer.from('CWS')));
console.log('FWS headers:', findPattern(Buffer.from('FWS')));
console.log('ZWS headers:', findPattern(Buffer.from('ZWS')));
console.log('Rar! headers:', findPattern(Buffer.from('Rar!')));
console.log('7z headers:', findPattern(Buffer.from([0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C])));
