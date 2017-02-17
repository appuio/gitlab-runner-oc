# etxend the official OpenShift origin image
FROM openshift/origin:v1.4.1

# override the entrypoint as we won't need to execute openshift'
ENTRYPOINT "bash"