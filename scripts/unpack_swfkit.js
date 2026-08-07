// scripts/unpack_swfkit.js
// فحص وتفكيك مشغل SWFKit للـ EXE التفاعلي لحرف الميم
const fs = require('fs');
const path = require('path');

const exePath = 'D:\\Education  vol2\\مناهج 2026\\ص1         ت1\\arabic_1prim_t1_م.exe';
const outDir = 'd:/Projects/faseeh/assets/audio/letters/meem_swfkit';

fs.mkdirSync(outDir, { recursive: true });

const data = fs.readFileSync(exePath);
console.log(`📦 جاري فحص هيكلية SWFKit في ${exePath} (الحجم: ${data.length} بايت)...`);

// Read PE Header to find Overlay Start Offset
// e_lfanew at offset 0x3C (60)
const peOffset = data.readUInt32LE(0x3C);
console.log(`PE Header Offset: 0x${peOffset.toString(16)}`);

// NumberOfSections at peOffset + 6 (2 bytes)
const numSections = data.readUInt16LE(peOffset + 6);
// SizeOfOptionalHeader at peOffset + 20 (2 bytes)
const sizeOfOptionalHeader = data.readUInt16LE(peOffset + 20);

// Section headers start right after Optional Header: peOffset + 24 + sizeOfOptionalHeader
const sectionHeaderStart = peOffset + 24 + sizeOfOptionalHeader;

let maxRawEnd = 0;
for (let i = 0; i < numSections; i++) {
  const secOffset = sectionHeaderStart + i * 40;
  const name = data.slice(secOffset, secOffset + 8).toString('ascii').replace(/\0/g, '');
  const sizeOfRawData = data.readUInt32LE(secOffset + 16);
  const pointerToRawData = data.readUInt32LE(secOffset + 20);
  const endOffset = pointerToRawData + sizeOfRawData;

  console.log(`Section [${i}] ${name}: RawData 0x${pointerToRawData.toString(16)} .. 0x${endOffset.toString(16)} (${sizeOfRawData} bytes)`);
  if (endOffset > maxRawEnd) {
    maxRawEnd = endOffset;
  }
}

console.log(`\n🎯 بداية الـ PE Overlay (نهاية أقسام EXE): 0x${maxRawEnd.toString(16)} (${maxRawEnd} بايت)`);
console.log(`حجم الـ Overlay المستهدف: ${data.length - maxRawEnd} بايت (${((data.length - maxRawEnd) / (1024 * 1024)).toFixed(2)} MB)`);

const overlayData = data.slice(maxRawEnd);
fs.writeFileSync(path.join(outDir, 'meem_swfkit_overlay.bin'), overlayData);
console.log(`💾 تم حفظ الـ Overlay الكامل في ${outDir}/meem_swfkit_overlay.bin`);
