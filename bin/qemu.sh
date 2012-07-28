#!/bin/bash
# vim:ts=8:sw=2 et:sta
# Najib Ibrahim [mnajib@gmail.com]
#

# NOTE: For list of disk image, please see 
#   qemu/doc/img_list.txt
#

# IRC channels:
#	#qemu@irc.oftc.net
# 	#qemu@irc.freenode.net
# 	#virtualsquare@irc.freenode.net
# 	#ubuntu@irc.freenode.net
# pastebin:
#   https://pzt.me/75uy
#		http://img534.imageshack.us/img534/4631/networkingqemuvdebridge.png
#

# To enable 32-bit and 64-bit emulation (as guest hardware); steps:
#sudo apt-get install libsdl1.2-dev
#sudo apt-get install zlib1g-dev
#sudo apt-get install libvde-dev libvde0 libvdeplug2 libvdeplug2-dev
#sudo apt-get install libspice-server libspice-server-dev spice spice-protocol-dev libspice-client libspice-client-dev spice-client
#cd
#wget "http://download.savannah.gnu.org/releases/qemu/qemu-0.14.1.tar.gz"
#tar -vxzf qemu-0.14.1.tar.gz -C /opt/qemu
#cd /opt/qemu
#
#	--enable-spice \
#	--enable-docs \
#./configure \
#	--prefix=/opt/qemu \
#	--target-list=i386-softmmu,x86_64-softmmu,i386-linux-user,x86_64-linux-user \
#	--enable-sdl \
#	--enable-system \
#	--enable-vde \
#	--enable-curses \
#	--enable-vnc-thread \
#	--enable-debug
#
#make
#sudo make install
##make clean
#cd /opt/qemu
#/opt/qemu/bin/qemu-system-x86_64 -cpu qemu64 ...
#
#----------------------------------------------------------
# Thinking to use QEMU like an application server, it could be 
# helpful to hide it. Adding those option to Qemu command line 
# does the job: 
#   "-nographic -monitor null -serial null". 
# The 
# problem that could arise is that the shutdown command does 
# not poweroff by default on many distributions, and qemu 
# process remains running until you kill it in some way. To 
# solve the problem, on my Ubuntu 6.06 server installation, I 
# installed acpi and apm stuff and added the line 
#   "apm power_off=1" 
# to /etc/modules.
#
#apt-get install gtkvncviewer

#
# Backing file vs snapshot ?
# ...
#

# vdeq qemu-kvm \
#		-curses \
#		-drive file=/lala.img,snapshot=off,cache=none,if=virtio,boot=on \
#		-smp 2 -m 1G \
#		-monitor telnet:127.0.0.1:9221,server,nowait
#		-net vde,vlan=0 \
#		-net nic,model=virtio,vlan=0,macaddr=52:54:00:00:AA:01 \
#
#	vdeq qemu-kvm \
#		-curses \
#		-drive file=nana.img,snapshot=off,cache=none,if=virtio,boot=on \
#		-smp 2 -m 1G \
#		-monitor telnet:127.0.0.1:9222,server,nowait
#		-net vde,vlan=0 \
#		-net nic,model=virtio,vlan=0,macaddr=52:54:00:00:AA:03 \
#		-net vde,vlan=1 \
#		-net nic,model=virtio,vlan=1,macaddr=52:54:00:00:AA:04

#qemu -version
#
#QEMU32="/usr/bin/qemu"
#QEMU64="/usr/bin/qemu-system-x86_64"
#QEMU=${QEMU32}
#QEMU32VDE="vdeqemu"
#QEMUROOT="/opt/qemu/bin/" # custom compile									# compile with vde support
QEMUROOT="/usr/bin" # custom compile									# compile with vde support
#QEMUROOT="/usr/bin"	# default qemu ubuntu did not support vde									# compile with vde support
QEMU32="${QEMUROOT}/qemu"
#QEMU32="${QEMUROOT}/qemu-system-i386" # ?
QEMU64="${QEMUROOT}/qemu-system-x86_64"
QEMU=${QEMU32}														# ...
#QEMU=${QEMU64}	# ?									# ...
QEMU32VDE=${QEMU32}												# ...
QEMU64VDE=${QEMU64}												# ...
#QEMU="qemu-spice"			# ?
#QEMU="qemu-kvm"				# ?
#QEMU="qemu-kvm-spice"	# ?

# qemu -cpu \?
# qemu -cpu '?'
#
# NOTE: 
#   for 32-bit hardware system, /usr/bin/qemu is same as  
#   qemu-system-386 -cpu qemu32
#   for 64-bit hardware system, /usr/bin/qemu is same as
#   qemu-system-x86_64 -cpu qemu64
#       

# qemu monitor
#info
#info snapshots
#

# Ref: BASH Internal Variable
# Check OS; 32bit or 64bit?
_bitOS() {
	echo $(getconf LONG_BIT)
}
#echo -e "OS bit level is `_bitOS` bit"

_hostname() {
	echo "$(hostname)"
}

# Boot device
harddisk="c"
cdrom="d"

BASEDIR="/mnt/data/DATA/vm/qemu"
BASEIMGDIR="img/base"
DIFFIMGDIR="img/diff"

ISODIR="/mnt/data/DATA/iso"
ISODIR2="/home/najib/Downloads"

#UPSCRIPT="/etc/qemu-ifup"		# for qemu-bridge
#DOWNSCRIPT="/etc/qemu-ifdown"		# for qemu-bridge

READMEfile="${BASEDIR}/README.txt"


#----------------------------------------------------------
function _create_baseimg() {
    # Check if the image file name already exist?
		#...

    #qemu-img create -f qcow2 ${BASEIMG} 20G
    qemu-img create -e -f qcow2 ${BASEIMG} 20G # encrypted
		# cont
}

function _run_base() {
    # WARNING! message
    #...

    qemu
    # TODO:
}

function _create_diffimg() {
    # Check if the image file name already exist?
    #...

    # Check if the base-image exist?
    #...

    # Check available space
    #...

    chmod -v a-rwx ${BASEIMG}
    cp -v ${BASEIMG} ${BASEIMG}.bak
    chmod -v a-rwx ${BASEIMG}.bak
    cd ${DIFFIMGDIR}
    qemu-img create -f qcow2 -b ../base/${BASEIMG} ${DIFFIMG} 20G
    #qemu-img create -f qcow2 -o backing_file=../base/${BASEIMG} ${DIFFIMG} 20G
    # TODO:
}

_convert_diff2base() {
  # TODO:
  # when use this? example:
	# we have /qemu/img/diff/fedora14.budu.qcow2 with backing file /qemu/img/base/fedora14.base.qcow2
	# after updating the fedora14.budu.qcow2, we deside to make it as base image if we wan to create new disk later.
	# ...
  # img (diff_img) guna backing-file; perlu update img bila backing-file berubah lokasi:

	#local QEMUROOT=""
	local QEMUROOT="/mnt/data/DATA/_master/_vm"
	local BASEIMG_OLD="fedora14.base.qcow2"
	local DIFFIMG_OLD="fedora14.budu.qcow2"
	local BASEIMG_NEW="fedora14.base-v0.4.qcow2"
	local DIFFIMG_NEW=${DIFFIMG_OLD}

	cd ${QEMUROOT}/qemu/img/base
	#cp ${QEMUROOT}/qemu/img/diff/${DIFFIMG_OLD} ${QEMUROOT}/qemu/img/base/ # temporary only
	mv ${QEMUROOT}/qemu/img/diff/${DIFFIMG_OLD} ${QEMUROOT}/qemu/img/base/ # temporary only
	qemu-img convert -O qcow2 -B ${BASEIMG_OLD} ${DIFFIMG_OLD} ${BASEIMG_NEW} # create new base image
	rm ${DIFFIMG_OLD}
	qemu-img info ${BASEIMG_NEW} 

	# XXX: 
	cd ${QEMUROOT}/qemu/img/diff
	#rm ${DIFFIMG_OLD}
	qemu-img create -f qcow2 -b ../base/${BASEIMG_NEW} ${DIFFIMG_NEW} 20G
	qemu-img info ${DIFFIMG_NEW} 

	# later, when we want to create a new fedora14 guest-os
	#DIFFIMG_FUTURE="fedora14.kelapa.qcow2"
	#cd ${QEMUROOT}/qemu/img/diff
	#qemu-img create -f qcow2 -b ../base/${BASEIMG_NEW} ${DIFFIMG_FUTURE}
	#qemu-img info ${DIFFIMG_FUTURE} 
}

_convert_diff2base2() {
  # TODO: method 2? (rebase)
  # when use this? example:
	# we have /qemu/img/diff/fedora14.budu.qcow2 with backing file /qemu/img/base/fedora14.base.qcow2
	# after updating the fedora14.budu.qcow2, we deside to make it as base image if we wan to create new disk later.
	# ...
  # img (diff_img) guna backing-file; perlu update img bila backing-file berubah lokasi:

	#local QEMUROOT=""
	local QEMUROOT="/mnt/data/DATA/_master/_vm"
	local BASEIMG_OLD="fedora14.base.qcow2"
	local DIFFIMG_OLD="fedora14.budu.qcow2"
	local BASEIMG_NEW="fedora14.base-v0.4.qcow2"
	local DIFFIMG_NEW=${DIFFIMG_OLD}

	cd ${QEMUROOT}/qemu/img/base
	#cp ${QEMUROOT}/qemu/img/diff/${DIFFIMG_OLD} ${QEMUROOT}/qemu/img/base/ # temporary only
	mv ${QEMUROOT}/qemu/img/diff/${DIFFIMG_OLD} ${QEMUROOT}/qemu/img/base/ # temporary only
	qemu-img convert -O qcow2 -B ${BASEIMG_OLD} ${DIFFIMG_OLD} ${BASEIMG_NEW} # create new base image
	rm ${DIFFIMG_OLD}
	qemu-img info ${BASEIMG_NEW} 

	# XXX: 
	cd ${QEMUROOT}/qemu/img/diff
	#rm ${DIFFIMG_OLD}
	qemu-img create -f qcow2 -b ../base/${BASEIMG_NEW} ${DIFFIMG_NEW} 20G
	##qemu-img convert -O qcow2 -B ../base/${BASEIMG_NEW} ${BASEIMG_NEW} ${DIFFIMG_NEW} # create new base image
	qemu-img info ${DIFFIMG_NEW} 

	# later, when we want to create a new fedora14 guest-os
	#DIFFIMG_FUTURE="fedora14.kelapa.qcow2"
	#cd ${QEMUROOT}/qemu/img/diff
	#qemu-img create -f qcow2 -b ../base/${BASEIMG_NEW} ${DIFFIMG_FUTURE}
	#qemu-img info ${DIFFIMG_FUTURE} 
}

_convert_vdi2qcow2() {
  # TODO:
  qemu-img convert \
		-f vdi \
		-O qcow2 \
		Ubuntu_Server.vdi \
		Ubuntu_Server.qcow2
}

_resizeImg() {
	echo "TODO: ..."

        local sometext = "From now on, we assume your existing VM disk image is called
  example.img. How much space would you like to add to it?
  Write this number down, but do so at the end of this command:
      
  qemu-img create -f raw additional.raw <size>

  Here, <size> is the amount of space that you want to
  add. So, 512M for 512 megabytes, 10G for 10
  gigabytes and so on. This will create an empty raw image containing
  as much (empty) space as you'd like to add to the real image.

  Now, convert your existing image to raw format as well.
      
  qemu-img convert -f qcow2 example.img -O raw example.raw

  And append the raw additional space to the end of your raw image:
      
  cat additional.raw >> example.raw

  Finally, convert the whole thing back to qcow2. I'm going to make a
  copy here instead of overwriting the original. This wastes a lot of
  disk space temporarily, but is safer if you've got the space to
  spare.
      
  qemu-img convert -f raw example.raw -O qcow2 example-expanded.img

  …and that's it. The example-expanded.img image
  should contain empty space after the final partition. To resize the
  partitions, download the GParted
  LiveCD, and boot it on the VM. You know how to do this;
  otherwise, you wouldn't be able to install an operating system on
  your VM."
        
}

_resetImgPasswd() {
  echo "TODO: encryption ..."
}

# NOTE: If copying a MAC address from an existing interface, 
# make it unique by altering any of the last 6 digits 
# at the end. The first 6 designate the card manufacturer 
# and so should not be made up.
#
# While generating your
# address beware to not use broadcast/multicast reserved MACs, ethernet
# rules say: the multicast bit is the low-order bit of the first byte,
# which is "the first bit on the wire". For example 34:12:de:ad:be:ef is
# an unicast address, 35:12:de:ad:be:ef is a multicast address (see
# ETHERNET MULTICAST ADDRESSES section in
# http://www.iana.org/assignments/ethernet-numbers for more
# informations).
#
# (http://www.cavebear.com/archive/cavebear/Ethernet/vendor.html)
# mac address for model realtec rtl1839 bermula dengan 00:E0:4C:
# 00:e0:4c:bd:64:ba	bingka
# 00:e0:4c:bd:64:bb	lengkuas
# 00:e0:4c:bd:64:bc	perahu
# 00:e0:4c:bd:64:bd	tempoyak
# 00:e0:4c:bd:64:be	belacan
# 00:e0:4c:bd:64:bf	kelapa
# 00:e0:4c:bd:64:ca	dodol
# 00:e0:4c:bd:64:cb	cencalok
# 00:e0:4c:bd:64:cc	bahulu
# 00:e0:4c:bd:64:cd	asamkeping
# 00:e0:4c:bd:64:ce	amanda
#
function _random_mac() {
    # TODO: Generate random MAC address
    #...

    echo ""
}

# TEST: study vde
#$ vde_switch -d -s /tmp/vdeswitch0 -M /tmp/vdeswitch0mgmt -t tap0 -mod 666
#$ brctl show
#$ brctl addif br0 tap0
#$ brctl show
#$ unixterm /tmp/vdeswitch0mgmt
#$ port/allprint
#$ port/showinfo
#$ logout
## vde_switch -d -s /tmp/vdeswitch1 -M /tmp/vdeswitch1mgmt
## unixterm /tmp/vdeswitch1mgmt
## port/showinfo
## logout
#$ dpipe vde_plug -p 32 -m 666 /tmp/vdeswitch0 = vde_plug -p 32 -m 666 /tmp/vdeswitch1
#$ vdeqemu ...
#
## brctl addbr br0
## brctl addif br0 eth0
## dhclient br0
### tunctl -u najib -t tap5
## vde_tunctl -u najib -t tap5
### ifconfig tap5 up
## ip link set tap5 up
## brctl addif br0 tap5
## brctl setfd br0 0
#$ vde_switch -d -s /tmp/vdeswitch5 -M /tmp/vdeswitch5mgmt
#$ unixterm /tmp/vdeswitch1mgmt
##$ vdeterm /tmp/vdeswitch1mgmt
#$ logout
#$ vde_plug2tap -d -s /tmp/vdeswitch5 tap5
#$ vdeqemu ... -net nic,macaddr=... -net vde,sock=/tmp/vdeswitch5
	#${QEMU32} \
	#-cdrom ${ISODIR3}/_freebsd-8.2/FreeBSD-8.2-RELEASE-i386-disc1.iso \
	#-net vde,vlan=0,port=2,sock=/tmp/vdeswitch0 \
	#-net nic,vlan=0,macaddr=00:e0:4c:bd:64:ba \
	#-net vde,vlan=0,sock=/tmp/vdeswitch0,port=2 \
	#-net nic,macaddr=00:e0:4c:bd:64:ba \
	#-net vde,sock=/tmp/vdeswitch0,port=2 \
	#-net vde,vlan=0,sock=/tmp/vdeswitch0,port=2 \
	#-net vde,sock=/tmp/vdeswitch0,port=2 \
	#-net vde,sock=/tmp/vdeswitch5 \
#
# 13:47 -!- Irssi: Join to #virtualsquare was synced in 2 secs
# 14:03 < najib> http://img534.imageshack.us/img534/4631/networkingqemuvdebridge.png. i am trying to make this network setup. is that doable if
#               the blue part was created by non-root user?
# 14:49 < julius> najib: yup
# 14:50 < julius> just give tap0 to a user - initialized with some ip or dhcpcd running
# 15:39 < shammash> yes I think that's the simplest solution: use vde_tunctl -u testuser and then run everything (qemu/vde) with testuser
# 15:40 < shammash> otherwise you have to play with a few vde_switch parameters to have the data socket writable for a certain group
#
# 18:08 < shammash> najib: you should bring up all the interfaces
# 18:08 < shammash> if you're using eth0 for some host traffic you should use br0 instead
# 18:10 < shammash> and for dhcp having 'brctl setfd br0 0' or something similar should help
#
#ifplugd
#
_startvdenet() {
  ## Load tun module
  #/sbin/modprobe tun 2>/dev/null
  ## Wait for the module to be loaded
  #while ! /bin/lsmod |grep -q "^tun"; do echo Waiting for tun device;sleep 1; done

	local VDETAP=tap0
	local VDESOCK=/tmp/vde0
	local VDEMGMTSOCK=/tmp/vde0.mgmt
	local VDEPID=/tmp/vde0.pid
	local PLUGVDE2TAPPID=/tmp/vde0tap0.pid
	
	# Create bridge network
	sudo ifconfig eth0 down
	# Check if already have and using bridge/br0
	#...
	sudo brctl addbr br0
	sudo brctl addif br0 eth0
	sudo ifconfig eth0 up
	sudo ifconfig eth0 0.0.0.0
	sudo ifconfig br0 up

	#sudo dhclient br0
	sudo ifconfig br0 192.168.1.2
	sudo route add default gw 192.168.1.1

	sudo vde_tunctl -u najib -t tap0
	sudo ifconfig tap0 up
	sudo brctl addif br0 tap0
	sudo brctl setfd br0 0
	#sleep 1

	# Create vde network
	#vde_switch -d -s ${VDESOCK} -M ${VDEMGMTSOCK}
		#--sock ${VDESOCK} --mode 775 --group kvm \
		#--mgmt ${VDEMGMTSOCK} --mgmtmode 770 --mgmtgroup kvm
	vde_switch --daemon \
		--pidfile ${VDEPID} \
		--sock ${VDESOCK} \
		--mgmt ${VDEMGMTSOCK}
  #unixterm /tmp/vdeswitch1mgmt
  #vdeterm /tmp/vdeswitch1mgmt
  #logout
	#vde_plug2tap -d -s /tmp/vde0 tap0
	vde_plug2tap --daemon \
		--pidfile ${PLUGVDE2TAPPID} \
		--sock ${VDESOCK} \
		${VDETAP} 
  #vde_switch --tap ${TAP_DEV} --daemon --group kvm \
  #  --sock /var/run/${TAP_DEV}.ctl --pidfile /var/run/${TAP_DEV}_vde.pid \
  #  --mod 775 --mgmtmode 770 --mgmt /var/run/${TAP_DEV}-manage
	#sleep 1

  # Change pipe permission:
  #chmod -R a+rwx /var/run/vde.ctl

	#vdeqemu ... -net nic,macaddr=... -net vde,sock=/tmp/vdeswitch5
}

_stopvdenet() {
	local VDETAP=tap0
	local VDEPID=/tmp/vde0.pid
	local PLUGVDE2TAPPID=/tmp/vde0tap0.pid

  # Bring tap interface down:
  #ifconfig ${TAP_DEV} down
	ifconfig ${VDETAP} down

  # Kill VDE switch:
  #pgrep -f vde_switch | xargs kill -TERM
	#kill -HUP $(cat /var/run/${TAP_DEV}_vde.pid)
	kill -HUP $(cat ${VDEPID})
	kill -HUP $(cat ${PLUGVDE2TAPPID})

  # Remove the control socket:
  #rmdir /var/run/vde.ctl
}






#----------------------------------------------------------
function _run_dodol() {
	#-net nic,vlan=1,macaddr=00:83:39:5b:94:e9 \
    ${QEMU} \
	-hda ${BASEDIR}/${DIFFIMGDIR}/fedora14.dodol.qcow2.img \
	-cdrom ${ISODIR}/Fedora-14-i386-disc1.iso \
	-boot c \
	-vga std \
	-monitor stdio \
	-soundhw es1370 \
	-m 256 \
	-cpu qemu32 \
	-localtime \
	-net nic,vlan=1,macaddr=00:e0:4c:bd:64:ca \
	-net tap,vlan=1,ifname=tap0,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown \
	-name "dodol" 
}

#----------------------------------------------------------
function _run_budu() {
    ${QEMU32} \
	-hda ${BASEDIR}/${DIFFIMGDIR}/fedora14.budu.qcow2 \
	-cdrom ${ISODIR}/Fedora-14-i386-disc1.iso \
	-boot c \
	-vga std \
	-monitor stdio \
	-soundhw es1370 \
	-cpu qemu32 \
	-m 256 \
	-no-reboot \
	-localtime \
	-net nic,vlan=0,macaddr=00:83:39:5b:94:ea \
	-net tap,vlan=0,ifname=tap15,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown \
	-name "budu" 

	exit $?
}

#----------------------------------------------------------
function _run_cendol() {
    ${QEMU} \
	-hda ${BASEDIR}/${DIFFIMGDIR}/fedora14.cendol.qcow2.img \
	-cdrom ${ISODIR}/Fedora-14-i386-disc1.iso \
	-boot c \
	-vga std \
	-monitor stdio \
	-soundhw es1370 \
	-m 256 \
	-localtime \
	-net nic,vlan=1 \
	-net tap,vlan=1,ifname=tap3,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown \
	-name "cendol" 
}

#----------------------------------------------------------
# move 
#   mnajib.dyndns.org 
# from
#   (64-bit cpu; windows 32-bits host; virtualbox ubuntu_server 64-bits guest) 
# to 
#   (32-bit cpu; ubuntu 32-bits host; qemu ubuntu_server 64-bits guest)
#
#	TODO:
# Check hostname!
# ip address: 192.168.1.3
# ssh port: 1982
function _run_lengkuas() {
	${QEMU64} \
	-hda ${BASEDIR}/${DIFFIMGDIR}/Ubuntu_Server.lengkuas.vdi \
	-boot ${BOOTHD} \
	-cpu qemu64 \
	-no-reboot \
	-vga std \
	-monitor stdio \
	-soundhw es1370 \
	-m 256 \
	-localtime \
	-net nic,vlan=0,macaddr=00:e0:4c:bd:64:bb \
	-net tap,vlan=0,ifname=tap12,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown \
	-name "Ubuntu_Server.lengkuas" 

	exit
}

# -nographic -monitor null -serial null 
# -vnc 127.0.0.1:1 -usbdevice tablet -k en-us -daemonize
# vncviewer 127.0.0.1:5901
function _run_lengkuasvnc() {
	${QEMU64} \
	-hda ${BASEDIR}/${DIFFIMGDIR}/Ubuntu_Server.lengkuas.vdi \
	-boot ${BOOTHD} \
	-cpu qemu64 \
	-no-reboot \
	-soundhw es1370 \
	-m 256 \
	-localtime \
	-vga std \
	-monitor stdio \
	-vnc :1 -usbdevice tablet -k en-us \
	-net nic,vlan=0,macaddr=00:e0:4c:bd:64:bb \
	-net tap,vlan=0,ifname=tap12,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown \
	-name "Ubuntu_Server.lengkuas" 

	exit
}

_run_lengkuasvde() {
	#local README="${BASEDIR}/doc/Ubuntu_server.lengkuas.vdi.txt"
	echo "README: ${BASEDIR}/doc/Ubuntu_server.lengkuas.vdi.txt"

		#-cpu qemu64 -no-reboot -soundhw es1370 -localtime \
		#-net nic,vlan=0,macaddr=00:e0:4c:bd:64:bb,model=rtl1839 \
		#-enable-kvm \
		#-net nic,vlan=0,macaddr=00:e0:4c:bd:64:bb,model=rtl8139 \
	#${QEMU32} \
	#-monitor stdio -vga std \
	#-soundhw es1370 \
	#${QEMU64} \
#		-monitor telnet:127.0.0.1:9221,server,nowait
		#-vga cirrus \
		#-vnc :1 -usbdevice tablet -k en-us \
	#vdeq kvm \
#xtightvncviewer :2 &
		#-m 256 \
	#/opt/qemu/bin/qemu-system-x86_64 \
		#-snapshot \
	${QEMU64} \
		-enable-kvm \
		-monitor stdio \
		-vnc :2 -usbdevice tablet -k en-us \
		-cpu qemu64 \
		-m 512 \
		-hda ${BASEDIR}/${DIFFIMGDIR}/Ubuntu_Server.lengkuas.vdi \
		-hdb ${BASEDIR}/${BASEIMGDIR}/Ubuntu_Server.lengkuas.diskforswap.raw \
		-hdc ${BASEDIR}/${DIFFIMGDIR}/Ubuntu_Server.lengkuas.disk2.qcow2 \
		-boot ${harddisk} \
		-no-reboot -localtime \
		-net nic,macaddr=00:e0:4c:bd:64:bb,model=rtl8139 \
		-net vde,sock=/tmp/vde0 \
		-name "lengkuas"

	exit
}

#----------------------------------------------------------
		#-cdrom ${ISODIR}/FreeBSD-8.1-RELEASE-i386-disc1.iso \
		#-hda ${BASEDIR}/${BASEIMGDIR}/freebsd-8.2.base.qcow2 \
		#-hda ${BASEDIR}/${DIFFIMGDIR}/freebsd-8.2.bingka.qcow2 \
		#-hda ${BASEDIR}/${BASEIMGDIR}/freebsd-8.2.base-v0.1.qcow2 \
function _run_bingka() {
	${QEMU32} \
		-hda ${BASEDIR}/${DIFFIMGDIR}/freebsd-8.2.bingka.qcow2 \
		-cdrom ${ISODIR3}/_freebsd-8.2/FreeBSD-8.2-RELEASE-i386-disc1.iso \
		-boot ${BOOTHD} \
		-vga std \
		-monitor stdio \
		-soundhw es1370 \
		-m 256 \
		-no-reboot \
		-cpu qemu32 \
		-localtime \
		-net nic,vlan=0,macaddr=00:e0:4c:bd:64:ba \
		-net tap,vlan=0,ifname=tap8,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown \
		-name "bingka"
}

		#-net nic,macaddr=00:e0:4c:bd:64:ba,model=e1000 \
function _run_bingkavde() {
	echo "README: ${BASEDIR}/doc/freebsd-8.2.bingka.qcow2.txt"

	${QEMU32} \
		-hda ${BASEDIR}/${DIFFIMGDIR}/freebsd-8.2.bingka.qcow2 \
		-boot ${harddisk} \
		-cpu qemu32 -no-reboot -soundhw es1370 -localtime \
		-monitor stdio -vga std \
		-m 256 \
		-net nic,macaddr=00:e0:4c:bd:64:ba,model=rtl8139 \
		-net vde,sock=/tmp/vde0 \
		-name "freebsd-8.2.bingka" 

	exit
}

#----------------------------------------------------------
_run_cencalokvde() {
	echo "README: ${BASEDIR}/doc/freebsd....cencalok.vdi.txt"

	/opt/qemu/bin/qemu-system-x86_64 \
		-cpu qemu64 \
		-snapshot \
		-enable-kvm \
		-monitor stdio \
		-vnc :3 -usbdevice tablet -k en-us \
		-hda ${BASEDIR}/${DIFFIMGDIR}/.vdi \
		-boot ${harddisk} \
		-no-reboot -localtime \
		-m 256 \
		-net nic,macaddr=00:e0:4c:bd:64:cb,model=rtl8139 \
		-net vde,sock=/tmp/vde0 \
		-name "cencalok"

	exit
}

#----------------------------------------------------------
_run_bahulu() {
  echo "README: ${BASEDIR}/doc/archlinux.bahulu.vdi.txt"

  #-loadvm aqemu_save \
  #-hda ${BASEDIR}/${BASEIMGDIR}/archlinux.base.qcow2.img \
  #-snapshot \
/opt/qemu/bin/qemu-system-x86_64 \
  -enable-kvm \
  -monitor stdio \
  -vnc :4 -usbdevice tablet -k en-us \
  -cpu qemu64 \
  -m 512 \
  -hda ${BASEDIR}/${DIFFIMGDIR}/archlinux.bahulu.qcow2.img \
  -boot ${harddisk} \
  -no-reboot -localtime \
  -net nic,macaddr=00:e0:4c:bd:64:cc,model=rtl8139 \
  -net vde,sock=/tmp/vde0 \
  -name "bahulu"

  exit
}

#----------------------------------------------------------
_run_asamkeping() {
  echo "README: ${BASEDIR}/doc/archlinux.asamkeping.vdi.txt"

  #-loadvm aqemu_save \
  #-hda ${BASEDIR}/${BASEIMGDIR}/archlinux-x86_64.base.qcow2 \
  #-hda ${BASEDIR}/${BASEIMGDIR}/archlinux-x86_64.base-v0.2.qcow2 \
  #-hda ${BASEDIR}/${DIFFIMGDIR}/archlinux-x86_64.asamkeping.qcow2 \
  #-snapshot \
#/opt/qemu/bin/qemu-system-x86_64 \
  #-cdrom ${ISODIR2}/archlinux-2010.05-netinstall-x86_64.iso \
${QEMU64} \
  -enable-kvm \
  -monitor stdio \
  -vnc :5 -usbdevice tablet -k en-us \
  -cpu qemu64 \
  -m 512 \
  -hda ${BASEDIR}/${BASEIMGDIR}/archlinux-x86_64.base-v0.2.qcow2 \
  -boot ${harddisk} \
  -no-reboot -localtime \
  -net nic,macaddr=00:e0:4c:bd:64:cd,model=rtl8139 \
  -net vde,sock=/tmp/vde0 \
  -name "asamkeping"

  exit
}

#----------------------------------------------------------
function _run_tempoyak() {
	${QEMU32} \
		-hda ${BASEDIR}/${DIFFIMGDIR}/freebsd-8.2.tempoyak.qcow2 \
		-cdrom ${ISODIR3}/_freebsd-8.2/FreeBSD-8.2-RELEASE-i386-disc1.iso \
		-boot ${BOOTHD} \
		-cpu qemu32 \
		-no-reboot \
		-monitor stdio \
		-soundhw es1370 \
		-vga std \
		-m 256 \
		-localtime \
		-net nic,vlan=0,macaddr=00:e0:4c:bd:64:bd \
		-net tap,vlan=0,ifname=tap17,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown \
		-name "tempoyak"
}

#----------------------------------------------------------
function _run_belacan() {
	${QEMU32} \
		-hda ${BASEDIR}/${DIFFIMGDIR}/freebsd-8.2.belacan.qcow2 \
		-cdrom ${ISODIR3}/_freebsd-8.2/FreeBSD-8.2-RELEASE-i386-disc1.iso \
		-boot ${BOOTHD} \
		-cpu qemu32 \
		-no-reboot \
		-monitor stdio \
		-soundhw es1370 \
		-vga std \
		-m 256 \
		-localtime \
		-net nic,vlan=0,macaddr=00:e0:4c:bd:64:be \
		-net tap,vlan=0,ifname=tap18,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown \
		-name "belacan"
}
	#${QEMU32VDE} \
		#-cdrom ${ISODIR3}/_freebsd-8.2/FreeBSD-8.2-RELEASE-i386-disc1.iso \
_run_belacanvde() {
	echo "README: ${BASEDIR}/doc/freebsd-8.2.belacan.qcow2.txt"

	${QEMU32} \
		-snapshot \
		-hda ${BASEDIR}/${DIFFIMGDIR}/freebsd-8.2.belacan.qcow2 \
		-boot ${harddisk} \
		-cpu qemu32 -no-reboot -soundhw es1370 -localtime \
		-monitor stdio -vga std \
		-m 256 \
		-net nic,macaddr=00:e0:4c:bd:64:be,model=rtl8139 \
		-net vde,sock=/tmp/vde0 \
		-name "belacan" 

	exit
}

#----------------------------------------------------------
		#-hda ${BASEDIR}/${DIFFIMGDIR}/freebsd-8.2.belacan.qcow2 \
_run_kelapavde() {
	echo "README: ${BASEDIR}/doc/ubuntu-11.04-server.kelapa.qcow2.txt"

		#-net nic,macaddr=00:e0:4c:bd:a1:aa,model=rtl8139 \
	${QEMU32} \
		-hda ${BASEDIR}/${BASEIMGDIR}/ubuntu-11.04-server.kelapa.qcow2 \
		-cdrom ${ISODIR}/ubuntu-11.04-server-i386.iso \
		-boot ${cdrom} \
		-cpu qemu32 -no-reboot -soundhw es1370 -localtime \
		-monitor stdio -vga std \
		-m 256 \
		-net nic,macaddr=00:e0:4c:bd:64:bf,model=rtl8139 \
		-net vde,sock=/tmp/vde0 \
		-name "kelapa" &

	exit
}

#----------------------------------------------------------
_run_amandavde() {
	echo "README: ${BASEDIR}/doc/fedora14.amanda.qcow2.txt"

	        #-snapshot \
		#-m 512 \
                #-soundhw es1370 
		#-vga std \
	${QEMU32} \
	        -snapshot \
		-enable-kvm \
		-monitor stdio \
		-vnc :3 -usbdevice tablet -k en-us \
		-cpu qemu32 \
		-m 256 \
		-hda ${BASEDIR}/${DIFFIMGDIR}/fedora14.amanda.qcow2 \
		-boot ${harddisk} \
		-no-reboot -localtime \
		-net nic,macaddr=00:e0:4c:bd:64:ce,model=rtl8139 \
		-net vde,sock=/tmp/vde0 \
		-name "amanda" &
	exit
}

#----------------------------------------------------------
function _run_perahu() {
	${QEMU32} \
		-hda ${BASEDIR}/${DIFFIMGDIR}/gobolinux.perahu.qcow2 \
		-cdrom ${ISODIR}/GoboLinux-014.01-i686.iso \
		-boot ${BOOTHD} \
		-cpu qemu32 \
		-no-reboot \
		-monitor stdio \
		-soundhw es1370 \
		-vga std \
		-m 256 \
		-localtime \
		-net nic,vlan=0,macaddr=00:e0:4c:bd:64:bc \
		-net tap,vlan=0,ifname=tap6,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown \
		-name "perahu"

	#${QEMU32} -cpu qemu32 -monitor stdio -soundhw es1370 -vga std -m 256 -localtime -cdrom ${ISODIR}/GoboLinux-014.01-i686.iso -hda ${BASEDIR}/${DIFFIMGDIR}/gobolinux.perahu.qcow2 -boot ${BOOTHD} -net nic,vlan=0,macaddr=00:e0:4c:bd:64:bc -net tap,vlan=0,ifname=tap5,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown -name "perahu"
	#qemu -cpu qemu32 -monitor stdio -soundhw es1370 -vga std -m 256 -localtime -cdrom /mnt/c/DATA/_iso/GoboLinux-014.01-i686.iso -hda /mnt/data/DATA/_master/_vm/_qemu/img/diff/gobolinux.perahu.qcow2 -boot c -net nic,vlan0,macaddr=00:e0:4d:bd:64:bc -net tap,vlan=0,ifname=tap5,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown -name "perahu"
	#qemu -cpu qemu32 -monitor stdio -soundhw es1370 -vga std -m 256 -localtime -cdrom /mnt/c/DATA/_iso/GoboLinux-014.01-i686.iso -hda /mnt/data/DATA/_master/_vm/_qemu/img/diff/gobolinux.perahu.qcow2 -boot c -net nic,macaddr=00:e0:4d:bd:64:bc -net tap,ifname=tap5,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown -name "perahu"

	exit
}

#----------------------------------------------------------
function _run_lempok() {
    ${QEMU} \
	-hda ${BASEDIR}/${DIFFIMGDIR}/fedora14.lempok.qcow2.img \
	-cdrom ${ISODIR}/Fedora-14-i386-disc1.iso \
	-boot ${BOOTHD} \
	-monitor stdio \
	-soundhw es1370 \
	-vga std \
	-m 256 \
	-localtime \
	-net nic,vlan=1 \
	-net tap,vlan=1,ifname=tap4,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown \
	-name "lempok" 
}


#----------------------------------------------------------
# http://alien.slackbook.org/dokuwiki/doku.php?id=slackware:qemu
_runTestWinXP() {
	#!/bin/sh
	#
	# Start Windows XP Pro in QEMU using VDE for better network support
	 
	PARAMS=$*
	 
	# Qemu can use SDL sound instead of the default OSS
	export QEMU_AUDIO_DRV=sdl
	 
	# Whereas SDL can play through alsa:
	export SDL_AUDIODRIVER=alsa
	 
	# Change this to the directory where _you_ keep your QEMU images:
	IMAGEDIR=/home/alien/QEMU
	 
	# Change this to the directory where _you_ keep your installation CDROM's ISO images:
	ISODIR=/home/alien/ISOS
	 
	# Now, change directory to your image directory
	cd $IMAGEDIR
	 
	# If you want to boot from the WinXP CD add a '-boot d' parameter to the commandline;
	#   if you don't need the CDROM present in the VM, leave '-cdrom ${ISODIR}/winxp_pro_us.iso' out:
	# I made the MAC address up - make sure it is unique on your (virtual) network.
	 
	# This command returns to the command prompt immediately,
	#   and QEMU's error output is redirected to files.
	vdeqemu -net vde,vlan=0 -net nic,vlan=0 -m 256 -localtime -soundhw all -hda winxp.img -cdrom ${ISODIR}/winxp_pro_us.iso  1>winxp.log 2>winxp.err ${PARAMS} &
}

# Create tun-tap device?
_createTun() {
	modprobe tun

	mkdir /dev/net
	mknod /dev/net/tun c 10 200
	chmod 660 /dev/net/tun
}

#----------------------------------------------------------
function _runInTempTestMode() {
  # TODO: run in temporary snapshot mode, not save/update the disk image.
  # the image will be back untouch after reboot

  macaddress=""

  #sudo env TMPDIR=/var/whatever qemu
  #
  # OR
  # To run the qumu as root user with env variable TMPDIR=
  # The default qemu TMPDIR="/tmp"; was hardcoded in block.c
  #su -
  TMPDIR=/mnt/data \
	${QEMU} \
	-snapshot \
	-hda ${BASEDIR}/${DIFFIMGDIR}/fedora14.dodol.qcow2.img \
	-cdrom ${ISODIR}/Fedora-14-i386-disc1.iso \
	-boot c \
	-monitor stdio \
	-soundhw es1370 \
	-vga std \
	-m 256 \
	-localtime \
	-net nic,vlan=0 \
	-net tap,vlan=0,ifname=tap0,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown \
	-name "dodol-TEMPSNAPSHOT" 
  #...
}

#----------------------------------------------------------
_runNoMon() {
	echo "no monitor display, but with vnc service"
	# TODO: ...

}

#----------------------------------------------------------

#run_base # run for first install only! <----- !!! WARNING !!!
#_startvdenet # should only run once!
#_stopvdenet 	# should only run once!
#_run_lengkuas
#_run_lengkuasvnc
#_run_dodol
#_run_cendol
#_run_lempok
#_run_budu
#_run_bingka
#_run_bingkavde
#_run_tempoyak
#_run_belacan
#_run_belacanvde
#_run_perahu

#----------------------------------------------------------

_printHost() {
	echo "HOSTNAME := [ vdeswitch | lengkuas | belacan | bingka | kelapa | bahulu | asamkeping | amanda ]"
}

_printUsage2() {
	echo "Usage: qemu.sh start HOSTNAME"
	_printHost
}

_pUsageInfo() {
	echo "Usage: qemu.sh info HOSTNAME"
	_printHost
}

_menuInfo() {
	local svrname=$1

	case $svrname in
		vdeswitch)
			echo "vdeswitch: virtual network switch/router/bridge/..."
			;;
		lengkuas)
			echo "lengkuas: ubuntu server running web/blog mnajib.dyndns.org"
			;;
		amanda)
			echo "amanda: fedora14 32bit - for test amanda backup software"
			;;
		#all)
		#	vdeswitch
		#	lengkuas
		#	;;
		help)
			_pUsageInfo
			;;
		'')		
			_pUsageInfo
			;;
		*)		
                        echo "Object \"$svrname\" is unknown, try \"qemu.sh info help\"."
			exit 1
			;;
	esac
}

_main4() {
	local $svrname=$1

	case $svrname in
		vdeswitch)
				_stopvdenet
				;;
		'')		
				echo "error"
				;;
		*)		echo "error"
				exit 1
				;;
	esac
}

_main2() {
  local svrname=$1

  case $svrname in
    vdeswitch)	        _startvdenet;;		# 
    lengkuas)		_run_lengkuasvde;; 	# ubuntu server: wordpress
    belacan) 		_run_belacanvde;;	# freebsd: version control
    bingka)		_run_bingkavde;;	# freebsd: 
    kelapa)		_run_kelapavde;;	# kelapa: chat server; ircd, sshd, ... 
    cencalok)
			#_run_cencalokvde 	# freebsd: dns for subdomain _.najib.magnifix.com.my
                        echo "TODO: ..."
                        ;;				
    bahulu)		_run_bahulu;; 		# archlinux x386: dns for subdomain _.najib.magnifix.com.my
    asamkeping)		_run_asamkeping;;	# archlinux x86_64: dns for subdomain _.najib.magnifix.com.my
    amanda)		_run_amandavde;;        # 
    help)
                        ;;
    '')					
                        _printUsage2
                        ;;
    *) 					
                        echo "Object \"$svrname\" is unknown, try \"qemu.sh start help\"."
                        exit 1
  esac
}

_printUsage() {
  #echo $"Usage: $0 {start|status} <hostname>"
  #echo "Usage: $0 {start|status} <hostname>"
  echo "Usage: qemu.sh { start | status | info } HOSTNAME"
  _printHost
}

_main3() {
  case $1 in
		start)			
								#echo "_main3: Will do 'start $2'"
								_main2 $2
								;;
		stop)			
								_main4 $2
								;;
		status)
								echo "\"qemu.sh status\" not implemented yet."
								;;
		help)
								_printUsage
								;;
		info)
								_menuInfo $2
								;;
		'')					
								_printUsage
								;;
		*)					
								#echo "_main3: Function not implemented."
								echo "Object \"$1\" is unknown, try \"qemu.sh help\"."
								#_printUsage
								exit 1
  esac
}

#if [ $# -lt 2 ]; then
#	echo "need 2 parameter"
#  _printUsage
#	exit 1
#	echo "" > /dev/null
#elif [ $# -gt 2 ]; then
#	echo "need only 2 parameter"
#	_printUsage
#	exit 1
#fi

_main3 $1 $2

exit 0
