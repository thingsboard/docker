# haproxy-certbot

Based on [nmarus/docker-haproxy-certbot](https://github.com/nmarus/docker-haproxy-certbot). For detailed info see origin repository.

## Setup and Create Container

Here an example of docker-compose.yml to setup haproxy-certbot:

```
version: '2.2'

services:
  haproxy:
    restart: always
    container_name: "haproxy-certbot"
    image: thingsboard/haproxy-certbot:1.3.0
    volumes:
     - ./haproxy/config:/config
     - ./haproxy/letsencrypt:/etc/letsencrypt
     - ./haproxy/certs.d:/usr/local/etc/haproxy/certs.d
    ports:
     - "80:80"
     - "443:443"
     - "1883:1883"
     - "9999:9999"
    cap_add:
     - NET_ADMIN
    environment:
      HTTP_PORT: 80
      HTTPS_PORT: 443
      FORCE_HTTPS_REDIRECT: "false"
```

It is important to note the mapping of the 3 volumes in the above command. This ensures that all non-persistent variable data is not maintained in the container itself.

The description of the 3 mapped volumes are as follows:

- `/config` - The configuration file location for haproxy.cfg
- `/etc/letsencrypt` - The directory that Let's Encrypt will store it's configuration, certificates and private keys. It is of significant importance that you maintain a backup of this folder in the event the data is lost or corrupted.
- `/usr/local/etc/haproxy/certs.d` - The directory that this container will store the processed certs/keys from Let's Encrypt after they have been converted into a format that HAProxy can use. This is automatically done at each refresh and can also be manually initiated. This volume is not as important as the previous as the certs used by HAProxy can be regenerated again based on the contents of the letsencrypt folder.

## Add a New Cert

This will add a new cert using a certbot config that is compatible with the haproxy config template below. After creating the cert, you should run the refresh script referenced below to initialize haproxy to use it. After adding the cert and running the refresh script, no further action is needed.

```
# request certificate from let's encrypt
docker exec haproxy-certbot certbot-certonly \
  --domain example.com \
  --domain www.example.com \
  --email mail@gmail.com \
  --dry-run

# create/update haproxy formatted certs in certs.d and then restart haproxy
docker exec haproxy-certbot haproxy-refresh
```

<i>After testing the setup, remove --dry-run to generate a live certificate</i>

## Renew a Cert

Renewing happens automatically but should you choose to renew manually, you can do the following.

```
docker exec haproxy-certbot certbot-renew --dry-run
```

<i>After testing the setup, remove --dry-run to generate a live certificate</i>

To apply changes to HAProxy:

```
docker exec haproxy-certbot haproxy-refresh
```

This will parse and individually concatenate all the certs found in <code>/etc/letsencrypt/live</code> directory into the folder <code>/usr/local/etc/haproxy/certs.d</code>. It additionally will restart the HAProxy service so that the new certs are active.


## Update cronjob for renewing a Cert

In case you need to update the cronjob responsible for renewing certificate:

```
# log into haproxy container
docker exec -it haproxy-certbot sh
# update cronjob configuration file
vi /etc/cron.d/certbot
crontab /etc/cron.d/certbot
# to check what cron job is active
crontab -l
```

## Sample HAProxy configuration with simple web-server

For the testing purposes we'll use [mendhak/http-https-echo](https://hub.docker.com/r/mendhak/http-https-echo) image. This is the simple web-server that listens to 8080 port and returns the details of the incoming HTTP request.

<b>docker-compose.yml</b>:

```
version: '2.2'

services:
  haproxy:
    restart: always
    container_name: "haproxy-certbot"
    image: thingsboard/haproxy-certbot:1.3.0
    volumes:
     - ./haproxy/config:/config
     - ./haproxy/letsencrypt:/etc/letsencrypt
     - ./haproxy/certs.d:/usr/local/etc/haproxy/certs.d
    ports:
     - "80:80"
     - "443:443"
     - "1883:1883"
     - "9999:9999"
    cap_add:
     - NET_ADMIN
    environment:
      HTTP_PORT: 80
      HTTPS_PORT: 443
      FORCE_HTTPS_REDIRECT: "false"
  web-test:
    restart: always
    container_name: "web-test"
    image: mendhak/http-https-echo:18

```

<b>./haproxy/config/haproxy.cfg</b>:

```
#HA Proxy Config
global
 ulimit-n 500000
 maxconn 99999
 maxpipes 99999
 tune.maxaccept 500

 log 127.0.0.1 local0
 log 127.0.0.1 local1 notice

 ca-base /etc/ssl/certs
 crt-base /etc/ssl/private

 ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS
 ssl-default-bind-options no-sslv3

defaults

 log global

 mode http

 timeout connect 5000ms
 timeout client 50000ms
 timeout server 50000ms
 timeout tunnel  1h    # timeout to use with WebSocket and CONNECT

 default-server init-addr none

#enable resolving throught docker dns and avoid crashing if service is down while proxy is starting
resolvers docker_resolver
  nameserver dns 127.0.0.11:53

listen stats
 bind *:9999
 stats enable
 stats hide-version
 stats uri /stats
 stats auth admin:admin@123

frontend http-in
 bind *:${HTTP_PORT}

 option forwardfor

 http-request add-header "X-Forwarded-Proto" "http"

 acl letsencrypt_http_acl path_beg /.well-known/acme-challenge/

 redirect scheme https if !letsencrypt_http_acl { env(FORCE_HTTPS_REDIRECT) -m str true }

 use_backend letsencrypt_http if letsencrypt_http_acl

 default_backend tb-web-backend

frontend https_in
  bind *:${HTTPS_PORT} ssl crt /usr/local/etc/haproxy/default.pem crt /usr/local/etc/haproxy/certs.d ciphers ECDHE-RSA-AES256-SHA:RC4-SHA:RC4:HIGH:!MD5:!aNULL:!EDH:!AESGCM

  option forwardfor

  http-request add-header "X-Forwarded-Proto" "https"

  default_backend tb-web-backend

backend letsencrypt_http
  server letsencrypt_http_srv 127.0.0.1:8080

backend tb-web-backend
  balance leastconn
  option tcp-check
  option log-health-checks
  server tbWeb web-test:8080 check inter 5s resolvers docker_resolver resolve-prefer ipv4
  http-request set-header X-Forwarded-Port %[dst_port]

```
