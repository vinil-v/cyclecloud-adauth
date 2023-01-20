#!/bin/sh
#Author : Vinil Vadakkepurakkal
#Integrating AD login for Linux Machines using SSSD.
#OS Tested : CentOS 7 / RHEL7 / Alma Linux 8 / Ubuntu 18.04
#Env - Azure CycleCloud
#define variables for AD
AD_SERVER=$(jetpack config adauth.ad_server)
AD_SERVER_IP=$(jetpack config adauth.ad_server_ip)
AD_DOMAIN=$AD_SERVER
ADMIN_NAME=$(jetpack config adauth.ad_admin_user)
ADMIN_PASSWORD=$(jetpack config adauth.ad_admin_password)

#removing AD server IP incase used in standalone DNS
sed -i '/$AD_SERVER_IP/d' /etc/hosts

#Update the nameserver and host file - for resolving AD server and AD has its own DNS
echo "nameserver ${AD_SERVER}" >> /etc/resolv.conf
echo "${AD_SERVER_IP} ${AD_SERVER}" >> /etc/hosts


#SSH configuration - enabling Password based authentication for login with password
#if you are using key based auth then no changed need. however in this scenario, home dir are created after the user login.
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
#Disabling stricthostkey checking - useful in hpc env.
cat <<EOF >/etc/ssh/ssh_config
Host *
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
EOF

#AD integration starts from here.
delay=15
n=1
max_retry=3

while true; do
logger -s "Domain join on $AD_DOMAIN"
echo $ADMIN_PASSWORD| realm join -U $ADMIN_NAME $AD_DOMAIN

if [ ! -f "/etc/sssd/sssd.conf" ]; then
    if [[ $n -le $max_retry ]]; then
        logger -s "Failed to domain join the server - Attempt $n/$max_retry:"
        sleep $delay
        ((n++))
    else
        logger -s "Failed to domain join the server after $n attempts."
        exit 1
    fi
else
    logger -s "Successfully joined domain $AD_DOMAIN"
    realm list
    break
fi
done

sed -i 's@use_fully_qualified_names.*@use_fully_qualified_names = False@' /etc/sssd/sssd.conf
sed -i 's@ldap_id_mapping.*@ldap_id_mapping = True@' /etc/sssd/sssd.conf
sed -i 's@fallback_homedir.*@fallback_homedir = /shared/home/%u@' /etc/sssd/sssd.conf

systemctl restart sssd
systemctl restart sshd

# Check if we are domain joined
realm list | grep active-directory
if [ $? -eq 1 ]; then
    logger -s "Node $(hostname) is not domain joined"
    exit 1
fi
