# etxend an ubuntu base image
FROM docker.io/ubuntu:24.04@sha256:3e1fb4aeedc137fc8cffe5f0a7c25bfd216ffab624460c8c17031724d9dc61e4

# specify versions for docker and the oc release
ENV DOCKER_VERSION=18.06.1~ce~3-0~ubuntu \
	OC_RELEASE=openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit \
	OC_VERSION=v3.11.0

# install necessary packages
RUN apt-get update && \
	apt-get install -yq \
		ca-certificates \
		curl \
		openssl \
		gettext-base \
		apt-transport-https \
		software-properties-common && \
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
	add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		$(lsb_release -cs) \
		stable" && \
	apt-get update && \
	apt-get install -yq \
		docker-ce=${DOCKER_VERSION} && \
	rm -rf /var/lib/apt/lists/*

# install the oc client tools
RUN set -x && \
    curl -fSL "https://github.com/openshift/origin/releases/download/${OC_VERSION}/${OC_RELEASE}.tar.gz" -o /tmp/release.tar.gz && \
    tar --strip-components=1 -xzvf /tmp/release.tar.gz -C /tmp/ && \
    mv /tmp/oc /usr/local/bin/ && \
    rm -rf /tmp/*

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash"]
