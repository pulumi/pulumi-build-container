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
    GOLANG_VERSION=1.13.10 \
    GOLANG_SHA256=8a4cbc9f2b95d114c38f6cbe94a45372d48c604b707db2057c787398dfbf8e7f \
    GOLANGCI_LINT_VERSION=1.23.8 \
    /build-scripts/install-go.sh

# Install Node.js and Yarn
RUN --mount=target=/build-scripts,type=bind,source=scripts \
    --mount=target=/var/lib/apt/lists,type=cache \
    --mount=target=/var/cache/apt,type=cache \
    NODE_VERSION=12.16.2 \
    NODE_DISTRO=bionic \
    YARN_VERSION=1.22.4 \
    /build-scripts/install-node.sh

# Install Python and accoutrements
RUN --mount=target=/build-scripts,type=bind,source=scripts \
    --mount=target=/var/lib/apt/lists,type=cache \
    --mount=target=/var/cache/apt,type=cache \
    PYTHON_VERSION=3.8 \
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

# Install Protocol Buffers compiler and various GRPC generators
RUN --mount=target=/build-scripts,type=bind,source=scripts \
    PROTOC_VERSION=3.11.4 \
    PROTOC_SHA256=6d0f18cd84b918c7b3edd0203e75569e0c8caecb1367bbbe409b45e28514f5be \
    PROTOC_GEN_GO_VERSION=1.3.3 \
    NODEJS_GRPC_VERSION=1.24.2 \
    NODEJS_GRPC_TOOLS_VERSION=1.8.1 \
    PYTHON_GRPCIO_VERSION=1.27.2 \
    PYTHON_GRPCIO_TOOLS_VERSION=1.27.2 \
    /build-scripts/install-protobuf-tools.sh

# Install Pulumi build tools
RUN --mount=target=/build-scripts,type=bind,source=scripts \
    TF2PULUMI_VERSION=0.8.0 \
    TF2PULUMI_SHA256=e4977893339949d11b79bdefdd3d011c59fd7bc5456e6f991ad055a4a5657b32\
    /build-scripts/install-pulumi-tools.sh

# Set various required environment variables
ENV GOPATH=/go \
    PATH=/go/bin:/root/.pulumi/bin:/usr/local/go/bin:/root/.yarn/bin/:$PATH \
    DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
