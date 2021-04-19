# Hugo

Hugo Extended and Git on Alpine Linux, for building static websites

## How to: update Hugo

(New versions of Alpine Linux are made available in May and November.)

Optional: remove the last locally built Docker image:

`docker image rm michielvoo/hugo`

Find the versions of Hugo and Git for the current stable version of Alpine 
Linux [here](https://pkgs.alpinelinux.org/packages), update the Dockerfile, and 
build the Docker image:

`docker build -t michielvoo/hugo .`

Run the local image to check the Hugo version:

`docker run --rm -it michielvoo/hugo version`

Change to a directory that contains a Hugo website, run the local image to 
start the Hugo server:

`docker run --rm -it -v $PWD:/src -p 1313:1313 michielvoo/hugo server --bind=0.0.0.0`

Browse to <http://localhost:1313> to test the website.
