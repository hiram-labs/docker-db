FROM rabbitmq:3.8.30-management-alpine

# create a directory to hold custom configs
RUN mkdir -p /etc/rabbitmq/conf.d
RUN printf "# insert rabbitmq.config info here\n" \
    >>/etc/rabbitmq/conf.d/1.conf

RUN rabbitmq-plugins enable --offline rabbitmq_mqtt rabbitmq_federation_management rabbitmq_stomp

EXPOSE 5672 15672
