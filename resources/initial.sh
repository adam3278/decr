#!/usr/bin/env bash

apt-get update
apt-get install -y apache2
sudo a2enmod rewrite
sed "/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/" -i /etc/apache2/apache2.conf
ufw allow in "Apache Full"
apt-get install -y mariadb-server
echo -e "\n\nn\ny\ny\ny\ny\n" | mysql_secure_installation
apt-get -y install software-properties-common git
echo -e "\n" | add-apt-repository ppa:ondrej/php
apt-get update
a2dissite *
mkdir -m 755 /var/www/start/
cp /var/vg_res/start.html /var/www/start/index.html
sed "s/%site_ip%/${START_ip}/g; s/%site_host%/${START_host}/g" /var/vg_res/start.conf > /tmp/$START_ip.conf
mv /tmp/$START_ip.conf /etc/apache2/sites-available/$START_ip.conf
a2ensite $START_ip
for site in "${!SITES_path[@]}";
do
	apt-get install -y php${SITES_php[$site]} libapache2-mod-php${SITES_php[$site]} php${SITES_php[$site]}-{fpm,bcmath,bz2,intl,gd,mbstring,mysql,zip,json,xml,curl}
	a2enmod php${SITES_php[$site]}
	a2enconf php${SITES_php[$site]}-fpm
	phpenmod -v ${SITES_php[$site]} -S ALL bcmath bz2 intl gd mbstring mysqli pdo zip json xml curl
	sed "s/%site_ip%/${site}/g; s/%site_host%/${SITES_host[$site]}/g; s/%site_dir%/${SITES_path[$site]}/g; s/%php_version%/${SITES_php[$site]}/g" /var/vg_res/defsite.conf > /tmp/$site.conf
	mv /tmp/$site.conf /etc/apache2/sites-available/$site.conf
	mysql -u root -e "CREATE DATABASE \`drup-${site}-db\`"
	mysql -u root -e "CREATE USER 'drup-${SITES_user[$site]}'@'localhost' IDENTIFIED BY '${USERS[${SITES_user[$site]}]}'"
	mysql -u root -e "GRANT ALL PRIVILEGES ON \`drup-${site}-db\`.* TO 'drup-${SITES_user[$site]}'@'localhost'"
	a2ensite $site
done
apt-get install -y php7.3 libapache2-mod-php7.3 php7.3-{fpm,bcmath,bz2,intl,gd,mbstring,mysql,zip,json,xml,curl} libapache2-mod-fcgid
a2enmod php7.3
phpenmod -v 7.3 -s cli bcmath bz2 intl gd mbstring mysqli pdo zip json xml curl
wget -O /tmp/libapache2-mod-fastcgi.deb http://us.archive.ubuntu.com/ubuntu/pool/multiverse/liba/libapache-mod-fastcgi/libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb
dpkg -i /tmp/libapache2-mod-fastcgi.deb
rm /tmp/libapache2-mod-fastcgi.deb
wget -O /tmp/composer-setup.php https://getcomposer.org/installer
php7.3 /tmp/composer-setup.php --install-dir=/bin/ --filename=composer
rm /tmp/composer-setup.php
php7.3 /bin/composer config --global process-timeout 6000
wget -O /tmp/drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar
chmod +x /tmp/drush.phar
mv /tmp/drush.phar /usr/local/bin/drush
drush self-update
a2enmod actions alias proxy_fcgi fcgid setenvif
service apache2 restart
for site in "${!SITES_path[@]}";
do
	cd /var/www/${SITES_path[$site]}
	git clone --branch ${SITES_drup_ver[$site]} https://git.drupal.org/project/drupal.git .
	php7.3 /bin/composer require drush/drush
	echo -e "y\n" | drush si standard --db-url=mysql://drup-${SITES_user[$site]}:${USERS[${SITES_user[$site]}]}@localhost:3306/drup-$site-db --site-name="${SITES_drup[$site]}" --account-name="${SITES_user[$site]}" --account-pass="${USERS[${SITES_user[$site]}]}"
done

echo -e "0000000000\noooooooooo\n0000000000\noooooooooo     ^^%^^^^^^DECr Successfully (re)installed^^^^^^%^^\n0000000000\noooooooooo\n0000000000"
