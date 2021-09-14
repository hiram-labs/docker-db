## Database

1. postgres
2. influxdb
3. neo4j
4. redis

---

### Requirements

- docker
- docker compose

---

### Dev setup

#### On first run if dumping is needed:

- Ensure dump are named `postgres.dump` `influxdb.dump` `neo4j.dump` `redis.dump`.
- Place these in `./dump`. This is needed before you can run any dump commands

NB dumps are not checked into remote repo.

```
start your docker client
git clone https://github.com/hiram-labs/docker-db.git
cd docker-db
```

#### On subsequent runs:

```
./run start // to start all db
./run stop // to stop all db
```

#### Troubleshooting

If the a database is not being created you may have to remove containers and clean volumes as appropriate.

```
docker container ls -qa
docker container rm [ id ]

docker volume ls
docker volume rm [ id ]
```

---

### Adminer (a postgres UI client)

Adminer frontend is available for interacting with postgres

`http://localhost:9000`

Use the following when prompted by adminer:

- system: PostgresSQL
- server: postgres
- username: postgres
- password: secret
- database: **_leave empty_**

---

### PSQL cli (a postgres cli tool)

```
./run pg:shell
```

password: secret

Command opens up psql cli you can then run `\l` to list all available databases and `\c [ db_name ]` to start issuing commands against `[ db_name ]`

[PSQL cheat sheet](https://postgrescheatsheet.com/)

---

### Restore a postgres dump

Place the dump file inside `./dump` as mentioned before

```
./run pg:restore
```

---

### Dump a postgres db

NB this replaces corresponding matches in `./dump`

```
docker exec -it postgres /bin/bash --login
pg_dump -Fc --create --clean --verbose -U postgres -d [db_name] --file=/var/backups/[db_name].dump
```

---

### Influxdb UI client

Influxdb comes with a front end client which can be accessed at:

`http://localhost:9002`

username: admin
password: a-long-secret-password

---

### Influxdb cli

Influxdb has the cli which uses the `influx` command to manage the instance of the db. Run command below to get a shell into the container and run influx commands from there.

```
./run idb:shell
```

---

## Restore a influx dump

NB these may be a folder

Place the dump file/folder inside `./dump` as mentioned before.

```
./run idb:restore
```

---

### Dump an influxdb

NB this replaces corresponding matches in `./dump`

```
docker exec -it influxdb /bin/bash --login
influx backup /var/backups/analytics.dump -t [admin-token]
```

---

### neo4j UI client

neo4j comes with a front end client which can be accessed at:

`http://localhost:9004`

username: neo4j
password: secret

---

### Neo4j cli (cypher)

```
./run n4j:shell
```

---

## Restore a neo4j dump

Place the dump file/folder inside `./dump` as mentioned before.

```
./run n4j:restore
```

---

### Dump a neo4j database

NB this replaces corresponding matches in `./dump`

```
docker exec -it neo4j /bin/bash --login
neo4j-admin dump --database=[ database_name ] --to=/var/backups/graph.dump --verbose
```

---

### Redis cli

Redis has the cli which uses the `redis-cli` command to manage the instance of the db. Run command below to get a shell into the container.

```
./run rdb:shell
```

---

## Restore a redis dump

Place the dump file inside `./dump` as mentioned before.

```
./run rdb:restore
```

---

### Dump a redis db

NB this replaces corresponding matches in `./dump`

```
docker exec -it redis /bin/sh
cp /var/lib/redis/dump.rdb /var/backups/redis.dump
```

---

### Credentials for local development.

POSTGRES

- address/host: 127.0.0.1
- port: 9001
- username: postgres
- password: secret
- database: hiramlabs

INFLUXDB

- address/host: 127.0.0.1
- port: 9002
- username: admin
- password: a-long-secret-password
- organisation: hiramlabs
- admin-token: a-very-long-super-secret-auth-token

NEO4J

- address/host: 127.0.0.1
- port: 9003
- username: neo4j
- password: secret

REDIS

- address/host: 127.0.0.1
- port: 9004
