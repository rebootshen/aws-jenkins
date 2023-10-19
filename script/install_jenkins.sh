#!/bin/bash
#Updates the EC2 Instance
sudo apt-get update -y
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