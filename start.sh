#!/bin/bash

node --version
npm --version

ORGANIZATION=$ORGANIZATION
REG_TOKEN=$REG_TOKEN

cd /home/docker/actions-runner

CONTAINER_FLAG_DIR=/opt/runner/meta/${CONTAINER_ID}

if [ ! -d "$CONTAINER_FLAG_DIR" ]; then
    mkdir $CONTAINER_FLAG_DIR
    ./config.sh --url https://github.com/${ORGANIZATION} --token ${REG_TOKEN}
    cp ./.credentials $CONTAINER_FLAG_DIR
    cp ./.credentials_rsaparams $CONTAINER_FLAG_DIR
    cp ./.env $CONTAINER_FLAG_DIR
    cp ./.path $CONTAINER_FLAG_DIR
    cp ./.runner $CONTAINER_FLAG_DIR
else
    cp -a $CONTAINER_FLAG_DIR/. .
fi

# cleanup() {
#     echo "Removing runner..."
#     ./config.sh remove --unattended --token ${REG_TOKEN}
# }

# trap 'cleanup; exit 130' INT
# trap 'cleanup; exit 143' TERM

./run.sh --once & wait $!
