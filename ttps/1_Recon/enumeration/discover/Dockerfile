FROM docker.io/ubuntu:jammy

LABEL \
    org.opencontainers.image.name='Metasploit Framework' \
    org.opencontainers.image.description='The worlds most used penetration testing framework.' \
    org.opencontainers.image.usage='https://docs.metasploit.com/' \
    org.opencontainers.image.url='https://www.metasploit.com/' \
    org.opencontainers.image.vendor='Rapid7' \
    org.opencontainers.image.schema-version='6'

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8

RUN \
	set -e; \
	apt-get upgrade -yq; \
	apt-get update -yq; \
	apt-get install -y \
		bash \
		ca-certificates \
		curl \
		gnupg \
		iptables \
		apt-transport-https \
		software-properties-common \
		wget; \
	\
	curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall; \
	chmod +x msfinstall; \
	./msfinstall; \
	\
	apt-get update -yq; \
	apt-get install -y \
		build-essential \
		libffi-dev \
		libgit2-dev \
		python3 \
		python3-pip \
		tmux \
		golang \
		git \
		openssl \
		hydra \
		hashcat \
        nikto \
		tor \
		torsocks \
		vim \
		nmap \
		wget; \
	apt-get clean -y

WORKDIR /app/discover

COPY --chmod=755 src/ .
COPY --chmod=755 init.sh .

ENTRYPOINT ["bash", "-c", "./init.sh"]
