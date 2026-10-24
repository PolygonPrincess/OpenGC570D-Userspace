#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
# Check invariants shared by the Fedora common and AKMOD specifications.

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
PACKAGING_DIR="$PROJECT_DIR/packaging/fedora"
KMOD_SPEC="$PACKAGING_DIR/gc570d-kmod.spec"
COMMON_SPEC="$PACKAGING_DIR/gc570d.spec"

die()
{
	echo "check-fedora-packaging: $*" >&2
	exit 1
}

spec_version()
{
	sed -n 's/^Version:[[:space:]]*//p' "$1" | sed -n '1p'
}

[ -f "$KMOD_SPEC" ] || die "missing gc570d-kmod.spec"
[ -f "$COMMON_SPEC" ] || die "missing gc570d.spec"
[ -f "$PACKAGING_DIR/gc570d.rpmlintrc" ] || die "missing gc570d.rpmlintrc"

KMOD_VERSION=$(spec_version "$KMOD_SPEC")
COMMON_VERSION=$(spec_version "$COMMON_SPEC")
[ -n "$KMOD_VERSION" ] || die "gc570d-kmod.spec has no Version"
[ "$KMOD_VERSION" = "$COMMON_VERSION" ] ||
	die "spec versions differ: kmod=$KMOD_VERSION common=$COMMON_VERSION"

grep -Fq 'https://github.com/neoyagami/OpenGC570D' "$KMOD_SPEC" ||
	die "kmod spec does not use the canonical upstream"
grep -Fq '/archive/refs/tags/v%{version}/' "$KMOD_SPEC" ||
	die "kmod spec does not build from an immutable release tag"
grep -Fq 'ExclusiveArch:  x86_64' "$KMOD_SPEC" ||
	die "kmod spec must remain restricted to the tested architecture"
grep -Fq 'Provides:       %{name}-kmod-common = %{version}-%{release}' \
	"$COMMON_SPEC" || die "common package does not provide kmod-common"
grep -Fq 'Requires:       %{name}-kmod >= %{version}' "$COMMON_SPEC" ||
	die "common package does not require its matching kernel module"

if [ -n "${EXPECTED_VERSION:-}" ] && [ "$KMOD_VERSION" != "$EXPECTED_VERSION" ]; then
	die "spec version $KMOD_VERSION does not match expected $EXPECTED_VERSION"
fi

echo "Fedora packaging checks passed for OpenGC570D $KMOD_VERSION"
