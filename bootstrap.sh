#!/usr/bin/env bash

## Change this to the PS version you'd like to use
PS_VERSION=prestashop_1.7.2.3.zip

## Setup and basic tools
sudo DEBIAN_FRONTEND=noninteractive apt-get update && sudo apt-get upgrade -yq
sudo apt-get install -y unzip

## Apache
sudo apt-get install -y apache2 libapache2-mod-php5
# Enable required mod rewrite
sudo a2enmod rewrite

## MySQL and PHP
echo "mysql-server-5.5 mysql-server/root_password password abc123" | sudo debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again password abc123" | sudo debconf-set-selections
sudo apt-get install -y mysql-server php5-mysql
sudo apt-get install -y php5 php5-mcrypt php5-curl php5-intl
# sudo apt-get install -y php5-memcached

## phpMyAdmin
sudo apt-get install -y phpmyadmin
sudo cp /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
sudo a2enconf phpmyadmin 
sudo service apache2 reload

## Download Prestashop
cd /vagrant
wget http://www.prestashop.com/download/old/$PS_VERSION
unzip -o $PS_VERSION
sudo rm ./$PS_VERSION

## Create a database
mysql -uroot -pabc123 -e 'create database prestashop'

## Restart Apache to get config changes
sudo apachectl -k restart
