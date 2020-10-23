#
# Docker Bionic image to build Yocto 3.0
#
FROM ubuntu:18.04

# Keep the dependency list as short as reasonable
RUN apt-get update && \
    apt-get install -y bc bison bsdmainutils build-essential curl locales \
        flex g++-multilib gcc-multilib git gnupg gperf lib32ncurses5-dev \
        lib32z1-dev libncurses5-dev git-lfs \
        libsdl1.2-dev libxml2-utils lzop \
        openjdk-8-jdk lzop wget git-core unzip \
        genisoimage sudo socat xterm gawk cpio texinfo \
        gettext vim diffstat chrpath \
        python-mako libusb-1.0-0-dev exuberant-ctags \
        pngcrush schedtool xsltproc zip zlib1g-dev libswitch-perl && \
        apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Extras
RUN apt-get update && \
    apt-get install -y ranger tree

ADD https://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

# ===== create user/setup environment =====
# Replace 1000 with your user/group id
RUN export uid=1000 gid=1000 user=user && \
    mkdir -p /home/${user} && \
    echo "${user}:x:${uid}:${gid}:${user},,,:/home/${user}:/bin/bash" >> /etc/passwd && \
    echo "${user}:x:${uid}:" >> /etc/group && \
    echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${user} && \
    chmod 0440 /etc/sudoers.d/${user} && \
    chown ${uid}:${gid} -R /home/${user}

# The persistent data will be in these two directories, everything else is
# considered to be ephemeral
#VOLUME ["/tmp/ccache", "/aosp"]

# Improve rebuild performance by enabling compiler cache
ENV USE_CCACHE 1
ENV CCACHE_DIR /home/user/.ccache

# some QT-Apps/Gazebo do not show controls without this
ENV QT_X11_NO_MITSHM 1

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
 
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chown user:user /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

ENV HOME /home/user
ENV USER user
USER user
WORKDIR /home/user

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
