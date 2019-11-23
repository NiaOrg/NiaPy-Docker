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
if id -g "$GROUP" >/dev/null 2>&1; then
	groupdel $GROUP
fi
if id -g "$GROUPID" >/dev/null 2>&1; then
	groupdel $GROUPID
fi
groupadd -g $GROUPID $GROUP
useradd -u $USERID -g $GROUPID -s /bin/bash -d $HOME -k /etc/skel -m -c 'Jupyter notebook user' -N $USER 
cp -rn /etc/skel/* $HOME
chown -r $USER.$GROUP $HOME
