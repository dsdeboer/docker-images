#!/bin/bash

TAG="charpand/frontend${VERSION:+:${VERSION}}-${MY_TARGET}"

echo building ${TAG}

printenv | sort


# set -x
# docker build . \
#     --no-cache \
#     --target $MY_TARGET
#     -t "$TAG" \
#     --build-arg version=$VERSION \
#     --build-arg base_image=$BASE_IMAGE

# image_id=$(docker images $TAG --format "{{.ID}}")
# for tag in ${EXTRA_TAGS//;/$'\n'}
# do
#     echo $tag
#     docker tag $image_id "vaidik/etcd:${tag}"
# done
# docker run --rm --entrypoint echo "$TAG" "Hello $hello"