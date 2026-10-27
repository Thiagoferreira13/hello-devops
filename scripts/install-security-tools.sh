#!/usr/bin/env bash
# Releases oficiais fixadas por versão e SHA-256. Linux x86_64.
set -euo pipefail
bin_dir="${RUNNER_TEMP:-/tmp}/hello-devops-security-bin"
mkdir -p "$bin_dir"
work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT
for tool in "$@"; do
  case "$tool" in
    gitleaks) url='https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz'; checksum='551f6fc83ea457d62a0d98237cbad105af8d557003051f41f3e7ca7b3f2470eb' ;;
    trivy) url='https://github.com/aquasecurity/trivy/releases/download/v0.76.1/trivy_0.76.1_Linux-64bit.tar.gz'; checksum='c7cbe3137fb8a48a17574bede3dd6beb16742d1e9772929940fc90082c39d9c0' ;;
    syft) url='https://github.com/anchore/syft/releases/download/v1.55.0/syft_1.55.0_linux_amd64.tar.gz'; checksum='bb65249542db5fedeeb4d3f9b018b75e7264dbfbbb10486f044581a92f90490d' ;;
    *) echo "Ferramenta não suportada: $tool" >&2; exit 1 ;;
  esac
  curl --fail --silent --show-error --location --retry 3 "$url" -o "$work_dir/package.tar.gz"
  printf '%s  %s\n' "$checksum" "$work_dir/package.tar.gz" | sha256sum --check
  tar -xzf "$work_dir/package.tar.gz" -C "$bin_dir" "$tool"
  chmod +x "$bin_dir/$tool"
done
if [ -n "${GITHUB_PATH:-}" ]; then
  printf '%s\n' "$bin_dir" >> "$GITHUB_PATH"
else
  printf 'Ferramentas instaladas em: %s\n' "$bin_dir"
fi
