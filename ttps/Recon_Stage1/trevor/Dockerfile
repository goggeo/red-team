# syntax=docker/dockerfile:1
# TREVORproxy: A SOCKS proxy written in Python that randomizes your source IP address.
# TREVORspray: A modular password sprayer with threading, SSH proxying, loot modules, and more!
ARG repo="docker.io" \
    base_image="alpine:3.22" \
    image_hash="08001109a7d679fe33b04fa51d681bd40b975d8f5cea8c3ef6c0eccb6a7338ce"
    
FROM ${repo}/${base_image}@sha256:${image_hash}

ENV PATH="${PATH}:/trevorproxy/bin" \
    PATH="${PATH}:/trevorspray/bin" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    TZ=UTC

RUN \
    apk add --no-cache \
        bash \
        curl \
        ca-certificates \
        libgcc \
        libstdc++ \
        libcrypto1.1 \
        libssl1.1 \
        libcurl \
        libxml2 \
        musl-dev \
        linux-headers \
        clamav \
        freshclam \
        python3 \
        py3-pip; \
    \
    python3 -m venv trevorproxy; \
    . trevorproxy/bin/activate; \
    python3 -m pip install --upgrade pip; \
    python3 -m pip install --upgrade git+https://github.com/blacklanternsecurity/trevorproxy; \
    \
    python3 -m venv trevorspray; \
    . trevorspray/bin/activate; \
    python3 -m pip install --upgrade git+https://github.com/blacklanternsecurity/trevorspray; \
    \
    addgroup -g 65535 trevor; \
    adduser --shell /sbin/sh --disabled-password -h /home/trevor --uid 65535 --ingroup trevor trevor; \
    \
    freshclam; \
    clamscan -rvi -l /home/trevor/last_scan.log --exclude-dir="^/sys" /; \
    chown trevor:trevor /home/trevor/last_scan.log; \
    grep -Hrn " FOUND" /home/trevor/last_scan.log; \
    \
    rm -rf /var/cache/apk/* /root/.cache/*; \
    \
    chown -R trevor:trevor /trevorproxy; \
    chown -R trevor:trevor /trevorproxy

USER trevor
ARG interface
ENV INTERFACE=$interface
CMD [ "sh" ]
# sudo podman build --build-arg interface=wlo1 -t trevor .
#sudo podman run --rm -it --name trevor \
#   --net=host \
#   --cap-add=net_admin \
#   --cap-add=net_raw \
#   --cap-add=sys_nice \
#   -d trevor