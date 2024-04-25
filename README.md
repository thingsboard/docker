# docker

Build multi-arch images and push to Docker Hub:
```bash
mvn clean install -P push-docker-amd-arm-images
```

Build specific node version:
```bash
mvn clean install -P push-docker-amd-arm-images -Dnode.version=16.20.2
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

Build x64 locally (deprecated)
```bash
mvn clean install -Ddockerfile.skip=false -Ddockerfile.build.noCache=true
```
