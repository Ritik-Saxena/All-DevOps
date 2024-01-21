#!/bin/bash

# Function to log messages to deploy.log file
log() {
        message="$(date) - $1"
        sudo echo "$message" >> /var/log/barista_cafe_logs/deploy.log
        echo "$message"
}


log "*****Starting deployment*****"


# checking if user is root user or not
log "*****Checking for root user access*****"
if [ $EUID -ne 0 ]
  then
        log "Warning: Current user is not root user. Please run the script as root user or use sudo."
fi


# checking if package manager is yum or apt-get
log "*****Checking for the package manager*****"
if command -v yum >> /dev/null
  then
        packages="httpd unzip wget"
        service="httpd"
        pkg_manager="yum"

        log "$pkg_manager package manager found!!!"
elif command -v apt-get >> /dev/null
  then
        packages="apache2 unzip wget"
        service="apache2"
        pkg_manager="apt-get"

        log "$pkg_manager package manager found!!!"
else
        log "Error: Unsupported package manager"
        exit 1
fi


# installing the packages
log "*****Installing the required package*****"
if ! sudo $pkg_manager install $packages -y
  then
        log "Error: Failed to install packages"
        exit 1
else
        log "Packages installed successfully"
fi


# starting and enabling the web service
log "*****Starting and enabling $service*****"
if ! (sudo systemctl start $service && sudo systemctl enable $service)
  then
        log "Error: Failed to start and enable the $service"
        exit 1
else
        log "$service started and enabled successfully"

fi


# creating variables
url="https://www.tooplate.com/zip-templates/2137_barista_cafe.zip"
temp_folder="/temp/barista_cafe"
target_folder="/var/www/html"
artifact="2137_barista_cafe"


# creating folder /temp/barista_cafe
log "*****Creating folder $temp_folder*****"
if ! sudo mkdir -p $temp_folder
  then
        log "Error: Failed to create folder $temp_folder"
        exit 1
else
        log "$temp_folder created successfully"
fi


# navigating to the temp folder
log "*****Navigating to the folder $temp_folder*****"
if ! cd $temp_folder
  then
        log "Error: Failed to navigate to $temp_folder"
        exit 1
else
        log "Navigated to $temp_folder"
fi


# downloading the web files
log "*****Downloading the web files*****"
if ! sudo wget $url
  then
        log "Error: Failed to download the web files from url"
        exit 1
else
        log "Downloaded the web files successfully"
fi


# unzipping the downloaded files
log "*****Unzipping the downlaoded files*****"
if ! sudo unzip -o $artifact.zip
  then
        log "Error: Failed to unzip the web files"
        exit 1
else
        log "Unzipped the web files successfully"
fi


# copying the extracted files to /var/www/html
log "*****Copying the extracted files to $target_folder*****"
if ! sudo cp -r $artifact/* $target_folder
  then
        log "Error: Failed to copy the files to $target_folder"
        exit 1
else
        log "Copied the extracted files to $target_folder successfully"
fi


# printing the files at location /var/www/html
log "*****Printing the files at $target_folder*****"
ls $target_folder


# restarting the web service
log "*****Restarting the $service*****"

if ! sudo systemctl restart $service
  then
        log "Error: Failed to restart the $service"
else
        log "Re-started the $service successfully"
fi


log "Successfully deployed the website"
