# etxend the docker 1.13 image
FROM docker:1.13

# specify the version string of the oc release
ENV OC_VERSION "v1.4.1"
ENV OC_RELEASE "openshift-origin-client-tools-v1.4.1-3f9807a-linux-64bit"

# install the oc client tools
ADD https://github.com/openshift/origin/releases/download/$OC_VERSION/$OC_RELEASE.tar.gz /opt/oc/
RUN ls -la /opt/