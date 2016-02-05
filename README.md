<img width="200px" src="http://i.imgur.com/vc5ZVqL.png" />

# Symfony + Nginx + php-fpm
[![Foo](https://badge.imagelayers.io/kitpages/symfony:latest.svg)](https://imagelayers.io/?images=kitpages/symfony:latest)

Docker for Symfony application, powered by **Nginx** and **php-fpm**.

Based on Debian Jessie.

## Usage

```bash
docker pull kitpages/symfony
```

Then run in your symfony folder

```bash
docker run -v $(pwd):/var/www -p 8080:80 kitpages/symfony
```

Symfony app will be accessible on http://localhost:8080/app.php

## Minimal package included

* nginx
* php5-fpm
* php5-cli
* php5-intl

## Exposed port
* 80 : nginx
