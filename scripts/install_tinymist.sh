#!/usr/bin/env bash
# Installe le binaire Arch x86_64 testé, sans modifier le paquet système.
set -euo pipefail

if [[ "$(uname -s)" != Linux || "$(uname -m)" != x86_64 ]]; then
  echo "Cette installation nécessite Linux x86_64 (Arch ou WSL Arch)." >&2
  exit 1
fi

tmp_dir=$(mktemp -d)
trap 'rm -rf -- "$tmp_dir"' EXIT
archive="$tmp_dir/tinymist.pkg.tar.zst"
if [[ $# -gt 1 ]]; then
  echo "Usage: $0 [paquet_arch_local]" >&2
  exit 1
elif [[ $# -eq 1 ]]; then
  cp -- "$1" "$archive"
else
  curl --fail --location --retry 3 \
    'https://archive.archlinux.org/packages/t/tinymist/tinymist-1%3A0.15.2-1-x86_64.pkg.tar.zst' \
    --output "$archive"
fi

# Empreinte du paquet dont la signature a été vérifiée avec le trousseau Arch.
echo "c29db37dd901d9394ba33fdfbd89d720dbcafd40146b31452d54546b66c65764  $archive" | sha256sum --check --status
tar --extract --to-stdout --file="$archive" usr/bin/tinymist > "$tmp_dir/tinymist"
chmod 755 "$tmp_dir/tinymist"
"$tmp_dir/tinymist" --version

destination="${XDG_DATA_HOME:-$HOME/.local/share}/${NVIM_APPNAME:-nvim}/tinymist_0_15_2/tinymist"
install -D -m 755 -- "$tmp_dir/tinymist" "$destination"
printf 'Tinymist 0.15.2 installé : %s\n' "$destination"
