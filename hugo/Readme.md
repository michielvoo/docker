# Hugo

Hugo Extended and Git on Alpine Linux, for building static websites

This Docker image supports development and automated building of static 
websites. Change to a directory that contains the source for a Hugo website, 
and run the image to start the Hugo server at <http://localhost:1313> or to 
build the website:

```
docker run --rm -it -v $PWD:/root/work -p 1313:1313 hugo server --bind=0.0.0.0
docker run --rm -v $PWD:/root/work hugo
```

(These commands use a 'local' build of the Docker image named `hugo`.)

## Contributing

### How to: update Hugo and Git

Find the current versions of Hugo and Git for the base image's Apline Linux 
version [here](https://pkgs.alpinelinux.org/packages) and update the 
corresponding `apk add` commands in the Dockerfile accordingly.

After building the local Docker image run it to check the Git and Hugo versions:

```
docker run --rm -it --entrypoint git hugo --version
docker run --rm -it hugo version
```
