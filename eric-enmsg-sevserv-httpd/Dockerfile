ARG ERIC_ENM_SLES_APACHE2_IMAGE_NAME=eric-enm-sles-apache2
ARG ERIC_ENM_SLES_APACHE2_IMAGE_REPO=armdocker.rnd.ericsson.se/proj-enm
ARG ERIC_ENM_SLES_APACHE2_IMAGE_TAG=1.59.0-33

FROM ${ERIC_ENM_SLES_APACHE2_IMAGE_REPO}/${ERIC_ENM_SLES_APACHE2_IMAGE_NAME}:${ERIC_ENM_SLES_APACHE2_IMAGE_TAG}

ARG BUILD_DATE=unspecified
ARG IMAGE_BUILD_VERSION=unspecified
ARG GIT_COMMIT=unspecified
ARG ISO_VERSION=unspecified
ARG RSTATE=unspecified

LABEL \
com.ericsson.product-number="CXC Placeholder" \
com.ericsson.product-revision=$RSTATE \
enm_iso_version=$ISO_VERSION \
org.label-schema.name="ENM Sevserv UI SideCar" \
org.label-schema.build-date=$BUILD_DATE \
org.label-schema.vcs-ref=$GIT_COMMIT \
org.label-schema.vendor="Ericsson" \
org.label-schema.version=$IMAGE_BUILD_VERSION \
org.label-schema.schema-version="1.0.0-rc1"

RUN zypper install -y ERICsiteenergyvisualizationapp_CXP9042960 && \    
zypper clean -a

ENV CREDM_CONTROLLER_MNG="TRUE"
ENV PROXY_PASS_RULES="sev"

#This will be changed to add this script to the pre start folder when that is implemented in the base image
COPY addAppsToLauncher.sh /var/tmp/
RUN chmod +x /var/tmp/addAppsToLauncher.sh

RUN sed -i "9 a bash /var/tmp/addAppsToLauncher.sh" entry-point.sh

EXPOSE 8084 8444
