<!-- SPDX-License-Identifier: GPL-2.0-only -->

# Distribution packaging

This document describes the intended package boundary for distribution-built
versions of OpenGC570D. It does not claim endorsement by any distribution.

## Source and license

Build from an immutable tagged source archive. The project is licensed under
GPL-2.0-only and supports only PCI `1461:0054`, subsystem `1461:5700`.
Review [`DATA_PROVENANCE.md`](DATA_PROVENANCE.md), `NOTICE.md` and
[`LEGAL.md`](LEGAL.md) before accepting the package.

The build needs the target kernel's external-module build tree, `make`, the
matching GCC or LLVM toolchain, binutils and normal kernel-module development
dependencies. It does not need vendor firmware. The generated no-signal frame
is already present in tagged source archives; regenerating it additionally
requires `ffmpeg`, `ffprobe` and `xxd`.

The repository CI compiles against Fedora's packaged kernel and matching
toolchain. A separate repository check verifies that the Makefile selects
`LLVM=1` for a kernel build tree declaring `CONFIG_CC_IS_CLANG=y`. A real
CachyOS or other Clang-kernel package must still be built against that
distribution's own headers; forcing Clang against a GCC-built kernel is not an
equivalent compatibility test.

## Suggested package split

- A kernel package (`gc570d-kmod`/`akmod-gc570d`, or the distribution's
  equivalent) builds `gc570d.ko` for the exact target kernel.
- A common noarch package can carry the license, documentation and
  WirePlumber policy, and depend on the kernel-module package.
- A DKMS package can be offered where that is the distribution convention,
  but a DKMS build signed by a personal key is not equivalent to a
  distribution-built module signed by a recognized organizational key.

Install the module under the distribution's normal module tree, for example:

```text
/usr/lib/modules/<kernel-release>/extra/gc570d/gc570d.ko.xz
```

Run `depmod` after installation. The PCI module alias permits normal udev and
`modprobe` autoloading, so `config/systemd/gc570d.service` is not required for
a conventional package. That service exists for the portable `/var/lib`
installation used on immutable systems before a native package is available.

Install `config/wireplumber/51-gc570d.conf` in the system-wide WirePlumber
configuration location selected by the distribution. It gives stable desktop
names to the two ALSA capture devices; it is not involved in loading the
kernel module.

## Signing order

Build for the exact kernel, sign the final uncompressed `.ko`, verify its
metadata, and only then compress or package it. Do not strip, rewrite or append
data after signing because the kernel-module signature covers the complete
module image.

Useful checks include:

```sh
modinfo gc570d.ko | grep -E '^(vermagic|license|signer|sig_key|sig_hashalgo):'
modprobe --show-depends gc570d
```

Secure Boot accepts the module only when its signing certificate is trusted by
the running kernel. Compatibility with an attestation or anti-cheat policy is
a separate decision: a locally enrolled Machine Owner Key may be technically
trusted by the kernel while still being rejected by policy.

## Universal Blue and EAC Linux v2

For Bazzite, the intended path is a package built by `ublue-os/akmods` for the
Open Gaming Collective kernel and signed by Universal Blue's organizational
kernel-module keys. A locally signed portable module must not be advertised as
EAC Linux v2 compatible.

Epic's announced policy also requires a signed kernel, Secure Boot with only
well-known keys, TPM 2.0 measured boot, translated IOMMU operation, lockdown
integrity mode, disabled kexec and the BPF LSM. Distribution packaging of this
driver addresses only the kernel-module portion of that policy. Exact key
fingerprints and acceptance must be confirmed with Universal Blue and Epic;
the project cannot self-declare EAC compatibility.

References:

- <https://onlineservices.epicgames.com/news/introducing-easy-anti-cheat-linux-v2>
- <https://github.com/ublue-os/akmods>
- <https://docs.kernel.org/admin-guide/module-signing.html>
