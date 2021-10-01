docker stop runner
docker rm runner
docker run --detach --env ORGANIZATION=alexserov/gatest --env REG_TOKEN=AA5PWFYSIZTPIAK47DEHAU3BHIF3K --env CONTAINER_ID=runner0 --name runner --restart unless-stopped --mount "source=shared-storage,target=/opt/runner/meta" runner-image
