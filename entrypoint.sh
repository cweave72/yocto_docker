#!/bin/bash

# This entrypoint cd's to the directory the user was in when container is invoked.
# Add global PATH additions here:
#PATH=$PATH:$XILINX_PATH

echo Changing directory to $WORKING_DIR.
cd $WORKING_DIR
echo Executing "$@"
exec "$@"
