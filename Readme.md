# Docker

Bespoke Docker images

[![default workflow][badge]][workflow]

This Git repository contains definitions for Docker images, as well as GitHub workflows that 
test and build the Docker images, and push them to the Docker registry on [Docker Hub][hub] that 
corresponds to this GitHub repository's owner.

Pushing any Git tag that consists of two segments separated by `:` will trigger the workflow. The 
first segment should match both the path to a directory in this Git repository that contains a 
`Dockerfile`, as well as an existing Docker repository in the Docker registry on Docker Hub. The 
second segment of the Git tag indicates the version of the Docker image. The Git tag will be applied
as a Docker tag to the Docker image before it is pushed.

[badge]: https://github.com/michielvoo/Docker/actions/workflows/default.yml/badge.svg
[workflow]: https://github.com/michielvoo/Docker/actions/workflows/default.yml
[hub]: https://hub.docker.com

Docker images maintained in this repository:

- [aws](aws) - AWS Tools for PowerShell on Alpine Linux, for provisioning AWS resources and deploying applications to AWS
- [az](az) - Azure PowerShell on Alpine Linux, for provisioning Azure resources and deploying applications to Azure
- [hugo-sdk](hugo-sdk) - Hugo Extended and Git on Alpine Linux, for building static websites
- [pester](pester) - Pester for PowerShell on Alpine Linux, for automated testing of PowerShell scripts and modules
- [powershell-sdk](powershell-sdk)
- [pwsh](pwsh) - PowerShell on Alpine Linux, for running a PowerShell command or script
