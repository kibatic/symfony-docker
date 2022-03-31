![symfony-docker](http://i.imgur.com/vc5ZVqL.png?2)

# Symfony + Nginx + php-fpm
[![Build Status](https://travis-ci.org/kibatic/symfony-docker.svg?branch=master)](https://travis-ci.org/kibatic/symfony-docker)
[![](https://images.microbadger.com/badges/image/kibatic/symfony:latest.svg)](https://microbadger.com/images/kibatic/symfony:latest "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/kibatic/symfony:latest.svg)](https://microbadger.com/images/kibatic/symfony:latest "Get your own version badge on microbadger.com")


Docker for Symfony application, powered by **Nginx** and **php-fpm**.

Based on Debian Jessie.

If you are experiencing some issues, take a look at [TROUBLESHOOTING](TROUBLESHOOTING.md)

### Supported tags and respective `Dockerfile` links

Image tags follows PHP versions

`latest` `8.1` [(8.1/Dockerfile)](https://github.com/kibatic/symfony-docker/blob/master/8.1/Dockerfile)

`8.0` [(8.0/Dockerfile)](https://github.com/kibatic/symfony-docker/blob/master/8.0/Dockerfile)

`7` `7.4` [(7.4/Dockerfile)](https://github.com/kibatic/symfony-docker/blob/master/7.4/Dockerfile)

`7.3` [(7.3/Dockerfile)](https://github.com/kibatic/symfony-docker/blob/master/7.3/Dockerfile)

`7.2` [(7.2/Dockerfile)](https://github.com/kibatic/symfony-docker/blob/master/7.2/Dockerfile)

`7.1` **Not maintained, END OF LIFE**

`7.0` **Not maintained, END OF LIFE**

`5`, `5.6` **Not maintained, END OF LIFE**

`5.4` **Not maintained, END OF LIFE**

### Compatibility matrix

<table>
    <thead>
        <tr>
            <th></th>
            <th colspan="6">Symfony</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <th rowspan="9">Image</th>
            <td></td>
            <td>2.x</td>
            <td>3.x</td>
            <td>4.x</td>
            <td>5.x</td>
            <td>6.x</td>
        </tr>
        <tr>
            <td>8.1</td>
            <td>:x:</td>
            <td>:x:</td>
            <td>:heavy_check_mark: (not tested)</td>
            <td>:heavy_check_mark: (not tested)</td>
            <td>:heavy_check_mark: (not tested)</td>
        </tr>
        <tr>
            <td>8.0</td>
            <td>:x:</td>
            <td>:x:</td>
            <td>:heavy_check_mark: (not tested)</td>
            <td>:heavy_check_mark: (default)</td>
            <td>:heavy_check_mark: (not tested)</td>
        </tr>
        <tr>
            <td>7.4</td>
            <td>:x:</td>
            <td>:x:</td>
            <td>:heavy_check_mark:</td>
            <td>:heavy_check_mark: (default)</td>
            <td>:x:</td>
        </tr>
        <tr>
            <td>7.3</td>
            <td>:heavy_check_mark: (not tested)</td>
            <td>:heavy_check_mark: (not tested)</td>
            <td>:heavy_check_mark: (default)</td>
            <td>:heavy_check_mark: (not tested)</td>
            <td>:x:</td>
        </tr>
        <tr>
            <td>7.2</td>
            <td>:heavy_check_mark: (not tested)</td>
            <td>:heavy_check_mark:</td>
            <td>:heavy_check_mark:</td>
            <td>:heavy_check_mark: (not tested)</td>
            <td>:x:</td>
        </tr>
        <tr>
            <td>7.1</td>
            <td>:heavy_check_mark: (not tested)</td>
            <td>:heavy_check_mark:</td>
            <td>:heavy_check_mark:</td>
            <td>:x:</td>
            <td>:x:</td>
        </tr>
        <tr>
            <td>7.0</td>
            <td>:heavy_check_mark: (not tested)</td>
            <td>:heavy_check_mark: (not tested)</td>
            <td>:x:</td>
            <td>:x:</td>
            <td>:x:</td>
        </tr>
        <tr>
            <td>5.6</td>
            <td>:heavy_check_mark: (not tested)</td>
            <td>:heavy_check_mark: (not tested)</td>
            <td>:x:</td>
            <td>:x:</td>
            <td>:x:</td>
        </tr>
    </tbody>
</table>

Composer versions :

- 8.0+ : 2.x
- 7.4 : 2.x
- 7.3 : 1.10.17
- 7.2 : 1.10.17

### Usage

```bash
docker pull kibatic/symfony
```

Then run in your symfony folder

```bash
# Image >= 7.3 & Symfony 2.x, 3.x
docker run -e SYMFONY_VERSION=3 -v $(pwd):/var/www -p 8080:80 kibatic/symfony:7.3

# Image >= 7.3 & Symfony 4.x
docker run -v $(pwd):/var/www -p 8080:80 kibatic/symfony:7.3

# Image < 7.3 & Symfony 2.x, 3.x
docker run -v $(pwd):/var/www -p 8080:80 kibatic/symfony:7.2

# Image < 7.3 & Symfony 4.x
docker run -e SYMFONY_VERSION=4 -v $(pwd):/var/www -p 8080:80 kibatic/symfony:7.2
```

Symfony app will be accessible on http://localhost:8080/

### Custom nginx configuration

If you want to replace the default nginx settings, overwrite configuration file at `/etc/nginx/sites-enabled/default`.

```dockerfile
COPY nginx.conf /etc/nginx/sites-enabled/default
```

You may also want to add only some directives in [existing site config](7.4/rootfs/etc/nginx/sites-enabled/default#L5).

```dockerfile
COPY custom-config.conf /etc/nginx/conf.d/docker/custom-config.conf
```

### Logging (PHP >= 7.3)

For both production and dev environment you should log to stdout / stderr, example below.

```yaml
# config/packages/monolog.yaml
monolog:
    handlers:
        stdout:
            type: stream
            path: 'php://stdout'
            level: debug
            channels: ['!event']
            # (Optional) format logs to json
            #formatter: monolog.formatter.json
        stderr:
            type: stream
            path: 'php://stderr'
            level: error
            # (Optional) format logs to json
            #formatter: monolog.formatter.json
```


### Logging (PHP < 7.3)

A common practice is to log to stdout, but there are major bug in php-fpm wich makes stdout logging not reliable  :

* Logs are truncated when message length exceed 1024 https://bugs.php.net/bug.php?id=69031
* FPM prepend a warning string to worker output https://bugs.php.net/bug.php?id=71880

This image setup a known workaround ([see here](https://github.com/docker-library/php/issues/207)) and expose a log stream as env var **LOG_STREAM**, but **you cannot log to stdout**
For a proper logging you have to configure monolog to log to this stream

```yaml
# app/config_dev.yml
monolog:
    handlers:
        main:
            type:   stream
            path:   '/tmp/stdout'
            level:  debug
```

You can also use symfony `%env(LOG_STREAM)%` if your symfony version is compatible with [this syntax](https://symfony.com/doc/3.4/configuration/external_parameters.html)

We also provide a default dirty solution for standard monolog configuration, **this is not recommended in production**

```bash
tail -q -n 0 -F app/logs/dev.log app/logs/prod.log var/logs/dev.log var/logs/prod.log
```

### Minimal package included

* nginx
* php\*-fpm
* php\*-cli
* php\*-intl
* php\*-mbstring

### Exposed port
* 80 : nginx
