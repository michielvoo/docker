#!/bin/sh
case $1 in
    docs)
        echo "docs"
        ;;
    test)
        echo "test"
        ;;
    version)
        docker run --rm -it --entrypoint pwsh psdoc -Version
        ;;
esac
