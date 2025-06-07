# syntax=docker/dockerfile:1
# TREVORproxy: A SOCKS proxy written in Python that randomizes your source IP address.
ARG repo="docker.io" \
    base_image="alpine:3.22" \
    image_hash="08001109a7d679fe33b04fa51d681bd40b975d8f5cea8c3ef6c0eccb6a7338ce"
    
FROM ${repo}/${base_image}@sha256:${image_hash}

ENV PATH="${PATH}:/trevorproxy/bin"

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
    addgroup -g 65535 trevorproxy; \
    adduser --shell /sbin/sh --disabled-password -h /home/trevorproxy --uid 65535 --ingroup trevorproxy trevorproxy; \
    \
    freshclam; \
    clamscan -rvi -l /home/trevorproxy/last_scan.log --exclude-dir="^/sys" /; \
    chown trevorproxy:trevorproxy /home/trevorproxy/last_scan.log; \
    grep -Hrn " FOUND" /home/trevorproxy/last_scan.log; \
    \
    rm -rf /var/cache/apk/* /root/.cache/*; \
    \
    chown -R trevorproxy:trevorproxy /trevorproxy

USER trevorproxy
ARG interface
ENV INTERFACE=$interface
CMD [ "sh", "-c", "trevorproxy subnet -s dead:beef::0/64 -i $INTERFACE" ]
# sudo podman build --build-arg interface=wlo1 -t trevorproxy .
#sudo podman run --rm -it --name trevorproxy \
#   --net=host \
#   --cap-add=net_admin \
#   --cap-add=net_raw \
#   --cap-add=sys_nice \
#   -d trevorproxy