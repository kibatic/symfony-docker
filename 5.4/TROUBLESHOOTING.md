# Troubleshooting

### 502 Bad gateway

If you have setup your Symfony project before **v2.4.0-BETA1** you have following handlers in your `config_dev.yml`

```yml
monolog:
        chromephp:
            type:  chromephp
            level: info
```

This configuration is generating very HUGE headers wich break Nginx default limit.

```
[error] 28#0: *2 upstream sent too big header while reading response header from upstream
```

A solution could be to remove chromephp handler.
If you want to use this handler, you have to increase Nginx buffer limits with custom directives.

```nginx
fastcgi_buffers 16 512k;
fastcgi_buffer_size 512k;
```

Look at the [README](README.md#custom-nginx-configuration) how to load custom directives.

Check Symfony related [PR](https://github.com/symfony/symfony-standard/commit/c6497663a511925631127ae88c99dc611efedcbe) for more details.
