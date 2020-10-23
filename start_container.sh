#!/bin/bash

# Function which strips the leading parts of the path:
# Ex: /home/cdweave/some/path --> some/path
function stripPath {
ARGS="$@" python - << END
import os
import re
path = os.environ['ARGS']
m = re.search(r"\/home\/\w+\/(.*)", path)
if m:
    print m.group(1)
else:
    print ''
END
}

# Convert the full absolute path to the path relative to the home directory.
# Recall that the entrypoint changes to this directory first within user's home directory
# which is mounted within the container.
WORKING_DIR=$(stripPath $(pwd))

docker run -ti --rm \
           --net=host \
           --user $(id -u) \
           -e DISPLAY=$DISPLAY \
           -e WORKING_DIR="$WORKING_DIR" \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v $HOME/.Xauthority:/home/user/.Xauthority \
	   -v $HOME:/home/user \
           -v /mnt/probox/shares/netshare:/mnt/probox/shares/netshare \
           ubuntu-bionic \
           bash
