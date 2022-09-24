FROM alpine:latest

RUN apk add --no-cache curl

# SETUP USER
ARG USER_NAME=appuser
ARG USER_ID=9001
RUN adduser -u ${USER_ID} -S ${USER_NAME}

# SETUP SUPERCRONIC
ENV SUPERCRONIC_VERSION="v0.2.1"
RUN wget https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-amd64 -O /usr/local/bin/supercronic && \
	chmod 755 /usr/local/bin/supercronic
COPY --chown=root --chmod=644 ./crontab /home/${USER_NAME}/crontab
RUN supercronic -json -test /home/${USER_NAME}/crontab

COPY ./scripts /scripts
RUN chmod 755 /scripts/*.sh

USER ${USER_NAME}

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD [ "run" ]
