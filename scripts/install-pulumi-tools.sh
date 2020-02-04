#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o xtrace

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"
#shellcheck source=utils.sh
source "${SCRIPT_ROOT}/utils.sh"

ensureSet "${TF2PULUMI_VERSION}" "TF2PULUMI_VERSION" || exit 1
ensureSet "${TF2PULUMI_SHA256}" "TF2PULUMI_SHA256" || exit 1

# Install Pulumi CLI
curl -fsSL https://get.pulumi.com | sh

# Install tf2pulumi
curl --silent -qL \
	-o /tmp/tf2pulumi.tar.gz \
	"https://github.com/pulumi/tf2pulumi/releases/download/v${TF2PULUMI_VERSION}/tf2pulumi-v${TF2PULUMI_VERSION}-linux-x64.tar.gz"
verifySHASUM "/tmp/tf2pulumi.tar.gz" "${TF2PULUMI_SHA256}" || exit 1
tar -C /usr/local/bin -xzf /tmp/tf2pulumi.tar.gz
rm /tmp/tf2pulumi.tar.gz

# Install gomod-doccopy
/usr/local/go/bin/go get -v github.com/pulumi/scripts/gomod-doccopy
