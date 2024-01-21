#!/bin/bash

log() {
    message="$(date) - $1"
    echo "$message" >> /var/log/barista_cafe_logs/teardown.log
    echo "$message"
}


log "*****Starting teardown...*****"


# checking for root user
log "*****Checking for root user access*****"
if [ $EUID -ne 0 ]
    then
        log "Warning: Warning: Current user is not root user. Please run the script as root user or use sudo."
fi


# checking for package manager
log "*****Checking for package manager*****"
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


# stopping the web-service
log "*****Stopping $service*****"
if ! sudo systemctl stop $service
    then
        log "Error: Unable to stop $service"
else
    log "Successfully stopped $service"
fi


# removing installed packages
log "*****Removing installed packages*****"
if ! sudo $pkg_manager remove $packages -y
    then
        log "Error: Unable to remove packages: $packages"
        exit 1
else
    log "Packages removed successfully"
fi


# creating variables
temp_folder="/temp/barista_cafe"
target_folder="/var/www/html"
artifact="2137_barista_cafe"


# removing downloaded web files
log "*****Deleting web files*****"
if ! sudo rm -rf $temp_folder
    then
        log "Error: Unable to delete folder $temp_folder"
        exit 1
else
    log "Successfully deleted $temp_folder"
fi


# removing web files at location /var/www/html
log "*****Deleting web files*****"
if ! sudo rm -rf $target_folder
    then
        log "Error: Unable to delete folder $target_folder"
        exit 1
else
    log "Successfully deleted $target_folder"
fi


log "Teardown completed successfully!" 





