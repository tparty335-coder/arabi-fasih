// scripts/inspect_saf_payload.js
const fs = require('fs');

const overlayPath = 'd:/Projects/faseeh/assets/audio/letters/meem_swfkit/meem_swfkit_overlay.bin';
const data = fs.readFileSync(overlayPath);

// Offsets around bee1.swf
const nameOffset = 0x16b1dc;
const cwsOffset = 0x16b1f9;

console.log('SAF entry name:', data.slice(nameOffset, nameOffset + 18).toString('utf16le'));
console.log('Bytes between name and CWS:', data.slice(nameOffset, cwsOffset).toString('hex'));
console.log('CWS Header (8 bytes):', data.slice(cwsOffset, cwsOffset + 8).toString('hex'));
console.log('First 32 payload bytes (at cwsOffset+8):', data.slice(cwsOffset + 8, cwsOffset + 40).toString('hex'));
