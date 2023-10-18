#!/bin/bash
sudo apt update
sudo apt install -y apache2
sudo ufw allow 'Apache'
sudo systemctl start apache2
sudo chown -R $USER:$USER /var/www
echo "Hello World from EC2" > /var/www/html/index.html
