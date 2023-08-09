ARG CI_REGISTRY_IMAGE
ARG TAG
ARG DOCKERFS_TYPE
ARG DOCKERFS_VERSION
ARG MATLAB_VERSION
FROM ${CI_REGISTRY_IMAGE}/matlab-desktop:${MATLAB_VERSION}${TAG}
LABEL maintainer="florian.sipp@chuv.ch"

ARG DEBIAN_FRONTEND=noninteractive
ARG CARD
ARG CI_REGISTRY
ARG APP_NAME
ARG APP_VERSION

LABEL app_version=$APP_VERSION
LABEL app_tag=$TAG

WORKDIR /apps/${APP_NAME}

ENV APP_SPECIAL="no"
ENV APP_CMD="/opt/matlab/${APP_VERSION}/bin/matlab -desktop -nosplash"
ENV PROCESS_NAME="matlab"
ENV APP_DATA_DIR_ARRAY=".matlab"
ENV DATA_DIR_ARRAY=""

HEALTHCHECK --interval=10s --timeout=10s --retries=5 --start-period=30s \
  CMD sh -c "/apps/${APP_NAME}/scripts/process-healthcheck.sh \
  && /apps/${APP_NAME}/scripts/ls-healthcheck.sh /home/${HIP_USER}/nextcloud/"

COPY ./scripts/ scripts/

ENTRYPOINT ["./scripts/docker-entrypoint.sh"]
