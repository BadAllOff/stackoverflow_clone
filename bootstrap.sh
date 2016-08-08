# This file is used by Vagrant to start the application enviroment.

#!/usr/bin/env bash

GREEN='\033[1;32m'
BLUE='\033[1;34m'
NC='\033[0m'

printf "${GREEN}Let's get the party started!${NC}\n"

> /etc/default/locale
cd /etc/default

cat <<EOT >> locale
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8
LC_CTYPE=en_US.UTF-8
LANG=en_US.UTF-8
LC_NUMERIC=en_US.UTF-8
LC_TIME=en_US.UTF-8
LC_COLLATE=en_US.UTF-8
LC_MONETARY=en_US.UTF-8
LC_MESSAGES=en_US.UTF-8
LC_PAPER=en_US.UTF-8
LC_NAME=en_US.UTF-8
LC_ADDRESS=en_US.UTF-8
LC_TELEPHONE=en_US.UTF-8
LC_MEASUREMENT=en_US.UTF-8
LC_IDENTIFICATION=en_US.UTF-8
EOT

. ~/.bashrc

printf "${BLUE} -- creating user ... -- ${NC}\n"

adduser --disabled-password --gecos "" railsdev
echo railsdev:password | chpasswd
usermod -a -G sudo railsdev

printf "${GREEN} -- user added to SUDO -- ${NC}\n"

apt-get update

printf "${BLUE} -- installing dependencies ... -- ${NC}\n"

apt-get install git-core curl build-essential zlib1g-dev libssl-dev libreadline-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev nodejs libpq-dev python-software-properties libsqlite3-dev -y

#Qt for capybara webkit
apt-get install libqtwebkit-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x -y


printf "${GREEN} -- Git Postgre installed -- ${NC}\n"

# sudo add-apt-repository ppa:nginx/stable -y > /dev/null
# sudo aptitude update && sudo aptitude -y install nginx && sudo apt-get install libmagick++-dev -y > /dev/null

# printf "${GREEN} -- Nginx install (just in case of needed) -- ${NC}\n"

#Provision PostgreSQL 9.4
# Install the postgres key
printf "${BLUE} -- Importing PostgreSQL key and installing software -- ${NC}\n"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.4" >> /etc/apt/sources.list.d/pgdg.list
sudo apt-get update
sudo apt-get -y install postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4

printf "${BLUE} -- Changing to dummy password -- ${NC}\n"
sudo -u postgres psql postgres -c "ALTER USER postgres WITH ENCRYPTED PASSWORD 'postgres'"
sudo su - postgres -c 'createuser -s vagrant'
#sudo -u postgres psql postgres -c "CREATE USER railsdev WITH ENCRYPTED PASSWORD 'password' SUPERUSER"
sudo -u postgres psql postgres -c "CREATE DATABASE qna_thinknetica_development OWNER vagrant"
sudo -u postgres psql postgres -c "GRANT ALL PRIVILEGES ON DATABASE qna_thinknetica_development TO vagrant"
sudo -u postgres psql postgres -c "CREATE EXTENSION adminpack";

printf "${GREEN} -- Configuring postgresql.conf -- ${NC}\n"
printf "${BLUE} -- Patching pg_hba to change -> socket access -- ${NC}\n"

echo '# "local" is for Unix domain socket connections only
local   all             all                                  trust
# IPv4 local connections:
host    all             all             0.0.0.0/0            trust
# IPv6 local connections:
host    all             all             ::/0                 trust' | sudo tee /etc/postgresql/9.4/main/pg_hba.conf
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.4/main/postgresql.conf

printf "${GREEN} -- Patching complete, restarting -- ${NC}\n"
sudo /etc/init.d/postgresql restart
printf "${GREEN} -- Postgresql configured -- ${NC}\n"

printf "${BLUE} -- adding ENV variables ... -- ${NC}\n"
echo "export PG_DB_USER='vagrant'" >> /home/railsdev/.bashrc
echo "export PG_DB_PASS=''" >> /home/railsdev/.bashrc
printf "${GREEN} -- ENV variables added -- ${NC}\n"

# rvm and ruby
printf "${BLUE} -- adding RVM & Ruby ... -- ${NC}\n"
su - vagrant -c 'curl -sSL https://rvm.io/mpapis.asc | gpg --import -'
su - vagrant -c 'curl -sSL https://get.rvm.io | bash -s stable --ruby'
su - vagrant -c 'rvm rvmrc warning ignore allGemfiles'
su - vagrant -c 'source /home/vagrant/.rvm/scripts/rvm'
# error `require': cannot load such file -- mkmf (LoadError) - ruby-dev should solve it
apt-get install ruby-dev
gem install bundle
# do next cd /vagrant && bundle install