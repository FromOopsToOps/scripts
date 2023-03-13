#!/bin/bash

# emerge updater
#
# Automatically sync emerge database and repositories
# and then install stuff that can be done without interference
# this shouldn't go without saying that this is experimental

sendinfo="systemd-cat -t emerge-sync -p info"
sendwarn="systemd-cat -t emerge-sync -p warning"
senderro="systemd-cat -t emerge-sync -p error"

echo "Starting Emerge Syncer" |$sendinfo

emaint sync --allrepos &> /dev/null
status=$? # did we succeed?
if [ $status == '0' ]
	then #if so
		echo "Successfully updated database." |$sendinfo
	else
		echo "Emaint failed." |$senderro
		echo "We will stop for now and try again later." |$senderro
		exit
fi
unset status

# set up portage to run slowly
echo "Setting up Portage to run slowly" |$sendinfo
sed -i 's/${FAST}/${SLOW}/g' /etc/portage/make.conf

# Let's create the list of programs we can safely merge/update during

emerge -uDN --keep-going world
status=$? # did we succeed?
if [ $status == '0' ]
        then #if so
                echo "Successfully merged new packages." |$sendinfo
        else
            	echo "Portage failed." |$senderro
                echo "We will stop for now and try again later." |$senderro
		echo "Setting up Portage back to fast" |$sendinfo
		sed -i 's/${SLOW}/${FAST}/g' /etc/portage/make.conf
                exit
fi

echo "Setting up Portage back to fast" |$sendinfo
sed -i 's/${SLOW}/${FAST}/g' /etc/portage/make.conf
echo "Running depclean" |$sendinfo
emerge --depclean

if [ $status == '0' ]
        then #if so
                echo "Successfully ran depclean." |$sendinfo
		exit
        else
            	echo "Depclean failed." |$senderro
                echo "We will stop for now and try again later." |$senderro
                echo "Setting up Portage back to fast" |$sendinfo
                sed -i 's/${SLOW}/${FAST}/g' /etc/portage/make.conf
                exit
fi

exit
