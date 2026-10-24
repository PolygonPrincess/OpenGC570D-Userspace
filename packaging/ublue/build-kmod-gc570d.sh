#!/usr/bin/bash
# SPDX-License-Identifier: GPL-2.0-only
# Proposed ublue-os/akmods extra-group builder for OpenGC570D.

set ${CI:+-x} -euo pipefail

ARCH="$(rpm -E '%_arch')"
KERNEL="$(rpm -q "${KERNEL_NAME}" --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"
REPO=/etc/yum.repos.d/_copr_ublue-os-akmods.repo

cp /tmp/ublue-os-akmods-addons/rpmbuild/SOURCES/_copr_ublue-os-akmods.repo \
    "$REPO"

dnf install -y "akmod-gc570d-*.fc${RELEASE}.${ARCH}"
akmods --force --kernels "$KERNEL" --kmod gc570d

MODULE="/usr/lib/modules/${KERNEL}/extra/gc570d/gc570d.ko.xz"
modinfo "$MODULE" > /dev/null || {
    find /var/cache/akmods/gc570d/ -name '*.log' -print -exec cat {} \;
    exit 1
}

mkdir -p /var/cache/rpms/extra
dnf download --destdir /var/cache/rpms/extra gc570d
rm -f /var/cache/rpms/extra/*.src.rpm
rm -f "$REPO"
