# Hugo

Hugo Extended and Git on Alpine Linux, for building static websites

## How to: update Hugo

Find the current versions of Hugo and Git for the current stable version of 
Alpine Linux [here](https://pkgs.alpinelinux.org/packages) (new versions of 
Alpine Linux are made available in May and November), and update the Dockerfile.

After building the local Docker image run it to check the Hugo version:

```
docker run --rm -it hugo version
```

Change to a directory that contains a Hugo website, and run the local image to 
start the Hugo server:

```
docker run --rm -it -v $PWD:/src -p 1313:1313 hugo server --bind=0.0.0.0
```

Browse to <http://localhost:1313> to test the website.
