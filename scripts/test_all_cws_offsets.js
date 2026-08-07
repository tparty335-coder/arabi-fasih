// scripts/test_all_cws_offsets.js
const fs = require('fs');

const exeData = fs.readFileSync('D:\\Education  vol2\\مناهج 2026\\ص1         ت1\\arabic_1prim_t1_م.exe');

const offsets = [
   2568697,  3355017,  3929304,  4485733,
   5052028,  5743042,  6355658,  6858946,
   6970659,  7497302,  7542016,  7970668,
   8438293,  8912365,  9393354,  9964252,
  10383389, 10900971, 11557303, 12100399,
  12708301, 13302891, 13882004, 14419416,
  14884983, 15345767, 16003336, 16469884,
  17511500, 18017977, 18493447, 19012049,
  20072751, 21069151, 21529688, 21964501,
  22355650, 22915319, 23326115, 23792629,
  24292467, 24783157, 25260574, 25730220,
  26258103, 26884084, 27416438, 27977596,
  28605458, 28829628, 29603426
];

offsets.forEach((off, idx) => {
  const header = exeData.slice(off, off + 8);
  const zlibHeader = exeData.slice(off + 8, off + 10).toString('hex');
  console.log(`[${idx}] Offset ${off} (0x${off.toString(16)}) -> Version: ${header[3]}, Size: ${header.readUInt32LE(4)}, ZlibBytes: ${zlibHeader}`);
});
