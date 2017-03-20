![symfony-docker](http://i.imgur.com/vc5ZVqL.png?2)

# Symfony + Nginx + php-fpm
[![Build Status](https://travis-ci.org/kibatic/symfony-docker.svg?branch=master)](https://travis-ci.org/kibatic/symfony-docker)
[![](https://images.microbadger.com/badges/image/kibatic/symfony:latest.svg)](https://microbadger.com/images/kibatic/symfony:latest "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/kibatic/symfony:latest.svg)](https://microbadger.com/images/kibatic/symfony:latest "Get your own version badge on microbadger.com")


Docker for Symfony application, powered by **Nginx** and **php-fpm**.

Based on Debian Jessie.

If you are experiencing some issues, take a look at [TROUBLESHOOTING](TROUBLESHOOTING.md)

### Supported tags and respective `Dockerfile` links

`7`, `7.1` [(7.1/Dockerfile)](https://github.com/kibatic/symfony-docker/blob/master/7.1/Dockerfile)
`7.0` [(7.0/Dockerfile)](https://github.com/kibatic/symfony-docker/blob/master/7.0/Dockerfile)
`5`, `5.6`, `latest` [(5.6/Dockerfile)](https://github.com/kibatic/symfony-docker/blob/master/5.6/Dockerfile)
`5.4` [(5.4/Dockerfile)](https://github.com/kibatic/symfony-docker/blob/master/5.4/Dockerfile)

### Usage

```bash
docker pull kitpages/symfony
```

Then run in your symfony folder

```bash
docker run -v $(pwd):/var/www -p 8080:80 kitpages/symfony
```

Symfony app will be accessible on http://localhost:8080/app.php

### Custom nginx configuration

If you want to replace the default nginx settings, overwrite configuration file at `/etc/nginx/sites-enabled/default`.

```dockerfile
COPY nginx.conf /etc/nginx/sites-enabled/default
```

You may also want to add only some directives in [existing site config](config/vhost.conf#L5).

```dockerfile
COPY custom-config.conf /etc/nginx/conf.d/docker/custom-config.conf
```

### Minimal package included

* nginx
* php5-fpm
* php5-cli
* php5-intl

### Exposed port
* 80 : nginx
