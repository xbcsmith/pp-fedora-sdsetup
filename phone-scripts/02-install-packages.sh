#!/bin/bash
set -e

echo "==================="
echo "02-install-packages.sh"
echo "==================="

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo "[Error] $1" 1>&2
    exit 1
}

infecho "This adds my COPR repository (njha/mobile) and installs phone related packages."
infecho "Only functional on Fedora Rawhide."
infecho "HEAVY WIP, untested"

infecho "Enabling COPR repository..."
dnf copr enable njha/mobile

infecho "Removing old kernel..."
infecho "THIS WILL FAIL, DON'T WORRY ITS PROBABLY OK"
dnf remove kernel || rpm -e --noscripts kernel-core
dnf install linux-firmware

infecho "Installing kernel..."
dnf --disablerepo="*" --enablerepo="copr:copr.fedorainfracloud.org:njha:mobile" install kernel

infecho "Installing recommended packages..."
dnf install feedbackd phoc phosh squeekboard gnome-shell ModemManager rtl8723cs-firmware \
    f2fs-tools chatty calls carbons purple-mm-sms pinephone-helpers evolution-data-server \
    f32-backgrounds-gnome kgx epiphany gnome-contacts evolution cheese NetworkManager-wwan \
    lightdm-mobile-greeter

infecho "Enabling graphical boot and lightdm..."
systemctl disable initial-setup.service
systemctl enable lightdm
systemctl set-default graphical.target

infecho "Making COPR higher priority for kernel updates..."
echo "priority=10" >> /etc/yum.repos.d/_copr\:copr.fedorainfracloud.org\:njha\:mobile.repo

infecho "Upgrading packages..."
dnf update
