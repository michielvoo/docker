# Docker

Bespoke Docker images

![default workflow][badge]

This Git repository contains definitions for Docker images, as well as a GitHub workflow that 
builds the Docker images and pushes them to the Docker registry on [Docker Hub][hub] that 
corresponds to the GitHub repository's owner. 

Pushing any Git tag that consists of two segments separated by `/` will trigger the workflow. The 
first segment should match both a top-level directory in this Git repository that contains a 
`Dockerfile`, as well as an existing Docker repository in the Docker registry on Docker Hub. The 
second segment of the Git tag indicates the version of the Docker image, and will be applied as a 
Docker tag to the Docker image before it is pushed.

## How to: update a Docker image

Commit changes to the `Dockerfile`:

```
git add Dockerfile
git commit -m "..."
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

Now tag another Git commit and push the Git commit and Git tag to GitHub to trigger the GitHub 
workflow. The Docker image on Docker Hub will be replaced.

[badge]: https://github.com/michielvoo/Docker/actions/workflows/default.yml/badge.svg
[hub]: https://hub.docker.com
