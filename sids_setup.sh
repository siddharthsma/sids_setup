#!/bin/bash

yes_no_pattern='[YyNn]|[Yy]es|[Nn]o'
os_type_pattern='[MmDd]'
os_mac='[Mm]'
os_debian='[Dd]'

echo "Initializing Sid's bash setup ..."

echo "Are you on Mac[M] or Debian[D] ?"
read os_type

while ! [[ $os_type =~ $os_type_pattern ]]
do
  echo "Invalid entry. You have to enter eith 'M' or 'D'"
  read os_type
done

echo "Is your internet access through a proxy ? [y/n]"
read proxy_needed

while ! [[ $proxy_needed =~ $yes_no_pattern ]]
do
  echo "Invalid entry. You have to enter either a 'y' or 'n'"
  read proxy_needed
done

if [[ $proxy_needed =~ '[Yy]' ]]
then
echo "Enter HTTP_PROXY e.g. http://proxy.intranet.com"
read http_proxy

echo "Enter HTTPS_PROXY e.g. https://proxy.intranet.com"
read https_proxy

echo "Enter FTP_PROXY e.g. ftp://proxy.intranet.com"
read ftp_proxy

echo "Applying proxies ..."
touch ~/.bash_profile
echo "export HTTP_PROXY=$http_proxy" >> ~/.bash_profile
echo "export HTTPS_PROXY=$https_proxy" >> ~/.bash_profile
echo "export FTP_PROXY=$ftp_proxy" >> ~/.bash_profile
source ~/.bash_profile
fi

echo "Applying proxies ..."

echo "Installing rvm with rails ..."
curl -sSL https://get.rvm.io | bash -s stable --rails

if [[ $os_type =~ $os_mac ]]
then
  echo "Installing brew ..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo "Installing brew cask ..."
  brew install caskroom/cask/brew-cask
  echo "Installing iTerm ..."
  brew cask install iterm2
  echo "Installing mysql server ..."
  brew install mysql
  echo "Setting up mysql server to start at login ..."
  ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
  echo "Restarting mysql server ..."
  mysql.server restart
fi

if [[ $os_type =~ $os_debian ]]
then
  echo "Installing Apache ..."
  apt-get install apache2
  echo "Installing php ..."
  apt-get install php5
  echo "Installing mysql server ..."
  apt-get install mysql-server
  echo "Setting up phpmyadmin ..."
  echo 'Include /etc/phpmyadmin/apache2.conf' >> /etc/apache2/apache2.conf
  echo "Restarting Apache ..."
  sudo service apache2 restart
fi

echo "All Done. Enjoy !"
