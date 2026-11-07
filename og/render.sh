#!/usr/bin/env bash
# Chụp ảnh chia sẻ và icon của landing page bằng Chrome headless (cần mạng để tải font Be Vietnam Pro):
#   og-image.html -> ../assets/og-image.jpg (1200 × 630, og:image / twitter:image)
#   icon (180 × 180, nền liền) -> ../assets/apple-touch-icon.png
set -euo pipefail
cd "$(dirname "$0")"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

shot() {  # shot <html> <width> <height> <png>
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size="$2,$3" --virtual-time-budget=8000 --screenshot="$4" "file://$PWD/$1" >/dev/null 2>&1
}

shot og-image.html 1200 630 "$TMP/og.png"
sips -s format jpeg -s formatOptions 88 "$TMP/og.png" --out ../assets/og-image.jpg >/dev/null

cat > "$TMP/icon.html" <<'EOF'
<!doctype html><html><body style="margin:0;background:#1E2A44">
<svg width="180" height="180" viewBox="4 4 24 24" style="display:block"><rect x="4" y="4" width="24" height="24" fill="#1E2A44"/><rect x="5.5" y="5.5" width="21" height="21" rx="4.5" fill="#F5C400"/><rect x="8.5" y="8" width="15" height="8.5" rx="1.8" fill="#0E1116"/><g fill="#1E2A44"><circle cx="10.8" cy="20" r="1"/><circle cx="14.3" cy="20" r="1"/><circle cx="17.7" cy="20" r="1"/><circle cx="21.2" cy="20" r="1"/><circle cx="12.5" cy="23.3" r="1"/><circle cx="16" cy="23.3" r="1"/><circle cx="19.5" cy="23.3" r="1"/></g></svg>
</body></html>
EOF
cp "$TMP/icon.html" ./.icon.html
shot .icon.html 180 180 ../assets/apple-touch-icon.png
rm -f ./.icon.html
sips -g pixelWidth -g pixelHeight ../assets/og-image.jpg ../assets/apple-touch-icon.png | grep pixel
