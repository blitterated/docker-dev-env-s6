FROM dde

MAINTAINER blitterated blitterated@protonmail.com

ARG S6_OVERLAY_VERSION=3.1.4.2

WORKDIR /root
COPY dde.rc/*.* .dde.rc/
COPY provision/*.* .provision/

RUN ./.provision/apt_prep.sh
RUN ./.provision/s6-overlay.sh "${S6_OVERLAY_VERSION}"

COPY utils/container/bounce /usr/bin/bounce
COPY utils/container/path /usr/bin/path
COPY utils/container/docker-s6-quick-exit /usr/bin/docker-s6-quick-exit

ENTRYPOINT ["/init"]
