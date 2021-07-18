# Docker

Bespoke Docker images

![default workflow][badge]

This Git repository contains definitions for Docker images, as well as a GitHub workflow that 
builds the Docker images and pushes them to the Docker registry on [Docker Hub][hub] that 
corresponds to this GitHub repository's owner.

Pushing any Git tag that consists of two segments separated by `/` will trigger the workflow. The 
first segment should match both a top-level directory in this Git repository that contains a 
`Dockerfile`, as well as an existing Docker repository in the Docker registry on Docker Hub. The 
second segment of the Git tag indicates the version of the Docker image, and will be applied as a 
Docker tag to the Docker image before it is pushed.

## Docker images

- [aws](aws) - AWS Tools for PowerShell on Alpine Linux, for provisioning AWS resources
- [hugo](hugo) - Hugo Extended and Git on Alpine Linux, for building static websites

## How to: update a Docker image

Commit changes to the `Dockerfile`:

```
git add Dockerfile
git commit --message "..."
```

Remove the last locally built Docker image (optional) and rebuild the local Docker image:

```
docker image rm $(basename $PWD)
docker build . --tag $(basename $PWD)
```

Tag the Git commit:

```
git tag <tag>
```

Push the Git commit to GitHub, then push the Git tag to GitHub to trigger the GitHub workflow:

```
git push origin
git push origin <tag>
```

## How to: republish a Docker image

Delete the Git tag locally and on GitHub:

```
git tag --delete <tag>
git push origin --delete <tag>
```

Now tag the Git commit and push the Git commit and Git tag to GitHub to trigger the GitHub 
workflow.

```
git tag <tag>
git push origin
git push origin <tag>
```

The Docker image on Docker Hub will be replaced.

[badge]: https://github.com/michielvoo/Docker/actions/workflows/default.yml/badge.svg
[hub]: https://hub.docker.com
