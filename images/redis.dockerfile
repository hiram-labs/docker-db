FROM redis:alpine3.14

# sets cmds to run when first initialised during docker compose
RUN mkdir -p /usr/local/etc/redis
RUN printf "# insert redis.config info here\n\
appendonly yes\n\
appendfsync everysec\n\
auto-aof-rewrite-percentage 100\n\
auto-aof-rewrite-min-size 64mb\n\
dir /data\n\
maxmemory 256mb\n\
maxmemory-policy allkeys-lru\n\
bind 0.0.0.0\n" \
    >>/usr/local/etc/redis/redis.conf

# set cmds to run on restore
RUN printf "#!/bin/bash\n\
set +e\n\
cat redis.dump | redis-cli --pipe\
echo \"Finished loading redis backups\"\n\
exit 0" \
    >>/root/.load_backups

EXPOSE 6379

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
