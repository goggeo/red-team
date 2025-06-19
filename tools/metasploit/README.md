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
```

Nvidia docker/podman support:
```sh
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update

sudo apt-get install -y \
    linux-headers-$(uname -r) \
    podman \
    podman-compose \
    nvidia-driver \
    nvidia-cuda-toolkit \
    nvidia-container-toolkit

# Set/Check NVIDIA configuration
nvidia-ctk cdi generate --output=/var/run/cdi/nvidia.yaml
nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
chmod a+r /var/run/cdi/nvidia.yaml /var/run/cdi/nvidia.yaml 
nvidia-smi -L
nvidia-ctk cdi list
```

Run with gpu support for faster cracking:
```sh
podman-compose up
```

Without:
```sh
podman build -t metasploit .

podman run -it --name metasploit metasploit
```
