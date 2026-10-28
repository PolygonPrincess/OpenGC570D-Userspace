<!-- SPDX-License-Identifier: GPL-2.0-only -->

Feature and driver-fix pull requests should normally target `dev`. Target
`main` only for a `dev` promotion, a release-related change or a narrowly
scoped urgent fix. See the [branch and validation
workflow](../CONTRIBUTING.md#branch-and-validation-workflow).

## Summary

Describe the problem and the narrow change that addresses it.

## Evidence

- Kernel and distribution:
- GC570D PCI subsystem:
- HDMI source/display mode, when relevant:
- Static-analysis evidence, when relevant:
- Physical hardware result, when relevant:

## Checklist

- [ ] I kept the validated HDMI IN 2 path unchanged, or explicitly tested it.
- [ ] I separated static-analysis conclusions from physical observations.
- [ ] I ran `make`, `make check`, and `git diff --check`.
- [ ] I disclosed any AI-assisted work and reviewed the resulting changes.
- [ ] I did not include proprietary drivers, firmware, private captures, or investigation artifacts.
