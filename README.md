# docker

Build multi-arch images and push to Docker Hub:
```bash
# do not ask user for interactive confirmation
docker buildx prune -f
mvn clean install -P push-docker-amd-arm-images -pl base -Ddebian.codename=bullseye-slim
mvn clean install -P push-docker-amd-arm-images -pl base
mvn clean install -P push-docker-amd-arm-images -pl '!base'
```

Build specific node version:
```bash
mvn clean install -P push-docker-amd-arm-images -Dnode.version=16.20.2
``` 

Build only specific node version on specific Debian codename
```bash
mvn clean install -P push-docker-amd-arm-images --projects=node -Dnode.version=16.20.2 -Ddebian.codename=bullseye-slim -Ddocker.push-arm-amd-image.phase=none -Ddocker.push-arm-amd-image-latest.phase=none
```

Build specific haproxy-certbot version:
```bash
mvn clean install -P push-docker-amd-arm-images -Dhaproxy.version=2.2.33
```

Build to your custom repo
```bash
mvn clean install -P push-docker-amd-arm-images -Ddocker.repo=your-docker-repo
```

Build locally with no push
```bash
mvn clean install -P push-docker-amd-arm-images -Ddocker.output.type=image
```

Build locally with --load
```bash
mvn clean install -P push-docker-amd-arm-images -Ddocker.output.type=image --projects="openjdk21" -am
```

Build x64 locally (deprecated)
```bash
mvn clean install -Ddockerfile.skip=false -Ddockerfile.build.noCache=true
```

### Multi-arch build setup
If you failed to build or see some segmentation fault during the build, check your qemu and builder setup

```bash
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker run --rm -t arm64v8/ubuntu uname -m
```
