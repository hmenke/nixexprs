#!/usr/bin/env bash
#shellcheck enable=all

{ # Prevent execution if this script was only partially downloaded

set -o errexit
set -o nounset
set -o pipefail

_HOME=~
cd "${_HOME}"

url="${NIXEXPRS_ARTIFACT_URL:-https://hmenke.github.io/nixexprs/local-bin-share.tar.gz}"
versions=".local/share/nixexprs/package-versions"

echo "==> Downloading ${url}"
if command -v curl >/dev/null; then
	curl -fL --progress-bar -o local-bin-share.tar.gz "${url}"
elif command -v wget >/dev/null; then
	wget -q -O local-bin-share.tar.gz "${url}"
elif command -v python3 >/dev/null; then
	python3 -I -c 'import sys, urllib.request; urllib.request.urlretrieve(*sys.argv[1:])' "${url}" local-bin-share.tar.gz
else
	echo "error: need one of curl, wget or python3 to download" >&2; exit 1
fi

if [[ ! -f "${_HOME}/${versions}" ]]; then
	echo "==> Fresh installation, no previous package versions found"
elif diff -U0 -L installed -L new "${versions}" <(gzip -dc local-bin-share.tar.gz | tar -xOf - "${versions}" || true); then
	echo "==> Package versions are unchanged"
fi

echo "==> Installing into ${_HOME}"
gzip -dc local-bin-share.tar.gz | tar -xf - -C "${_HOME}"

echo "==> Removing local-bin-share.tar.gz"
rm local-bin-share.tar.gz

} # End of wrapping
