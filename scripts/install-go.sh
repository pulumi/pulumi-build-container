#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o xtrace

SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#shellcheck source=utils.sh
source "${SCRIPT_ROOT}/utils.sh"

ensureSet "${GOLANG_VERSION}" "GOLANG_VERSION" || exit 1
ensureSet "${GOLANG_SHA256}" "GOLANG_SHA256" || exit 1
ensureSet "${GOLANGCI_LINT_VERSION}" "GOLANGCI_LINT_VERSION" || exit 1

curl --silent -qL \
    -o /tmp/go.tar.gz \
    "https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz"

verifySHASUM "/tmp/go.tar.gz" "${GOLANG_SHA256}" || exit 1

tar -C /usr/local -xzf /tmp/go.tar.gz

rm /tmp/go.tar.gz

/usr/local/go/bin/go version

mkdir -p /go/{src,pkg,bin}
chmod -R 777 /go

# Install GolangCI Lint
curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | \
    sh -s -- -b "/usr/local/bin" "v${GOLANGCI_LINT_VERSION}"

# Install gocovmerge
#
# gocovmerge does not publish versioned releases, but it also hasn't been updated
# in two years, so getting HEAD is pretty safe.
/usr/local/go/bin/go get -v github.com/wadey/gocovmerge
