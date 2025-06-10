# syntax=docker/dockerfile:1
# spyai: Intelligent Malware that takes screenshots for entire monitors and exfiltrate them through Trusted Channel Slack 
#        to the C2 server that's using GPT-4 Vision to analyze them and construct daily activity — frame by frame
ARG repo="docker.io" \
    base_image="alpine:3.22" \
    image_hash="08001109a7d679fe33b04fa51d681bd40b975d8f5cea8c3ef6c0eccb6a7338ce"
    
FROM ${repo}/${base_image}@sha256:${image_hash}

ENV PATH=/spyai:/usr/local/bin:/usr/bin:$PATH \
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
        libxml2 \
        musl-dev \
        linux-headers \
        python3 \
        py3-pip; \
    \
    python3 -m venv spyai; \
    . spyai/bin/activate; \
    python3 -m pip install --upgrade --no-cache-dir pip; \
    python3 -m pip install --upgrade --no-cache-dir slack_sdk; \
    python3 -m pip install --upgrade --no-cache-dir requests; \
    python3 -m pip install --upgrade --no-cache-dir openai; \
    python3 -m pip install --upgrade --no-cache-dir pillow; \
    \
    rm -rf /var/cache/apk/* /root/.cache/*

WORKDIR /spyai
COPY . .
RUN chmod +x ./server.py
CMD [ "./server.py" ]