# syntax=docker/dockerfile:1
# sccmsecrets: SCCM policies exploitation tool.
ARG repo="docker.io" \
    base_image="alpine:3.22" \
    image_hash="08001109a7d679fe33b04fa51d681bd40b975d8f5cea8c3ef6c0eccb6a7338ce"
    
FROM ${repo}/${base_image}@sha256:${image_hash}

ENV PATH=/sccmsecrets/bin:/usr/local/bin:/usr/bin:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    TZ=UTC

RUN \
    apk add --no-cache \
        bash \
        tzdata \
        coreutils \
        findutils \
        ca-certificates \
        libgcc \
        libstdc++ \
        iputils \
        openssl \
        musl-dev \
        linux-headers \
        python3 \
        py3-pip; \
    \
    python3 -m venv sccmsecrets; \
    . sccmsecrets/bin/activate; \
    python3 -m pip install --upgrade pip; \
    python3 -m pip install --upgrade requests; \
    python3 -m pip install --upgrade typer[all]; \
    python3 -m pip install --upgrade bs4; \
    python3 -m pip install --upgrade cryptography; \
    python3 -m pip install --upgrade requests_ntlm; \
    python3 -m pip install --upgrade requests_toolbelt; \
    python3 -m pip install --upgrade pyasn1_modules; \
    rm -rf /var/cache/apk/* /root/.cache/*

COPY . .

CMD [ "bash" ]