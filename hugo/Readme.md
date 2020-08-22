# Hugo

`docker build -t michielvoo/hugo .`

`docker run --rm -it -v $PWD:/src michielvoo/hugo`
`docker run --rm -it -v $PWD:/src -p 1313:1313 michielvoo/hugo server --bind=0.0.0.0`
