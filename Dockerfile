# etxend an ubuntu base image
FROM ubuntu:16.04

# install necessary packages
RUN apt-get update && \
	apt-get install -yq \
		ca-certificates \
		curl \
		openssl \
	&& rm -rf /var/lib/apt/lists/*
	
# specify versions for docker and the oc release
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_RELEASE 17.04
ENV DOCKER_VERSION 17.04.0-ce
ENV DOCKER_SHA256 c52cff62c4368a978b52e3d03819054d87bcd00d15514934ce2e0e09b99dd100

ENV OC_RELEASE openshift-origin-client-tools-v1.4.1-3f9807a-linux-64bit
ENV OC_VERSION v1.4.1

# install docker
RUN set -x && \
	curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz && \
	echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - && \
	tar -xzvf docker.tgz && \
	curl -fSL "https://raw.githubusercontent.com/docker-library/docker/master/${DOCKER_RELEASE}/docker-entrypoint.sh" -o docker/docker-entrypoint.sh && \
	chmod +x docker/docker-entrypoint.sh && \
	mv docker/* /usr/local/bin/ && \
	rmdir docker && \
	rm docker.tgz

# install the oc client tools
RUN set -x && \
    curl -fSL "https://github.com/openshift/origin/releases/download/${OC_VERSION}/${OC_RELEASE}.tar.gz" -o /tmp/release.tar.gz && \
    tar --strip-components=1 -xzvf /tmp/release.tar.gz -C /tmp/ && \
    mv /tmp/oc /usr/local/bin/ && \
    rm -rf /tmp/*

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash"]
