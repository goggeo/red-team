# syntax=docker/dockerfile:1
# TREVORproxy: A SOCKS proxy written in Python that randomizes your source IP address.
# TREVORspray: A modular password sprayer with threading, SSH proxying, loot modules, and more!
ARG repo="docker.io" \
    base_image="alpine:3.22" \
    image_hash="08001109a7d679fe33b04fa51d681bd40b975d8f5cea8c3ef6c0eccb6a7338ce"
    
FROM ${repo}/${base_image}@sha256:${image_hash}

ENV PATH=/trevorproxy/bin:/trevorspray/bin:/usr/local/bin:/usr/bin:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    TZ=UTC

RUN \
    apk add --no-cache \
        bash \
        curl \
        sudo \
        tzdata \
        coreutils \
        findutils \
        grep \
        ca-certificates \
        libgcc \
        libstdc++ \
        proxychains-ng \
        git \
        iptables \
        iputils \
        openssl \
        openssh \
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
    freshclam; \
    clamscan -rvi -l last_scan.log --exclude-dir="^/sys" /; \
    grep -Hrn " FOUND" last_scan.log; \
    \
    rm -rf /var/cache/apk/* /root/.cache/*

ARG interface
ENV INTERFACE=$interface
CMD [ "sh" ]