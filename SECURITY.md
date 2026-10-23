<!-- SPDX-License-Identifier: GPL-2.0-only -->

# Security policy

## Supported versions

Security fixes are developed against `main` and released from the latest
tagged version. Older releases are not maintained as separate branches.

## Reporting a vulnerability

Use GitHub's private vulnerability reporting for this repository when it is
available under **Security → Report a vulnerability**. If that option is not
available, open a public issue requesting a private contact channel without
including exploit details, private captures, credentials or proprietary
files.

Include the affected commit or release, kernel version, PCI IDs, trigger and
impact. Reports involving DMA, memory corruption, privilege boundaries,
module-signature handling or unsafe device state are security-sensitive.

Ordinary capture failures, unsupported signal modes and build regressions can
be reported through the normal issue tracker.

The project cannot promise a private response deadline, but maintainers will
avoid publishing vulnerability details before a fix or mitigation is ready.
