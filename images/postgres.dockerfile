FROM postgres

ENV POSTGRES_PASSWORD secret

# sets cmds to run when first initialised during docker compose
RUN printf "#!/bin/bash\n\
set -e\n\
psql -v ON_ERROR_STOP=1 -U postgres -d postgres <<-EOSQL\n\
    CREATE DATABASE hiramlabs;\n\
EOSQL\n" \
    >>/docker-entrypoint-initdb.d/init-instance.sh

# set cmds to run on restore
RUN printf "#!/bin/bash\n\
set +e\n\
pg_restore --create --clean --verbose --no-acl --no-owner -U postgres -d postgres /var/backups/postgres.dump\n\
echo \"Finished loading postgres dump! Refer to logs if any errors occurred\"\n\
exit 0" \
    >>/root/.load_backups

# customise psql client appearance
RUN echo "\n\
\\set PROMPT1 '%001%[%033[1;32;40m%]%002%n@%/%R%#'\
\\set PROMPT2 '> '" \
    >>/root/.psqlrc

EXPOSE 5432
