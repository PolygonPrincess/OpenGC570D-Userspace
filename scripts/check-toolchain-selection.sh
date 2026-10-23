#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
# Check Makefile selection without requiring a second installed kernel.

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT HUP INT TERM

mkdir -p "$WORK_DIR/gcc/include/config" "$WORK_DIR/clang/include/config"
: > "$WORK_DIR/gcc/include/config/auto.conf"
printf '%s\n' 'CONFIG_CC_IS_CLANG=y' > \
	"$WORK_DIR/clang/include/config/auto.conf"

gcc_result=$(
	unset LLVM
	make -s -C "$PROJECT_DIR" KDIR="$WORK_DIR/gcc" print-toolchain
)
clang_result=$(
	unset LLVM
	make -s -C "$PROJECT_DIR" KDIR="$WORK_DIR/clang" print-toolchain
)
override_result=$(
	LLVM=custom make -s -C "$PROJECT_DIR" KDIR="$WORK_DIR/clang" \
		print-toolchain
)

[ "$gcc_result" = 'LLVM=' ] || {
	echo "unexpected GCC-kernel selection: $gcc_result" >&2
	exit 1
}
[ "$clang_result" = 'LLVM=1' ] || {
	echo "unexpected Clang-kernel selection: $clang_result" >&2
	exit 1
}
[ "$override_result" = 'LLVM=custom' ] || {
	echo "explicit LLVM override was not preserved: $override_result" >&2
	exit 1
}

echo "Toolchain auto-selection check passed"
