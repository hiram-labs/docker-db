FROM neo4j:4.3.0-community

# sets cmds to run when neo4j instance is first initialise during docker compose
RUN printf "#!/bin/bash\n\
set -e\n\
neo4j-admin set-initial-password secret\n\
echo \"Password set to secret\"\n" \
    >>/extension_script.sh

ENV EXTENSION_SCRIPT /extension_script.sh

# set cmds to run on yarn restore
RUN printf "#!/bin/bash\n\
set +e\n\
neo4j-admin load --from=/backups/neo4j.dump --database=hiramlabs --force\n\
echo \"Finished loading neo4j backups\"\n\
exit 0" \
    >>/root/.load_backups
