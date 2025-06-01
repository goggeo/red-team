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
	#wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb; \
	#dpkg -i packages-microsoft-prod.deb; \
	#rm packages-microsoft-prod.deb; \
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
		wget; \
		#powershell \
		#dotnet-sdk-8.0 \
		#aspnetcore-runtime-8.0; \
	apt-get clean -y

# copy sploit/tor/wordlist scripts, see README's...
COPY . /

# tooling install, uncomment to elect which to install

RUN \
	mkdir -p /root/tooling; \
	find / -name "*.sh" -exec chmod +x {} \; ; \
	find / -name "*.py" -exec chmod +x {} \; ; \
	rm -f *.zip

# move PoC exploits into msf container
#COPY ../exploits /root/tooling

RUN \
	cp tmux.conf /root/.tmux.conf; \
	chmod 0755 /init.sh; \
	python3 -m pip --no-cache-dir install -r ./requirements.txt

WORKDIR /opt
ENTRYPOINT ["/init.sh"]
