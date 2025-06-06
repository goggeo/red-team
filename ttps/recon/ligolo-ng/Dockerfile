# syntax=docker/dockerfile:1
# Ligolo-ng is a simple, lightweight and fast tool that allows pentesters to establish tunnels 
# from a reverse TCP/TLS connection using a tun interface (without the need of SOCKS).
ARG repo="docker.io" \
    base_image="alpine:edge" \
    image_hash="20c6c97faaa88f32bbbc45696d259f0c01404a4ec2f1fa4fa8bc5aa5140443ec"
    
FROM ${repo}/${base_image}@sha256:${image_hash} AS base

FROM base AS go-builder

ENV GOPATH=/usr/local/bin/go

RUN \
    apk add --no-cache -t .build-deps \
        bash \
        ca-certificates \
        curl; \
        go; \
    apk add --no-cache -t .av-scan \
        clamav \
        freshclam; \
    mkdir -p ${GOPATH}/src/github.com/ligolo-ng

WORKDIR ${GOPATH}/src/github.com/ligolo-ng
COPY . .

RUN \
    go build -o agent cmd/agent/main.go; \
    go build -o proxy cmd/proxy/main.go; \
    apk del --no-network --purge .build-deps; \
    freshclam; \
    clamscan -rvi -l /clamav_scan.log --exclude-dir="^/sys|^/dev" /; \
    grep -Hrn FOUND /clamav_scan.log; \ 
    apk del --no-network --purge .av-scan; \
    rm -rf /var/cache/apk/*; \
    rm -rf ${GOPATH}/src/github.com

FROM base

COPY --from=go-builder /usr/local/bin/go/bin/ /usr/local/bin
COPY --from=go-builder /clamav_scan.log /home/anchore
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl --fail http://localhost:8080 || exit 1
CMD ["bash", "-c", "echo 'Ligolo-ng is ready to run!'; exec /usr/local/bin/go/bin/agent -h || exec /usr/local/bin/go/bin/proxy -h"]
# https://docs.ligolo.ng/Quickstart/