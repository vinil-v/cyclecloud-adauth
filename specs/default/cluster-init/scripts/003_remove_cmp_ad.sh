#!/bin/sh
#cleanup computer resources from Activate directory after node terminatation.
cat <<\EOF > /opt/realm_cleanup.sh
#!/bin/sh
ADMIN_NAME=$(/opt/cycle/jetpack/bin/jetpack config adauth.ad_admin_user)
ADMIN_PASSWORD=$(/opt/cycle/jetpack/bin/jetpack config adauth.ad_admin_password)

echo $ADMIN_PASSWORD | realm leave -U $ADMIN_NAME  --remove
EOF

chmod +x /opt/realm_cleanup.sh

cat <<EOF > /etc/systemd/system/realmcleanup-before-shutdown.service
[Unit]
Description=Removing realm before shutdown
DefaultDependencies=no
Before=shutdown.target

[Service]
Type=oneshot
ExecStart=/opt/realm_cleanup.sh
TimeoutStartSec=0

[Install]
WantedBy=shutdown.target
EOF
systemctl daemon-reload
systemctl enable realmcleanup-before-shutdown.service
