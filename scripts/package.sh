#!/usr/bin/env bash
# Lambda packaging contract (see docs/02-architecture.md):
#   services/<function>/handler.py  +  services/shared/ (+ optional services/<function>/requirements.txt)
#   -> build/<function>.zip   (handler.lambda_handler at the zip root)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
rm -rf build && mkdir -p build

count=0
for dir in services/*/; do
  name="$(basename "$dir")"
  [[ "$name" == "shared" ]] && continue
  [[ -f "$dir/handler.py" ]] || continue
  tmp="$(mktemp -d)"
  cp -r "$dir"/. "$tmp"/
  cp -r services/shared "$tmp"/shared
  if [[ -f "$dir/requirements.txt" ]]; then
    pip install -q -r "$dir/requirements.txt" -t "$tmp"
  fi
  (cd "$tmp" && zip -qr "$ROOT/build/$name.zip" . -x '*/__pycache__/*' -x '*.pyc' -x 'tests/*')
  rm -rf "$tmp"
  echo "built build/$name.zip"
  count=$((count + 1))
done
echo "packaged $count function(s)"
