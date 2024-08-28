ARG ERIC_ENM_SLES_EAP7_IMAGE_NAME=eric-enm-sles-eap7
ARG ERIC_ENM_SLES_EAP7_IMAGE_REPO=armdocker.rnd.ericsson.se/proj-enm
ARG ERIC_ENM_SLES_EAP7_IMAGE_TAG=1.64.0-32

FROM ${ERIC_ENM_SLES_EAP7_IMAGE_REPO}/${ERIC_ENM_SLES_EAP7_IMAGE_NAME}:${ERIC_ENM_SLES_EAP7_IMAGE_TAG}

ARG BUILD_DATE=unspecified
ARG IMAGE_BUILD_VERSION=unspecified
ARG GIT_COMMIT=unspecified
ARG ISO_VERSION=unspecified
ARG RSTATE=unspecified

LABEL \
com.ericsson.product-number="CXC 174 2126" \
com.ericsson.product-revision=$RSTATE \
enm_iso_version=$ISO_VERSION \
org.label-schema.name="ENM Sevserv Service Group" \
org.label-schema.build-date=$BUILD_DATE \
org.label-schema.vcs-ref=$GIT_COMMIT \
org.label-schema.vendor="Ericsson" \
org.label-schema.version=$IMAGE_BUILD_VERSION \
org.label-schema.schema-version="1.0.0-rc1"

RUN zypper install -y aaa_base \
postgresql15 \
openldap2-client \
libedit0 \
unzip \
ERICpostgresutils_CXP9038493 \
ERICmodelserviceapi_CXP9030594 \
ERICmodelservice_CXP9030595 \
ERICpib2_CXP9037459 \
ERICserviceframework4_CXP9037454 \
ERICserviceframeworkmodule4_CXP9037453 \
ERICdpsruntimeimpl_CXP9030468 \
ERICdpsruntimeapi_CXP9030469 \
ERICdpsmediationclient2_CXP9038436 \
ERICmediationengineapi2_CXP9038435 \
ERICsiteenergyvisualizationservice_CXP9042963 \
ERICescnodemodelcommon_CXP9033769 \
ERICscunodemodelcommon_CXP9037524 \
ERICcontroller6610nodemodelcommon_CXP9039546 \
ERICsiteenergyvisualizationdb_CXP9042971 \
ERICsiteenergyvisualizationmodel_CXP9042965 \
ERICopenidmaccesspolicies_CXP9031742 && \
zypper download EXTRpostgresclient2_CXP9043965 && \
rpm -ivh /var/cache/zypp/packages/enm_iso_repo/EXTRpostgresclient2_CXP9043965*.rpm --nodeps --noscripts && \
#rpm -ivh --replacefiles https://ci-portal.seli.wh.rnd.internal.ericsson.com/static/tmpUploadSnapshot//2023-09-26_11-19-20/ERICenmsgsevserv_CXP9042972-1.4.2.rpm --nodeps --noscripts && \
rm -f /ericsson/3pp/jboss/bin/post-start/update_management_credential_permissions.sh \
          /ericsson/3pp/jboss/bin/post-start/update_standalone_permissions.sh && \
zypper clean -a

RUN zypper install -y ERICenmsgsevserv_CXP9042972 && \
zypper clean -a && \
mkdir -p /ericsson/tor/data/apps/siteenergyvisualization && \
mkdir -p /opt/rh/postgresql92/root/usr/bin/

RUN ln -s /usr/bin/psql /opt/rh/postgresql92/root/usr/bin/psql

COPY image_content/cn_jboss_healthcheck.sh /usr/lib/ocf/resource.d/
RUN chmod +x /usr/lib/ocf/resource.d/cn_jboss_healthcheck.sh
COPY image_content/sevserv_config.sh /var/tmp/
RUN /usr/sbin/groupadd mdt

RUN sed -i "9 a bash /var/tmp/sevserv_config.sh" /ericsson/3pp/jboss/entry_point.sh

ENV ENM_JBOSS_SDK_CLUSTER_ID="sevserv" \
    ENM_JBOSS_BIND_ADDRESS="0.0.0.0" \
    GLOBAL_CONFIG="/gp/global.properties" \
    JBOSS_CONF="/ericsson/3pp/jboss/app-server.conf"

EXPOSE 58171 7687 4447 7600 8009
