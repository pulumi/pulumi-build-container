# syntax = docker/dockerfile:experimental
FROM ubuntu:bionic

LABEL description="Pulumi Build Container"
LABEL maintainer="james@jen20.com"

# Install various packages
RUN --mount=target=/build-scripts,type=bind,source=scripts \
    --mount=target=/var/lib/apt/lists,type=cache \
    --mount=target=/var/cache/apt,type=cache \
    /build-scripts/install-packages.sh

# Install Go compiler and linter
RUN --mount=target=/build-scripts,type=bind,source=scripts \
    GOLANG_VERSION=1.13.7 \
    GOLANG_SHA256=b3dd4bd781a0271b33168e627f7f43886b4c5d1c794a4015abf34e99c6526ca3 \
    GOLANGCI_LINT_VERSION=1.18.0 \
    /build-scripts/install-go.sh

# Install Node.js and Yarn
RUN --mount=target=/build-scripts,type=bind,source=scripts \
    --mount=target=/var/lib/apt/lists,type=cache \
    --mount=target=/var/cache/apt,type=cache \
    NODE_VERSION=10.x \
    NODE_DISTRO=bionic \
    YARN_VERSION=1.21.1 \
    /build-scripts/install-node.sh

# Install Python and accoutrements
RUN --mount=target=/build-scripts,type=bind,source=scripts \
    --mount=target=/var/lib/apt/lists,type=cache \
    --mount=target=/var/cache/apt,type=cache \
    PYTHON_VERSION=3.7 \
    PIPENV_VERSION=2018.11.26 \
    AWSCLI_VERSION=1.17.9 \
    WHEEL_VERSION=0.34.2 \
    TWINE_VERSION=3.1.1 \
    /build-scripts/install-python.sh

# Install Dotnet
RUN --mount=target=/build-scripts,type=bind,source=scripts \
    --mount=target=/var/lib/apt/lists,type=cache \
    --mount=target=/var/cache/apt,type=cache \
    DOTNET_SDK_VERSION=3.1 \
    /build-scripts/install-dotnet.sh

# Install Pulumi build tools
RUN --mount=target=/build-scripts,type=bind,source=scripts \
    TF2PULUMI_VERSION=0.6.0 \
    TF2PULUMI_SHA256=9a8fdfc590f8813a5ccaf1bfb1abba3064f109cce34f47fc66a34adaaa44c50f \
    /build-scripts/install-pulumi-tools.sh

# Set various required environment variables
ENV GOPATH=/go \
    PATH=/go/bin:/root/.pulumi/bin:/usr/local/go/bin:/root/.yarn/bin/:$PATH \
    DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
