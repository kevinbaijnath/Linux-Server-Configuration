##### INSTALL PACKAGES ######
echo Installing required packages
sudo apt-get install -y apache2 libapache2-mod-wsgi python-pip postgresql git libpq-dev python-dev libpam-cracklib
#############################

###### USER SECTION #####
echo Creating a new user grader
sudo adduser --disabled-password --gecos "" grader
echo Adding public key to newly created user authorized keys
mkdir /home/grader/.ssh
cat Linux-Server-Configuration/public_key.pub > /home/grader/.ssh/authorized_keys
chmod 700 /home/grader/.ssh
chmod 644 /home/grader/.ssh/authorized_keys
#https://askubuntu.com/questions/94060/run-adduser-non-interactively
echo grader:Udacity12345 | chpasswd
echo Requiring user to change password upon first login
sudo passwd -e grader
echo Granting the grader user sudo permissions
echo "grader ALL=(ALL) ALL" > grader
sudo mv grader /etc/sudoers.d/
#########################

###### PACKAGES #####
echo updating packages
sudo apt-get update

echo upgrading installed packages
sudo apt-get upgrade -y --force-yes
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

##### OBTAINING APPLICATION #####
echo Obtaining Item catalog
git clone -b linuxserver https://github.com/kevinbaijnath/Item-Catalog
cd Item-Catalog/vagrant/catalog

echo Installing Application Packages
sudo pip install -r requirements.txt
#################################

##### CONFIGURE POSTGRES #####
echo Configuring Postgres
sudo -u postgres psql -c "CREATE USER catalog WITH PASSWORD 'test';"
sudo -u postgres createdb -O catalog itemcatalog
#https://help.ubuntu.com/community/Postg reSQL
###############################

##### CONFIGURING APPLICATION #####
echo Configuring Application
python database_setup.py
python populatecourses.py
mv * /var/www/html/
cd ../../../
rm -r Item-Catalog
###################################

##### CONFIGURE APACHE #####
echo Configuring Apache
#https://stackoverflow.com/questions/11694980/using-sed-insert-a-line-below-or-above-the-pattern
sed -i '/<\/VirtualHost>/i \\tWSGIScriptAlias \/ \/var\/www\/html\/project.wsgi' /etc/apache2/sites-enabled/000-default.conf
echo Restarting Apache
sudo apache2ctl restart
###########################

##### SETUP SERVICES #####
service ssh restart
echo y | sudo ufw enable
##########################
