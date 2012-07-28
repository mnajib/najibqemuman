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
#

# Qemu Version
QEMUROOT="/usr/bin"
QEMU32="${QEMUROOT}/qemu"
QEMU64="${QEMUROOT}/qemu-system-x86_64"
QEMU=${QEMU32}
#QEMU=${QEMU64}
QEMU32VDE=${QEMU32}
QEMU64VDE=${QEMU64}
#QEMU="qemu-spice"
#QEMU="qemu-kvm"
#QEMU="qemu-kvm-spice"

# Boot device
harddisk="c"
cdrom="d"

BASEDIR="/mnt/data/DATA/vm/qemu"
BASEIMGDIR="img/base"
DIFFIMGDIR="img/diff"

ISODIR="/mnt/data/DATA/iso"
ISODIR2="/home/najib/Downloads"

READMEfile="${BASEDIR}/README.txt"

#----------------------------------------------------------
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

# Create tun-tap device?
_createTun() {
	modprobe tun

	mkdir /dev/net
	mknod /dev/net/tun c 10 200
	chmod 660 /dev/net/tun
}

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
# mac address for model realtec rtl1839 start with 00:E0:4C:
#
# ---------------------------------
#    My Server's MAC Address
# ---------------------------------
# My MAC Address        My Hostname
# -----------------     -----------
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
# ---------------------------------
#
function _random_mac() {
    # TODO: Generate random MAC address
    #...

    echo ""
}

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
# Guest config/start script
#----------------------------------------------------------

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
_run_kelapavde() {
	echo "README: ${BASEDIR}/doc/ubuntu-11.04-server.kelapa.qcow2.txt"

		#-hda ${BASEDIR}/${DIFFIMGDIR}/freebsd-8.2.belacan.qcow2 \
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
_runNoMon() {
	echo "no monitor display, but with vnc service"
	# TODO: ...

}

#----------------------------------------------------------
#run_base     # run for every first install guest only! <----- !!! WARNING !!!
#_startvdenet # should only run once!
#_stopvdenet  # should only run once!
#_run_bingkavde

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
#   ------------------- ----------------------- --------------------------------------------------------------
#   hostname            start script            notes
#   ------------------- ----------------------- --------------------------------------------------------------
    lengkuas)		_run_lengkuasvde;; 	# ubuntu server: wordpress
    belacan) 		_run_belacanvde;;	# freebsd: version control
    bingka)		_run_bingkavde;;	# freebsd: puppet
    kelapa)		_run_kelapavde;;	# kelapa: chat server; ircd, sshd, ... 
    cencalok)
			#_run_cencalokvde 	# freebsd: dns for subdomain ...
                        echo "TODO: ..."
                        ;;				
    bahulu)		_run_bahulu;; 		# archlinux x386: dns for subdomain ...
    asamkeping)		_run_asamkeping;;	# archlinux x86_64: dns for subdomain ...
    amanda)		_run_amandavde;;        # 
#   ------------------- ----------------------- --------------------------------------------------------------
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
