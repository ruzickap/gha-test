#!/usr/bin/env bash

set -euo pipefail

# Test123

# Configuration
GH_REPO_DEFAULTS_BASE="${GH_REPO_DEFAULTS_BASE:-${HOME}/git/my-git-projects/gh-repo-defaults}"

# Simple logging
log() { echo "[$(date +'%H:%M:%S')] ${*}" >&2; }
log_info() { log "INFO: ${*}"; }
log_error() { log "ERROR: ${*}"; }
die() {
  log_error "${*}"
  exit 1
}

# Validation
[[ -n "${REPOSITORY:-}" ]] || die "REPOSITORY environment variable required"
[[ -d "${GH_REPO_DEFAULTS_BASE}" ]] || die "Defaults directory not found: ${GH_REPO_DEFAULTS_BASE}"
command -v rclone > /dev/null || die "rclone not found"
command -v git > /dev/null || die "git not found"

# Core functions
copy_defaults() {
  local SOURCE_DIR="${1}"
  local DESCRIPTION="${2:-${SOURCE_DIR##*/}}"

  if [[ ! -d "${SOURCE_DIR}" ]]; then
    log "ERROR: Source directory not found: ${SOURCE_DIR}"
    return 1
  fi

  log_info "${DESCRIPTION} | ${REPOSITORY}"
  if ! rclone copyto --verbose --stats 0 --no-update-modtime --no-update-dir-modtime "${SOURCE_DIR}" .; then
    log_error "Failed to copy from: ${SOURCE_DIR}"
    return 1
  fi
}

checkout_files() {
  for FILE in "${@}"; do
    if git checkout "${FILE}" 2> /dev/null; then
      log_info "Checked out: ${FILE}"
    else
      log_info "Skipped: ${FILE}"
    fi
  done
}

remove_files() {
  for FILE in "${@}"; do
    [[ -f "${FILE}" ]] && rm "${FILE}" && log_info "Removed: ${FILE}"
  done
}

# Set MegaLinter flavor in workflow file
# Flavors: https://megalinter.io/v9/flavors/
megalinter_flavor() {
  local FLAVOR="${1}"
  local WORKFLOW_FILE=".github/workflows/mega-linter.yml"

  # Associative array mapping flavor names to full action references
  declare -A MEGALINTER_FLAVORS=(
    # renovate: datasource=github-tags depName=oxsecurity/megalinter
    ["c_cpp"]="uses: oxsecurity/megalinter/flavors/c_cpp@55a59b24a441e0e1943080d4a512d827710d4a9d # 9.2.0"
    # renovate: datasource=github-tags depName=oxsecurity/megalinter
    ["ci_light"]="uses: oxsecurity/megalinter/flavors/ci_light@55a59b24a441e0e1943080d4a512d827710d4a9d # 9.2.0"
    # renovate: datasource=github-tags depName=oxsecurity/megalinter
    ["cupcake"]="uses: oxsecurity/megalinter/flavors/cupcake@55a59b24a441e0e1943080d4a512d827710d4a9d # 9.2.0"
    # renovate: datasource=github-tags depName=oxsecurity/megalinter
    ["documentation"]="uses: oxsecurity/megalinter/flavors/documentation@55a59b24a441e0e1943080d4a512d827710d4a9d # 9.2.0"
    # renovate: datasource=github-tags depName=oxsecurity/megalinter
    ["python"]="uses: oxsecurity/megalinter/flavors/python@55a59b24a441e0e1943080d4a512d827710d4a9d # 9.2.0"
    # renovate: datasource=github-tags depName=oxsecurity/megalinter
    ["ruby"]="uses: oxsecurity/megalinter/flavors/ruby@55a59b24a441e0e1943080d4a512d827710d4a9d # 9.2.0"
    # renovate: datasource=github-tags depName=oxsecurity/megalinter
    ["security"]="uses: oxsecurity/megalinter/flavors/security@55a59b24a441e0e1943080d4a512d827710d4a9d # 9.2.0"
    # renovate: datasource=github-tags depName=oxsecurity/megalinter
    ["terraform"]="uses: oxsecurity/megalinter/flavors/terraform@55a59b24a441e0e1943080d4a512d827710d4a9d # 9.2.0"
  )

  # Validate flavor
  if [[ -z "${MEGALINTER_FLAVORS[${FLAVOR}]+x}" ]]; then
    log_error "Invalid MegaLinter flavor: ${FLAVOR}"
    log_error "Valid flavors: ${!MEGALINTER_FLAVORS[*]}"
    return 1
  fi

  if [[ ! -f "${WORKFLOW_FILE}" ]]; then
    log_error "Workflow file not found: ${WORKFLOW_FILE}"
    return 1
  fi

  # Replace megalinter action with flavored version
  local ACTION_REF="${MEGALINTER_FLAVORS[${FLAVOR}]}"
  if sed -i "s|uses: oxsecurity/megalinter.*|${ACTION_REF}|" "${WORKFLOW_FILE}"; then
    log_info "Set MegaLinter flavor: ${FLAVOR}"
  else
    log_error "Failed to set MegaLinter flavor: ${FLAVOR}"
    return 1
  fi
}

# Main processing
log_info "Processing ${REPOSITORY}"

# Always copy base defaults
copy_defaults "${GH_REPO_DEFAULTS_BASE}/my-defaults"
sed -i "s@/ruzickap/my-git-projects/@/${REPOSITORY}/@" ".github/ISSUE_TEMPLATE/config.yml"

# Repository-specific handling
case "${REPOSITORY}" in
  ruzickap/action-*)
    copy_defaults "${GH_REPO_DEFAULTS_BASE}/action"
    ;;
  ruzickap/ansible-*)
    copy_defaults "${GH_REPO_DEFAULTS_BASE}/ansible"
    ;;
  ruzickap/cheatsheet-*)
    copy_defaults "${GH_REPO_DEFAULTS_BASE}/latex"
    ;;
  ruzickap/cv)
    copy_defaults "${GH_REPO_DEFAULTS_BASE}/latex"
    # arm64 is not supported in private repos
    checkout_files "run.sh" ".github/workflows/commit-check.yml" ".github/workflows/release-please.yml" ".github/workflows/renovate.yml" ".github/workflows/semantic-pull-request.yml" ".github/workflows/stale.yml"
    remove_files ".github/workflows/codeql.yml" ".github/workflows/scorecards.yml"
    ;;
  ruzickap/caisp-notes)
    # arm64 is not supported in private repos
    checkout_files ".github/workflows/commit-check.yml" ".github/workflows/release-please.yml" ".github/workflows/renovate.yml" ".github/workflows/semantic-pull-request.yml" ".github/workflows/stale.yml" ".mega-linter.yml"
    remove_files ".github/workflows/codeql.yml" ".github/workflows/scorecards.yml"
    ;;
  ruzickap/gha_test)
    remove_files ".github/workflows/pr-slack-notification.yml"
    ;;
  ruzickap/petr.ruzicka.dev | ruzickap/xvx.cz)
    copy_defaults "${GH_REPO_DEFAULTS_BASE}/hugo"
    ;;
  ruzickap/malware-cryptominer-container)
    checkout_files ".checkov.yml" ".github/workflows/release-please.yml" ".github/renovate.json5"
    ;;
  ruzickap/ruzickap.github.io)
    checkout_files ".github/renovate.json5" ".rumdl.toml" ".mega-linter.yml" "AGENTS.md"
    ;;
  *)
    log_info "Using default configuration for ${REPOSITORY}"
    ;;
esac

log_info "Completed processing ${REPOSITORY}"
