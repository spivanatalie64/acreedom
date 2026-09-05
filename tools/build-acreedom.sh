#!/usr/bin/env bash
set -euo pipefail
root=$(pwd)
shopt -s nullglob
sources=(output/icecat-*/)
[[ ${#sources[@]} == 1 ]]
cd "${sources[0]}"
./mach build
./mach package
packages=(obj-acreedom/dist/acreedom-*.tar.xz obj-acreedom/dist/acreedom-*.tar.bz2)
[[ ${#packages[@]} == 1 ]]
mkdir -p "$root/output/smoke" "$root/output/release"
tar -xf "${packages[0]}" -C "$root/output/smoke"
binary="$root/output/smoke/acreedom/acreedom"
"$binary" --version | tee "$root/output/release/browser-version.txt"
grep -qi acreedom "$root/output/release/browser-version.txt"
timeout 120 "$binary" --headless --screenshot "$root/output/smoke/screenshot.png" 'data:text/html,<h1>Acreedom smoke test</h1>'
test -s "$root/output/smoke/screenshot.png"
cp "${packages[0]}" "$root/output/release/"
version=$(cat browser/config/version.txt)
printf '%s\n' "$version" > "$root/output/release/VERSION"
# Include the exact branded source and configuration used to compile the binary.
tar --exclude='./obj-acreedom' -cJf "$root/output/release/acreedom-$version-source.tar.xz" .
cd "$root/output/release"
cat > BUILD.md <<EOF
Acreedom $version for Linux x86-64, compiled from GNU IceCat / Firefox ESR.

Repository commit: ${GITHUB_SHA:-$(git -C "$root" rev-parse HEAD)}
Workflow: https://github.com/${GITHUB_REPOSITORY:-spivanatalie64/acreedom}/actions/runs/${GITHUB_RUN_ID:-local}

Includes the compiled browser, corresponding branded source and SHA-256 checksums.
Validation: packaged executable reports Acreedom and renders a headless screenshot.
Acreedom product naming is applied; upstream IceCat artwork and license notices are retained.
EOF
sha256sum ./*.tar.* browser-version.txt VERSION BUILD.md > SHA256SUMS
