#!/usr/bin/env sh
set -eu

if ! command -v curl >/dev/null 2>&1; then
  echo "error: curl is required but was not found." >&2
  exit 1
fi

if [ -z "${HOME:-}" ]; then
  echo "error: HOME is not set." >&2
  exit 1
fi

REPO="${GUGA_CODEX_REPO:-Calculus-Singularity/guga-codex}"
INSTALL_DIR="${GUGA_CODEX_INSTALL_DIR:-$HOME/.local/bin}"
TAG="${GUGA_CODEX_VERSION:-}"

OS="$(uname -s 2>/dev/null || true)"
ARCH="$(uname -m 2>/dev/null || true)"

case "$OS" in
  Linux)
    case "$ARCH" in
      x86_64|amd64) TARGET="x86_64-unknown-linux-gnu" ;;
      *)
        echo "error: unsupported Linux architecture: $ARCH" >&2
        exit 1
        ;;
    esac
    ;;
  Darwin)
    case "$ARCH" in
      x86_64|amd64) TARGET="x86_64-apple-darwin" ;;
      arm64|aarch64) TARGET="aarch64-apple-darwin" ;;
      *)
        echo "error: unsupported macOS architecture: $ARCH" >&2
        exit 1
        ;;
    esac
    ;;
  *)
    echo "error: unsupported OS: $OS" >&2
    echo "hint: use scripts/install.ps1 on Windows." >&2
    exit 1
    ;;
esac

ASSET="guga-codex-$TARGET"

if [ -z "$TAG" ]; then
  API_URL="https://api.github.com/repos/$REPO/releases/latest"
  echo "Fetching latest release for $REPO ..."
  TAG="$(
    curl -fsSL "$API_URL" \
      | sed -n 's/.*"tag_name":[[:space:]]*"\([^"]*\)".*/\1/p' \
      | head -n 1
  )"
  if [ -z "$TAG" ]; then
    echo "error: could not detect latest release tag from $API_URL" >&2
    exit 1
  fi
fi

DOWNLOAD_URL="https://github.com/$REPO/releases/download/$TAG/$ASSET"
TMP_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t guga-codex-install)"
TMP_BIN="$TMP_DIR/guga-codex"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT TERM

echo "Downloading $ASSET ($TAG) ..."
curl -fL --retry 3 --connect-timeout 10 -o "$TMP_BIN" "$DOWNLOAD_URL"

mkdir -p "$INSTALL_DIR"
chmod +x "$TMP_BIN"
cp "$TMP_BIN" "$INSTALL_DIR/guga-codex"

echo "Installed: $INSTALL_DIR/guga-codex"
if ! printf '%s' ":${PATH:-}:" | grep -q ":$INSTALL_DIR:"; then
  echo "warning: $INSTALL_DIR is not in PATH for this shell." >&2
  echo "Add this line to your shell profile:" >&2
  echo "  export PATH=\"$INSTALL_DIR:\$PATH\"" >&2
fi
echo "Run: guga-codex --help"
