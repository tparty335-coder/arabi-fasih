// scripts/dissect_saf.js
// تشريح ومسح هيكلية SWFKit SAF (SAF\0)
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const overlayPath = 'd:/Projects/faseeh/assets/audio/letters/meem_swfkit/meem_swfkit_overlay.bin';
const outDir = 'd:/Projects/faseeh/assets/audio/letters/meem_extracted_assets';

fs.mkdirSync(outDir, { recursive: true });

const data = fs.readFileSync(overlayPath);
console.log(`📦 SAF Container Header: ${data.slice(0, 4).toString('ascii')}`);

// Search for all UTF-16LE or ASCII filenames inside the SAF container
let count = 0;
let pos = 4; // Start after 'SAF\0'

console.log('🔍 Scanning SAF container records...');

// Scan for embedded file entries in SAF
// In SAF, file names are encoded as UTF-16LE strings terminated by null (0x00 0x00)
while (pos < data.length - 16) {
  // Check for UTF-16LE filename extensions like .s.w.f., .m.p.3., .w.a.v., .p.n.g., .j.p.g.
  // .s.w.f -> 2E 00 73 00 77 00 66 00
  // .m.p.3 -> 2E 00 6D 00 70 00 33 00
  const isSwf = data[pos] === 0x2E && data[pos + 1] === 0x00 && data[pos + 2] === 0x73 && data[pos + 3] === 0x00 && data[pos + 4] === 0x77 && data[pos + 5] === 0x00 && data[pos + 6] === 0x66 && data[pos + 7] === 0x00;
  const isMp3 = data[pos] === 0x2E && data[pos + 1] === 0x00 && data[pos + 2] === 0x6D && data[pos + 3] === 0x00 && data[pos + 4] === 0x70 && data[pos + 5] === 0x00 && data[pos + 6] === 0x33 && data[pos + 7] === 0x00;

  if (isSwf || isMp3) {
    // Scan backwards to find the start of the UTF-16 string
    let nameStart = pos;
    while (nameStart > 4 && (data[nameStart] !== 0x00 || data[nameStart + 1] !== 0x00)) {
      nameStart -= 2;
    }
    nameStart += 2;

    const nameBuf = data.slice(nameStart, pos + 8);
    const fileName = nameBuf.toString('utf16le');
    console.log(`Found asset record [#${count}]: "${fileName}" at offset 0x${nameStart.toString(16)}`);
    count++;
  }
  pos += 2;
}

console.log(`\n🎉 Total asset records discovered: ${count}`);
