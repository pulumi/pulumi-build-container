# Pulumi Build Container

This repository contains a `Dockerfile` for building a container image containing all of the build dependencies for Pulumi and the Pulumi provider ecosystem.

## Building

```shell
$ DOCKER_BUILDKit=1 docker build .
```

## CI and Releases

Snapshot builds of the container are built with every push to `master` and published to the GitHub Docker Registry for this repository. 

Release builds are made when tags of the form `vX` are pushed, and published to `pulumi/pulumi-build-container` on Docker Hub. Release builds are tagged both with the tag name and `latest`. 
