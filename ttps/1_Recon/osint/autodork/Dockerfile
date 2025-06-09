FROM python:3.14-rc-slim-bookworm

WORKDIR /app

COPY . .

RUN \
    # Attempt to install the packages using pip3
    pip3 install -r requirements.txt 2>&1 | grep "error: externally-managed-environment" >/dev/null; \
    \
    if [ $? -eq 0 ]; then ; \
        # If the pip3 installation failed, install the packages using apt
        echo "Installing required packages using apt"; \
        apt-get update; \
        apt-get install -y $(cat requirements.txt); \
    fi; \
    \
    chmod +x sitedorks.py

CMD ["sh"]