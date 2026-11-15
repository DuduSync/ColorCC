#!/data/data/com.termux/files/usr/bin/bash
# Measure the ColorCC notification-glass one-frame dark flash.
# Run with the media notification visible/playing. Requires root.
set -u
BASE="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$BASE/evidence"
mkdir -p "$OUT"
MP4="/data/local/tmp/colorcc-flicker-test.mp4"

echo "[1/4] opening the notification shade"
su -c 'input swipe 200 20 200 2200 300'
sleep 2

echo "[2/4] recording 8 s at the display refresh rate"
su -c "rm -f $MP4; screenrecord --time-limit 10 --bit-rate 50000000 $MP4" &
REC=$!
sleep 9
su -c 'pkill -INT screenrecord' 2>/dev/null || true
wait "$REC" 2>/dev/null || true

echo "[3/4] pulling the video"
su -c "chmod 644 $MP4"
cp "$MP4" "$OUT/test-last.mp4"

echo "[4/4] looking for one-frame brightness drops"
ffmpeg -v error -i "$OUT/test-last.mp4" \
  -vf "crop=1400:500:20:300,scale=1:1:flags=area,format=gray" \
  -f rawvideo -pix_fmt gray - \
| python3 -c '
import sys
b=sys.stdin.buffer.read()
v=list(b)
if not v:
    print("no frames decoded"); raise SystemExit(2)
# Robust baseline: median of all sampled frames.
s=sorted(v); med=s[len(s)//2]
drops=[]
for i in range(1,len(v)-1):
    # A flicker is a single-frame drop followed by immediate recovery.
    if v[i] < med-8 and v[i-1] > med-5 and v[i+1] > med-5:
        drops.append((i,v[i-1],v[i],v[i+1]))
print(f"frames={len(v)} median_luma={med} single_frame_drops={len(drops)}")
for i,a,c,b2 in drops[:20]:
    print(f"  frame {i}: {a} -> {c} -> {b2}")
'
