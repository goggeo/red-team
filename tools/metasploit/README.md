## Metasploit Framework

```sh
|                                                                              |
|                   METASPLOIT CYBER MISSILE COMMAND V5                        |
|______________________________________________________________________________|
      \                                  /                      /
       \     .                          /                      /            x
        \                              /                      /
         \                            /          +           /
          \            +             /                      /
           *                        /                      /
                                   /      .               /
    X                             /                      /            X
                                 /                     ###
                                /                     # % #
                               /                       ###
                      .       /
     .                       /      .            *           .
                            /
                           *
                  +                       *

                                       ^
####      __     __     __          #######         __     __     __        ####
####    /    \ /    \ /    \      ###########     /    \ /    \ /    \      ####
################################################################################
################################################################################
# WAVE 5 ######## SCORE 31337 ################################## HIGH FFFFFFFF #
################################################################################
                                                           https://metasploit.com

# to contain msf to user namespace
sudo addgroup -g 65535 metasploit
sudo adduser -h /home/metasploit --uid 65535 --ingroup metasploit metasploit
sudo passwd metasploit

modprobe tun
echo tun >>/etc/modules
echo metasploit:165536:65536 >/etc/subuid
echo metasploit:165536:65536 >/etc/subgid

sudo tee /etc/sysctl.d/99-metasploit-pod.conf<<\EOF
[main]
summary= <1024 ports for metasploit to use
[sysctl]
net.ipv4.ip_unprivileged_port_start=80
net.ipv4.ip_unprivileged_port_start=443
net.ipv4.ip_unprivileged_port_start=445
EOF

sudo sysctl -p /etc/sysctl.d/99-metasploit-pod.conf

sudo -u metasploit bash

# local build - just msf without tor configuration
podman build -t msf .
podman network create msf
podman run --rm -it --security-opt=no-new-privileges --network msf --name msf msf

<<comment
/
      redirect all traffic through tor network including dns queries for anonymizing entire system.
      modify init.sh to configure tor routing
/
comment

# generate new hashed torrc password
# having tor installed on system

tor --hash-password <secret>

vim torctl.sh

# replace in function gen_torrc()
HashedControlPassword 16:FDE8ED505C45C8BA602385E2CA5B3250ED00AC0920FEC1230813A1F86F

vim init.sh

# optional, uncomment to use
echo '------------------------------------------'
echo '[+] ---------------------- Configuring tor'
echo '------------------------------------------'
bash -c "/torctl.sh start"

# configure host machine settings for tor routing
sudo chmod +x torctl_sysctl_host.sh
./torctl_sysctl_host.sh

# run container with host network stack
sudo podman run --rm -it --name msf \
      --net=host \
      --cap-add=net_admin \
      --cap-add=net_raw \
      --cap-add=sys_nice \
      -p 9040 -p 9053 -p 9051 \
      -d msf
```
