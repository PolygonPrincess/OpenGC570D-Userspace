<!-- SPDX-License-Identifier: GPL-2.0-only -->

# Maintainers

## Project maintainer

- `neoyagami` — repository owner, release maintainer and primary hardware
  tester: <https://github.com/neoyagami>

GitHub issues and pull requests are the public support and contribution
channels. Security-sensitive reports should follow [`SECURITY.md`](SECURITY.md).

## Maintained scope

The maintained hardware match is the AVerMedia Live Gamer DUO GC570D PCI
device `1461:0054` with subsystem `1461:5700`. The latest release and the
`main` branch are the maintained software lines. A build on another device ID
does not imply hardware support.

Maintenance covers:

- review of narrowly scoped fixes and kernel-compatibility updates;
- tagged source releases after repository and hardware checks;
- physical regression testing when a change affects validated hardware paths;
- accurate separation between recovered behavior, automated checks and
  physical observations; and
- coordination with distribution packagers for reproducible external-module
  builds.

This remains an experimental community driver. Maintenance does not imply a
hardware warranty, support for protected content or validation of every HDMI
source/display combination.
