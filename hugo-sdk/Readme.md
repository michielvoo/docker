# hugo-sdk

Hugo Extended and Git on Alpine Linux, for building static websites

## Usage

This Docker image supports development and automated building of static 
websites. Change to a directory that contains the source for a Hugo website, 
and run a container from this image to start the Hugo server at <http://localhost:1313> 
or to build the website:

```
docker run --rm -it -v $PWD:/root/work -p 1313:1313 hugo-sdk server --bind=0.0.0.0
docker run --rm -v $PWD:/root/work hugo-sdk
```
