#!/bin/bash

pwd=$(pwd)

REGISTRY_SERVER=${REGISTRY_SERVER}
REGISTRY_USER=${REGISTRY_USER}
REGISTRY_SECRET=${REGISTRY_SECRET}

OWNER=${OWNER:-dxdx}
NAME=docker-builder-php

IMAGE_TAG_PREFIX=$OWNER/$NAME:

IMAGE_PHP74=bitnami/php-fpm:7.4.6-debian-10-r3-prod
IMAGE_PHP73=bitnami/php-fpm:7.3.11-debian-9-r20-prod
IMAGE_PHP72=bitnami/php-fpm:7.2.34-debian-10-r113-prod
IMAGE_PHP71=bitnami/php-fpm:7.1.33-debian-9-r20-prod
IMAGE_PHP70=bitnami/php-fpm:7.0.33-debian-9-r20-prod

BRANCH_PHP74=php-7.4
BRANCH_PHP73=php-7.3
BRANCH_PHP72=php-7.2
BRANCH_PHP71=php-7.1
BRANCH_PHP70=php-7.0

VERSIONS="PHP70 PHP71 PHP72 PHP73 PHP74"
VERSIONS=${1:-$VERSIONS}

function log {
    echo "$*"
}

function run {
    log $*
    eval $*
}

function build {
    local version=$1
    local branch=$2
    local image=$3

    local tag_version=$(echo $image | cut -d":" -f2 | cut -d"-" -f1)
    local tag_major_version=$(echo $branch | cut -d"-" -f2)

    local tag=$OWNER/$NAME:$tag_version
    local tag_major=$OWNER/$NAME:$tag_major_version

    echo "$version ($branch) ($image) [$tag] [$tag_major]"

    run cp common/* $branch    
    run cd $branch
    run docker build --build-arg '"DOCKER_IMAGE=$image"' -t $tag .
    run docker tag $tag $tag_major
    run docker push $tag
    run docker push $tag_major
    for c in `ls ../common`
    do
        run rm $c
    done 
    run cd $pwd
}

if [ "$REGISTRY_SERVER" != "" ] && [ "$REGISTRY_USER" != "" ] && [ "$REGISTRY_SECRET" != "" ]; then
	echo $REGISTRY_SECRET | docker login -u $REGISTRY_USER --password-stdin $REGISTRY_SERVER
fi

for v in $VERSIONS
do
    branch=BRANCH_$v
    image=IMAGE_$v

    build $v ${!branch} ${!image}
done
