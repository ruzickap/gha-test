# AI Agent Guidelines

## Overview

This repository (`ruzickap/gha-test`) is a GitHub Actions test/template
repository. It contains CI/CD workflows, linting configs, shell scripts,
Terraform files, a Dockerfile, and Markdown documentation. There is no
application source code or traditional test suite.

## Build/Lint/Test Commands

CI runs via MegaLinter (`.mega-linter.yml`). Run individual linters
locally as follows:

```bash
# Markdown linting (Rust-based, config: .rumdl.toml)
rumdl .
rumdl README.md              # single file

# Shell script linting and formatting
shellcheck --exclude=SC2317 path/to/script.sh
shfmt --case-indent --indent 2 --space-redirects -d path/to/script.sh
shfmt --case-indent --indent 2 --space-redirects -w path/to/script.sh

# JSON linting (allows comments)
jsonlint --comments path/to/file.json

# Link checking (config: lychee.toml)
lychee .
lychee README.md              # single file

# Terraform
tflint
checkov --quiet -f cloudwatch-log-group-unencrypted.tf
trivy config --severity HIGH,CRITICAL --ignore-unfixed .
kics scan --fail-on high -p .

# GitHub Actions workflow validation
actionlint

# TypeScript/JavaScript formatting
prettier --html-whitespace-sensitivity=ignore --check .
prettier --html-whitespace-sensitivity=ignore --write .

# Run full MegaLinter locally via Docker (documentation flavor)
docker run --rm -v "$(pwd):/tmp/lint" \
  oxsecurity/megalinter/flavors/documentation:v9
```

There are no unit tests. Validation is done entirely through linting
and security scanning in CI.

## Code Style Guidelines

### General

- Use **two spaces** for indentation everywhere (YAML, shell, HCL, JSON)
- Never use tabs
- Wrap Markdown prose lines at **72 characters**
- Use `# keep-sorted start` / `# keep-sorted end` blocks to maintain
  sorted sections in YAML and JSON5 config files

### Markdown

- Use proper heading hierarchy (never skip levels)
- Include language identifiers in code fences (`bash`, `json`, `hcl`)
- Prefer code fences over inline code for multi-line examples
- Shell code blocks (tagged `bash`, `shell`, or `sh`) are extracted
  and validated with `shellcheck` + `shfmt` during CI
- Exclude `CHANGELOG.md` from manual edits (auto-generated)

### Shell Scripts

- Shebang: `#!/usr/bin/env bash`
- Strict mode: `set -euo pipefail`
- Variables: **UPPERCASE** with braces (`${MY_VARIABLE}`)
- Local variables in functions: `local` keyword, still uppercase
- Quoting: always quote variables (`"${VAR}"`)
- Conditionals: use `[[ ]]` (not `[ ]`)
- Logging: use simple functions (`log`, `log_info`, `log_error`, `die`)
  that write to stderr (`>&2`)
- Error handling: validate inputs early, use `die` for fatal errors
- Formatting: `shfmt --case-indent --indent 2 --space-redirects`
- Linting: `shellcheck --exclude=SC2317`

### Terraform (HCL)

- Two-space indentation
- Align `=` signs in attribute blocks
- Document intentional security skips with inline comments:
  - Checkov: `#checkov:skip=CKV_XXX:Reason`
  - Trivy: `# trivy:ignore:AVD-XXX`
  - KICS: inline comment with reason

### Dockerfile

- Pin base images to digest (`image@sha256:...`)
- Use `SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]`
- Clean up apt caches in the same `RUN` layer
- Run as non-root user
- Include `HEALTHCHECK` instruction
- Add Checkov skip annotations with reasons

### GitHub Actions Workflows

- **Pin all actions to full SHA** with version comment:
  `uses: actions/checkout@<sha> # v4.2.0`
- Top-level `permissions: read-all`; elevate per-job as needed
- Set `timeout-minutes` on every job
- Start YAML files with `---` and a descriptive comment header
- Use `# keep-sorted start/end` for sorted config blocks
- Use Renovate annotations for automated dependency tracking:
  `# renovate: datasource=github-releases depName=org/repo`

### JSON / JSON5

- Two-space indentation
- Comments are allowed (validated with `jsonlint --comments`)
- `.devcontainer/devcontainer.json` is excluded from linting

## Version Control

### Commit Messages

Conventional commit format: `<type>: <description>`. Types: `feat`,
`fix`, `docs`, `chore`, `refactor`, `test`, `style`, `perf`, `ci`,
`build`, `revert`. Imperative mood, lowercase, no trailing period.
Max 72 characters (subject and body lines). Body: explain **what**
and **why**, reference issues with `Fixes`, `Closes`, or `Resolves`.

### Branching

[Conventional Branch](https://conventional-branch.github.io/) format:
`<type>/<description>` (`feature/`, `bugfix/`, `hotfix/`, `release/`,
`chore/`). Lowercase, hyphens only. Include issue number when
applicable: `feature/issue-42-add-feature`.

### Pull Requests

- Always create as **draft** initially
- Title must follow conventional commit format
- Include clear description and link related issues

## Security Scanning

- **Checkov**: IaC scanner (skips `CKV_GHA_7` via `.checkov.yml`)
- **DevSkim**: Ignores DS162092, DS137138; excludes `CHANGELOG.md`
- **KICS**: Fails only on HIGH severity
- **Trivy**: HIGH/CRITICAL only, ignores unfixed vulnerabilities
- **CodeQL**: GitHub Actions analysis on push to main

## Quality Checklist

- [ ] `rumdl .` passes for Markdown files
- [ ] `shellcheck` and `shfmt` pass for shell scripts
- [ ] `actionlint` passes for workflow files
- [ ] `tflint` and `checkov` pass for Terraform files
- [ ] `lychee` finds no broken links in changed files
- [ ] Commit messages follow conventional commit format
- [ ] Lines wrapped at 72 characters in Markdown/commits
- [ ] GitHub Actions pinned to full SHA commits
