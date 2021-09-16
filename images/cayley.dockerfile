FROM cayleygraph/cayley:v0.7.5 as builder

FROM alpine:3

RUN apk --update add rsync bash
RUN mkdir tmp_files
COPY --from=builder . /tmp_files

RUN rsync -a /tmp_files/ /
RUN rm -rf tmp_files
RUN mv /etc/cayley.json /etc/cayley.default.json

RUN printf "# insert cayley.json info here to overwrite default\n \
store:\n\
    backend: bolt\n\
    address: /data/cayley.db" \
    >/etc/cayley.yml

# set cmds to run on restore
RUN printf "#!/bin/bash\n\
set +e\n\
mv /backups/cayley.dump /backups/data.pq.gz\n\
cayley load --init -c /etc/cayley.yml -i /backups/data.pq.gz\n\
echo \"Finished loading cayley backups\"\n\
exit 0" \
    >>/root/.load_backups

# copies from https://github.com/cayleygraph/cayley/blob/master/Dockerfile
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "cayley", "health" ]

EXPOSE 64210

CMD ["cayley", "http", "--host=:64210"]
