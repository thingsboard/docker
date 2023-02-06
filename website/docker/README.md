# The deployment of the thingsboard website in docker
These instructions will help to run the thingsboard/thingsboard.github.io project in the docker. You do not need to install additional dependencies and packages, everything is already built into the docker image.

If you do not have docker installed, you need to install it. You can do this by following the installation instructions: [Docker Engine installation overview](https://docs.docker.com/engine/install/)

If you do not have a local thingsboard.github.io repository, you need to clone project into the "website" directory.

```bash
git clone https://github.com/thingsboard/thingsboard.github.io.git website
```
## Deploy the site using the docker run command

Please replace the `THINGSBOARD_WEBSITE_DIR` with the full path to your local thingsboard.github.io repository.

```bash
docker run --rm -d -p 4000:4000 --name thingsboard_website --volume="THINGSBOARD_WEBSITE_DIR:/website" thingsboard/website
```

## Deploy the site using the docker-compose file

Please replace the `THINGSBOARD_WEBSITE_DIR` with the full path to your local thingsboard.github.io repository and create docker-compose.yml file:

```bash
cat <<EOT | sudo tee docker-compose.yml
version: '3.1'
services:
  thingsboard_website:
    container_name: thingsboard_website
    restart: always
    image: "thingsboard/website"
    ports:
      - "4000:4000"
    volumes:
      - THINGSBOARD_WEBSITE_DIR:/website
EOT
```

To start the docker container with docker-compose, run the command:

```bash
docker compose up
```

In about 2 minutes (depending on PC performance), your copy of the site will be available for viewing at http://localhost:4000

## Image preview generator in docker

Usage:
```bash
docker exec thingsboard_website bash -c "./generate-previews.sh path file_mask*.png"

```

Example:
```bash
docker exec thingsboard_website bash -c "./generate-previews.sh images/solution-templates *.png"

```
> **_NOTE:_** This command must be executed with the running container