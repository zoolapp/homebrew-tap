#!/usr/bin/env bash
# Points Casks/aime.rb at a published AIME release.
#   bash scripts/update-cask.sh [<version>]   (default: version in get.zool.app/aime/latest.json)
# Reads the pkg SHA-256 from the release's SHA256SUMS.txt; commits locally, does not push.
# Set COMMIT_TRAILER (e.g. a Co-Authored-By line) to append it to the commit message.
set -euo pipefail
cd "$(dirname "$0")/.."
version="${1:-$(curl -fsS https://get.zool.app/aime/latest.json | python3 -c 'import json,sys; print(json.load(sys.stdin)["version"])')}"
sha="$(curl -fsS "https://get.zool.app/aime/$version/SHA256SUMS.txt" | awk -v f="AIME-$version.pkg" '$2 == f {print $1}')"
[[ "$sha" =~ ^[0-9a-f]{64}$ ]] || { echo "no SHA-256 for AIME-$version.pkg" >&2; exit 1; }
sed -i '' -E "s/^  version \".*\"/  version \"$version\"/; s/^  sha256 \".*\"/  sha256 \"$sha\"/" Casks/aime.rb
git add Casks/aime.rb
if ! git diff --cached --quiet; then
  msg=(-m "aime $version")
  [[ -n "${COMMIT_TRAILER:-}" ]] && msg+=(-m "$COMMIT_TRAILER")
  git commit -q "${msg[@]}"
fi
git log --oneline -1
