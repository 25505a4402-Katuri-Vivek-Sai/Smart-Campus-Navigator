#!/usr/bin/env bash
set -euo pipefail

# Vercel does not include the Flutter SDK by default, so install a shallow stable checkout.
FLUTTER_DIR="${HOME}/flutter"
if [ ! -x "${FLUTTER_DIR}/bin/flutter" ]; then
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "${FLUTTER_DIR}"
fi
export PATH="${FLUTTER_DIR}/bin:${PATH}"
flutter config --enable-web
flutter --version
flutter pub get
flutter build web --release
