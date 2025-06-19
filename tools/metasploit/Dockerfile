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
	# add extra packages here, using msf for just exploitation purposes here.
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
		tor \
		torsocks \
		vim \
		nmap \
		nikto \
		wget; \
	apt-get clean -y

# copy sploit/tor/wordlist scripts, see README's...
COPY --chmod=755 . .

RUN \
	cp tmux.conf /root/.tmux.conf; \
	python3 -m pip --no-cache-dir install -r ./requirements.txt

ENTRYPOINT ["bash", "-c", "/init.sh"]
