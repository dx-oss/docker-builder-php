#!/bin/bash

ORG=dx-oss
NAME=docker-builder-php

IMAGE_TAG_PREFIX=$ORG/$NAME:

IMAGE_PHP73=php:7.3.11-fpm
IMAGE_PHP72=php:7.2.23-fpm
IMAGE_PHP71=php:7.1.33-fpm
IMAGE_PHP70=php:7.0.33-fpm

BRANCH_PHP73=php-7.3
BRANCH_PHP72=php-7.2
BRANCH_PHP71=php-7.1
BRANCH_PHP70=php-7.0

VERSIONS="PHP70 PHP71 PHP72 PHP73"
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

    local tag=$ORG/$NAME:$tag_version
    local tag_major=$ORG/$NAME:$tag_major_version

    echo "$version ($branch) ($image) [$tag] [$tag_major]"
    
    run git checkout $branch
    run docker build --build-arg '"DOCKER_IMAGE=$image"' -t $tag .
    run docker tag $tag $tag_major
    run docker push $tag
    run docker push $tag_major
    run git checkout master
}

for v in $VERSIONS
do
    branch=BRANCH_$v
    image=IMAGE_$v

    build $v ${!branch} ${!image}
done
