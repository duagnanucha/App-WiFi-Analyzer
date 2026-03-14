#!/bin/bash
set -e

echo "=== WiFi Analyzer Pro - Netlify Web Build ==="

FLUTTER_VERSION="${FLUTTER_VERSION:-3.29.2}"
FLUTTER_DIR="$HOME/flutter"

# Install Flutter SDK if not cached
if [ ! -d "$FLUTTER_DIR" ]; then
  echo "Installing Flutter SDK $FLUTTER_VERSION..."
  git clone https://github.com/flutter/flutter.git -b "$FLUTTER_VERSION" --depth 1 "$FLUTTER_DIR"
else
  echo "Flutter SDK found in cache"
  cd "$FLUTTER_DIR"
  git fetch --depth 1 origin "refs/tags/$FLUTTER_VERSION"
  git checkout "$FLUTTER_VERSION" 2>/dev/null || true
  cd -
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

echo "Flutter version:"
flutter --version

echo "Enabling web..."
flutter config --enable-web

echo "Getting dependencies..."
flutter pub get

echo "Building for web (release)..."
flutter build web --release --web-renderer html --dart-define=FLUTTER_WEB_USE_SKIA=false

echo "Build complete! Output in build/web/"
ls -la build/web/
