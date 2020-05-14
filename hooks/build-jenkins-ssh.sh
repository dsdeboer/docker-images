#!/bin/bash

TAG="charpand/jenkins-ssh-agent${VERSION:+:${VERSION}}-${MY_TARGET}"

set -x
docker build ./jenkins-ssh \
    --no-cache \
    --quiet \
    --target $MY_TARGET \
    -t "$TAG" \
    --build-arg version=$VERSION

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push $TAG

image_id=$(docker images $TAG --format "{{.ID}}")
for tag in ${EXTRA_TAGS//;/$'\n'}
do
    echo $tag
    docker tag $image_id "charpand/jenkins-ssh-agent:${tag}"
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    docker push $image_id "charpand/jenkins-ssh-agent:${tag}"
done

docker run --rm --entrypoint echo "$TAG" "Hello $hello"