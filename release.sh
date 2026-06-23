#!/usr/bin/env bash
#
# Cuts a release: bumps the version in pyproject.toml, regenerates CHANGELOG.md
# from the commit history (git-cliff), commits, and creates an annotated tag
# whose message is the changelog for the new version.
#
# Usage: ./release.sh v[X.Y.Z]
#   e.g. ./release.sh v1.2.0
#
# Afterwards, push with: git push && git push --tags

set -euo pipefail

if [ -z "${1:-}" ]; then
	echo "Please provide a tag."
	echo "Usage: ./release.sh v[X.Y.Z]"
	exit 1
fi

tag="$1"
version="${tag#v}"

# Tag must look like vMAJOR.MINOR.PATCH (optionally with a -prerelease suffix).
if ! [[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
	echo "Error: tag must be of the form v[X.Y.Z] (got '$tag')."
	exit 1
fi

# Refuse to release from a dirty tree so the version bump is the only change.
if [ -n "$(git status --porcelain)" ]; then
	echo "Error: working tree is not clean. Commit or stash changes first."
	exit 1
fi

if git rev-parse "$tag" >/dev/null 2>&1; then
	echo "Error: tag '$tag' already exists."
	exit 1
fi

echo "Preparing $tag..."

# Update the version in pyproject.toml in place (only the first `version =`
# under [project]; tool tables don't carry one in this template).
python - "$version" <<'PY'
import re
import sys
from pathlib import Path

version = sys.argv[1]
path = Path("pyproject.toml")
text = path.read_text()
text, count = re.subn(r'^version = ".*"', f'version = "{version}"', text, count=1, flags=re.M)
if count != 1:
	sys.exit('Error: could not find a `version = "..."` line in pyproject.toml.')
path.write_text(text)
PY

# Regenerate the changelog including the new tag.
git-cliff --config cliff.toml --tag "$tag" --output CHANGELOG.md

git add -A
git commit -m "chore(release): prepare for $tag"
git show --stat

# Build the tag message from the unreleased section of the changelog.
export GIT_CLIFF_TEMPLATE="\
	{% for group, commits in commits | group_by(attribute=\"group\") %}
	{{ group | upper_first }}\
	{% for commit in commits %}
		- {% if commit.breaking %}(breaking) {% endif %}{{ commit.message | upper_first }} ({{ commit.id | truncate(length=7, end=\"\") }})\
	{% endfor %}
	{% endfor %}"
changelog="$(git-cliff --config cliff.toml --unreleased --strip all)"
git tag -a "$tag" -m "Release $tag" -m "$changelog"

echo "Done!"
echo "Now push the commit and tag: git push && git push --tags"
