##### INSTALL PACKAGES ######
echo Installing required packages
sudo apt-get install apache2 libapache2-mod-wsgi postgresql git libpq-dev python-dev libpam-cracklib
#############################

###### USER SECTION #####
echo Creating a new user grader
sudo adduser grader
echo grader: | chpasswd
sudo passwd -e grader
#https://askubuntu.com/questions/244115/how-do-i-enforce-a-password-complexity-policy
echo Granting the grader user sudo permissions
echo "grader ALL=(ALL) ALL" > grader
sudo mv grader /etc/sudoers.d/
#########################

###### PACKAGES #####
echo updating packages
sudo apt-get update

echo upgrading installed packages
sudo apt-get upgrade
#####################

##### CHANGE TIMEZONE #####
echo changing timezone to UTC
sudo echo 'Etc/UTC' > /etc/timezone
#https://unix.stackexchange.com/questions/110522/timezone-setting-in-linux
sudo dpkg-reconfigure -f noninteractive tzdata
####################

##### SSH CONFIG #####
echo Configuring SSH
echo Changing SSH port
sudo sed -ie 's/Port 22/Port 2200/g' /etc/ssh/sshd_config

echo Disabling Password Authentication
sudo sed -ie 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

echo Disabling root login via SSH
sudo sed -ie 's/PasswordAuthentication .*/PasswordAuthentication no/g' /etc/ssh/sshd_config
######################

##### FIREWALL #####
echo Configuring to block inbound access from all ports except 2200, 80 and 123
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 2200/tcp
sudo ufw allow 80/tcp
sudo ufw allow 123/tcp
#####################

##### CONFIGURE POSTGRES #####
echo Configuring Postgres
sudo -u postgres psql -c "CREATE USER catalog WITH PASSWORD 'test';"
sudo -u postgres createdb -O catalog itemcatalog
#https://help.ubuntu.com/community/PostgreSQL

##### CONFIGURE APPLICATION #####
echo Obtaining Item catalog
git clone -b linuxserver https://github.com/kevinbaijnath/Item-Catalog
cd Item-Catalog/vagrant/catalog

echo Installing Application Packages
sudo pip install -r requirements.txt

echo Configuring Application
python database_setup.py
python populatecourses.py
mv * /var/www/html/
cd
rm -r Item-Catalog

##### CONFIGURE APACHE #####
echo Configuring Apache
#https://stackoverflow.com/questions/11694980/using-sed-insert-a-line-below-or-above-the-pattern
sed -i '/<\/VirtualHost>/i \\tWSGIScriptAlias \/ \/var\/www\/html\/project.wsgi' /etc/apache2/sites-enabled/000-default.conf
echo Restarting Apache
sudo apache2ctl restart
###########################

##### SETUP SERVICES #####
#service ssh restart
#echo y | sudo ufw enable
##########################