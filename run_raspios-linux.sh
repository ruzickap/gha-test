#!/usr/bin/env bash

set -euxo pipefail

DEVICE="sdb"

wget -c https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2023-05-03/2023-05-03-raspios-bullseye-arm64-lite.img.xz

cat > owner.txt << EOF
Petr Ruzicka

petr.ruzicka@gmail.com

Czech Republic
EOF

lsblk --output NAME,MODEL,MODEL | grep ${DEVICE}

umount /run/media/liveuser/boot /run/media/liveuser/rootfs || true

read -r -p "Press enter to remove everything from ${DEVICE} !!!"

xzcat ./*raspios*.xz | sudo dd of=/dev/${DEVICE} bs=4M
sudo partprobe /dev/${DEVICE}

MYTMP=$(mktemp --directory)
sudo mount /dev/${DEVICE}1 "${MYTMP}"
sudo touch "${MYTMP}/ssh"
RPI_USER_PASSWORD=$(openssl passwd -6 raspberry)
sudo bash -c "echo \"pi:${RPI_USER_PASSWORD}\" > \"${MYTMP}/userconf.txt\""
sudo cp owner.txt "${MYTMP}/"
sudo umount "${MYTMP}"

sudo mount "/dev/${DEVICE}2" "${MYTMP}"
sudo bash -c "cat >> ${MYTMP}/etc/dhcpcd.conf" << EOF
interface eth0
static ip_address=192.168.1.2/24
static routers=192.168.1.1
static domain_name_servers=1.1.1.1
EOF
sudo cp owner.txt "${MYTMP}/"
sudo umount "${MYTMP}"
