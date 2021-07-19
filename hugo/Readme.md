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

### How to: update Hugo

Find the current versions of Hugo and Git for the current stable version of 
Alpine Linux [here](https://pkgs.alpinelinux.org/packages) (new versions of 
Alpine Linux are made available in May and November), and update the Dockerfile 
accordingly.

After building the local Docker image run it to check the Hugo version:

```
docker run --rm -it hugo version
```
