docker stop runner
docker rm runner
docker volume rm shared-storage
docker volume create shared-storage
docker build --tag runner-image .
