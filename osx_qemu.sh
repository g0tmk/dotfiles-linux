#!/usr/bin/env bash

# Start an install of a osx mojave VM in qemu
#
# Guides:
#  - OSX Mojave in QEMU: https://github.com/kholia/OSX-KVM
#  - Build QEMU: https://wiki.qemu.org/Hosts/Linux#Building_QEMU_for_Linux
# debian 9.9 expected but will work elsewhere with small tweaks

# exit on errors, even if inside pipes, and treat unset vars as errors
set -eEuo pipefail


WORKING_DIR="${HOME}/.qemu"  # where to install qemu, OSX-QEMU repository, and osx iso

QEMU_VERSION_TO_INSTALL="2.12.1"  # NOTE: should be >= 2.11 if following the above OSX guide
#QEMU_VERSION_TO_INSTALL="4.0.0"  # NOTE: should be >= 2.11 if following the above OSX guide
QEMU_BUILD_WITH_DEBUG="true"  # set to false to use release instead of debug qemu
QEMU_BINARY_NAME="qemu-system-x86_64"  # probably the same for all versions

OSX_VM_HDD_SIZE="64G"

if $QEMU_BUILD_WITH_DEBUG; then
    QEMU_BUILD_SUBTREE="bin/debug/native"
    QEMU_CONFIGURE_FLAGS="--enable-debug"
else
    QEMU_BUILD_SUBTREE="bin/release/native"
    QEMU_CONFIGURE_FLAGS=""
fi
QEMU_ABSOLUTE_PATH="${WORKING_DIR}/qemu-${QEMU_VERSION_TO_INSTALL}/${QEMU_BUILD_SUBTREE}/x86_64-softmmu/${QEMU_BINARY_NAME}"

install_prereqs() {
    # QEMU build dependencies
    sudo apt install -y git build-essential libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev
    # optional dependencies; not sure which features are needed so install them all
    sudo apt install -y libaio-dev libbz2-dev libcap-dev libcap-ng-dev libcurl4-gnutls-dev libgtk-3-dev libncurses5-dev libnuma-dev libsasl2-dev libsdl1.2-dev libseccomp-dev libsnappy-dev libssh2-1-dev libvde-dev libvdeplug-dev libvte-2.91-dev libxen-dev liblzo2-dev xfslibs-dev libnfs-dev libiscsi-dev
    # optional qemu dependency: spice - allows for `qemu -vga qxl`
    sudo apt install -y libspice-protocol-dev libspice-server-dev
    # optional dependencies not available on debian 9.9:
    # sudo apt install -y libjpeg8-dev

    # install modules used by osx setup
    sudo apt install -y dmg2img wget git virt-manager
    # dependencies listed in the guide but I saw no need for them
    # sudo apt install -y uml-utilities
}

download_qemu() {
    mkdir -p "$WORKING_DIR"
    cd "$WORKING_DIR"

    if ls "qemu-${QEMU_VERSION_TO_INSTALL}" > /dev/null; then
        # if qemu folder exists, skip this function
        return
    fi

    wget "https://download.qemu.org/qemu-${QEMU_VERSION_TO_INSTALL}.tar.xz"
    tar xJf "qemu-${QEMU_VERSION_TO_INSTALL}.tar.xz"
}

compile_qemu() {
    mkdir -p "$WORKING_DIR"
    cd "$WORKING_DIR"
    if ls "$QEMU_ABSOLUTE_PATH" > /dev/null; then
        # if built binary exists, skip steps in this function
        return
    fi

    echo "Installng QEMU to $WORKING_DIR"
    cd "qemu-${QEMU_VERSION_TO_INSTALL}"
    mkdir -p "$QEMU_BUILD_SUBTREE"
    cd "$QEMU_BUILD_SUBTREE"
    # Configure QEMU for x86_64 only - faster build
    # --enable-spice to build with spice to allow `-vga qxl`
    ../../../configure --enable-spice --target-list=x86_64-softmmu "$QEMU_CONFIGURE_FLAGS"
    make
    cd ../../..
}

test_qemu() {
    read -p "Hit <ENTER> to open QEMU to BIOS as a test. Close when satisfied everything works." -n 1 -r
    "$QEMU_ABSOLUTE_PATH" -L pc-bios
}

check_fix_no_default_network_issue() {
    # this checks virsh and verifies there is a default network - if not, it
    # makes one. I don't think the uuid or MAC address are particularly important
    # since multiple guides online exist and they use different values. I used this:
    # https://gist.github.com/archerslaw/9523b3857a2553a4f84a

    if virsh net-list --all | grep default; then
        # exit if network already exists
        return
    else
        echo "Adding virsh network..."

        virsh net-define /dev/stdin <<EOF
<network connections='1'>
  <name>default</name>
  <uuid>18bb3790-11ee-41b1-8847-970590a06e4d</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0' />
  <mac address='52:54:00:F6:C8:DE'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254' />
    </dhcp>
  </ip>
</network>
EOF

    fi
}


create_osx_install_files() {
    # guide: https://github.com/kholia/OSX-KVM/blob/master/README.md

    # if output img exists, skip this function
    if ls "$WORKING_DIR/OSX-KVM/mac_hdd_ng.img"; then
        return
    fi

    # ignore MSRs and make the change permanent
    echo 1 | sudo tee /sys/module/kvm/parameters/ignore_msrs
    if ! grep "ignore_msrs" /etc/modprobe.d/kvm.conf; then
        echo "options kvm ignore_msrs=1" | sudo tee -a /etc/modprobe.d/kvm.conf
    fi

    # clone OSX-KVM repo and use it to fetch OSX ISO
    mkdir -p "$WORKING_DIR"
    cd "$WORKING_DIR"
    # ignore git failures since I don't want to exit if repo already exists
    git clone https://github.com/kholia/OSX-KVM.git || true
    cd OSX-KVM

    #echo "\nShowing available OSX ISOs (EDIT: install stuck at 2 mins remain?)I just picked newest (10.14.5 build 18F203))"
    echo "\nShowing available OSX ISOs (I picked (10.14.4 build 18E2034))"
    rm BaseSystem.dmg BaseSystem.img || true
    ./fetch-macOS.py
    dmg2img BaseSystem.dmg BaseSystem.img

    # setup new VM
    qemu-img create -f qcow2 mac_hdd_ng.img "$OSX_VM_HDD_SIZE"
}

start_osx() {
    # configure networking so VM can connect to internet

    # if no tap0 network then add it
    if ! ip tuntap show | grep tap0; then
        sudo ip tuntap add dev tap0 mode tap
    fi
    sudo ip link set tap0 up promisc on

    # if no 'default' virsh network, then add one
    check_fix_no_default_network_issue

    # start 'default' virsh network if it isn't already
    if sudo virsh net-info default | grep Active | grep no; then
        sudo virsh net-start default
    fi
    sudo virsh net-autostart default
    sudo ip link set dev virbr0 up
    sudo ip link set dev tap0 master virbr0

    # since debian installed 'stable' qemu when I installed dependencies, the qemu in
    # PATH is not new enough. Create a new script which uses an absolute path to the 
    # built qemu.
    cd "$WORKING_DIR"/OSX-KVM
    sed "s:qemu-system-x86_64:${QEMU_ABSOLUTE_PATH}:" ./boot-macOS-NG.sh > ./boot-macOS-NG-absolutepath.sh
    chmod +x ./boot-macOS-NG-absolutepath.sh
    sed "s:-monitor stdio:-monitor stdio -vga qxl:" ./boot-macOS-NG-absolutepath.sh > ./boot-macOS-NG-qxl.sh
    chmod +x ./boot-macOS-NG-qxl.sh
    # do itt
    echo -e "\nFirst-time boot/OSX install guide:
    - The system will boot into recovery mode
    - Choose Language
    - Click Disk Utility
    - Select the largest partition (labeled 'QEMU HARDDISK Media' for me)
    - Click 'Erase' and fill in:
      - Name: Mac HD
      - Format: Mac OS Extended (Journaled)
      - Scheme: GUID Partition Map
      - and hit Erase
    - Close Disk Utility
    - The following step is from the guide, but it did not work for me since /Extra did not exist. If it happens to you, idk, skip it probably.
    - Go to Utilities > Terminal and type 'cp -av /Extra /Volumes/Mac HD/'
    - Select 'Reinstall macOS' and select Mac HD. The installer will download about
      3 GB and take ~45 minutes before booting automatically into OSX.
How to change resolution (doesn't actually do anything for me):
      - Boot the system. *BEFORE* you see the Clover bootloader, hit Escape to get to OMVF.
      - Select 'Device Manager' then 'OMVF Platform Configuration'
      - Select a new resolution
      - Save and exit
\n"
    ./boot-macOS-NG-absolutepath.sh
    # use QXL (uses spice protocol), which people on reddit said would allow for
    # changing resolutions (it didn't)
    #./boot-macOS-NG-qxl.sh
}

install_prereqs
download_qemu
compile_qemu
#test_qemu
create_osx_install_files
start_osx


