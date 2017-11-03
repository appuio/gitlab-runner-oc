FROM ubuntu:16.04

# OpenShift client version
ENV OC_VERSION v3.6.1
ENV OC_RELEASE v3.6.1-008f2d5-linux-64bit

# Docker release channel
ENV CHANNEL stable

ENV OC_URL "https://github.com/openshift/origin/releases/download/${OC_VERSION}/openshift-origin-client-tools-${OC_RELEASE}.tar.gz"
ENV DEBIAN_FRONTEND noninteractive

# install the oc client tools
RUN set -x && \
    apt-get update -q && \
    apt-get install -yq curl ca-certificates openssl gettext-base && \
    curl -sSL https://get.docker.com | sh && \
    curl -sSL "$OC_URL" -o /tmp/release.tar.gz && \
    tar --strip-components=1 -xzvf /tmp/release.tar.gz -C /tmp/ && \
    mv /tmp/oc /usr/local/bin/ && \
    rm -rf /tmp/* /var/lib/apt/lists/*

CMD ["bash"]
