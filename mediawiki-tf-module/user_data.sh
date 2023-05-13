#!/usr/bin/env bash

export db_username=${db_username}
export db_password=${db_password}
export mediawiki_major_version=${mediawiki_major_version}
export mediawiki_minor_version=${mediawiki_minor_version}

# Install OS packages

dnf update -y
dnf module reset php
dnf module enable php:7.4
dnf install httpd php php-mysqlnd php-gd php-xml mariadb-server mariadb php-mbstring php-json mod_ssl php-intl php-apcu wget tar -y


# Start DB and tomcat services 

systemctl start httpd
systemctl start mariadb
sleep 10

# Secure the MariaDB installation

cat <<EOF | mysql_secure_installation
$db_password
n
y
y
y
y
EOF

#Database (MySQL) post-install configuration 

mysql -u $db_username --password=$db_password -e "CREATE DATABASE my_wiki"
mysql -u $db_username --password=$db_password -e "use my_wiki"
mysql -u $db_username --password=$db_password -e "CREATE USER 'wikiuser'@'localhost' IDENTIFIED BY 'password';"
mysql -u $db_username --password=$db_password -e "GRANT ALL PRIVILEGES ON my_wiki.* TO 'wikiuser'@'localhost' WITH GRANT OPTION;"

# Autostart webserver and database daemons (services) post restart VM

systemctl enable mariadb
systemctl enable httpd

# Install MediaWiki tarball ("sources") 
cd /var/www
wget https://releases.wikimedia.org/mediawiki/${mediawiki_major_version}/mediawiki-${mediawiki_major_version}.${mediawiki_minor_version}.tar.gz
tar -xvzf mediawiki-${mediawiki_major_version}.${mediawiki_minor_version}.tar.gz
ln -s mediawiki-${mediawiki_major_version}.${mediawiki_minor_version}/ mediawiki
chown -R apache:apache /var/www/mediawiki-${mediawiki_major_version}.${mediawiki_minor_version}
sed -i 's|/var/www/html|/var/www/mediawiki|g' /etc/httpd/conf/httpd.conf
sed -i 's|DirectoryIndex index.html|DirectoryIndex index.html index.html.var index.php|g' /etc/httpd/conf/httpd.conf

# Restart Apache Service
service httpd restart

echo "[INFO] Mediawiki installation has been completed."

