// scripts/inspect_swfkit_overlay.js
const fs = require('fs');

const overlayPath = 'd:/Projects/faseeh/assets/audio/letters/meem_swfkit/meem_swfkit_overlay.bin';
const data = fs.readFileSync(overlayPath);

console.log(`Overlay size: ${data.length} bytes`);
console.log('First 64 bytes (Hex):', data.slice(0, 64).toString('hex'));
console.log('First 64 bytes (ASCII):', data.slice(0, 64).toString('ascii').replace(/[^\x20-\x7E]/g, '.'));

console.log('\nLast 128 bytes (Hex):', data.slice(data.length - 128).toString('hex'));
console.log('Last 128 bytes (ASCII):', data.slice(data.length - 128).toString('ascii').replace(/[^\x20-\x7E]/g, '.'));
