#!/bin/sh
# 全展示をビルドする。ルートの template.typ を共有するので --root はリポジトリ直下。
# 使い方: ./build.sh            # 全部
#        ./build.sh linetrace/linetrace.typ   # 1 つだけ
set -eu
cd "$(dirname "$0")"
if [ $# -gt 0 ]; then set -- "$@"; else
  set -- panel.typ linetrace/linetrace.typ packet-delivery/packet-delivery.typ all.typ all-local.typ \
         raspberyth/raspberyth.typ VR/vr.typ susume/susume.typ map/map.typ takada/takada.typ
fi
for f in "$@"; do
  [ -f "$f" ] || { echo "skip $f (なし)"; continue; }
  typst compile --root . "$f" && echo "ok  $f"
done
# A1 ポスター(自前の images/ を相対パスで読む)は上書きを避けるため既定では対象外。
# ビルドするとき: (cd packet-delivery/poster && typst compile how-to-play.typ)
