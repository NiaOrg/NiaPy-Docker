#! /bin/bash
USER=$1
USERID=$2
GROUP=$3
GROUPID=$4
HOME=$5
if id -u "$USER" >/dev/null 2>&1; then
	userdel -r $USER
fi
if id -u "$USERID" >/dev/null 2>&1; then
	userdel -r $USERID
fi
if id -u "$GROUP" >/dev/null 2>&1; then
	groupdel $GROUP
fi
if id -u "$GROUPID" >/dev/null 2>&1; then
	groupdel $GROUPID
fi
groupadd -g $GROUPID $GROUP
useradd -c 'Jupyter notebook user' -k /etc/skel -s /bin/bash -md $HOME -N -u $USERID -g $GROUPID $USER 
