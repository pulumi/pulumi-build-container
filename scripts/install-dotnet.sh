#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o xtrace

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"
#shellcheck source=utils.sh
source "${SCRIPT_ROOT}/utils.sh"

ensureSet "${DOTNET_SDK_VERSION}" "DOTNET_SDK_VERSION" || exit 1

export DEBIAN_FRONTEND=noninteractive

curl -sSL https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
	-o packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

apt-get update

apt-get install -y \
	"dotnet-sdk-${DOTNET_SDK_VERSION}" \
	"aspnetcore-runtime-${DOTNET_SDK_VERSION}"
