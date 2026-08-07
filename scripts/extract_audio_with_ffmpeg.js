const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const inputDir = 'd:/Projects/faseeh/assets/audio/letters/meem_swfs_extracted';
const outputDir = 'd:/Projects/faseeh/assets/audio/letters/meem_audio_extracted';

if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
}

const files = fs.readdirSync(inputDir).filter(f => f.endsWith('.swf'));
console.log(`Found ${files.length} SWF files.`);

let successCount = 0;
let failCount = 0;

for (const file of files) {
    const swfPath = path.join(inputDir, file);
    const baseName = path.basename(file, '.swf');
    const mp3Path = path.join(outputDir, `${baseName}.mp3`);
    
    console.log(`Extracting audio from ${file}...`);
    try {
        // -y to overwrite, -vn to ignore video, -acodec libmp3lame to convert/save as mp3
        // If it fails to find audio, ffmpeg returns an error
        const cmd = `ffmpeg -y -i "${swfPath}" -vn -acodec libmp3lame -q:a 2 "${mp3Path}" 2>&1`;
        const output = execSync(cmd, { encoding: 'utf8' });
        
        if (fs.existsSync(mp3Path) && fs.statSync(mp3Path).size > 0) {
            console.log(` -> SUCCESS: Saved ${baseName}.mp3`);
            successCount++;
        } else {
            console.log(` -> FAILED (No audio or zero byte): ${file}`);
            if (fs.existsSync(mp3Path)) fs.unlinkSync(mp3Path);
            failCount++;
        }
    } catch (err) {
        console.log(` -> FAILED: ${file}`);
        // console.error(err.message);
        failCount++;
    }
}

console.log(`\nExtraction complete. Success: ${successCount}, Failed: ${failCount}`);
