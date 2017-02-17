# etxend an ubuntu base image
FROM ubuntu:16.10

# specify versions for docker and the oc release
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.13.1
ENV DOCKER_SHA256 97892375e756fd29a304bd8cd9ffb256c2e7c8fd759e12a55a6336e15100ad75
ENV OC_VERSION v1.3.3
ENV OC_RELEASE openshift-origin-client-tools-v1.3.3-bc17c1527938fa03b719e1a117d584442e3727b8-linux-64bit

# install necessary packages
RUN apt-get update && \
	apt-get install -yq \
		ca-certificates \
		curl \
		openssl \
	&& rm -rf /var/lib/apt/lists/*

# install docker
RUN set -x && \
	curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz && \
	echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - && \
	tar -xzvf docker.tgz && \
	curl -fSL "https://raw.githubusercontent.com/docker-library/docker/master/1.13/docker-entrypoint.sh" -o docker/docker-entrypoint.sh && \
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