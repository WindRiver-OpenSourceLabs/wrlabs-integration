#!/bin/sh

cleanup() {
umount ${upboot} /tmp/sysroot_b/boot
umount ${uproot} /tmp/sysroot_b
rm -rf /tmp/sysroot_b
exit
}

partbase=`mount |grep "sysroot " | awk '{print $1}' | awk -F 'p' '{print $1}'`
partroot=`mount |grep "sysroot " | awk '{print $1}' | awk -F 'p' '{print $2}'`

partbase=${partbase}'p'

rootpart=${partbase}'1'

abflag='B'
upboot=${partbase}'7'
uproot=${partbase}'8'
runboot=${partbase}'5'
runroot=${partbase}'6'
label_append='_b'
if [ x${partroot} = 'x8' ]; then
	abflag='A'
	upboot=${partbase}'5'
	uproot=${partbase}'6'
	runboot=${partbase}'7'
	runroot=${partbase}'8'
	label_append=''
fi
label_pre=""
teststr=`grep "_hd" /proc/cmdline`
if [ -n "${teststr}" ]; then
	label_pre="_hd"
fi

#Mount backup device
mkdir -p /tmp/sysroot_b
mount ${uproot} /tmp/sysroot_b
#if failed
testval=$?
if [ ! -d /tmp/sysroot_b/ostree/repo ]; then
	testval=1
else
	if [ -d /tmp/sysroot_b/boot ];then
		mount ${upboot} /tmp/sysroot_b/boot
		testval=$?
	else
		testval=1
	fi
fi
if [ $testval -ne 0 ]; then
	umount ${upboot}
	umount ${uproot}
	dd if=${runroot} of=${uproot} bs=1M status=progress
	e2label ${uproot} otaroot${label_append}${label_pre}
	sleep 0.5
	e2label ${uproot} otaroot${label_append}${label_pre}
	sync
	mount ${uproot} /tmp/sysroot_b
	testval=$?
	if [ $testval -ne 0 ]; then
		echo "Fatal error on "${uproot}
		cleanup
	fi
	if [ ! -d /tmp/sysroot_b/ostree/repo ]; then
		echo "Fatal error on "${uproot}/ostree
		cleanup
	fi

	dd if=${runboot} of=${upboot} bs=1M status=progress
	e2label ${upboot} otaboot${label_append}${label_pre}
	sleep 0.5
	e2label ${upboot} otaboot${label_append}${label_pre}
	sync
	mount ${upboot} /tmp/sysroot_b/boot
	testval=$?
	if [ $testval -ne 0 ]; then
		echo "Fatal error on "${upboot}
		cleanup
	fi
fi

#TOOD:pull-local
#ostree pull-local --repo=/tmp/sysroot_b/ostree/repo /sysroot/ostree/repo/ pulsar-linux:cube-gw-ostree-runtime
branch=`ls /tmp/sysroot_b/ostree/repo/refs/remotes/pulsar-linux/ | sed -n '1p'`

if [ -z '${branch}' ]; then
	echo "No branch found, try default cube-gw"
	branch=cube-gw-ostree-runtime
fi

ostree pull --repo=/tmp/sysroot_b/ostree/repo pulsar-linux:${branch}
testval=$?
if [ $testval -ne 0 ]; then
	echo "Ostree pull failed"
	cleanup
fi

ostree admin --sysroot=/tmp/sysroot_b/ deploy --os=pulsar-linux ${branch}
testval=$?
if [ $testval -ne 0 ]; then
	echo "Ostree deploy failed"
	cleanup
fi


umount ${upboot}
umount ${uproot}

mount ${rootpart} /tmp/sysroot_b
echo "123"${abflag} > /tmp/sysroot_b/boot_ab_flag
umount /tmp/sysroot_b

rm -rf /tmp/sysroot_b

reboot
