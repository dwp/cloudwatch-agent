FROM ubuntu:latest as build

# NOTE: This arg will be populated by docker buildx
# https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETARCH

RUN apt-get update &&  \
    apt-get install -y ca-certificates curl  

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y awscli

RUN rm -rf /var/lib/apt/lists/*

RUN curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/${TARGETARCH:-$(dpkg --print-architecture)}/latest/amazon-cloudwatch-agent.deb && \
    dpkg -i -E amazon-cloudwatch-agent.deb && \
    rm -rf /tmp/* && \
    rm -rf /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard && \
    rm -rf /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl && \
    rm -rf /opt/aws/amazon-cloudwatch-agent/bin/config-downloader && \
    mkdir cwagent

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

ENV RUN_IN_CONTAINER="True"
ENTRYPOINT [ "/bin/entrypoint.sh" ]
