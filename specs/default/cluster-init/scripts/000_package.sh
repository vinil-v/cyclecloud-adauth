#!/bin/sh
#Author : Vinil Vadakkepurakkal
#Integrating AD login for Linux Machines using SSSD.
#OS Tested : CentOS 7 / RHEL7 / Alma Linux 8 / Ubuntu 18.04
#Env - Azure CycleCloud
#Installing the required Packages

OS_VER=$(jetpack config platform_family)
case $OS_VER in 
rhel)
    yum clean all
    yum install sssd realmd oddjob oddjob-mkhomedir adcli samba-common samba-common-tools krb5-workstation openldap-clients policycoreutils-python-utils -y
    ;;
debian)
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    sudo -E apt -y -qq install sssd realmd oddjob oddjob-mkhomedir adcli samba-common krb5-user sssd-krb5 ldap-utils policycoreutils-python-utils sssd-tools sssd libnss-sss libpam-sss adcli packagekit -y
    sleep 300
    echo "session required pam_mkhomedir.so" >> /etc/pam.d/common-session
    ;;
esac