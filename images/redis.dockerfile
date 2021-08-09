FROM redis:alpine3.14

# sets cmds to run when influx instance is first initialise during docker compose
RUN printf "#!/bin/bash\n\
set -e\n\
# insert redis.config info here\n" \
    >>/usr/local/etc/redis/redis.conf

# set cmds to run on yarn restore
RUN printf "#!/bin/bash\n\
set +e\n\
cat redis.dump | redis-cli --pipe\
echo \"Finished loading influxdb backups\"\n\
exit 0" \
    >>/root/.load_backups

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
