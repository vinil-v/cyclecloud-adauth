#!/bin/sh
#automating SSH key creation and passwordless configuration
cat <<EOF >/etc/profile.d/gen_sshkey.sh
#!/bin/sh
if [ ! -f  ~/.ssh/id_rsa.pub ] ; then
        ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
        cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
        chmod 644 ~/.ssh/authorized_keys
fi
EOF
chmod +x /etc/profile.d/gen_sshkey.sh
