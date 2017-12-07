#!/bin/bash

#USER_ID=$(id -u)
#GROUP_ID=$(id -g)
#USER=openfoam
#
#if [ x"$USER_ID" != x"0" ]; then
#    NSS_WRAPPER_PASSWD=/tmp/passwd.nss_wrapper
#    NSS_WRAPPER_GROUP=/tmp/group.nss_wrapper
#
#    cat /etc/passwd | sed -e "s/^${USER}:/ignore:/" > $NSS_WRAPPER_PASSWD
#    echo "${USER}:x:$USER_ID:$GROUP_ID:${USER},,,:/home/${USER}:/bin/bash" >> $NSS_WRAPPER_PASSWD
#
#    if [ x"$GROUP_ID" != x"0" ]; then
#        cat /etc/group | sed -e "s/^${USER}:/ignore:/" > $NSS_WRAPPER_GROUP
#        echo "${USER}:x:$GROUP_ID:" >> $NSS_WRAPPER_GROUP
#    fi
#
#    export NSS_WRAPPER_PASSWD
#    export NSS_WRAPPER_GROUP
#
#    LD_PRELOAD=/usr/lib/libnss_wrapper.so
#    export LD_PRELOAD
#fi
#
#exec /bin/bash "$@"

source /opt/openfoam/OpenFOAM-5.0/etc/bashrc
exec /bin/bash "$@"
