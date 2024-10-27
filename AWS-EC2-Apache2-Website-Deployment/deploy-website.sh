#!/bin/bash -e

# Updating the package list
sudo apt update -y

# Installing the package Apache2, Wget and Unzip
sudo apt install apache2 wget unzip -y

# Downloading the website files 
wget https://templatemo.com/download/templatemo_579_cyborg_gaming

# Changing the file name
mv templatemo_579_cyborg_gaming templatemo_579_cyborg_gaming.zip

# Unzipping the file
unzip templatemo_579_cyborg_gaming.zip

# Moving all the files to apache root folder 
sudo mv templatemo_579_cyborg_gaming/* /var/www/html/

# Restarting the Apache2 server
sudo systemctl restart apache2
