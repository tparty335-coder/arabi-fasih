# scripts/analyze_exe.py
import sys
import re

exe_path = r'D:\Education  vol2\مناهج 2026\ص1         ت1\arabic_1prim_t1_م.exe'

with open(exe_path, 'rb') as f:
    data = f.read()

print(f"File size: {len(data)} bytes")

# Search for any known strings or signatures
zips = [m.start() for m in re.finditer(b'PK\x03\x04', data)]
cwss = [m.start() for m in re.finditer(b'CWS', data)]
fwss = [m.start() for m in re.finditer(b'FWS', data)]
zwss = [m.start() for m in re.finditer(b'ZWS', data)]
mp3s = [m.start() for m in re.finditer(b'\xff\xfb', data)]

print(f"PK (Zip) headers: {len(zips)} at {zips[:5]}")
print(f"CWS headers: {len(cwss)} at {cwss[:5]}")
print(f"FWS headers: {len(fwss)} at {fwss[:5]}")
print(f"ZWS headers: {len(zwss)} at {zwss[:5]}")
print(f"MP3 Sync candidate headers (FF FB): {len(mp3s)}")
