#!/usr/bin/env sh
set -e

ZED_AGENTS_DIRNAME=~/.config/zed
HOME_AGENTS_DIRNAME=~/.agents
SKILL_FOLDER="$HOME_AGENTS_DIRNAME/skills"

BASE_URL="https://raw.githubusercontent.com/slacking-eveywhere/agents/refs/heads/main"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

die() {
    printf "error: %s\n" "$1" >&2
    exit 1
}

if [ "$(uname -s)" != "Linux" ]; then
    die "unsupported OS: $(uname -s). Only Linux supported."
fi

mkdir -p "$ZED_AGENTS_DIRNAME"
mkdir -p "$HOME_AGENTS_DIRNAME"

printf "Downloading checksums manifest...\n"
curl -L -sSf "$BASE_URL/bin/checksums.sha256" -o "$TMPDIR/checksums.sha256" || die "failed to download checksums.sha256"

printf "Downloading artifacts...\n"
curl -L -sSf "$BASE_URL/bin/skills.tar.gz" -o "$TMPDIR/skills.tar.gz" || die "failed to download skills.tar.gz"
curl -L -sSf "$BASE_URL/bin/guidelines.tar.gz" -o "$TMPDIR/guidelines.tar.gz" || die "failed to download guidelines.tar.gz"
curl -L -sSf "$BASE_URL/AGENTS.md" -o "$TMPDIR/AGENTS.md" || die "failed to download AGENTS.md"

printf "Verifying checksums...\n"
cd "$TMPDIR"
sha256sum -c checksums.sha256 || die "checksum verification failed"
cd - >/dev/null

printf "Extracting...\n"
tar -xz -C "$TMPDIR" -f "$TMPDIR/skills.tar.gz"
tar -xz -C "$TMPDIR" -f "$TMPDIR/guidelines.tar.gz"

printf "Installing...\n"
rm -rf "$SKILL_FOLDER"
mv "$TMPDIR/skills" "$SKILL_FOLDER"

rm -rf "$ZED_AGENTS_DIRNAME/guidelines"
mv "$TMPDIR/guidelines" "$ZED_AGENTS_DIRNAME/guidelines"

cp "$TMPDIR/AGENTS.md" "$ZED_AGENTS_DIRNAME/AGENTS.md"

printf "Installed:\n  AGENTS.md  -> %s\n  guidelines -> %s\n  skills     -> %s\n" \
    "$ZED_AGENTS_DIRNAME/AGENTS.md" "$ZED_AGENTS_DIRNAME/guidelines" "$SKILL_FOLDER"
