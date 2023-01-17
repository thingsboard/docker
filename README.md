# docker

Build images and push to Docker Hub:
```bash
mvn clean install -Ddockerfile.skip=false -P push-docker-amd-arm-images
```