// scripts/strings_meem.js
const fs = require('fs');

const exePath = 'D:\\Education  vol2\\مناهج 2026\\ص1         ت1\\arabic_1prim_t1_م.exe';
const data = fs.readFileSync(exePath);

console.log('Searching for embedded filenames and paths inside EXE...');

const asciiStrings = [];
let current = '';

for (let i = 0; i < data.length; i++) {
  const char = data[i];
  if (char >= 32 && char <= 126) {
    current += String.fromCharCode(char);
  } else {
    if (current.length >= 6) {
      if (current.includes('.mp3') || current.includes('.wav') || current.includes('.swf') || current.includes('.png') || current.includes('.jpg') || current.includes('zinc') || current.includes('mdm') || current.includes('flash')) {
        asciiStrings.push(current);
      }
    }
    current = '';
  }
}

console.log(`Found ${asciiStrings.length} matching string entries:`);
console.log(asciiStrings.slice(0, 30));
