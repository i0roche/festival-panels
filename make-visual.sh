#!/bin/sh
# 写真を「白黒ハーフトーン＋アクセント色の正方形(乗算)」に加工する。
# 使い方: ./make-visual.sh 入力.jpg 出力.png "#B0DC01" [幅 高さ]
# 既定の出力は 1600x992 (パネルの写真枠 400x248pt と同じ比率) の PNG。
# 枠を広げた時は幅・高さを枠の比率に合わせて渡す(例 1520 800 = 508x267pt)。
set -eu
in=$1 out=$2 accent=${3:-"#FE430C"}
W=${4:-1600} H=${5:-992}
S=$((H * 66 / 100))          # 正方形の一辺(枠高さの 66%)
X=$(((W - S) / 2)) Y=$(((H - S) / 2))

magick "$in" -resize "${W}x${H}^" -gravity center -extent "${W}x${H}" \
  -colorspace Gray -contrast-stretch 2%x2% -level 8%,92% \
  -ordered-dither h8x8a -colorspace sRGB \
  \( -size "${W}x${H}" xc:white -fill "$accent" \
     -draw "rectangle $X,$Y $((X + S - 1)),$((Y + S - 1))" \) \
  -compose Multiply -composite "$out"
echo "wrote $out"
