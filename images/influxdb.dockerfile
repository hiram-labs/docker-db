FROM influxdb:2.0

ENV DOCKER_INFLUXDB_INIT_MODE setup
ENV DOCKER_INFLUXDB_INIT_ORG hiramlabs
ENV DOCKER_INFLUXDB_INIT_BUCKET web-data
ENV DOCKER_INFLUXDB_INIT_USERNAME admin
ENV DOCKER_INFLUXDB_INIT_PASSWORD a-long-secret-password
ENV DOCKER_INFLUXDB_INIT_ADMIN_TOKEN a-very-long-super-secret-auth-token

# sets cmds to run when influx instance is first initialise during docker compose
RUN printf "#!/bin/bash\n\
set -e\n\
influx config create --config-name admin \
  --host-url http://localhost:8086 \
  --org ${DOCKER_INFLUXDB_INIT_ORG} \
  --token ${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN} \
  --active\n" \
  >>/docker-entrypoint-initdb.d/init-instance.sh

# set cmds to run on yarn restore
RUN printf "#!/bin/bash\n\
set +e\n\
influx restore /var/backups/influx.dump\n\
echo \"Finished loading influxdb backups\"\n\
exit 0" \
  >>/root/.load_backups
