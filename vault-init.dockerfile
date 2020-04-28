FROM vault

RUN  wget -O /usr/local/bin/jq  https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && chmod a+x /usr/local/bin/jq
COPY scripts/* /home/vault/

WORKDIR /home/vault