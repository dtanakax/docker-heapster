# Set the base image
FROM dtanakax/debianjp:wheezy

# File Author / Maintainer
MAINTAINER Daisuke Tanaka, dtanakax@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get clean all

ENV HEAPSTER_VERSION v0.11.0

# cAdvisor discovery via external files.
RUN mkdir -p /var/run/heapster && touch /var/run/heapster/hosts

RUN curl -OL https://github.com/GoogleCloudPlatform/heapster/releases/download/${HEAPSTER_VERSION}/heapster && \
    chmod +x /heapster && \
    mv /heapster /usr/bin/heapster

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["./start.sh"]

# "influxdb" or "gcm"
ENV SINK **None**
# ServiceHost URI e.g: http://<ipaddr>:<port>
ENV KUBERNETES_RO_SERVICE_HOST **None**
ENV COREOS_FLEET_SERVICE_HOST **None**
ENV INFLUXDB_HOST http://localhost:4001

CMD ["/usr/bin/heapster"]
