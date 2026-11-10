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
# Minimum macOS comes from the release's manifest (minimumSystemVersion), so the cask never
# offers a pkg to a system its installer rejects.
# Only the current manifest exists, so it must describe this version.
min="$(curl -fsS https://get.zool.app/aime/latest.json | python3 -c '
import json, sys
d = json.load(sys.stdin)
current = d.get("version")
if current != sys.argv[1]:
    sys.exit("latest.json is %s, not %s: cannot read its minimum macOS" % (current, sys.argv[1]))
print(d.get("minimumSystemVersion", ""))' "$version")"
case "${min%%.*}" in
  14) codename=sonoma ;;
  15) codename=sequoia ;;
  26) codename=tahoe ;;
  *) echo "unknown minimumSystemVersion '$min': add its Homebrew codename" >&2; exit 1 ;;
esac
sed -i '' -E "s/^  version \".*\"/  version \"$version\"/; s/^  sha256 \".*\"/  sha256 \"$sha\"/; s/^  depends_on macos: :[a-z_]+/  depends_on macos: :$codename/" Casks/aime.rb
git add Casks/aime.rb
if ! git diff --cached --quiet; then
  msg=(-m "aime $version")
  [[ -n "${COMMIT_TRAILER:-}" ]] && msg+=(-m "$COMMIT_TRAILER")
  git commit -q "${msg[@]}"
fi
git log --oneline -1
