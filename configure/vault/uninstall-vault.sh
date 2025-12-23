sudo systemctl stop vault
sudo systemctl disable vault
sudo dnf remove -y vault
sudo rm -rf /etc/vault.d
sudo rm -rf /var/lib/vault
sudo rm -f /usr/bin/vault
sudo rm -f /etc/systemd/system/vault.service
sudo systemctl daemon-reload
