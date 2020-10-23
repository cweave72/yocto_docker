# Docker image for Yocto builds

Clone:
` git clone https://github.com/cweave72/yocto_docker`

Build image:
```
cd yocto_docker
./build-image.sh
```

Start container:
`./start_container.sh`

Add shortcut to starting the container:
Suggestion:
```
sudo mkdir /opt/docker_aliases/ubuntu-bionic
cp start-container.sh /opt/docker_aliases/ubuntu-bionic
cd /opt/docker_aliases/ubuntu-bionic
sudo ln -s start_container.sh start-yocto
```

To prepare for a yocto build, navigate to the directory where you will be building and run `start-yocto`. \
This will start the container and place you in the directory you invoked `start-yocto` from. You can now `bitbake` away.
