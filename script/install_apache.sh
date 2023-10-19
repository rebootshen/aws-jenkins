#!/bin/bash

sudo apt update -y
sudo apt install -y apache2 git
sudo ufw allow 'Apache'

sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl status apache2


sudo rm -rf /var/www/html
sudo git clone https://github.com/rebootshen/aws-jenkins.git /var/www/html/
cd /var/www/html/
sudo git checkout static

hh=$(hostname -f)
sudo sed -i "s/HOSTNAME/$hh/g" /var/www/html/index.html 
sudo mkdir -p /var/www/html/test
echo "Hello World from $(hostname -f)" > /var/www/html/test/index.html

#This is installing a java implementation
sudo apt-get install openjdk-11-jre -y
#Adds the jenkins repository
sudo curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
sudo echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install fontconfig openjdk-11-jre -y
#These commands install Jenkins
sudo apt-get install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins