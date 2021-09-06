docker stop runner
docker rm runner
docker run --env ORGANIZATION=alexserov/gatest --env REG_TOKEN=############################# --env CONTAINER_ID=runner0 --name runner --restart unless-stopped --mount "source=shared-storage,target=/opt/runner/meta" runner-image
