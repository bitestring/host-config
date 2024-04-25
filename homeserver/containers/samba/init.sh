#!/bin/bash

if [[ $SAMBA_USERNAME = '' || $SAMBA_PASSWORD = '' ]]; then
    echo "Username or password is not set. Cannot run Samba."
    exit -1
else
    echo "Initializing Samba."
    echo -e "$SAMBA_PASSWORD\n$SAMBA_PASSWORD" | smbpasswd -a -s $SAMBA_USERNAME
    echo "Initialization Done."
    smbd --foreground --debug-stdout --no-process-group
fi
